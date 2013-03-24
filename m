Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab3CXUpF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 16:45:05 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:32812 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab3CXUpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 16:45:00 -0400
MIME-Version: 1.0
Reply-To: pierre.sauter@gmail.com
Date: Sun, 24 Mar 2013 21:44:57 +0100
Message-ID: <CANwVZGP96hUt-9PaTFmSaA0w+RoT9MvNiL60ZKqor3oDg8Sa7Q@mail.gmail.com>
Subject: PROBLEM: snd_hda_intel: Kernel crashes with onboard intel sound and
 Nvidia graphics card
From: Pierre Sauter <pierre.sauter@gmail.com>
To: alsa-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] One line summary:
With an activated onboard intel sound and nvidia graphics card with
hdmi sound device snd_hda_intel causes a kernel crash.

[2.] Full description of the problem/report:
Since installing a newish nvidia graphics card the kernel crashes
reproducibly during boot.
To boot successfully it is necessary to either deactivate the onboard
sound in BIOS or blacklist snd_hda_intel.
The two offending devices are:

# lspci -vvv -s 00:14.2
00:14.2 Audio device: Advanced Micro Devices [AMD] nee ATI SBx00
Azalia (Intel HDA) (rev 40)
        Subsystem: ASUSTeK Computer Inc. M4A89GTD PRO/USB3 Motherboard
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at fcff8000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

# lspci -vvv -s 01:00.1
01:00.1 Audio device: NVIDIA Corporation GF108 High Definition Audio
Controller (rev a1)
        Subsystem: ZOTAC International (MCO) Ltd. Device 5199
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 11
        Region 0: Memory at fe67c000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [60] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [78] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<4us, L1 <64us
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
                LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-

I flashed the newest bios version from Asus (3029) for my board (M4A89GTD PRO)
which mentioned something about hdmi audio, with no effect.

[3.] Keywords:
snd_hda_intel

[4.] Kernel version (from /proc/version):
cat /proc/version
Linux version 3.9.0-rc3 (pierre@r062032) (gcc version 4.7.2 (Debian
4.7.2-5) ) #10 SMP PREEMPT Sun Mar 24 19:52:04 CET 2013

