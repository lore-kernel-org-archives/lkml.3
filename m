Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab3IZGgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:36:05 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:55531 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab3IZGgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:36:03 -0400
Message-ID: <5243D5CE.2030302@xs4all.nl>
Date: Thu, 26 Sep 2013 08:35:58 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: BUG with kernel 3.11.1
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I found this in /var/log/messages:

Sep 26 03:37:36 recorder kernel: BUG: unable to handle kernel NULL
pointer dereference at 0000000000000008
Sep 26 03:37:36 recorder kernel: IP: [<ffffffff8122e393>]
__rb_insert_augmented+0x23/0x200
Sep 26 03:37:36 recorder kernel: PGD cf8d5067 PUD caf6a067 PMD 0
Sep 26 03:37:36 recorder kernel: Oops: 0000 [#1] PREEMPT SMP
Sep 26 03:37:36 recorder kernel: Modules linked in: f71882fg hid_generic
usbhid cp210x hid usbserial tda1004x budget_av saa7146_vv
videobuf_dma_sg videobuf_core v4l2_common videodev budget_core
ttpci_eeprom saa7146 snd_hda_codec_hdmi dvb_core snd_hda_codec_realtek
snd_hda_intel radeon snd_hda_codec fbcon snd_seq snd_seq_device bitblit
snd_pcm softcursor microcode font snd_page_alloc k10temp cfbfillrect
snd_timer evdev cfbimgblt cfbcopyarea backlight snd drm_kms_helper ttm
acpi_cpufreq i2c_piix4 ohci_pci ohci_hcd mperf processor button nfsd
auth_rpcgss oid_registry exportfs nfs_acl lockd sunrpc autofs4
ata_generic ehci_pci ehci_hcd sr_mod cdrom
Sep 26 03:37:36 recorder kernel: CPU: 0 PID: 10571 Comm: ld-linux-x86-64
Not tainted 3.11.1 #1
Sep 26 03:37:36 recorder kernel: Hardware name: To Be Filled By O.E.M.
To Be Filled By O.E.M./To be filled by O.E.M., BIOS 080015  05/04/2010
Sep 26 03:37:36 recorder kernel: task: ffff8800cc44d950 ti:
ffff8800cf98c000 task.ti: ffff8800cf98c000
Sep 26 03:37:36 recorder kernel: RIP: 0010:[<ffffffff8122e393>]
[<ffffffff8122e393>] __rb_insert_augmented+0x23/0x200
Sep 26 03:37:36 recorder kernel: RSP: 0018:ffff8800cf98dde8  EFLAGS:
00010246
Sep 26 03:37:36 recorder kernel: RAX: ffff880108f90090 RBX:
0000000000000000 RCX: ffff880108f90090
Sep 26 03:37:36 recorder kernel: RDX: ffffffff810e20c0 RSI:
ffff88010fa18a38 RDI: ffff880107164240
Sep 26 03:37:36 recorder kernel: RBP: ffff8801071211e8 R08:
0000000000000222 R09: 0000000000000020
Sep 26 03:37:36 recorder kernel: R10: ffff8801071641e8 R11:
ffff8800cf98df48 R12: ffff88010fa18a38
Sep 26 03:37:36 recorder kernel: R13: 000000394ac20000 R14:
0000000000000000 R15: ffff880107233500
Sep 26 03:37:36 recorder kernel: FS:  00007fa4bcd83700(0000)
GS:ffff88011fc00000(0000) knlGS:0000000000000000
Sep 26 03:37:36 recorder kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Sep 26 03:37:36 recorder kernel: CR2: 0000000000000008 CR3:
00000000caf9d000 CR4: 00000000000007f0
Sep 26 03:37:36 recorder kernel: Stack:
Sep 26 03:37:36 recorder kernel: ffffffff810e20c0 ffff8801071641e8
ffff8801071211e8 0000000000000000
Sep 26 03:37:36 recorder kernel: ffffffff810eb78b ffff88010fa18a38
000000394ae23000 ffff880107233540
Sep 26 03:37:36 recorder kernel: ffff88010c560ef8 ffff88010fa18a18
ffff880108e99180 0000000000000000
Sep 26 03:37:36 recorder kernel: Call Trace:
Sep 26 03:37:36 recorder kernel: [<ffffffff810e20c0>] ?
balloon_page_enqueue+0x90/0x90
Sep 26 03:37:36 recorder kernel: [<ffffffff810eb78b>] ?
vma_adjust+0x23b/0x670
Sep 26 03:37:36 recorder kernel: [<ffffffff810ebcdf>] ?
__split_vma.isra.35+0x11f/0x1d0
Sep 26 03:37:36 recorder kernel: [<ffffffff810eebb1>] ?
mprotect_fixup+0x1c1/0x270
Sep 26 03:37:36 recorder kernel: [<ffffffff810eedb3>] ?
SyS_mprotect+0x153/0x250
Sep 26 03:37:36 recorder kernel: [<ffffffff8141f952>] ?
system_call_fastpath+0x16/0x1b
Sep 26 03:37:36 recorder kernel: Code: 0f 1f 84 00 00 00 00 00 48 8b 07
48 85 c0 0f 84 ec 01 00 00 41 54 49 89 f4 55 53 48 83 ec 08 48 8b 18 f6
c3 01 0f 85 8c 01 00 00 <48> 8b 4b 08 49 89 d8 48 39 c8 74 4d 48 85 c9
0f 84 a8 00 00 00
Sep 26 03:37:36 recorder kernel: RIP  [<ffffffff8122e393>]
__rb_insert_augmented+0x23/0x200
Sep 26 03:37:36 recorder kernel: RSP <ffff8800cf98dde8>
Sep 26 03:37:36 recorder kernel: CR2: 0000000000000008
Sep 26 03:37:36 recorder kernel: ---[ end trace 7983ef4438c44a1f ]---

If you need more info, please let me know.

Kind regards,
Udo
