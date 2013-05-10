Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab3EJBu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 21:50:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501Ab3EJBuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 21:50:54 -0400
Date: Fri, 10 May 2013 09:51:00 +0800
From: Dave Young <dyoung@redhat.com>
To: Felipe Balbi <balbi@ti.com>
Cc: CAI Qian <caiqian@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.9.0: WARNING: at drivers/base/core.c:575
Message-ID: <20130510015058.GA10269@darkstar.nay.redhat.com>
References: <148688218.8139723.1367911491024.JavaMail.root@redhat.com>
 <1732336275.8141054.1367911558572.JavaMail.root@redhat.com>
 <20130509102949.GA28545@darkstar.nay.redhat.com>
 <20130509145044.GG28325@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130509145044.GG28325@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 05:53:08PM +0300, Felipe Balbi wrote:
> On Thu, May 09, 2013 at 06:29:51PM +0800, Dave Young wrote:
> > On Tue, May 07, 2013 at 03:25:58AM -0400, CAI Qian wrote:
> > > Never saw any of those messages were floating in any of the RC testing, but
> > > now happened in 3.9 GA on Power 7 systems.
> > > 
> > > [    0.329753] EEH: devices created
> > > [    0.340203] atomic64 test passed
> > > [    0.340407] NET: Registered protocol family 16
> > > [    0.340457] EEH: No capable adapters found
> > > [    0.340609] IBM eBus Device Driver
> > > [    0.358825] Write permission without 'store'
> > > [    0.358852] ------------[ cut here ]------------
> > > [    0.358859] WARNING: at drivers/base/core.c:575
> > > [    0.358866] Modules linked in:
> > > [    0.358877] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0+ #1
> > > [    0.358887] task: c0000003f8bc0000 ti: c0000003f8c00000 task.ti: c0000003f8c00000
> > > [    0.358897] NIP: c0000000004a7f44 LR: c0000000004a7f40 CTR: 0000000001766760
> > > [    0.358906] REGS: c0000003f8c03780 TRAP: 0700   Not tainted  (3.9.0+)
> > > [    0.358914] MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 28139d24  XER: 00000001
> > > [    0.358939] SOFTE: 1
> > > [    0.358944] CFAR: c00000000074427c
> > > [    0.358950] 
> > > GPR00: c0000000004a7f40 c0000003f8c03a00 c000000001117e50 0000000000000020 
> > > GPR04: 0000000000000000 0000000000000000 00000000160c9615 0000000000000000 
> > > GPR08: c000000001064af0 0000000000000000 0000000000000000 0000000000003fef 
> > > GPR12: 0000000028139d22 c000000007f00000 c00000000000bb30 0000000000000000 
> > > GPR16: 0000000000000000 0000000000000000 c000000000ff1c78 0000000000000001 
> > > GPR20: 0000000000000000 0000000000000000 0000000000000000 c00000000117eb08 
> > > GPR24: 00000000000000a6 c000000000af0028 0000000000000000 c000000000ff21a0 
> > > GPR28: 0000000000000002 c000000001500030 c0000000011b8200 c000000001500030 
> > > [    0.359070] NIP [c0000000004a7f44] .device_create_file+0xa4/0xe0
> > > [    0.359080] LR [c0000000004a7f40] .device_create_file+0xa0/0xe0
> > > [    0.359088] Call Trace:
> > > [    0.359095] [c0000003f8c03a00] [c0000000004a7f40] .device_create_file+0xa0/0xe0 (unreliable)
> > > [    0.359112] [c0000003f8c03a90] [c00000000074daf8] .register_cpu_online+0x21c/0x284
> > > [    0.359126] [c0000003f8c03b30] [c000000000a78308] .topology_init+0x130/0x200
> > > [    0.359138] [c0000003f8c03c10] [c00000000000b4d4] .do_one_initcall+0x144/0x1f0
> > > [    0.359150] [c0000003f8c03cd0] [c000000000a746a8] .kernel_init_freeable+0x23c/0x32c
> > > [    0.359163] [c0000003f8c03db0] [c00000000000bb4c] .kernel_init+0x1c/0x130
> > > [    0.359175] [c0000003f8c03e30] [c00000000000a164] .ret_from_kernel_thread+0x64/0x80
> > > [    0.359184] Instruction dump:
> > > [    0.359190] 3863e610 4829c2f1 60000000 0fe00000 e8810070 4bffffb0 60000000 3c62ff8c 
> > > [    0.359211] f8810070 3863e5e8 4829c2cd 60000000 <0fe00000> e8810070 a1240008 4bffff80 
> > > [    0.359241] ---[ end trace c949de754c984735 ]---
> > > 
> > Hi, Caiqian
> > 
> > Could you try below debug patch to print the attr name?
> > 
> > ---
> > print the sysfs attribute file name when we warn about bogus permissions 
> > 
> > Make it obvious to see what attribute is using bogus permissions.
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > ---
> >  drivers/base/core.c |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > --- linux-2.6.orig/drivers/base/core.c
> > +++ linux-2.6/drivers/base/core.c
> > @@ -572,9 +572,11 @@ int device_create_file(struct device *de
> >  
> >  	if (dev) {
> >  		WARN(((attr->attr.mode & S_IWUGO) && !attr->store),
> > -				"Write permission without 'store'\n");
> > +			"Attribute "%s": write permission without 'store'\n",
> 
> sure this even builds ?
> 

Hi, Felipe

Oops, here is the fix:
---

print the sysfs attribute file name when we warn about bogus permissions 

Make it obvious to see what attribute is using bogus permissions.

[v1->v2] build fix

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 drivers/base/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -572,9 +572,11 @@ int device_create_file(struct device *de
 
 	if (dev) {
 		WARN(((attr->attr.mode & S_IWUGO) && !attr->store),
-				"Write permission without 'store'\n");
+			"Attribute %s: write permission without 'store'\n",
+			attr->attr.name);
 		WARN(((attr->attr.mode & S_IRUGO) && !attr->show),
-				"Read permission without 'show'\n");
+			"Attribute %s: Read permission without 'show'\n",
+			attr->attr.name);
 		error = sysfs_create_file(&dev->kobj, &attr->attr);
 	}
 

