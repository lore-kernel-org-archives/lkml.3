Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab3FEEqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 00:46:35 -0400
Received: from ozlabs.org ([203.10.76.45]:52974 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab3FEEq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 00:46:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Ben Greear <greearb@candelatech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: Please add to stable:  module: don't unlink the module until we've removed all exposure.
In-Reply-To: <20130604100744.7cdf8777@jlaw-desktop.mno.stratus.com>
References: <51A8E884.1080009@candelatech.com> <87ehclumhr.fsf@rustcorp.com.au> <alpine.DEB.2.02.1306022212200.10003@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1306030724230.19647@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1306031012460.22652@jlaw-desktop.mno.stratus.com> <51ACBD6A.1030304@candelatech.com> <51ACC60B.8090504@candelatech.com> <87d2s2to4z.fsf@rustcorp.com.au> <20130604100744.7cdf8777@jlaw-desktop.mno.stratus.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 05 Jun 2013 12:59:28 +0930
Message-ID: <87vc5ts09z.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Lawrence <joe.lawrence@stratus.com> writes:
> On Tue, 04 Jun 2013 15:26:28 +0930
> Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> Do you have a backtrace of the 3.9.4 crash?  You can add "CFLAGS_module.o
>> = -O0" to get a clearer backtrace if you want...
>
> Hi Rusty,
>
> See my 3.9 stack traces below, which may or may not be what Ben had
> been seeing.  If you like, I can try a similar loop as the one you were
> testing in the other email.  
>
> Regards,
>
> -- Joe
>
> *** First instance ***
>
> ------------[ cut here ]------------
> WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xd4/0x100()
> Hardware name: ftServer 6400
> sysfs: cannot create duplicate filename '/module/mgag200'
> Modules linked in: enclosure(+) mgag200(+) ghash_clmulni_intel(+) pcspkr joydev osst vhost_net st tun macvtap macvlan uinput raid1 mpt2sas(OF) raid_class qla2xxx(OF) scsi_transport_fc scsi_transport_sas sd_mod(OF) usb_storage scsi_tgt scsi_hbas(OF) i2c_algo_bit drm_kms_helper ttm drm i2c_core
> Pid: 733, comm: systemd-udevd Tainted: GF          O 3.9.0sra_new+ #1
> Call Trace:
>  [<ffffffff81061a9f>] warn_slowpath_common+0x7f/0xc0
>  [<ffffffff81061b96>] warn_slowpath_fmt+0x46/0x50
>  [<ffffffff81319875>] ? strlcat+0x65/0x90
>  [<ffffffff81222914>] sysfs_add_one+0xd4/0x100
>  [<ffffffff81222b38>] create_dir+0x78/0xd0
>  [<ffffffff81222e86>] sysfs_create_dir+0x86/0xe0
>  [<ffffffff81313588>] kobject_add_internal+0xa8/0x270
>  [<ffffffff81313ab3>] kobject_init_and_add+0x63/0x90
>  [<ffffffff810ca34d>] load_module+0x12dd/0x2890
>  [<ffffffff81331670>] ? ddebug_proc_open+0xc0/0xc0
>  [<ffffffff810cb9ea>] sys_init_module+0xea/0x140
>  [<ffffffff81680d19>] system_call_fastpath+0x16/0x1b
> ---[ end trace 247a5f5f82ef192d ]---
> ------------[ cut here ]------------
> WARNING: at lib/kobject.c:196 kobject_add_internal+0x204/0x270()
> Hardware name: ftServer 6400
> kobject_add_internal failed for mgag200 with -EEXIST, don't try to register things with the same name in the same directory.
> Modules linked in:0m] Started Conf mdio(+) coretemp(+) crc32c_intel(+) dca(+) enclosure(+) mgag200(+) ghash_clmulni_intel pcspkr joydev osst vhost_net st tun macvtap macvlan uinput raid1 mpt2sas(OF) raid_class qla2xxx(OF) scsi_transport_fc scsi_transport_sas sd_mod(OF) usb_storage scsi_tgt scsi_hbas(OF) i2c_algo_bit drm_kms_helper ttm drm i2c_core
> Pid: 733, comm: systemd-udevd Tainted: GF       W  O 3.9.0sra_new+ #1
>
> Call Trace:
>  [<ffffffff81061a9f>] warn_slowpath_common+0x7f/0xc0
>  [<ffffffff81061b96>] warn_slowpath_fmt+0x46/0x50
>  [<ffffffff813136e4>] kobject_add_internal+0x204/0x270
>  [<ffffffff81313ab3>] kobject_init_and_add+0x63/0x90
>  [<ffffffff810ca34d>] load_module+0x12dd/0x2890
>  [<ffffffff81331670>] ? ddebug_proc_open+0xc0/0xc0
>  [<ffffffff810cb9ea>] sys_init_module+0xea/0x140
>  [<ffffffff81680d19>] system_call_fastpath+0x16/0x1b
> ---[ end trace 247a5f5f82ef192e ]---

