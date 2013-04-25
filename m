Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab3DYAPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 20:15:54 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:37206 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085Ab3DYAPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 20:15:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130416135956.GA18383@hansolo.jdub.homelinux.org>
References: <20130416135956.GA18383@hansolo.jdub.homelinux.org>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 24 Apr 2013 17:15:30 -0700
Message-ID: <CAK5ve-JvOzDOsEJPo7G4b160F9rBBb7cZXx1NOd59OwU4FhKng@mail.gmail.com>
Subject: Re: leds-ss4200 oops in 3.7/3.8
To: Josh Boyer <jwboyer@redhat.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Greg KH <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 6:59 AM, Josh Boyer <jwboyer@redhat.com> wrote:
> Hi All,
>
> We've had a report[1] of the leds-ss4200 driver oopsing during device
> initialization on both the 3.7 and 3.8 kernels.  The backtrace is below.
> In the same report a gentoo user posted a similar backtrace on 3.7.10,
> and has output from a working 3.5 kernel.
>
> Interestingly enough, there are no changes to this driver between 3.5 and
> 3.7, and only very simple changes to it in 3.8.  Looking at the backtrace
> it seems to be failing when calling led_classdev_register from
> register_nasgpio_led.  I'm slightly confused as to how this could be
> causing the oops, but it appears consistently.  The only theory I have is
> that there is some kind of race here and the kref associated with the
> device isn't correctly initialized, which is why kobject_get is oopsing.
>
> Thoughts?
>

Can we do some bisect between 3.5 and 3.7 or 3.6? It should be not
very hard find it, since leds subsystem changes almost goes into
kernel during merge windows.

So please try 3.5-rc1 and 3.6-rc1 firstly.

Thanks,
-Bryan

> josh
>
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=950160
>
> nas kernel: [   11.327331] leds_ss4200: detected 'Intel SS4200-E'
> nas kernel: [   11.332120] leds_ss4200: registering PCI driver
> nas kernel: [   11.336678] BUG: unable to handle kernel NULL pointer dereference at 00000000000000e0
> nas kernel: [   11.337636] IP: [<ffffffff812f7d10>] kobject_get+0x10/0x40
> nas kernel: [   11.337636] PGD 0
> nas kernel: [   11.337636] Oops: 0000 [#1] SMP
> nas kernel: [   11.337636] Modules linked in: leds_ss4200(+) lpc_ich mfd_core i2c_i801 coretemp i2c_core serio_raw ftdi_sio microcode e1000e nfsd auth_rpcgss nfs_acl lockd sunrpc raid456 async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx sata_sil24 usb_storage
> nas kernel: [   11.369200] CPU 1
> nas kernel: [   11.369200] Pid: 383, comm: systemd-udevd Not tainted 3.8.5-201.fc18.x86_64 #1 Intel SS4200-E/SS4200-E
> nas kernel: [   11.369200] RIP: 0010:[<ffffffff812f7d10>]  [<ffffffff812f7d10>] kobject_get+0x10/0x40
> nas kernel: [   11.369200] RSP: 0018:ffff88007bff5bf8  EFLAGS: 00010282
> nas kernel: [   11.369200] RAX: 00000000000000a8 RBX: ffff880079210c00 RCX: 0000000000000000
> nas kernel: [   11.369200] RDX: ffff8800797e2400 RSI: ffffffff81a212b4 RDI: 00000000000000a8
> nas kernel: [   11.369200] RBP: ffff88007bff5c08 R08: 0000000000000000 R09: 000000000000ffff
> nas kernel: [   11.369200] R10: ffff88007d001308 R11: 0000000000000000 R12: ffff880079210c00
> nas kernel: [   11.369200] R13: ffffffff81a28a8b R14: ffff880079210e60 R15: ffff880079210c00
> nas kernel: [   11.369200] FS:  00007f147e4ab840(0000) GS:ffff88007fc80000(0000) knlGS:0000000000000000
> nas kernel: [   11.369200] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> nas kernel: [   11.369200] CR2: 00000000000000e0 CR3: 000000007892b000 CR4: 00000000000007e0
> nas kernel: [   11.369200] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> nas kernel: [   11.369200] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> nas kernel: [   11.369200] Process systemd-udevd (pid: 383, threadinfo ffff88007bff4000, task ffff880036f90000)
> nas kernel: [   11.369200] Stack:
> nas kernel: [   11.369200]  000000000000000f ffff880079210cb8 ffff88007bff5c18 ffffffff813e65a7
> nas kernel: [   11.369200]  ffff88007bff5c98 ffffffff813e7ef3 ffff88007bff5c58 ffffffff8108ec02
> nas kernel: [   11.369200]  ffffffff81a28a8b ffff880079210c00 ffff880079210c00 ffffffff81a28a8b
> nas kernel: [   11.369200] Call Trace:
> nas kernel: [   11.369200]  [<ffffffff813e65a7>] get_device+0x17/0x30
> nas kernel: [   11.369200]  [<ffffffff813e7ef3>] device_add+0xd3/0x6e0
> nas kernel: [   11.369200]  [<ffffffff8108ec02>] ? complete_all+0x52/0x60
> nas kernel: [   11.369200]  [<ffffffff813e851e>] device_register+0x1e/0x30
> nas kernel: [   11.369200]  [<ffffffff813e862b>] device_create_vargs+0xfb/0x130
> nas kernel: [   11.369200]  [<ffffffff813e8691>] device_create+0x31/0x40
> nas kernel: [   11.369200]  [<ffffffffa01af000>] ? 0xffffffffa01aefff
> nas kernel: [   11.369200]  [<ffffffffa01af01d>] ? ss4200_led_dmi_callback+0x1d/0x1d [leds_ss4200]
> nas kernel: [   11.369200]  [<ffffffff814fdc52>] led_classdev_register+0x32/0x140
> nas kernel: [   11.369200]  [<ffffffffa01af120>] nas_gpio_init+0x103/0xfe3 [leds_ss4200]
> nas kernel: [   11.369200]  [<ffffffffa01af01d>] ? ss4200_led_dmi_callback+0x1d/0x1d [leds_ss4200]
> nas kernel: [   11.369200]  [<ffffffff8100215a>] do_one_initcall+0x12a/0x180
> nas kernel: [   11.369200]  [<ffffffff810c4db1>] load_module+0x1b01/0x2230
> nas kernel: [   11.369200]  [<ffffffff81314dd0>] ? ddebug_proc_open+0xc0/0xc0
> nas kernel: [   11.369200]  [<ffffffff810c55b7>] sys_init_module+0xd7/0x120
> nas kernel: [   11.369200]  [<ffffffff81658c19>] system_call_fastpath+0x16/0x1b
> nas kernel: [   11.369200] Code: 48 c7 c7 68 3c cd 81 31 c0 e8 fd be 01 00 eb d0 66 66 2e 0f 1f 84 00 00 00 00 00 48 85 ff 48 89 f8 74 14 55 48 89 e5 48 83 ec 10 <8b> 57 38 85 d2 74 07 f0 ff 40 38 c9 f3 c3 be 2a 00 00 00 48 c7
> nas kernel: [   11.369200] RIP  [<ffffffff812f7d10>] kobject_get+0x10/0x40
> nas kernel: [   11.369200]  RSP <ffff88007bff5bf8>
> nas kernel: [   11.369200] CR2: 00000000000000e0
>