[5.] Output of Oops.. message:
[  135.851607] usb 2-3: USB disconnect, device number 4
[  159.656001] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000128
[  159.662670] IP: [<ffffffffa05a55fa>]
snd_hda_queue_unsol_event+0x3a/0x9e [snd_hda_codec]
[  159.669285] PGD 40c91b067 PUD 40e73e067 PMD 0
[  159.675853] Oops: 0000 [#1] PREEMPT SMP
[  159.682371] Modules linked in: snd_hda_intel(+) snd_hda_codec
snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer
usb_storage netconsole configfs cpufreq_conservative cpufreq_powersave
cpufreq_userspace cpufreq_stats parport_pc ppdev lp parport
sp5100_tco ext3 jbd hid_generic joydev hid_logitech_dj usbhid hid
acpi_cpufreq mperf kvm_amd kvm pcspkr psmouse microcode serio_raw
edac_mce_amd k10temp i2c_piix4 edac_core nouveau video mxm_wmi ttm
drm_kms_helper drm evdev i2c_algo_bit i2c_core processor thermal_sys
asus_atk0110 cpuid msr loop firewire_sbp2 fuse autofs4 ext4 crc16 jbd2
mbcache btrfs xor zlib_deflate raid6_pq crc32c libcrc32c sd_mod
crc_t10dif
md_mod uvesafb cn sg sr_mod cdrom firewire_ohci firewire_core
crc_itu_t ata_generic ohci_hcd ehci_pci pata_jmicron ehci_hcd ahci
pata_atiixp
libahci usbcore wmi usb_common libata scsi_mod button
[  159.713866] CPU 5
[  159.713926] Pid: 3161, comm: rsync Not tainted 3.9.0-rc3 #10 System
manufacturer System Product Name/M4A89GTD-PRO
[  159.729842] RIP: 0010:[<ffffffffa05a55fa>]  [<ffffffffa05a55fa>]
snd_hda_queue_unsol_event+0x3a/0x9e [snd_hda_codec]
[  159.738111] RSP: 0018:ffff88041fd43e38  EFLAGS: 00010046
[  159.746381] RAX: 0000000000000000 RBX: ffff88040bade000 RCX: 0000000000000010
[  159.754755] RDX: 0000000000000010 RSI: 00000000ffffffff RDI: 0000000000000000
[  159.763151] RBP: 0000000000000000 R08: ffff88041ec00050 R09: 00000000ffffffff
[  159.771564] R10: ffff88040ed1a000 R11: 000000000000b74c R12: 00000000ffffffff
[  159.779986] R13: 0000000000000010 R14: 00000000c0000000 R15: ffff88040bade200
[  159.788410] FS:  00007ff553fc2700(0000) GS:ffff88041fd40000(0000)
knlGS:0000000000000000
[  159.796927] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  159.805449] CR2: 0000000000000128 CR3: 000000040bf9c000 CR4: 00000000000007e0
[  159.813994] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  159.822492] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  159.830940] Process rsync (pid: 3161, threadinfo ffff88040dab2000,
task ffff88040e124c20)
[  159.839447] Stack:
[  159.847908]  0000000000000010 ffff88040bade000 0000000000000001
0000000000000000
[  159.856621]  0000000000000008 ffffffffa05d44d0 ffff88040bade000
ffff8803d038ccd0
[  159.865340]  ffff88040bade044 ffffffffa05d5960 ffff88040eddcac0
0000000000000010
[  159.874056] Call Trace:
[  159.882653]  <IRQ>
[  159.882711]  [<ffffffffa05d44d0>] ? azx_update_rirb+0x81/0xe2 [snd_hda_intel]
[  159.899841]  [<ffffffffa05d5960>] ? azx_interrupt+0x133/0x157 [snd_hda_intel]
[  159.908389]  [<ffffffff8109f163>] ? handle_irq_event_percpu+0x68/0x1e2
[  159.916909]  [<ffffffff8109f314>] ? handle_irq_event+0x37/0x57
[  159.925369]  [<ffffffff810a183c>] ? handle_fasteoi_irq+0x77/0xaa
[  159.933839]  [<ffffffff81010ac9>] ? handle_irq+0x15/0x1d
[  159.942293]  [<ffffffff8101080b>] ? do_IRQ+0x41/0x96
[  159.950723]  [<ffffffff813908ed>] ? common_interrupt+0x6d/0x6d
[  159.959157]  <EOI>
[  159.959213]  [<ffffffff8105fcfa>] ? __wake_up_common+0x42/0x78
[  159.976021]  [<ffffffff8108292e>] ? arch_local_irq_restore+0x2/0x8
[  159.984471]  [<ffffffff81390659>] ? _raw_spin_unlock_irqrestore+0xd/0x38
[  159.992942]  [<ffffffff812bf411>] ? sock_def_readable+0x35/0x4f
[  160.001413]  [<ffffffff8133ef9e>] ? unix_stream_sendmsg+0x217/0x2a5
[  160.009878]  [<ffffffff812bbb42>] ? sock_aio_write+0xc8/0xed
[  160.018306]  [<ffffffff8110b9c7>] ? do_sync_write+0x62/0x9b
[  160.026700]  [<ffffffff8110bf7d>] ? vfs_write+0x9d/0xf8
[  160.035058]  [<ffffffff8110c19e>] ? sys_write+0x51/0x80
[  160.043338]  [<ffffffff81394ea9>] ? system_call_fastpath+0x16/0x1b
[  160.051649] Code: 51 8b 05 02 59 01 00 85 c0 74 20 eb 65 48 8b 7b
08 44 89 e9 44 89 e2 48 89 ee ff 13 48 83 c3 10 48 83 3b 00 eb 5b e8
4b
fa ff ff <48> 8b 85 28 01 00 00 48 85 c0 74 4e 44 8b 80 04 02 00 00 48 8d
[  160.061274] RIP  [<ffffffffa05a55fa>]
snd_hda_queue_unsol_event+0x3a/0x9e [snd_hda_codec]
[  160.070185]  RSP <ffff88041fd43e38>
[  160.078996] CR2: 0000000000000128
[  160.087726] ---[ end trace 8909788ac576b268 ]---
[  160.096445] Kernel panic - not syncing: Fatal exception in interrupt
[  161.396279] Shutting down cpus with NMI
[  161.405056] drm_kms_helper: panic occurred, switching back to text console
[  161.413955] ------------[ cut here ]------------
[  161.422873] WARNING: at drivers/gpu/drm/drm_crtc.c:82
drm_warn_on_modeset_not_all_locked+0x33/0x68 [drm]()
[  161.431987] Hardware name: System Product Name
[  161.441094] Modules linked in: snd_hda_intel(+) snd_hda_codec
snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer
usb_storage netconsole configfs cpufreq_conservative cpufreq_powersave
cpufreq_userspace cpufreq_stats parport_pc ppdev lp parport
sp5100_tco ext3 jbd hid_generic joydev hid_logitech_dj usbhid hid
acpi_cpufreq mperf kvm_amd kvm pcspkr psmouse microcode serio_raw
edac_mce_amd k10temp i2c_piix4 edac_core nouveau video mxm_wmi ttm
drm_kms_helper drm evdev i2c_algo_bit i2c_core processor thermal_sys
asus_atk0110 cpuid msr loop firewire_sbp2 fuse autofs4 ext4 crc16 jbd2
mbcache btrfs xor zlib_deflate raid6_pq crc32c libcrc32c sd_mod
crc_t10dif
md_mod uvesafb cn sg sr_mod cdrom firewire_ohci firewire_core
crc_itu_t ata_generic ohci_hcd ehci_pci pata_jmicron ehci_hcd ahci
pata_atiixp
libahci usbcore wmi usb_common libata scsi_mod button
[  161.483289] Pid: 3161, comm: rsync Tainted: G      D      3.9.0-rc3 #10
[  161.493917] Call Trace:
[  161.504429]  <IRQ>  [<ffffffff8103f27c>] ? warn_slowpath_common+0x76/0x8c
[  161.515136]  [<ffffffffa037d149>] ?
drm_warn_on_modeset_not_all_locked+0x33/0x68 [drm]
[  161.525817]  [<ffffffffa03aaa23>] ?
drm_fb_helper_restore_fbdev_mode+0x1a/0x48 [drm_kms_helper]
[  161.536482]  [<ffffffffa03aaa88>] ?
drm_fb_helper_force_kernel_mode+0x37/0x66 [drm_kms_helper]
[  161.547096]  [<ffffffffa03aae16>] ? drm_fb_helper_panic+0x1e/0x24
[drm_kms_helper]
[  161.557709]  [<ffffffff813932bb>] ? notifier_call_chain+0x2e/0x59
[  161.567981]  [<ffffffff81393320>] ? __atomic_notifier_call_chain+0x3a/0x4d
[  161.577927]  [<ffffffff8138a9ea>] ? panic+0xf6/0x1d1
[  161.587491]  [<ffffffff813915ce>] ? oops_end+0xa1/0xae
[  161.596695]  [<ffffffff8138a414>] ? no_context+0x241/0x26c
[  161.605702]  [<ffffffff810648e5>] ? check_preempt_curr+0x36/0x62
[  161.614617]  [<ffffffff8139320c>] ? __do_page_fault+0x30c/0x388
[  161.623407]  [<ffffffff81056698>] ? __queue_work+0x1a1/0x1ea
[  161.632075]  [<ffffffff81056737>] ? queue_work_on+0x47/0x53
[  161.640684]  [<ffffffff811af939>] ? blk_peek_request+0x19a/0x1d3
[  161.649319]  [<ffffffff81390c08>] ? page_fault+0x28/0x30
[  161.657951]  [<ffffffffa05a55fa>] ?
snd_hda_queue_unsol_event+0x3a/0x9e [snd_hda_codec]
[  161.666683]  [<ffffffffa05d44d0>] ? azx_update_rirb+0x81/0xe2 [snd_hda_intel]
[  161.675429]  [<ffffffffa05d5960>] ? azx_interrupt+0x133/0x157 [snd_hda_intel]
[  161.684089]  [<ffffffff8109f163>] ? handle_irq_event_percpu+0x68/0x1e2
[  161.692706]  [<ffffffff8109f314>] ? handle_irq_event+0x37/0x57
[  161.701245]  [<ffffffff810a183c>] ? handle_fasteoi_irq+0x77/0xaa
[  161.709802]  [<ffffffff81010ac9>] ? handle_irq+0x15/0x1d
[  161.718370]  [<ffffffff8101080b>] ? do_IRQ+0x41/0x96
[  161.726843]  [<ffffffff813908ed>] ? common_interrupt+0x6d/0x6d
[  161.735256]  <EOI>  [<ffffffff8105fcfa>] ? __wake_up_common+0x42/0x78
[  161.743693]  [<ffffffff8108292e>] ? arch_local_irq_restore+0x2/0x8
[  161.752127]  [<ffffffff81390659>] ? _raw_spin_unlock_irqrestore+0xd/0x38
[  161.760572]  [<ffffffff812bf411>] ? sock_def_readable+0x35/0x4f
[  161.768957]  [<ffffffff8133ef9e>] ? unix_stream_sendmsg+0x217/0x2a5
[  161.777398]  [<ffffffff812bbb42>] ? sock_aio_write+0xc8/0xed
[  161.785779]  [<ffffffff8110b9c7>] ? do_sync_write+0x62/0x9b
[  161.794170]  [<ffffffff8110bf7d>] ? vfs_write+0x9d/0xf8
[  161.802508]  [<ffffffff8110c19e>] ? sys_write+0x51/0x80
[  161.810832]  [<ffffffff81394ea9>] ? system_call_fastpath+0x16/0x1b
[  161.819189] ---[ end trace 8909788ac576b269 ]---
[  161.827559] ------------[ cut here ]------------
[  161.836074] WARNING: at drivers/gpu/drm/drm_crtc.c:82
drm_warn_on_modeset_not_all_locked+0x33/0x68 [drm]()
[  161.844898] Hardware name: System Product Name
[  161.853586] Modules linked in: snd_hda_intel(+) snd_hda_codec
snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer
usb_storage netconsole configfs cpufreq_conservative cpufreq_powersave
cpufreq_userspace cpufreq_stats parport_pc ppdev lp parport
sp5100_tco ext3 jbd hid_generic joydev hid_logitech_dj usbhid hid
acpi_cpufreq mperf kvm_amd kvm pcspkr psmouse microcode serio_raw
edac_mce_amd k10temp i2c_piix4 edac_core nouveau video mxm_wmi ttm
drm_kms_helper drm evdev i2c_algo_bit i2c_core processor thermal_sys
asus_atk0110 cpuid msr loop firewire_sbp2 fuse autofs4 ext4 crc16 jbd2
mbcache btrfs xor zlib_deflate raid6_pq crc32c libcrc32c sd_mod
crc_t10dif
md_mod uvesafb cn sg sr_mod cdrom firewire_ohci firewire_core
crc_itu_t ata_generic ohci_hcd ehci_pci pata_jmicron ehci_hcd ahci
pata_atiixp
libahci usbcore wmi usb_common libata scsi_mod button
[  161.894142] Pid: 3161, comm: rsync Tainted: G      D W    3.9.0-rc3 #10
[  161.904392] Call Trace:
[  161.914573]  <IRQ>  [<ffffffff8103f27c>] ? warn_slowpath_common+0x76/0x8c
[  161.924950]  [<ffffffffa037d149>] ?
drm_warn_on_modeset_not_all_locked+0x33/0x68 [drm]
[  161.935395]  [<ffffffffa03aaa23>] ?
drm_fb_helper_restore_fbdev_mode+0x1a/0x48 [drm_kms_helper]
[  161.945941]  [<ffffffffa03aaa88>] ?
drm_fb_helper_force_kernel_mode+0x37/0x66 [drm_kms_helper]
[  161.956510]  [<ffffffffa03aae16>] ? drm_fb_helper_panic+0x1e/0x24
[drm_kms_helper]
[  161.966826]  [<ffffffff813932bb>] ? notifier_call_chain+0x2e/0x59
[  161.976872]  [<ffffffff81393320>] ? __atomic_notifier_call_chain+0x3a/0x4d
[  161.986876]  [<ffffffff8138a9ea>] ? panic+0xf6/0x1d1
[  161.996874]  [<ffffffff813915ce>] ? oops_end+0xa1/0xae
[  162.006855]  [<ffffffff8138a414>] ? no_context+0x241/0x26c
[  162.016793]  [<ffffffff810648e5>] ? check_preempt_curr+0x36/0x62
[  162.026706]  [<ffffffff8139320c>] ? __do_page_fault+0x30c/0x388
[  162.036566]  [<ffffffff81056698>] ? __queue_work+0x1a1/0x1ea
[  162.046365]  [<ffffffff81056737>] ? queue_work_on+0x47/0x53
[  162.056034]  [<ffffffff811af939>] ? blk_peek_request+0x19a/0x1d3
[  162.065607]  [<ffffffff81390c08>] ? page_fault+0x28/0x30
[  162.074847]  [<ffffffffa05a55fa>] ?
snd_hda_queue_unsol_event+0x3a/0x9e [snd_hda_codec]
[  162.083832]  [<ffffffffa05d44d0>] ? azx_update_rirb+0x81/0xe2 [snd_hda_intel]
[  162.092482]  [<ffffffffa05d5960>] ? azx_interrupt+0x133/0x157 [snd_hda_intel]
[  162.100763]  [<ffffffff8109f163>] ? handle_irq_event_percpu+0x68/0x1e2
[  162.108864]  [<ffffffff8109f314>] ? handle_irq_event+0x37/0x57
[  162.116793]  [<ffffffff810a183c>] ? handle_fasteoi_irq+0x77/0xaa
[  162.124661]  [<ffffffff81010ac9>] ? handle_irq+0x15/0x1d
[  162.132435]  [<ffffffff8101080b>] ? do_IRQ+0x41/0x96
[  162.140144]  [<ffffffff813908ed>] ? common_interrupt+0x6d/0x6d
[  162.147833]  <EOI>  [<ffffffff8105fcfa>] ? __wake_up_common+0x42/0x78
[  162.155579]  [<ffffffff8108292e>] ? arch_local_irq_restore+0x2/0x8
[  162.163318]  [<ffffffff81390659>] ? _raw_spin_unlock_irqrestore+0xd/0x38
[  162.171061]  [<ffffffff812bf411>] ? sock_def_readable+0x35/0x4f
[  162.178789]  [<ffffffff8133ef9e>] ? unix_stream_sendmsg+0x217/0x2a5
[  162.186550]  [<ffffffff812bbb42>] ? sock_aio_write+0xc8/0xed
[  162.194314]  [<ffffffff8110b9c7>] ? do_sync_write+0x62/0x9b
[  162.202066]  [<ffffffff8110bf7d>] ? vfs_write+0x9d/0xf8
[  162.209798]  [<ffffffff8110c19e>] ? sys_write+0x51/0x80
[  162.217494]  [<ffffffff81394ea9>] ? system_call_fastpath+0x16/0x1b
[  162.225226] ---[ end trace 8909788ac576b26a ]---
[  162.232956] ------------[ cut here ]------------
[  162.240803] WARNING: at drivers/gpu/drm/drm_crtc.c:84
drm_fb_helper_restore_fbdev_mode+0x1a/0x48 [drm_kms_helper]()
[  162.248845] Hardware name: System Product Name
[  162.256835] Modules linked in: snd_hda_intel(+) snd_hda_codec
snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer
usb_storage netconsole configfs cpufreq_conservative cpufreq_powersave
cpufreq_userspace cpufreq_stats parport_pc ppdev lp parport
sp5100_tco ext3 jbd hid_generic joydev hid_logitech_dj usbhid hid
acpi_cpufreq mperf kvm_amd kvm pcspkr psmouse microcode serio_raw
edac_mce_amd k10temp i2c_piix4 edac_core nouveau video mxm_wmi ttm
drm_kms_helper drm evdev i2c_algo_bit i2c_core processor thermal_sys
asus_atk0110 cpuid msr loop firewire_sbp2 fuse autofs4 ext4 crc16 jbd2
mbcache btrfs xor zlib_deflate raid6_pq crc32c libcrc32c sd_mod
crc_t10dif
md_mod uvesafb cn sg sr_mod cdrom firewire_ohci firewire_core
crc_itu_t ata_generic ohci_hcd ehci_pci pata_jmicron ehci_hcd ahci
pata_atiixp
libahci usbcore wmi usb_common libata scsi_mod button
[  162.294776] Pid: 3161, comm: rsync Tainted: G      D W    3.9.0-rc3 #10
[  162.304428] Call Trace:
[  162.314035]  <IRQ>  [<ffffffff8103f27c>] ? warn_slowpath_common+0x76/0x8c
[  162.323912]  [<ffffffffa03aaa23>] ?
drm_fb_helper_restore_fbdev_mode+0x1a/0x48 [drm_kms_helper]
[  162.333760]  [<ffffffffa03aaa88>] ?
drm_fb_helper_force_kernel_mode+0x37/0x66 [drm_kms_helper]
[  162.343590]  [<ffffffffa03aae16>] ? drm_fb_helper_panic+0x1e/0x24
[drm_kms_helper]
[  162.353400]  [<ffffffff813932bb>] ? notifier_call_chain+0x2e/0x59
[  162.363183]  [<ffffffff81393320>] ? __atomic_notifier_call_chain+0x3a/0x4d
[  162.372991]  [<ffffffff8138a9ea>] ? panic+0xf6/0x1d1
[  162.382772]  [<ffffffff813915ce>] ? oops_end+0xa1/0xae
[  162.392547]  [<ffffffff8138a414>] ? no_context+0x241/0x26c
[  162.402329]  [<ffffffff810648e5>] ? check_preempt_curr+0x36/0x62
[  162.412161]  [<ffffffff8139320c>] ? __do_page_fault+0x30c/0x388
[  162.421989]  [<ffffffff81056698>] ? __queue_work+0x1a1/0x1ea
[  162.431773]  [<ffffffff81056737>] ? queue_work_on+0x47/0x53
[  162.441544]  [<ffffffff811af939>] ? blk_peek_request+0x19a/0x1d3
[  162.451217]  [<ffffffff81390c08>] ? page_fault+0x28/0x30
[  162.460777]  [<ffffffffa05a55fa>] ?
snd_hda_queue_unsol_event+0x3a/0x9e [snd_hda_codec]
[  162.470108]  [<ffffffffa05d44d0>] ? azx_update_rirb+0x81/0xe2 [snd_hda_intel]
[  162.479104]  [<ffffffffa05d5960>] ? azx_interrupt+0x133/0x157 [snd_hda_intel]
[  162.487718]  [<ffffffff8109f163>] ? handle_irq_event_percpu+0x68/0x1e2
[  162.496001]  [<ffffffff8109f314>] ? handle_irq_event+0x37/0x57
[  162.504052]  [<ffffffff810a183c>] ? handle_fasteoi_irq+0x77/0xaa
[  162.512070]  [<ffffffff81010ac9>] ? handle_irq+0x15/0x1d
[  162.520014]  [<ffffffff8101080b>] ? do_IRQ+0x41/0x96
[  162.527868]  [<ffffffff813908ed>] ? common_interrupt+0x6d/0x6d
[  162.535682]  <EOI>  [<ffffffff8105fcfa>] ? __wake_up_common+0x42/0x78
[  162.543557]  [<ffffffff8108292e>] ? arch_local_irq_restore+0x2/0x8
[  162.551418]  [<ffffffff81390659>] ? _raw_spin_unlock_irqrestore+0xd/0x38
[  162.559278]  [<ffffffff812bf411>] ? sock_def_readable+0x35/0x4f
[  162.567122]  [<ffffffff8133ef9e>] ? unix_stream_sendmsg+0x217/0x2a5
[  162.574970]  [<ffffffff812bbb42>] ? sock_aio_write+0xc8/0xed
[  162.582829]  [<ffffffff8110b9c7>] ? do_sync_write+0x62/0x9b
[  162.590691]  [<ffffffff8110bf7d>] ? vfs_write+0x9d/0xf8
[  162.598530]  [<ffffffff8110c19e>] ? sys_write+0x51/0x80
[  162.606332]  [<ffffffff81394ea9>] ? system_call_fastpath+0x16/0x1b
[  162.614160] ---[ end trace 8909788ac576b26b ]---