That's a WARN_ON.  It's harmless, but indeed is fixed by the patch
suggested.

> *** Second instance ***
>
> mgag200: module is already loaded
> igb: Intel(R) Gigabit Ethernet Network Driver - version 4.1.2-k
> BUG: unable to handle kernel paging request at ffffffffa01d060c
> IP: [<ffffffff81313276>] kobject_del+0x16/0x40
> PGD 1c0f067 PUD 1c10063 PMD 851372067 PTE 0
> Oops: 0002 [#1] SMP 
> Modules linked in: ixgbe(OF+) igb(OF+) mgag200(+) ptp pps_core mdio dca coretemp crc32c_intel pcspkr ghash_clmulni_intel vhost_net tun macvtap macvlan uinput raid1 usb_storage mpt2sas(OF) raid_class qla2xxx(OF) scsi_transport_fc scsi_transport_sas sd_mod(OF) scsi_tgt scsi_hbas(OF) i2c_algo_bit drm_kms_helper ttm drm i2c_core
> CPU 28 
> Pid: 719, comm: systemd-udevd Tainted: GF          O 3.9.0sra_new+ #1 Stratus ftServer 6400/G7LAZ
> RIP: 0010:[<ffffffff81313276>]  [<ffffffff81313276>] kobject_del+0x16/0x40
> RSP: 0018:ffff88103814fd08  EFLAGS: 00010292
> RAX: 0000000000000200 RBX: ffffffffa01d05d0 RCX: 0000000100250004
> RDX: ffff88103814ffd8 RSI: 0000000000250004 RDI: 0000000000000246
> RBP: ffff88103814fd18 R08: ffff88103814fa80 R09: 0000000000000000
> R10: ffff88085f821d40 R11: 0000000000000025 R12: ffffffff81c412c0
> R13: ffff880852c8cfc0 R14: ffffffffa01e0580 R15: ffffffffa01e0598
> FS:  00007fc98fe6c840(0000) GS:ffff88107fd80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffa01d060c CR3: 0000001038137000 CR4: 00000000000407e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process systemd-udevd (pid: 719, threadinfo ffff88103814e000, task ffff8810380d98a0)
> Stack:
>  ffff88103814fd18 ffffffffa01d05d0 ffff88103814fd48 ffffffff81313302
>  ffff88103814fd78 ffffffffa01d05d0 ffffffffa01d05d0 ffffffffffffffea
>  ffff88103814fd68 ffffffff8131348b 00000000ffff8000 ffff88103814fee8
> Call Trace:
>  [<ffffffff81313302>] kobject_cleanup+0x62/0x1b0
>  [<ffffffff8131348b>] kobject_put+0x2b/0x60
>  [<ffffffff810cb8f1>] load_module+0x2881/0x2890
>  [<ffffffff81331670>] ? ddebug_proc_open+0xc0/0xc0
>  [<ffffffff810cb9ea>] sys_init_module+0xea/0x140
>  [<ffffffff81680d19>] system_call_fastpath+0x16/0x1b
> Code: 02 00 00 48 8b 5d f0 4c 8b 65 f8 c9 c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 85 ff 74 22 e8 7a fc f0 ff <80> 63 3c fd 48 89 df e8 6e ff ff ff 48 8b 7b 18 e8 d5 01 00 00 
> RIP  [<ffffffff81313276>] kobject_del+0x16/0x40
>  RSP <ffff88103814fd08>
> CR2: ffffffffa01d060c
> ---[ end trace e320c2319820c81a ]---
> Kernel panic - not syncing: Fatal exception

This is the interesting one!  This is kind of crash which Linus' a49b7e82
fixed, but 3.9 contains that already.

For some reason, mgag200 is being unloaded (or failing to load) while
another one is being loaded.  The new module does this:

	kobj = kset_find_obj(module_kset, mod->name);
	if (kobj) {
		printk(KERN_ERR "%s: module is already loaded\n", mod->name);
		kobject_put(kobj);

The old one does this:

	kobject_put(&mod->mkobj.kobj);  /* in mod_sysfs_fini */
        ...
        module_free(mod, mod->module_core); /* in free_module */

And it doesn't wait for the kobj count to hit zero, so the other
kobject_put() it on a kobject which is freed...

Normally the right answer would be to offload the freeing of the module
memory to module_ktype's release function.

The backported dont-remove-from-list fix prevents this race from
happening, since the duplicate module is now caught earlier.  It does
not prevent the same problem with other kobj references; for example,
what about sysfs accesses to a module which fails init?

So the simplest thing is to backport the fix, as suggested.  But now I'm
trying to trigger the same bug in other ways.

Thanks,
Rusty.




