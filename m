Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbaLVDH6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 22:07:58 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:51468 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753733AbaLVDH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 22:07:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroGALCJl1R5LXwz/2dsb2JhbABbgwaELsZhgk0CgRYXAQEBAQF9hA0BBSMVHiIRCB0CBRYLAgIJAwIBAgEnHhMIAognuHSVSAELAR+BIY5YgmiBQQWgZyOHRCKCMoFPK4J0AQEB
Message-ID: <54978AFC.7080104@internode.on.net>
Date: Mon, 22 Dec 2014 13:37:40 +1030
From: Arthur Marsh <arthur.marsh@internode.on.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: general protection fault on 3.19.0-rc1 / amd64 SMP anon_vma_interval_tree_remove
 (?)
References: <6624c5997d630f90ef4243b18d3504910c3e653d@webmail.internode.on.net>
In-Reply-To: <6624c5997d630f90ef4243b18d3504910c3e653d@webmail.internode.on.net>
X-Forwarded-Message-Id: <6624c5997d630f90ef4243b18d3504910c3e653d@webmail.internode.on.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I just hit this rebooting an x86-64 3.19.0-rc1 kernel on a 4 core AMD
cpu when the machine was starting check the filesystems:

[   22.427652] general protection fault: 0000 [#1] PREEMPT SMP
[   22.431822] Modules linked in: max6650 fuse parport_pc ppdev lp 
parport snd_hda_codec_hdmi ir_mce_kbd_decoder ir_lirc_codec 
ir_sharp_decoder ir_jvc_decoder ir_xmp_decoder ir_sanyo_decoder lirc_dev 
ir_sony_decoder ir_rc5_decoder ir_rc6_decoder ir_nec_decoder 
snd_hda_codec_realtek fc0012 snd_hda_codec_generic dvb_usb_rtl28xxu 
rtl2830 rtl2832 snd_hda_intel snd_hda_controller i2c_mux dvb_usb_v2 
kvm_amd dvb_core kvm snd_hda_codec rc_core snd_hwdep snd_pcm_oss 
snd_mixer_oss snd_pcm snd_timer radeon snd soundcore ttm drm_kms_helper 
drm i2c_algo_bit psmouse pcspkr serio_raw evdev k10temp acpi_cpufreq 
sp5100_tco processor asus_atk0110 i2c_piix4 button thermal_sys wmi ext4 
mbcache crc16 jbd2 sg sr_mod cdrom sd_mod ata_generic uas usb_storage 
ohci_pci ahci pata_atiixp libahci libata r8169 mii ehci_pci scsi_mod
[   22.447067]  ohci_hcd ehci_hcd usbcore usb_common
[   22.452140] CPU: 2 PID: 449 Comm: udevd Not tainted 3.19.0-rc1 #1422
[   22.457351] Hardware name: System manufacturer System Product 
Name/M3A78 PRO, BIOS 1701    01/27/2011
[   22.462707] task: ffff8800cba60450 ti: ffff88022e21c000 task.ti: 
ffff88022e21c000
[   22.468111] RIP: 0010:[<ffffffff8115ec00>]  [<ffffffff8115ec00>] 
anon_vma_interval_tree_remove+0x1f0/0x250
[   22.473677] RSP: 0018:ffff88022e21fd28  EFLAGS: 00010246
[   22.479257] RAX: ffff88022e1f87a1 RBX: ffff88022e258540 RCX: 
0000000000000000
[   22.484914] RDX: 09be26aa0000000b RSI: ffff8800ca746f88 RDI: 
ffff88022e258540
[   22.490600] RBP: ffff88022e21fd38 R08: 0000000000000001 R09: 
0000000000000000
[   22.496345] R10: 0000000000000000 R11: ffff88022e258560 R12: 
ffff8800ca746ef8
[   22.502153] R13: ffff88022e1c88d0 R14: ffff8800ca746ef8 R15: 
ffff88022e1c88c0
[   22.507950] FS:  00007f465b1ed880(0000) GS:ffff88022d480000(0000) 
knlGS:0000000000000000
[   22.513766] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   22.519600] CR2: 00007f465a5e1148 CR3: 0000000223bf6000 CR4: 
00000000000007e0
[   22.525500] Stack:
[   22.531390]  ffff88022e258540 ffff8800ca746ef8 ffff88022e21fd88 
ffffffff81172f99
[   22.537441]  ffff88022e21fd58 ffff88022e1c8858 ffff88022e21fd88 
ffff88022e1c8908
[   22.543499]  000000301b600000 0000000000000000 ffff88022e21fdf8 
ffff88022e1c8858
[   22.549577] Call Trace:
[   22.555627]  [<ffffffff81172f99>] unlink_anon_vmas+0x69/0x1c0
[   22.561787]  [<ffffffff81164750>] free_pgtables+0xa0/0x120
[   22.567922]  [<ffffffff8116f18e>] exit_mmap+0xae/0x170
[   22.574018]  [<ffffffff8104f70d>] mmput+0x4d/0x110
[   22.580077]  [<ffffffff8105530f>] do_exit+0x2af/0xb30
[   22.586123]  [<ffffffff8153f820>] ? retint_swapgs+0x13/0x1b
[   22.592127]  [<ffffffff81055c1f>] do_group_exit+0x4f/0xe0
[   22.598082]  [<ffffffff81055cbf>] SyS_exit_group+0xf/0x10
[   22.603928]  [<ffffffff8153eb69>] system_call_fastpath+0x12/0x17
[   22.609688] Code: 85 c0 4c 89 c0 74 5c 4d 39 58 10 74 4a 49 89 48 08 
48 85 c9 74 52 48 89 11 45 31 c0 48 85 c0 0f 85 43 ff ff ff eb 9e 48 8b 
47 20 <48> 89 02 48 83 e0 fc 74 4c 4c 3b 58 10 74 23 48 89 50 08 eb d9
[   22.616345] RIP  [<ffffffff8115ec00>] 
anon_vma_interval_tree_remove+0x1f0/0x250
[   22.622537]  RSP <ffff88022e21fd28>
[   22.628794] ---[ end trace d911d3ebea9cb352 ]---
[   22.635030] Fixing recursive fault but reboot is needed!

  I haven't hit one of these errors for a while and this has only
happened the once with this kernel. If anyone wants more details I'm
happy to supply them.
  Arthur.



