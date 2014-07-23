Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbaGWMyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:54:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaGWMyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:54:11 -0400
Date: Wed, 23 Jul 2014 13:54:07 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        "xinhui.pan" <xinhuix.pan@intel.com>, linux-kernel@vger.kernel.org,
        agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        "Liu, ShuoX" <shuox.liu@intel.com>
Subject: Re: [dm-devel] [PATCH] md/dm-ioctl.c: optimize memory allocation
	in copy_params
Message-ID: <20140723125407.GG6822@agk-dp.fab.redhat.com>
Mail-Followup-To: Mikulas Patocka <mpatocka@redhat.com>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	"xinhui.pan" <xinhuix.pan@intel.com>, linux-kernel@vger.kernel.org,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	"Liu, ShuoX" <shuox.liu@intel.com>
References: <53B68068.2060102@intel.com> <alpine.LRH.2.02.1407081831510.27831@file01.intranet.prod.int.rdu2.redhat.com> <53BCA278.5050205@linux.intel.com> <alpine.LRH.2.02.1407091032400.4545@file01.intranet.prod.int.rdu2.redhat.com> <53CDB81B.90509@linux.intel.com> <20140722012352.GD6822@agk-dp.fab.redhat.com> <53CF26B2.6060503@linux.intel.com> <alpine.LRH.2.02.1407230816000.29551@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1407230816000.29551@file01.intranet.prod.int.rdu2.redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 08:16:58AM -0400, Mikulas Patocka wrote:
> So, it means that you do not use device mapper at all. So, why are you 
> trying to change memory allocation in device mapper?
 
So the *test* they run is asking device-mapper to briefly reserve a 64KB
buffer when there is no data to report:  The answer is not to run that
pointless test:)

And if a single 64KB allocation really is a big deal, then patch 'vold'
in userspace so it doesn't ask for 64KB when it clearly doesn't need it!

+ int Devmapper::dumpState(SocketClient *c) {
+    char *buffer = (char *) malloc(1024 * 64);

The code has just
#define DEVMAPPER_BUFFER_SIZE 4096
for all the other dm ioctls it issues.

Only use a larger value when it is needed i.e. if DM_BUFFER_FULL_FLAG gets set.

Alasdair