[6.] A small shell script or example program which triggers the problem:
modprobe snd_hda_intel

[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)
 Gnu C                  4.7
Gnu make               3.81
binutils               2.22
util-linux             2.20.1
mount                  support
module-init-tools      9
e2fsprogs              1.42.5
PPP                    2.4.5
Linux C Library        2.17
Dynamic linker (ldd)   2.17
Procps                 3.3.4
Net-tools              1.60
Kbd                    1.15.3
Sh-utils               8.20
Modules Loaded         cpufreq_conservative cpufreq_powersave
cpufreq_userspace cpufreq_stats parport_pc ppdev lp parport ext3 jbd
hid_logitech_dj joydev hid_generic usbhid hid acpi_cpufreq mperf
kvm_amd kvm psmouse sp5100_tco edac_mce_amd serio_raw microcode pcspkr
k10temp edac_core i2c_piix4 evdev processor i2c_core thermal_sys
asus_atk0110 cpuid msr loop firewire_sbp2 fuse autofs4 ext4 crc16 jbd2
mbcache btrfs xor zlib_deflate raid6_pq crc32c libcrc32c sd_mod
crc_t10dif md_mod uvesafb cn sg sr_mod cdrom ata_generic firewire_ohci
ahci pata_atiixp libahci pata_jmicron firewire_core crc_itu_t wmi
ehci_pci button ohci_hcd ehci_hcd libata usbcore usb_common scsi_mod

