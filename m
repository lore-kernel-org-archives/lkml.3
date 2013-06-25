Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab3FYQDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:03:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:60268 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab3FYQDB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:03:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,938,1363158000"; 
   d="scan'208";a="322365827"
From: "Luck, Tony" <tony.luck@intel.com>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>
CC: "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        Colin Cross <ccross@android.com>, LKML <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "Anton Blanchard" <anton@samba.org>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>
Subject: RE: [PATCH 3/3] powerpc/pseries: Support compression of oops text
 via pstore
Thread-Topic: [PATCH 3/3] powerpc/pseries: Support compression of oops text
 via pstore
Thread-Index: AQHOcKOFI+fbT3qTAkWgSP4nHd50LJlFnK6AgADb4ICAAB740A==
Date: Tue, 25 Jun 2013 16:02:58 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31C5376F@ORSMSX106.amr.corp.intel.com>
References: <20130624061936.12963.72529.stgit@aruna-ThinkPad-T420>
 <20130624062316.12963.87911.stgit@aruna-ThinkPad-T420>
 <CAGXu5jJezRynWEBmmH8wp=pt1yEjukhe6Pg_aRcZP7E6t-1R=g@mail.gmail.com>
 <51C94101.3030702@linux.vnet.ibm.com>
In-Reply-To: <51C94101.3030702@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Introducing headersize in pstore_write() API would need changes at
> multiple places whereits being called. The idea is to move the
> compression support to pstore infrastructure so that other platforms
> could also make use of it.

Any thoughts on the back/forward compatibility as we switch to compressed
pstore data?   E.g. imagine I have a system installed with some Linux distribution
with a kernel too old to know about compressed pstore. I use that machine to
run the latest kernels that do compression ... and one fine day one of them crashes
hard - logging in compressed form to pstore. Now I boot my distro kernel to pick
up the pieces ... what do I see in /sys/fs/pstore/*? Some compressed files? Can I
read them with some tool?

This somewhat of a corner case - but not completely unrealistic ... I'd at least
like to be reassured that the old kernel won't choke when it sees the compressed
blobs.

-Tony

