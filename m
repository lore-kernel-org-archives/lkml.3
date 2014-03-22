Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaCVXnV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 19:43:21 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:58885 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaCVXnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 19:43:19 -0400
Date: Sun, 23 Mar 2014 00:43:17 +0100
From: Andreas Mohr <andi@lisas.de>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: 3.14-rc7 crashes in drm ([PATCH] a crash in mga_driver_irq_uninstall)
Message-ID: <20140322234317.GA10483@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1402261551010.9913@file01.intranet.prod.int.rdu2.redhat.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

now testing 3.14-rc7 here (r128 hardware rather than MGA),
and I seem to still be experiencing the same or very similar crash as you here:

agpgart-intel 0000:00:00.0: AGP 2.0 bridge
agpgart-intel 0000:00:00.0: putting AGP V2 device into 4x mode
pci 0000:01:00.0: putting AGP V2 device into 4x mode
Registering platform device 'r128_cce.0'. Parent at platform
device: 'r128_cce.0': device_add
bus: 'platform': add device r128_cce.0
PM: Adding info for platform:r128_cce.0
__allocate_fw_buf: fw-r128/r128_cce.bin buf=dd9ec800
platform r128_cce.0: firmware: direct-loading firmware r128/r128_cce.bin
fw_set_page_data: fw-r128/r128_cce.bin buf=dd9ec800 data=e07f8000 size=2048
bus: 'platform': remove device r128_cce.0
PM: Removing info for platform:r128_cce.0
fw_name_devm_release: fw_name-r128/r128_cce.bin devm-dd9ccfcc released
__fw_free_buf: fw-r128/r128_cce.bin buf=dd9ec800 data=e07f8000 size=2048
evbug: Event. Dev: input7, Type: 2, Code: 0, Value: 1
evbug: Event. Dev: input7, Type: 2, Code: 1, Value: 1
evbug: Event. Dev: input7, Type: 0, Code: 0, Value: 0
evbug: Event. Dev: input7, Type: 2, Code: 0, Value: 2
evbug: Event. Dev: input7, Type: 0, Code: 0, Value: 0
BUG: unable to handle kernel paging request at e07f0040
IP: [<e293fdb8>] r128_driver_irq_uninstall+0x18/0x1d [r128]
*pde = 1f414067 *pte = 00000000 
Oops: 0002 [#1] 
Modules linked in: lp r128 drm uinput nls_iso8859_1 nls_cp437 vfat fat radeonfb 
cfbfillrect cfbimgblt cfbcopyarea i2c_algo_bit fb_ddc i2c_core fb fbdev ppdev lo
op fuse firewire_sbp2 mcs7830 usbnet usb_storage mii iTCO_wdt iTCO_vendor_suppor
t snd_maestro3 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq
_midi snd_rawmidi snd_seq_oss pcmcia snd_seq_midi_event snd_seq snd_seq_device s
nd_timer microcode firewire_ohci dell_laptop sg dcdbas yenta_socket snd firewire
_core sr_mod pcmcia_rsrc psmouse crc_itu_t cdrom pcmcia_core pcspkr video backli
ght evbug evdev uhci_hcd floppy rtc_cmos ehci_hcd intel_agp intel_gtt usbcore us
b_common lpc_ich mfd_core
CPU: 0 PID: 4674 Comm: Xorg Not tainted 3.14.0-rc7+ #9
Hardware name: Dell Computer Corporation Inspiron 8000                   /Inspir
on 8000            , BIOS A23 01/21/2004
task: ded082f0 ti: da6c4000 task.ti: da6c4000
EIP: 0060:[<e293fdb8>] EFLAGS: 00213246 CPU: 0
EIP is at r128_driver_irq_uninstall+0x18/0x1d [r128]
EAX: 00000000 EBX: dd9eb400 ECX: 00000000 EDX: e07f0000
ESI: 00000001 EDI: dd9ccd40 EBP: da6c5d48 ESP: da6c5d48
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
CR0: 80050033 CR2: e07f0040 CR3: 1da53000 CR4: 000007d0
Stack:
 da6c5d78 e284dc79 00000000 e28696c5 e285fddc e28696bd 0000000b 01cc54c0
 00203202 dd9eb400 dd9eb400 00000000 da6c5d90 e293b163 dd9ec8e0 dd9ec8e8
 dd9eb400 dd9eb400 da6c5d98 e293fc9c da6c5dc0 e284c542 00000001 e2869575
Call Trace:
 [<e284dc79>] drm_irq_uninstall+0x119/0x13b [drm]
 [<e293b163>] r128_do_cleanup_cce+0x15/0xb3 [r128]
 [<e293fc9c>] r128_driver_lastclose+0x8/0xa [r128]
 [<e284c542>] drm_lastclose+0x40/0x143 [drm]
 [<e284ca37>] drm_release+0x3f2/0x419 [drm]
 [<c10b4c07>] __fput+0xca/0x185
 [<c10b4ce8>] ____fput+0x8/0xa
 [<c103c213>] task_work_run+0x4f/0x60
 [<c102a4fc>] do_exit+0x27f/0x6bb
 [<c1032bc0>] ? __sigqueue_free+0x2c/0x2f
 [<c102b4df>] do_group_exit+0x2e/0x65
 [<c1034963>] get_signal_to_deliver+0x420/0x45b
 [<c1033788>] ? __send_signal.constprop.34+0x15a/0x234
 [<c10014a2>] do_signal+0x34/0x6d0
 [<c1033fdf>] ? do_send_specific+0x4a/0x74
 [<c1001b69>] do_notify_resume+0x2b/0x52
 [<c12c5a33>] work_notifysig+0x24/0x29
Code: 50 10 b8 01 00 00 00 89 42 44 5d c3 55 31 c0 89 e5 5d c3 55 8b 80 e8 00 00 00 89 e5 85 c0 74 0e 8b 80 94 00 00 00 8b 50 10 31 c0 <89> 42 40 5d c3 55 ba f0 0c 94 e2 89 e5 b8 68 0d 94 e2 e8 55 15
EIP: [<e293fdb8>] r128_driver_irq_uninstall+0x18/0x1d [r128] SS:ESP 0068:da6c5d48
CR2: 00000000e07f0040
---[ end trace 018ccfcd552fb6cf ]---
Fixing recursive fault but reboot is needed!
device: '254:0': device_add








Applying your (probably experimental?) posted patch
(thanks for having done the necessary debugging work for me :)
upon next boot made this dump go away,
but I got greeted with a relatively similar:











[drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[drm] No driver support for vblank timestamp query.
[drm] Initialized r128 2.5.0 20030725 for 0000:01:00.0 on minor 0
agpgart-intel 0000:00:00.0: AGP 2.0 bridge
agpgart-intel 0000:00:00.0: putting AGP V2 device into 4x mode
pci 0000:01:00.0: putting AGP V2 device into 4x mode
Registering platform device 'r128_cce.0'. Parent at platform
device: 'r128_cce.0': device_add
bus: 'platform': add device r128_cce.0
PM: Adding info for platform:r128_cce.0
__allocate_fw_buf: fw-r128/r128_cce.bin buf=dda02aa0
platform r128_cce.0: firmware: direct-loading firmware r128/r128_cce.bin
fw_set_page_data: fw-r128/r128_cce.bin buf=dda02aa0 data=e080c000 size=2048
bus: 'platform': remove device r128_cce.0
PM: Removing info for platform:r128_cce.0
fw_name_devm_release: fw_name-r128/r128_cce.bin devm-dda289cc released
__fw_free_buf: fw-r128/r128_cce.bin buf=dda02aa0 data=e080c000 size=2048
device class 'printer': registering
lp: driver loaded but no devices found
BUG: unable to handle kernel NULL pointer dereference at 00000058
IP: [<e2a11cab>] r128_get_vblank_counter+0xd/0x16 [r128]
*pde = 00000000 
Oops: 0000 [#1] 
Modules linked in: lp r128 drm uinput nls_iso8859_1 nls_cp437 vfat fat radeonfb cfbfillrect cfbimgblt cfbcopyarea i2c_algo_bit fb_ddc i2c_core fb fbdev ppdev loop fuse firewire_sbp2 mcs7830 usbnet mii usb_storage iTCO_wdt iTCO_vendor_support snd_maestro3 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi microcode snd_seq_oss dell_laptop snd_seq_midi_event dcdbas snd_seq snd_seq_device pcmcia snd_timer sg firewire_ohci sr_mod psmouse pcspkr firewire_core yenta_socket crc_itu_t snd cdrom pcmcia_rsrc pcmcia_core video backlight rtc_cmos floppy uhci_hcd ehci_hcd evbug evdev intel_agp lpc_ich intel_gtt mfd_core usbcore usb_common
CPU: 0 PID: 3842 Comm: Xorg Not tainted 3.14.0-rc7+ #9
Hardware name: Dell Computer Corporation Inspiron 8000                   /Inspiron 8000            , BIOS A23 01/21/2004
task: df796230 ti: dd9ee000 task.ti: dd9ee000
EIP: 0060:[<e2a11cab>] EFLAGS: 00213046 CPU: 0
EIP is at r128_get_vblank_counter+0xd/0x16 [r128]
EAX: 00000000 EBX: decd0c00 ECX: e2a12d68 EDX: 00000000
ESI: 00000001 EDI: dda28400 EBP: dd9efebc ESP: dd9efebc
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
CR0: 80050033 CR2: 00000058 CR3: 1da04000 CR4: 000007d0
Stack:
 dd9efeec e29bbbe6 00000000 c0000000 bfc2f150 00000009 dd9efee4 00a0f964
 00203202 dda02b00 decd0c00 00000000 dd9eff08 e29bd7bb 00000000 decd0c40
 dd9a2cc0 decd0c00 00000000 dd9eff14 e29bd893 dd9a2c80 dd9eff54 e29ba9c6
Call Trace:
 [<e29bbbe6>] drm_irq_uninstall+0x86/0x126 [drm]
 [<e29bd7bb>] drm_master_destroy+0x31/0xee [drm]
 [<e29bd893>] drm_master_put+0x1b/0x1d [drm]
 [<e29ba9c6>] drm_release+0x381/0x419 [drm]
 [<c10b4c07>] __fput+0xca/0x185
 [<c10b4ce8>] ____fput+0x8/0xa
 [<c103c213>] task_work_run+0x4f/0x60
 [<c1001b8c>] do_notify_resume+0x4e/0x52
 [<c12c5a33>] work_notifysig+0x24/0x29
Code: 10 8b 80 14 07 00 00 c7 43 48 00 00 00 00 83 c4 14 5b 5d c3 55 89 e5 e8 b2 b4 ff ff 5d c3 55 85 d2 8b 80 e8 00 00 00 89 e5 75 05 <8b> 40 58 eb 02 31 c0 5d c3 55 89 e5 53 8b 8a e8 00 00 00 89 d3
EIP: [<e2a11cab>] r128_get_vblank_counter+0xd/0x16 [r128] SS:ESP 0068:dd9efebc
CR2: 0000000000000058
---[ end trace 0180925feaa449a7 ]---
device: 'vcs9': device_add


and non-responsive graphics mode.


01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Rage Mobility 128 AGP 4X/Mobility M4


ii  libdrm-dev                           2.4.45-3                          i386         Userspace interface to kernel DRM services -- development files
ii  libdrm-intel1:i386                   2.4.45-3                          i386         Userspace interface to intel-specific kernel DRM services -- runtime
rc  libdrm-nouveau1                      2.4.21-1~squeeze3                 i386         Userspace interface to nouveau-specific kernel DRM services -- runtime
ii  libdrm-nouveau2:i386                 2.4.45-3                          i386         Userspace interface to nouveau-specific kernel DRM services -- runtime
ii  libdrm-radeon1:i386                  2.4.45-3                          i386         Userspace interface to radeon-specific kernel DRM services -- runtime
ii  libdrm2:i386                         2.4.45-3                          i386         Userspace interface to kernel DRM services -- runtime


So, "Hmm?" :)

Thanks,

Andreas Mohr