[7.2.] Processor information (from /proc/cpuinfo):
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 10
model name      : AMD Phenom(tm) II X6 1090T Processor
stepping        : 0
microcode       : 0x10000dc
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 6
core id         : 0
cpu cores       : 6
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid aperfmperf pni monitor cx16 popcnt lahf_lm
cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch
osvw ibs skinit wdt nodeid_msr cpb hw_pstate npt lbrv svm_lock
nrip_save pausefilter
bogomips        : 7332.59
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate cpb

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 10
model name      : AMD Phenom(tm) II X6 1090T Processor
stepping        : 0
microcode       : 0x10000dc
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 6
core id         : 1
cpu cores       : 6
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid aperfmperf pni monitor cx16 popcnt lahf_lm
cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch
osvw ibs skinit wdt nodeid_msr cpb hw_pstate npt lbrv svm_lock
nrip_save pausefilter
bogomips        : 7332.59
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate cpb

processor       : 2
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 10
model name      : AMD Phenom(tm) II X6 1090T Processor
stepping        : 0
microcode       : 0x10000dc
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 6
core id         : 2
cpu cores       : 6
apicid          : 2
initial apicid  : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid aperfmperf pni monitor cx16 popcnt lahf_lm
cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch
osvw ibs skinit wdt nodeid_msr cpb hw_pstate npt lbrv svm_lock
nrip_save pausefilter
bogomips        : 7332.59
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate cpb

