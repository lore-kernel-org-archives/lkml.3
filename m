Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaGWMRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:17:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbaGWMRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:17:01 -0400
Date: Wed, 23 Jul 2014 08:16:58 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: "xinhui.pan" <xinhuix.pan@intel.com>, linux-kernel@vger.kernel.org,
        agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        "Liu, ShuoX" <shuox.liu@intel.com>
Subject: Re: [dm-devel] [PATCH] md/dm-ioctl.c: optimize memory allocation in
 copy_params
In-Reply-To: <53CF26B2.6060503@linux.intel.com>
Message-ID: <alpine.LRH.2.02.1407230816000.29551@file01.intranet.prod.int.rdu2.redhat.com>
References: <53B68068.2060102@intel.com> <alpine.LRH.2.02.1407081831510.27831@file01.intranet.prod.int.rdu2.redhat.com> <53BCA278.5050205@linux.intel.com> <alpine.LRH.2.02.1407091032400.4545@file01.intranet.prod.int.rdu2.redhat.com> <53CDB81B.90509@linux.intel.com>
 <20140722012352.GD6822@agk-dp.fab.redhat.com> <53CF26B2.6060503@linux.intel.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Jul 2014, Zhang, Yanmin wrote:

> On 2014/7/22 9:23, Alasdair G Kergon wrote:
> > > > > On 2014/7/9 6:39, Mikulas Patocka wrote:
> > > > Which ioctl with more than 16kB
> > > > arguments do you use?
> > Unanswered.  Let's ask the same question in a different way:
> > 
> > Please supply the output of these three commands on the real-world system on
> > which you believe that that particular allocation is causing you a problem:
> >    dmsetup info -c
> >    dmsetup table
> >    dmsetup status
> 
> Android doesn't include the command. We compiled lvm2-2_02_107.tar.gz and copy
> dmsetup to the board. But command reports No devices.
> 
> # /data/bin/dmsetup info
> No devices found

So, it means that you do not use device mapper at all. So, why are you 
trying to change memory allocation in device mapper?

Mikulas