processor       : 3
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 10
model name      : AMD Phenom(tm) II X6 1090T Processor
stepping        : 0
microcode       : 0x10000dc
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 6
core id         : 3
cpu cores       : 6
apicid          : 3
initial apicid  : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid aperfmperf pni monitor cx16 popcnt lahf_lm
cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch
osvw ibs skinit wdt nodeid_msr cpb hw_pstate npt lbrv svm_lock
nrip_save pausefilter
bogomips        : 7332.59
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate cpb

processor       : 4
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 10
model name      : AMD Phenom(tm) II X6 1090T Processor
stepping        : 0
microcode       : 0x10000dc
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 6
core id         : 4
cpu cores       : 6
apicid          : 4
initial apicid  : 4
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid aperfmperf pni monitor cx16 popcnt lahf_lm
cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch
osvw ibs skinit wdt nodeid_msr cpb hw_pstate npt lbrv svm_lock
nrip_save pausefilter
bogomips        : 7332.59
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate cpb

processor       : 5
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 10
model name      : AMD Phenom(tm) II X6 1090T Processor
stepping        : 0
microcode       : 0x10000dc
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 6
core id         : 5
cpu cores       : 6
apicid          : 5
initial apicid  : 5
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid aperfmperf pni monitor cx16 popcnt lahf_lm
cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch
osvw ibs skinit wdt nodeid_msr cpb hw_pstate npt lbrv svm_lock
nrip_save pausefilter
bogomips        : 7332.59
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate cpb

[7.3.] Module information (from /proc/modules):
cpufreq_conservative 13225 0 - Live 0xffffffffa0392000
cpufreq_powersave 12454 0 - Live 0xffffffffa038d000
cpufreq_userspace 12576 0 - Live 0xffffffffa031d000
cpufreq_stats 12944 0 - Live 0xffffffffa0340000
parport_pc 22409 0 - Live 0xffffffffa0316000
ppdev 12763 0 - Live 0xffffffffa0311000
lp 13064 0 - Live 0xffffffffa02de000
parport 31812 3 parport_pc,ppdev,lp, Live 0xffffffffa0384000
ext3 163079 1 - Live 0xffffffffa0d15000
jbd 54093 1 ext3, Live 0xffffffffa0331000
hid_logitech_dj 17354 0 - Live 0xffffffffa01a4000
joydev 17235 0 - Live 0xffffffffa01be000
hid_generic 12393 0 - Live 0xffffffffa019f000
usbhid 40756 1 hid_logitech_dj, Live 0xffffffffa0326000
hid 81727 3 hid_logitech_dj,hid_generic,usbhid, Live 0xffffffffa02fc000
acpi_cpufreq 13354 1 - Live 0xffffffffa02e3000
mperf 12453 1 acpi_cpufreq, Live 0xffffffffa0359000
kvm_amd 47732 0 - Live 0xffffffffa03b6000
kvm 320553 1 kvm_amd, Live 0xffffffffa03da000
psmouse 74646 0 - Live 0xffffffffa044e000
sp5100_tco 12864 0 - Live 0xffffffffa03b1000
edac_mce_amd 17070 0 - Live 0xffffffffa03d4000
serio_raw 12894 0 - Live 0xffffffffa03ac000
microcode 116192 0 - Live 0xffffffffa0366000
pcspkr 12632 0 - Live 0xffffffffa02f7000
k10temp 12664 0 - Live 0xffffffffa0361000
edac_core 43502 0 - Live 0xffffffffa034d000
i2c_piix4 12660 0 - Live 0xffffffffa0348000
evdev 17568 7 - Live 0xffffffffa02f1000
processor 28414 1 acpi_cpufreq, Live 0xffffffffa0197000
i2c_core 24040 2 nvidia,i2c_piix4, Live 0xffffffffa02ea000
thermal_sys 22879 1 processor, Live 0xffffffffa0190000
asus_atk0110 17202 0 - Live 0xffffffffa0186000
cpuid 12745 0 - Live 0xffffffffa0172000
msr 12796 0 - Live 0xffffffffa0181000
loop 22902 0 - Live 0xffffffffa016b000
firewire_sbp2 17956 0 - Live 0xffffffffa01aa000
fuse 67123 7 - Live 0xffffffffa0159000
autofs4 27746 3 - Live 0xffffffffa0179000
ext4 410756 2 - Live 0xffffffffa0278000
crc16 12343 1 ext4, Live 0xffffffffa0139000
jbd2 80892 1 ext4, Live 0xffffffffa0144000
mbcache 13114 2 ext3,ext4, Live 0xffffffffa00c7000
btrfs 652154 1 - Live 0xffffffffa01d7000
xor 17024 1 btrfs, Live 0xffffffffa00ab000
zlib_deflate 25638 1 btrfs, Live 0xffffffffa0131000
raid6_pq 95587 1 btrfs, Live 0xffffffffa0118000
crc32c 12656 1 - Live 0xffffffffa0070000
libcrc32c 12426 1 btrfs, Live 0xffffffffa00c2000
sd_mod 40549 11 - Live 0xffffffffa010d000
crc_t10dif 12348 1 sd_mod, Live 0xffffffffa0055000
md_mod 92426 0 - Live 0xffffffffa00d1000
uvesafb 26184 0 - Live 0xffffffffa00ba000
cn 12943 1 uvesafb, Live 0xffffffffa0050000
sg 26048 0 - Live 0xffffffffa0068000
sr_mod 21988 0 - Live 0xffffffffa0031000
cdrom 35212 1 sr_mod, Live 0xffffffffa0046000
ata_generic 12490 0 - Live 0xffffffffa00cc000
firewire_ohci 31845 0 - Live 0xffffffffa00b1000
ahci 25148 11 - Live 0xffffffffa00a3000
pata_atiixp 12838 0 - Live 0xffffffffa01d2000
libahci 23136 1 ahci, Live 0xffffffffa01cb000
pata_jmicron 12483 0 - Live 0xffffffffa01c6000
firewire_core 49120 2 firewire_sbp2,firewire_ohci, Live 0xffffffffa01b1000
crc_itu_t 12347 1 firewire_core, Live 0xffffffffa013f000
wmi 13243 0 - Live 0xffffffffa0075000
ehci_pci 12472 0 - Live 0xffffffffa0063000
button 12944 0 - Live 0xffffffffa005a000
ohci_hcd 26642 0 - Live 0xffffffffa0029000
ehci_hcd 40420 1 ehci_pci, Live 0xffffffffa003b000
libata 141643 5 ata_generic,ahci,pata_atiixp,libahci,pata_jmicron,
Live 0xffffffffa00e9000
usbcore 134475 4 usbhid,ehci_pci,ohci_hcd,ehci_hcd, Live 0xffffffffa0081000
usb_common 12354 1 usbcore, Live 0xffffffffa007a000
scsi_mod 162727 5 firewire_sbp2,sd_mod,sg,sr_mod,libata, Live 0xffffffffa0000000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : EC cmd
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0170-0177 : 0000:00:14.1
    0170-0177 : pata_atiixp
  01f0-01f7 : 0000:00:14.1
    01f0-01f7 : pata_atiixp
  0230-023f : pnp 00:09
  0290-029f : pnp 00:09
  0376-0376 : 0000:00:14.1
    0376-0376 : pata_atiixp
  03c0-03df : vga+
  03f6-03f6 : 0000:00:14.1
    03f6-03f6 : pata_atiixp
  03f8-03ff : serial
  040b-040b : pnp 00:08
  04d0-04d1 : pnp 00:08
  04d6-04d6 : pnp 00:08
  0800-089f : pnp 00:08
    0800-0803 : ACPI PM1a_EVT_BLK
    0804-0805 : ACPI PM1a_CNT_BLK
    0808-080b : ACPI PM_TMR
    0810-0815 : ACPI CPU throttle
    0820-0827 : ACPI GPE0_BLK
  08ff-08ff : ACPI PM2_CNT_BLK
  0900-090f : pnp 00:08
  0910-091f : pnp 00:08
  0a30-0a3f : pnp 00:09
  0b00-0b1f : pnp 00:08
  0b20-0b3f : pnp 00:08
  0c00-0c01 : pnp 00:08
  0c14-0c14 : pnp 00:08
  0c50-0c51 : pnp 00:08
  0c52-0c52 : pnp 00:08
  0c6c-0c6c : pnp 00:08
  0c6f-0c6f : pnp 00:08
  0cd0-0cd1 : pnp 00:08
  0cd2-0cd3 : pnp 00:08
  0cd4-0cd5 : pnp 00:08
  0cd6-0cd7 : pnp 00:08
    0cd6-0cd7 : SB800 TCO
  0cd8-0cdf : pnp 00:08
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  0f40-0f4f : pnp 00:09
  6000-600f : 0000:00:11.0
    6000-600f : ahci
  7000-7003 : 0000:00:11.0
    7000-7003 : ahci
  8000-8007 : 0000:00:11.0
    8000-8007 : ahci
  9000-9003 : 0000:00:11.0
    9000-9003 : ahci
  a000-a007 : 0000:00:11.0
    a000-a007 : ahci
  b000-bfff : PCI Bus 0000:01
    bc00-bc7f : 0000:01:00.0
  c000-cfff : PCI Bus 0000:02
    c400-c40f : 0000:02:00.1
      c400-c40f : pata_jmicron
    c480-c483 : 0000:02:00.1
      c480-c483 : pata_jmicron
    c800-c807 : 0000:02:00.1
      c800-c807 : pata_jmicron
    c880-c883 : 0000:02:00.1
      c880-c883 : pata_jmicron
    cc00-cc07 : 0000:02:00.1
      cc00-cc07 : pata_jmicron
  d000-dfff : PCI Bus 0000:03
    dc00-dc7f : 0000:03:07.0
  e000-efff : PCI Bus 0000:04
    e800-e8ff : 0000:04:00.0
      e800-e8ff : r8169
  fe00-fefe : pnp 00:08
  ff00-ff0f : 0000:00:14.1
    ff00-ff0f : pata_atiixp

cat /proc/iomem
00000000-00000fff : reserved
00001000-0009efff : System RAM
0009f000-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000c7fff : Video ROM
000d0000-000dffff : PCI Bus 0000:00
000e4000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-dfe7ffff : System RAM
  01000000-013988bd : Kernel code
  013988be-016d0f3f : Kernel data
  0185d000-019dbfff : Kernel bss
  d4000000-d7ffffff : GART
dfe80000-dfe97fff : ACPI Tables
dfe98000-dfebffff : ACPI Non-volatile Storage
dfec0000-dfefffff : reserved
dff00000-dfffffff : PCI Bus 0000:00
  dff00000-dfffffff : pnp 00:08
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
  e0000000-efffffff : pnp 00:0a
f0000000-febfffff : PCI Bus 0000:00
  f0000000-f9ffffff : PCI Bus 0000:01
    f0000000-f7ffffff : 0000:01:00.0
    f8000000-f9ffffff : 0000:01:00.0
  fbf00000-fbffffff : PCI Bus 0000:04
    fbff8000-fbffbfff : 0000:04:00.0
      fbff8000-fbffbfff : r8169
    fbfff000-fbffffff : 0000:04:00.0
      fbfff000-fbffffff : r8169
  fcff7000-fcff7fff : 0000:00:16.0
    fcff7000-fcff7fff : ohci_hcd
  fcff8000-fcffbfff : 0000:00:14.2
  fcffc000-fcffcfff : 0000:00:14.5
    fcffc000-fcffcfff : ohci_hcd
  fcffd000-fcffdfff : 0000:00:13.0
    fcffd000-fcffdfff : ohci_hcd
  fcffe000-fcffefff : 0000:00:12.0
    fcffe000-fcffefff : ohci_hcd
  fcfff000-fcfff0ff : 0000:00:16.2
    fcfff000-fcfff0ff : ehci_hcd
  fcfff400-fcfff4ff : 0000:00:13.2
    fcfff400-fcfff4ff : ehci_hcd
  fcfff800-fcfff8ff : 0000:00:12.2
    fcfff800-fcfff8ff : ehci_hcd
  fcfffc00-fcffffff : 0000:00:11.0
    fcfffc00-fcffffff : ahci
  fd000000-fe6fffff : PCI Bus 0000:01
    fd000000-fdffffff : 0000:01:00.0
      fd000000-fdffffff : nvidia
    fe67c000-fe67ffff : 0000:01:00.1
    fe680000-fe6fffff : 0000:01:00.0
  fe700000-fe7fffff : PCI Bus 0000:02
    fe7fe000-fe7fffff : 0000:02:00.0
      fe7fe000-fe7fffff : ahci
  fe800000-fe8fffff : PCI Bus 0000:03
    fe8ff800-fe8fffff : 0000:03:07.0
      fe8ff800-fe8fffff : firewire_ohci
  fe900000-fe9fffff : PCI Bus 0000:04
    fe9f0000-fe9fffff : 0000:04:00.0
fec00000-fec003ff : IOAPIC 0
fec10000-fec1001f : pnp 00:08
fed00000-fed003ff : HPET 2
fed80000-fed80fff : pnp 00:08
  fed80b00-fed80b07 : SB800 TCO
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : pnp 00:07
ffb80000-ffbfffff : pnp 00:08
ffe00000-ffffffff : reserved
100000000-41fffffff : System RAM

[7.5.] PCI information ('lspci -vvv' as root)
lspci -vvv
00:00.0 Host bridge: Advanced Micro Devices [AMD] RS880 Host Bridge
        Subsystem: Advanced Micro Devices [AMD] Device 9600
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [c4] HyperTransport: Slave or Primary Interface
                Command: BaseUnitID=0 UnitCnt=12 MastHost- DefDir- DUL-
                Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC-
TXO- <CRCErr=0 IsocEn+ LSEn- ExtCTL- 64b-
                Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut-
LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
                Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+
TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
                Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut-
LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
                Revision ID: 3.00
                Link Frequency 0: [b]
                Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+
500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
                Link Frequency 1: 200MHz
                Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 1: 200MHz- 300MHz- 400MHz-
500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE-
CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
                Prefetchable memory behind bridge Upper: 00-00
                Bus Number: 00
        Capabilities: [54] HyperTransport: UnitID Clumping
        Capabilities: [40] HyperTransport: Retry Mode
        Capabilities: [9c] HyperTransport: #1a
        Capabilities: [f8] HyperTransport: #1c

00:02.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI
bridge (ext gfx port 0) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000b000-0000bfff
        Memory behind bridge: fd000000-fe6fffff
        Prefetchable memory behind bridge: 00000000f0000000-00000000f9ffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag+ RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
                LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1,
Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep+ BwNot+
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug- Surprise-
                        Slot #2, PowerLimit 75.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown,
Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -3.5dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee3f00c  Data: 4171
        Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] Device 9600
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [100 v1] Vendor Specific Information: ID=0001
Rev=1 Len=010 <?>
        Capabilities: [110 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Kernel driver in use: pcieport

00:0a.0 PCI bridge: Advanced Micro Devices [AMD] RS780/RS880 PCI to
PCI bridge (PCIE port 5) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: fe700000-fe7fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag+ RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
                LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1,
Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep+ BwNot+
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug- Surprise-
                        Slot #10, PowerLimit 25.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown,
Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee3f00c  Data: 4181
        Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] Device 9600
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [100 v1] Vendor Specific Information: ID=0001
Rev=1 Len=010 <?>
        Capabilities: [110 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Kernel driver in use: pcieport

00:11.0 SATA controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 SATA Controller [IDE mode] (rev 40) (prog-if 01
[AHCI 1.0])
        Subsystem: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 SATA Controller [IDE mode]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: I/O ports at a000 [size=8]
        Region 1: I/O ports at 9000 [size=4]
        Region 2: I/O ports at 8000 [size=8]
        Region 3: I/O ports at 7000 [size=4]
        Region 4: I/O ports at 6000 [size=16]
        Region 5: Memory at fcfffc00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [70] SATA HBA v1.0 InCfgSpace
        Capabilities: [a4] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: ahci

00:12.0 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
        Subsystem: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at fcffe000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci_hcd

00:12.2 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
        Subsystem: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB EHCI Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 17
        Region 0: Memory at fcfff800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+
        Capabilities: [e4] Debug port: BAR=1 offset=00e0
        Kernel driver in use: ehci-pci

00:13.0 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
        Subsystem: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at fcffd000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci_hcd

00:13.2 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
        Subsystem: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB EHCI Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 17
        Region 0: Memory at fcfff400 (32-bit, non-prefetchable) [size=256]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+
        Capabilities: [e4] Debug port: BAR=1 offset=00e0
        Kernel driver in use: ehci-pci

00:14.0 SMBus: Advanced Micro Devices [AMD] nee ATI SBx00 SMBus
Controller (rev 41)
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:14.1 IDE interface: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 IDE Controller (rev 40) (prog-if 8a [Master SecP
PriP])
        Subsystem: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 IDE Controller
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Interrupt: pin B routed to IRQ 17
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at ff00 [size=16]
        Kernel driver in use: pata_atiixp

00:14.2 Audio device: Advanced Micro Devices [AMD] nee ATI SBx00
Azalia (Intel HDA) (rev 40)
        Subsystem: ASUSTeK Computer Inc. M4A89GTD PRO/USB3 Motherboard
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at fcff8000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

00:14.3 ISA bridge: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
        Subsystem: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 LPC host controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0

00:14.4 PCI bridge: Advanced Micro Devices [AMD] nee ATI SBx00 PCI to
PCI Bridge (rev 40) (prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fe800000-fe8fffff
        Prefetchable memory behind bridge: fff00000-000fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB OHCI2 Controller (prog-if 10 [OHCI])
        Subsystem: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at fcffc000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci_hcd

00:15.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI
SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0) (prog-if 00 [Normal
decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: fe900000-fe9fffff
        Prefetchable memory behind bridge: 00000000fbf00000-00000000fbffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag+ RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
                LnkCap: Port #0, Speed 5GT/s, Width x1, ASPM L0s L1,
Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep+ BwNot+
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug- Surprise-
                        Slot #32, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown,
Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd-
                DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -3.5dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee3f00c  Data: 4191
        Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] nee
ATI Device 0000
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [100 v1] Vendor Specific Information: ID=0001
Rev=1 Len=010 <?>
        Kernel driver in use: pcieport

00:16.0 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
        Subsystem: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at fcff7000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci_hcd

00:16.2 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
        Subsystem: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB EHCI Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 17
        Region 0: Memory at fcfff000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+
        Capabilities: [e4] Debug port: BAR=1 offset=00e0
        Kernel driver in use: ehci-pci

00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor
HyperTransport Configuration
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Capabilities: [80] HyperTransport: Host or Secondary Interface
                Command: WarmRst+ DblEnd- DevNum=0 ChainSide-
HostHide+ Slave- <EOCErr- DUL-
                Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO-
<CRCErr=0 IsocEn+ LSEn+ ExtCTL- 64b-
                Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut-
LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
                Revision ID: 3.00
                Link Frequency: [b]
                Link Error: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability: 200MHz+ 300MHz- 400MHz+
500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
                Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT-
64bA+ UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor
Address Map
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor
DRAM Controller
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor
Miscellaneous Control
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Capabilities: [f0] Secure device <?>
        Kernel driver in use: k10temp

00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor
Link Control
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

01:00.0 VGA compatible controller: NVIDIA Corporation GK107 [GeForce
GT 630] (rev a1) (prog-if 00 [VGA controller])
        Subsystem: ZOTAC International (MCO) Ltd. Device 5199
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 44
        Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: Memory at f0000000 (64-bit, prefetchable) [size=128M]
        Region 3: Memory at f8000000 (64-bit, prefetchable) [size=32M]
        Region 5: I/O ports at bc00 [size=128]
        [virtual] Expansion ROM at fe680000 [disabled] [size=512K]
        Capabilities: [60] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [68] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee3f00c  Data: 41d1
        Capabilities: [78] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
unlimited, L1 <64us
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend+
                LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [b4] Vendor Specific Information: Len=14 <?>
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Capabilities: [128 v1] Power Budgeting <?>
        Capabilities: [600 v1] Vendor Specific Information: ID=0001
Rev=1 Len=024 <?>
        Kernel driver in use: nvidia

01:00.1 Audio device: NVIDIA Corporation GF108 High Definition Audio
Controller (rev a1)
        Subsystem: ZOTAC International (MCO) Ltd. Device 5199
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 11
        Region 0: Memory at fe67c000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [60] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [78] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<4us, L1 <64us
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
                LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-

02:00.0 SATA controller: JMicron Technology Corp. JMB361 AHCI/IDE (rev
02) (prog-if 01 [AHCI 1.0])
        Subsystem: ASUSTeK Computer Inc. Device 824f
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 5: Memory at fe7fe000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] Express (v1) Legacy Endpoint, MSI 01
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq+
AuxPwr- TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s,
Latency L0 <1us, L1 <16us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Kernel driver in use: ahci

02:00.1 IDE interface: JMicron Technology Corp. JMB361 AHCI/IDE (rev
02) (prog-if 85 [Master SecO PriO])
        Subsystem: ASUSTeK Computer Inc. Device 824f
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 0: I/O ports at cc00 [size=8]
        Region 1: I/O ports at c880 [size=4]
        Region 2: I/O ports at c800 [size=8]
        Region 3: I/O ports at c480 [size=4]
        Region 4: I/O ports at c400 [size=16]
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pata_jmicron

03:07.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire
II(M)] IEEE 1394 OHCI Controller (rev c0) (prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. M4A series motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (8000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at fe8ff800 (32-bit, non-prefetchable) [size=2K]
        Region 1: I/O ports at dc00 [size=128]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA
PME(D0-,D1-,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: firewire_ohci

04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
        Subsystem: ASUSTeK Computer Inc. P8P67 and other motherboards
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 43
        Region 0: I/O ports at e800 [size=256]
        Region 2: Memory at fbfff000 (64-bit, prefetchable) [size=4K]
        Region 4: Memory at fbff8000 (64-bit, prefetchable) [size=16K]
        Expansion ROM at fe9f0000 [disabled] [size=64K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee3f00c  Data: 41a1
        Capabilities: [70] Express (v2) Endpoint, MSI 01
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
                Vector table: BAR=4 offset=00000000
                PBA: BAR=4 offset=00000800
        Capabilities: [d0] Vital Product Data
                Unknown small resource type 00, will not decode more.
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO+ CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 0e, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
        Kernel driver in use: r8169

Regards
Pierre
