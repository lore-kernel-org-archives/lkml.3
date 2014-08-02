Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbaHBQJW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 12:09:22 -0400
Received: from nm20-vm8.access.bullet.mail.gq1.yahoo.com ([216.39.63.228]:25071
	"EHLO nm20-vm8.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477AbaHBQJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 12:09:19 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Aug 2014 12:09:19 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s2048; d=rogers.com;
	b=n43WG3SeK0+ko0vVtrDhxKOghl27o4fRDIJZwA5uAL2yJlUzCI96BEJmb95YEUwqsMm2SJIwU3zv0T3Co7yQq7p3loKzjnoqYeuiZTqrLUqzJ6cI1bne48fqwB2qu4TRjT5KxMhiDrWO/1Pcn+v+lj1FpxFfJPpTTputdbW1aV1MINqiIQGok8tu5h3BHuxa807mqH7KjDC+rnWowix8esuU2u4EYaGXZ2mjKiQXJkhYd1WBoJj6mpR1kVhit9G3IBzdj7BdZ4C2B7yRY5fKKgI4cM0NC7BY08OQRlWSnm+5nBq+4MtqOcdbOikj+dvuqw9PJG/iO4fyuVfc+TYt3Q==;
X-Yahoo-Newman-Id: 309160.89983.bm@smtp112.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Jmt58_UVM1niX9TPDVcM2I.jHtG60GOMngAXS7PEodVUC3K
 Lp8rXWwA9lVzEH4BVJVMM7zBnXnN3Vffm7NiAK2uv2SgkF8j7b0IYSj7vL1Y
 IYiv3bTFHWbC_CiVf9g06GlaSQ2qn7gw6lmXH_UChYIjsiTTb9iAv_NbtlO8
 P03ejPoMRakPovzlYYMpBTZqGmiks85WEOmUlJbtdrQWXwhm1mMneu5fH6Mz
 7NpTUVV23T0j87yYcGhqvqhASktXzS8VlmnZ5PfmvexeLT02UVI8IAWvCfqu
 WF_8xHbpIyPW8L.ePuREyFJ8mnwdnPxI4yJWFR1S2NY5fiGhtHOQjSSJX0ay
 ma9g7_7MRUcWluRDFCQQLzXpvm_hd5mEatHcQVu_9yv4tMAmSX4OojvWfBmR
 1NiQuIw1YVmteV4J2M01lfW.f6p9wYa54xgvz_fs9PPN7tjp3AqWersWvwVJ
 x_NKUcoIdFpthe1VX18STqTgAS5T6V5nRiF7LbzAuwk7ZVQ1oqetckpXeCB1
 b.T9VtwyKOYeNJj8D.fgeWGaS5zABU7M2aA.cTzCQM36jGbp89aglIj269mg
 fmP9SV8UX.MRfYTEK43fyD8QIbrW8w_Mn2i86saIS4Hr0ebvCbw_iohTeI_q
 L7nxQEXByfS4cExxZYl2_m30deQ--
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
From: Shawn Starr <shawn.starr@rogers.com>
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [3.16-rcX][pciehp][radeon] PCIe HotPlug conflicts with radeon GPU
Date: Sat, 02 Aug 2014 12:02:59 -0400
Message-ID: <2354837.kuMZPK0Y1Q@segfault>
Organization: sh0n.net
User-Agent: KMail/4.13.3 (Linux/3.16.0-0.rc7.git3.1.fc21.x86_64; KDE/4.13.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello devs,

There are two issues I am encountering with the PCIe Hotplug driver on my Lenovo Laptop (W500). I note this goes back further than 3.15.

It is noted here: 
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=f244d8b623dae7a7bc695b0336f67729b95a9736
https://bugzilla.kernel.org/show_bug.cgi?id=79701

And my open bug here:
https://bugzilla.kernel.org/show_bug.cgi?id=77261

1) If I enable the device to use both the integrated and discrete GPU, pciehp will decide to force unload radeon because it puts itself into a power saving state, fails back to the Intel integrated GPU in this case unless I tell radeon.ko to runpm=0 (no power management, then pciehp wont touch it).

2) If the Radeon GPU resets and you use pci_reset=1 for kernel module option, pciehp decides to force unload radeon even though the GPU is trying to setup after failing.

Kernel I am using right now: 3.16.0-0.rc7.git3.1.fc21.x86_64 (about to boot into snapshot kernel-core-3.16.0-0.rc7.git4.1.fc21.x86_64)

Here is kernel dump (from time GPU resets, and cascading failure with PCIe Hotplug fighting):

Aug  2 11:31:24 segfault kernel: [  515.525087] radeon 0000:01:00.0: ring 0 stalled for more than 10158msec
Aug  2 11:31:24 segfault kernel: [  515.525280] radeon 0000:01:00.0: GPU lockup (waiting for 0x00000000000154b6 last fence id 0x00000000000154b0 on ring 0)
Aug  2 11:31:24 segfault kernel: [  515.743497] radeon 0000:01:00.0: Saved 185 dwords of commands on ring 0.
Aug  2 11:31:24 segfault kernel: [  515.743724] radeon 0000:01:00.0: GPU softreset: 0x00000008
Aug  2 11:31:24 segfault kernel: [  515.743897] radeon 0000:01:00.0:   R_008010_GRBM_STATUS      = 0xA0003030
Aug  2 11:31:24 segfault kernel: [  515.744152] radeon 0000:01:00.0:   R_008014_GRBM_STATUS2     = 0x00000003
Aug  2 11:31:24 segfault kernel: [  515.744396] radeon 0000:01:00.0:   R_000E50_SRBM_STATUS      = 0x200000C0
Aug  2 11:31:24 segfault kernel: [  515.744623] radeon 0000:01:00.0:   R_008674_CP_STALLED_STAT1 = 0x00000000
Aug  2 11:31:24 segfault kernel: [  515.744820] radeon 0000:01:00.0:   R_008678_CP_STALLED_STAT2 = 0x00000000
Aug  2 11:31:24 segfault kernel: [  515.745030] radeon 0000:01:00.0:   R_00867C_CP_BUSY_STAT     = 0x00028186
Aug  2 11:31:24 segfault kernel: [  515.745251] radeon 0000:01:00.0:   R_008680_CP_STAT          = 0x80028645
Aug  2 11:31:24 segfault kernel: [  515.745456] radeon 0000:01:00.0:   R_00D034_DMA_STATUS_REG   = 0x44C83D57
Aug  2 11:31:25 segfault kernel: [  515.802395] radeon 0000:01:00.0: R_008020_GRBM_SOFT_RESET=0x00004001
Aug  2 11:31:25 segfault kernel: [  515.802633] radeon 0000:01:00.0: SRBM_SOFT_RESET=0x00000100
Aug  2 11:31:25 segfault kernel: [  515.804908] radeon 0000:01:00.0:   R_008010_GRBM_STATUS      = 0xA0003030
Aug  2 11:31:25 segfault kernel: [  515.805147] radeon 0000:01:00.0:   R_008014_GRBM_STATUS2     = 0x00000003
Aug  2 11:31:25 segfault kernel: [  515.805355] radeon 0000:01:00.0:   R_000E50_SRBM_STATUS      = 0x200080C0
Aug  2 11:31:25 segfault kernel: [  515.805560] radeon 0000:01:00.0:   R_008674_CP_STALLED_STAT1 = 0x00000000
Aug  2 11:31:25 segfault kernel: [  515.805756] radeon 0000:01:00.0:   R_008678_CP_STALLED_STAT2 = 0x00000000
Aug  2 11:31:25 segfault kernel: [  515.805957] radeon 0000:01:00.0:   R_00867C_CP_BUSY_STAT     = 0x00000000
Aug  2 11:31:25 segfault kernel: [  515.806184] radeon 0000:01:00.0:   R_008680_CP_STAT          = 0x80100000
Aug  2 11:31:25 segfault kernel: [  515.806384] radeon 0000:01:00.0:   R_00D034_DMA_STATUS_REG   = 0x44C83D57
Aug  2 11:31:25 segfault kernel: [  515.806583] radeon 0000:01:00.0: GPU pci config reset
Aug  2 11:31:25 segfault kernel: [  515.887334] pciehp 0000:00:01.0:pcie04: Card not present on Slot(1-1)
Aug  2 11:31:25 segfault kernel: [  515.889380] Console: switching to colour VGA+ 80x25
Aug  2 11:31:25 segfault kernel: [  515.893123] pciehp 0000:00:01.0:pcie04: Card present on Slot(1-1)
Aug  2 11:31:25 segfault kernel: [  515.902365] drm_kms_helper: drm: unregistered panic notifier
Aug  2 11:31:25 segfault kernel: [  516.046783] radeon 0000:01:00.0: GPU reset succeeded, trying to resume
Aug  2 11:31:25 segfault kernel: [  516.175830] [drm:radeon_pm_resume_dpm] *ERROR* radeon: dpm resume failed
Aug  2 11:31:26 segfault kernel: [  516.842282] radeon 0000:01:00.0: Wait for MC idle timedout !
Aug  2 11:31:26 segfault kernel: [  517.008275] radeon 0000:01:00.0: Wait for MC idle timedout !
Aug  2 11:31:26 segfault kernel: [  517.010332] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
Aug  2 11:31:26 segfault kernel: [  517.010627] divide error: 0000 [#1] SMP
Aug  2 11:31:26 segfault kernel: [  517.010793] Modules linked in: vhost_net vhost macvtap macvlan tun bridge stp llc uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev media snd_usb_audio snd_usbmidi_lib mmc_block snd_rawmidi coretemp kvm_intel kvm iTCO_wdt sdhci_pci arc4 iwldvm mac80211 sdhci iTCO_vendor_support snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep lpc_ich iwlwifi i2c_i801 mmc_core microcode mei_me snd_seq snd_seq_device mfd_core cfg80211 snd_pcm thinkpad_acpi r592 memstick tpm_tis mei snd_timer shpchp snd soundcore wmi video tpm rfkill acpi_cpufreq binfmt_misc sunrpc radeon i2c_algo_bit drm_kms_helper ttm e1000e drm ptp pps_core i2c_core
ug  2 11:31:26 segfault kernel: [  517.011015] CPU: 0 PID: 996 Comm: Xorg.bin Not tainted 3.16.0-0.rc7.git3.1.fc21.x86_64 #1
Aug  2 11:31:26 segfault kernel: [  517.011015] Hardware name: LENOVO 4058CTO/4058CTO, BIOS 6FET93WW (3.23 ) 10/12/2012
Aug  2 11:31:26 segfault kernel: [  517.011015] task: ffff88022fe399d0 ti: ffff88022fe10000 task.ti: ffff88022fe10000
Aug  2 11:31:26 segfault kernel: [  517.011015] RIP: 0010:[<ffffffffa013817a>]  [<ffffffffa013817a>] r6xx_remap_render_backend+0x6a/0xe0 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.011015] RSP: 0018:ffff88022fe13bd8  EFLAGS: 00010246
Aug  2 11:31:26 segfault kernel: [  517.011015] RAX: 0000000000000002 RBX: 00000000ffffffff RCX: 0000000000000002
Aug  2 11:31:26 segfault kernel: [  517.011015] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
Aug  2 11:31:26 segfault kernel: [  517.011015] RBP: ffff88022fe13c10 R08: 00000000000000ff R09: 0000000000000000
Aug  2 11:31:26 segfault kernel: [  517.011015] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000080000000
Aug  2 11:31:26 segfault kernel: [  517.011015] R13: 00000000000000ff R14: 0000000000000000 R15: 0000000000000000
Aug  2 11:31:26 segfault kernel: [  517.011015] FS:  00007f5e6b4c99c0(0000) GS:ffff880232e00000(0000) knlGS:0000000000000000
Aug  2 11:31:26 segfault kernel: [  517.011015] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug  2 11:31:26 segfault kernel: [  517.011015] CR2: 00007fb83967a000 CR3: 000000022feef000 CR4: 00000000000427e0
Aug  2 11:31:26 segfault kernel: [  517.011015] Stack:
Aug  2 11:31:26 segfault kernel: [  517.011015]  ffff8800bf6c0000 0000000200000200 ffff8800bf6c0000 000000000000c352
Aug  2 11:31:26 segfault kernel: [  517.011015]  00000000ffffffff 000000000000cb52 0000000000ffff00 ffff88022fe13c68
Aug  2 11:31:26 segfault kernel: [  517.011015]  ffffffffa013b347 00000000000058d0 ffffffff00000006 00000000ffffffff
Aug  2 11:31:26 segfault kernel: [  517.011015] Call Trace:
Aug  2 11:31:26 segfault kernel: [  517.011015]  [<ffffffffa013b347>] r600_startup+0x8a7/0x1780 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.011015]  [<ffffffffa013c253>] r600_resume+0x33/0x70 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.011015]  [<ffffffffa00eb921>] radeon_gpu_reset+0x131/0x2c0 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.011015]  [<ffffffffa011b04e>] radeon_gem_handle_lockup.part.4+0xe/0x20 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.011015]  [<ffffffffa011bbc8>] radeon_gem_wait_idle_ioctl+0x98/0x100 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.011015]  [<ffffffffa0029cdf>] drm_ioctl+0x1df/0x6a0 [drm]
Aug  2 11:31:26 segfault kernel: [  517.011015]  [<ffffffff81811796>] ? _raw_spin_unlock_irqrestore+0x36/0x70
Aug  2 11:31:26 segfault kernel: [  517.011015]  [<ffffffff810ff71d>] ? trace_hardirqs_on_caller+0x15d/0x200
Aug  2 11:31:26 segfault kernel: [  517.011015]  [<ffffffff810ff7cd>] ? trace_hardirqs_on+0xd/0x10
Aug  2 11:31:26 segfault kernel: [  517.011015]  [<ffffffffa00e904c>] radeon_drm_ioctl+0x4c/0x80 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.011015]  [<ffffffff81263390>] do_vfs_ioctl+0x2f0/0x520
Aug  2 11:31:26 segfault kernel: [  517.011015]  [<ffffffff8126fa2a>] ? __fget+0x12a/0x2f0
Aug  2 11:31:26 segfault kernel: [  517.011015]  [<ffffffff8126f905>] ? __fget+0x5/0x2f0
Aug  2 11:31:26 segfault kernel: [  517.011015]  [<ffffffff8126fc60>] ? __fget_light+0x30/0x160
Aug  2 11:31:26 segfault kernel: [  517.011015]  [<ffffffff81263641>] SyS_ioctl+0x81/0xa0
Aug  2 11:31:26 segfault kernel: [  517.011015]  [<ffffffff818125a9>] system_call_fastpath+0x16/0x1b
Aug  2 11:31:26 segfault kernel: [  517.011015] Code: b6 ed 45 09 c5 41 80 fd ff 45 0f 44 e8 d3 e7 89 7d d4 44 89 ef e8 97 ff ff ff 8b 4d d4 41 29 c7 44 39 f9 72 6c 89 c8 31 d2 89 cf <41> f7 f7 44 0f af f8 89 c6 48 8b 45 c8 44 29 ff 83 b8 e0 01 00
Aug  2 11:31:26 segfault kernel: [  517.011015] RIP  [<ffffffffa013817a>] r6xx_remap_render_backend+0x6a/0xe0 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.011015]  RSP <ffff88022fe13bd8>
Aug  2 11:31:26 segfault kernel: [  517.021382] ---[ end trace 2be177afde0240c0 ]---
Aug  2 11:31:26 segfault kernel: [  517.021753] [drm] radeon atom LVDS backlight unloaded
Aug  2 11:31:26 segfault kernel: [  517.022275] ------------[ cut here ]------------
Aug  2 11:31:26 segfault kernel: [  517.022422] WARNING: CPU: 0 PID: 2631 at drivers/gpu/drm/drm_crtc.c:4782 drm_mode_config_cleanup+0x269/0x2a0 [drm]()
Aug  2 11:31:26 segfault kernel: [  517.022745] Modules linked in: vhost_net vhost macvtap macvlan tun bridge stp llc uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev media snd_usb_audio snd_usbmidi_lib mmc_block snd_rawmidi coretemp kvm_intel kvm iTCO_wdt sdhci_pci arc4 iwldvm mac80211 sdhci iTCO_vendor_support snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep lpc_ich iwlwifi i2c_i801 mmc_core microcode mei_me snd_seq snd_seq_device mfd_core cfg80211 snd_pcm thinkpad_acpi r592 memstick tpm_tis mei snd_timer shpchp snd soundcore wmi video tpm rfkill acpi_cpufreq binfmt_misc sunrpc radeon i2c_algo_bit drm_kms_helper ttm e1000e drm ptp pps_core i2c_core
Aug  2 11:31:26 segfault kernel: [  517.025365] CPU: 0 PID: 2631 Comm: kworker/0:0 Tainted: G      D       3.16.0-0.rc7.git3.1.fc21.x86_64 #1
Aug  2 11:31:26 segfault kernel: [  517.025656] Hardware name: LENOVO 4058CTO/4058CTO, BIOS 6FET93WW (3.23 ) 10/12/2012
Aug  2 11:31:26 segfault kernel: [  517.025893] Workqueue: pciehp-1 pciehp_power_thread
Aug  2 11:31:26 segfault kernel: [  517.026066]  0000000000000000 00000000c6d3ec2c ffff8800737efaf0 ffffffff81808a15
Aug  2 11:31:26 segfault kernel: [  517.026349]  0000000000000000 ffff8800737efb28 ffffffff8109b3dd ffff8800bf5539b0
Aug  2 11:31:26 segfault kernel: [  517.026661]  ffff8800bf553000 ffff8800bf553820 ffff8800bf5539b0 ffff8800bf5539c0
Aug  2 11:31:26 segfault kernel: [  517.026956] Call Trace:
Aug  2 11:31:26 segfault kernel: [  517.027066]  [<ffffffff81808a15>] dump_stack+0x4d/0x66
Aug  2 11:31:26 segfault kernel: [  517.027238]  [<ffffffff8109b3dd>] warn_slowpath_common+0x7d/0xa0
Aug  2 11:31:26 segfault kernel: [  517.027450]  [<ffffffff8109b50a>] warn_slowpath_null+0x1a/0x20
Aug  2 11:31:26 segfault kernel: [  517.027651]  [<ffffffffa0038b39>] drm_mode_config_cleanup+0x269/0x2a0 [drm]
Aug  2 11:31:26 segfault kernel: [  517.027928]  [<ffffffffa0115fae>] radeon_modeset_fini+0x7e/0xa0 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.028171]  [<ffffffffa00ed440>] radeon_driver_unload_kms+0x40/0x60 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.028439]  [<ffffffffa0030349>] drm_dev_unregister+0x29/0xb0 [drm]
Aug  2 11:31:26 segfault kernel: [  517.028640]  [<ffffffffa0030993>] drm_put_dev+0x23/0x80 [drm]
Aug  2 11:31:26 segfault kernel: [  517.028848]  [<ffffffffa00e9275>] radeon_pci_remove+0x15/0x20 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.029086]  [<ffffffff81430a6b>] pci_device_remove+0x3b/0xc0
Aug  2 11:31:26 segfault kernel: [  517.029277]  [<ffffffff815203df>] __device_release_driver+0x7f/0xf0
Aug  2 11:31:26 segfault kernel: [  517.029489]  [<ffffffff81520475>] device_release_driver+0x25/0x40
Aug  2 11:31:26 segfault kernel: [  517.029694]  [<ffffffff8142ace4>] pci_stop_bus_device+0x94/0xa0
Aug  2 11:31:26 segfault kernel: [  517.029916]  [<ffffffff8142ade2>] pci_stop_and_remove_bus_device+0x12/0x20
Aug  2 11:31:26 segfault kernel: [  517.030164]  [<ffffffff81447530>] pciehp_unconfigure_device+0xb0/0x1c0
Aug  2 11:31:26 segfault kernel: [  517.030383]  [<ffffffff81446ef4>] pciehp_disable_slot+0x54/0xe0
Aug  2 11:31:26 segfault kernel: [  517.030590]  [<ffffffff8144706f>] pciehp_power_thread+0xef/0x160
Aug  2 11:31:26 segfault kernel: [  517.030786]  [<ffffffff810c0551>] process_one_work+0x211/0x6f0
Aug  2 11:31:26 segfault kernel: [  517.030973]  [<ffffffff810c04e5>] ? process_one_work+0x1a5/0x6f0
Aug  2 11:31:26 segfault kernel: [  517.031170]  [<ffffffff810c0a9b>] worker_thread+0x6b/0x540
Aug  2 11:31:26 segfault kernel: [  517.031355]  [<ffffffff810c0a30>] ? process_one_work+0x6f0/0x6f0
Aug  2 11:31:26 segfault kernel: [  517.031549]  [<ffffffff810c8d38>] kthread+0x108/0x120
Aug  2 11:31:26 segfault kernel: [  517.031708]  [<ffffffff810e1d18>] ? sched_clock_cpu+0x98/0xc0
Aug  2 11:31:26 segfault kernel: [  517.031902]  [<ffffffff810ff71d>] ? trace_hardirqs_on_caller+0x15d/0x200
Aug  2 11:31:26 segfault kernel: [  517.032157]  [<ffffffff810c8c30>] ? insert_kthread_work+0x80/0x80
Aug  2 11:31:26 segfault kernel: [  517.032382]  [<ffffffff818124fc>] ret_from_fork+0x7c/0xb0
Aug  2 11:31:26 segfault kernel: [  517.032547]  [<ffffffff810c8c30>] ? insert_kthread_work+0x80/0x80
Aug  2 11:31:26 segfault kernel: [  517.032744] ---[ end trace 2be177afde0240c1 ]---
Aug  2 11:31:26 segfault kernel: [  517.032884] ------------[ cut here ]------------
Aug  2 11:31:26 segfault kernel: [  517.033054] WARNING: CPU: 0 PID: 2631 at drivers/gpu/drm/drm_crtc.c:665 drm_framebuffer_remove+0x151/0x160 [drm]()
Aug  2 11:31:26 segfault kernel: [  517.033402] Modules linked in: vhost_net vhost macvtap macvlan tun bridge stp llc uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev media snd_usb_audio snd_usbmidi_lib mmc_block snd_rawmidi coretemp kvm_intel kvm iTCO_wdt sdhci_pci arc4 iwldvm mac80211 sdhci iTCO_vendor_support snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep lpc_ich iwlwifi i2c_i801 mmc_core microcode mei_me snd_seq snd_seq_device mfd_core cfg80211 snd_pcm thinkpad_acpi r592 memstick tpm_tis mei snd_timer shpchp snd soundcore wmi video tpm rfkill acpi_cpufreq binfmt_misc sunrpc radeon i2c_algo_bit drm_kms_helper ttm e1000e drm ptp pps_core i2c_core
Aug  2 11:31:26 segfault kernel: [  517.036000] CPU: 0 PID: 2631 Comm: kworker/0:0 Tainted: G      D W     3.16.0-0.rc7.git3.1.fc21.x86_64 #1
Aug  2 11:31:26 segfault kernel: [  517.036361] Hardware name: LENOVO 4058CTO/4058CTO, BIOS 6FET93WW (3.23 ) 10/12/2012
Aug  2 11:31:26 segfault kernel: [  517.036634] Workqueue: pciehp-1 pciehp_power_thread
Aug  2 11:31:26 segfault kernel: [  517.036781]  0000000000000000 00000000c6d3ec2c ffff8800737efa80 ffffffff81808a15
Aug  2 11:31:26 segfault kernel: [  517.037045]  0000000000000000 ffff8800737efab8 ffffffff8109b3dd ffff8800bf553810
Aug  2 11:31:26 segfault kernel: [  517.037295]  ffff8800b64e6300 ffff8800bf553820 ffff8800bf553000 ffff8800bf5539c0
Aug  2 11:31:26 segfault kernel: [  517.037557] Call Trace:
Aug  2 11:31:26 segfault kernel: [  517.037643]  [<ffffffff81808a15>] dump_stack+0x4d/0x66
Aug  2 11:31:26 segfault kernel: [  517.037805]  [<ffffffff8109b3dd>] warn_slowpath_common+0x7d/0xa0
Aug  2 11:31:26 segfault kernel: [  517.037999]  [<ffffffff8109b50a>] warn_slowpath_null+0x1a/0x20
Aug  2 11:31:26 segfault kernel: [  517.038193]  [<ffffffffa0037001>] drm_framebuffer_remove+0x151/0x160 [drm]
Aug  2 11:31:26 segfault kernel: [  517.038432]  [<ffffffff8109b3ec>] ? warn_slowpath_common+0x8c/0xa0
Aug  2 11:31:26 segfault kernel: [  517.038619]  [<ffffffffa0038a65>] drm_mode_config_cleanup+0x195/0x2a0 [drm]
Aug  2 11:31:26 segfault kernel: [  517.038862]  [<ffffffffa0115fae>] radeon_modeset_fini+0x7e/0xa0 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.039094]  [<ffffffffa00ed440>] radeon_driver_unload_kms+0x40/0x60 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.039337]  [<ffffffffa0030349>] drm_dev_unregister+0x29/0xb0 [drm]
Aug  2 11:31:26 segfault kernel: [  517.039523]  [<ffffffffa0030993>] drm_put_dev+0x23/0x80 [drm]
Aug  2 11:31:26 segfault kernel: [  517.039694]  [<ffffffffa00e9275>] radeon_pci_remove+0x15/0x20 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.039902]  [<ffffffff81430a6b>] pci_device_remove+0x3b/0xc0
Aug  2 11:31:26 segfault kernel: [  517.040086]  [<ffffffff815203df>] __device_release_driver+0x7f/0xf0
Aug  2 11:31:26 segfault kernel: [  517.040316]  [<ffffffff81520475>] device_release_driver+0x25/0x40
Aug  2 11:31:26 segfault kernel: [  517.040490]  [<ffffffff8142ace4>] pci_stop_bus_device+0x94/0xa0
Aug  2 11:31:26 segfault kernel: [  517.040657]  [<ffffffff8142ade2>] pci_stop_and_remove_bus_device+0x12/0x20
Aug  2 11:31:26 segfault kernel: [  517.040849]  [<ffffffff81447530>] pciehp_unconfigure_device+0xb0/0x1c0
Aug  2 11:31:26 segfault kernel: [  517.041071]  [<ffffffff81446ef4>] pciehp_disable_slot+0x54/0xe0
Aug  2 11:31:26 segfault kernel: [  517.041262]  [<ffffffff8144706f>] pciehp_power_thread+0xef/0x160
Aug  2 11:31:26 segfault kernel: [  517.041432]  [<ffffffff810c0551>] process_one_work+0x211/0x6f0
Aug  2 11:31:26 segfault kernel: [  517.041626]  [<ffffffff810c04e5>] ? process_one_work+0x1a5/0x6f0
Aug  2 11:31:26 segfault kernel: [  517.041797]  [<ffffffff810c0a9b>] worker_thread+0x6b/0x540
Aug  2 11:31:26 segfault kernel: [  517.041972]  [<ffffffff810c0a30>] ? process_one_work+0x6f0/0x6f0
Aug  2 11:31:26 segfault kernel: [  517.042167]  [<ffffffff810c8d38>] kthread+0x108/0x120
Aug  2 11:31:26 segfault kernel: [  517.042346]  [<ffffffff810e1d18>] ? sched_clock_cpu+0x98/0xc0
Aug  2 11:31:26 segfault kernel: [  517.042540]  [<ffffffff810ff71d>] ? trace_hardirqs_on_caller+0x15d/0x200
Aug  2 11:31:26 segfault kernel: [  517.042735]  [<ffffffff810c8c30>] ? insert_kthread_work+0x80/0x80
Aug  2 11:31:26 segfault kernel: [  517.042905]  [<ffffffff818124fc>] ret_from_fork+0x7c/0xb0
Aug  2 11:31:26 segfault kernel: [  517.043073]  [<ffffffff810c8c30>] ? insert_kthread_work+0x80/0x80
Aug  2 11:31:26 segfault kernel: [  517.043287] ---[ end trace 2be177afde0240c2 ]---
Aug  2 11:31:26 segfault kernel: [  517.235153] ------------[ cut here ]------------
Aug  2 11:31:26 segfault kernel: [  517.235332] WARNING: CPU: 0 PID: 2631 at fs/sysfs/group.c:219 sysfs_remove_group+0x99/0xa0()
Aug  2 11:31:26 segfault kernel: [  517.235630] sysfs group ffffffff81f618e0 not found for kobject 'i2c-5'
Aug  2 11:31:26 segfault kernel: [  517.235873] Modules linked in: vhost_net vhost macvtap macvlan tun bridge stp llc uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev media snd_usb_audio snd_usbmidi_lib mmc_block snd_rawmidi coretemp kvm_intel kvm iTCO_wdt sdhci_pci arc4 iwldvm mac80211 sdhci iTCO_vendor_support snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep lpc_ich iwlwifi i2c_i801 mmc_core microcode mei_me snd_seq snd_seq_device mfd_core cfg80211 snd_pcm thinkpad_acpi r592 memstick tpm_tis mei snd_timer shpchp snd soundcore wmi video tpm rfkill acpi_cpufreq binfmt_misc sunrpc radeon i2c_algo_bit drm_kms_helper ttm e1000e drm ptp pps_core i2c_core
Aug  2 11:31:26 segfault kernel: [  517.238378] CPU: 0 PID: 2631 Comm: kworker/0:0 Tainted: G      D W     3.16.0-0.rc7.git3.1.fc21.x86_64 #1
Aug  2 11:31:26 segfault kernel: [  517.238661] Hardware name: LENOVO 4058CTO/4058CTO, BIOS 6FET93WW (3.23 ) 10/12/2012
Aug  2 11:31:26 segfault kernel: [  517.238890] Workqueue: pciehp-1 pciehp_power_thread
Aug  2 11:31:26 segfault kernel: [  517.239061]  0000000000000000 00000000c6d3ec2c ffff8800737ef9b0 ffffffff81808a15
Aug  2 11:31:26 segfault kernel: [  517.239370]  ffff8800737ef9f8 ffff8800737ef9e8 ffffffff8109b3dd 0000000000000000
Aug  2 11:31:26 segfault kernel: [  517.239604]  ffffffff81f618e0 ffff88022d4a8800 ffff88022d4a8dc8 ffff88022d4a8908
Aug  2 11:31:26 segfault kernel: [  517.239857] Call Trace:
Aug  2 11:31:26 segfault kernel: [  517.239939]  [<ffffffff81808a15>] dump_stack+0x4d/0x66
Aug  2 11:31:26 segfault kernel: [  517.240100]  [<ffffffff8109b3dd>] warn_slowpath_common+0x7d/0xa0
Aug  2 11:31:26 segfault kernel: [  517.240334]  [<ffffffff8109b45c>] warn_slowpath_fmt+0x5c/0x80
Aug  2 11:31:26 segfault kernel: [  517.240504]  [<ffffffff8180ecbe>] ? mutex_unlock+0xe/0x10
Aug  2 11:31:26 segfault kernel: [  517.240659]  [<ffffffff812d6eaa>] ? kernfs_find_and_get_ns+0x4a/0x60
Aug  2 11:31:26 segfault kernel: [  517.240848]  [<ffffffff812daaa9>] sysfs_remove_group+0x99/0xa0
Aug  2 11:31:26 segfault kernel: [  517.241037]  [<ffffffff81527787>] dpm_sysfs_remove+0x57/0x60
Aug  2 11:31:26 segfault kernel: [  517.241227]  [<ffffffff8151be45>] device_del+0x45/0x1e0
Aug  2 11:31:26 segfault kernel: [  517.241401]  [<ffffffff8151bffe>] device_unregister+0x1e/0x70
Aug  2 11:31:26 segfault kernel: [  517.241584]  [<ffffffffa0002e91>] i2c_del_adapter+0x2f1/0x380 [i2c_core]
Aug  2 11:31:26 segfault kernel: [  517.241795]  [<ffffffffa0072482>] drm_dp_aux_unregister+0x12/0x20 [drm_kms_helper]
Aug  2 11:31:26 segfault kernel: [  517.242070]  [<ffffffffa0118c1c>] radeon_i2c_destroy+0x3c/0x40 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.242329]  [<ffffffffa0118c9d>] radeon_i2c_fini+0x2d/0x50 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.242536]  [<ffffffffa0115fbf>] radeon_modeset_fini+0x8f/0xa0 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.242733]  [<ffffffffa00ed440>] radeon_driver_unload_kms+0x40/0x60 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.242943]  [<ffffffffa0030349>] drm_dev_unregister+0x29/0xb0 [drm]
Aug  2 11:31:26 segfault kernel: [  517.243165]  [<ffffffffa0030993>] drm_put_dev+0x23/0x80 [drm]
Aug  2 11:31:26 segfault kernel: [  517.243370]  [<ffffffffa00e9275>] radeon_pci_remove+0x15/0x20 [radeon]
Aug  2 11:31:26 segfault kernel: [  517.243580]  [<ffffffff81430a6b>] pci_device_remove+0x3b/0xc0
Aug  2 11:31:26 segfault kernel: [  517.243743]  [<ffffffff815203df>] __device_release_driver+0x7f/0xf0
Aug  2 11:31:26 segfault kernel: [  517.243920]  [<ffffffff81520475>] device_release_driver+0x25/0x40
Aug  2 11:31:26 segfault kernel: [  517.244104]  [<ffffffff8142ace4>] pci_stop_bus_device+0x94/0xa0
Aug  2 11:31:26 segfault kernel: [  517.244318]  [<ffffffff8142ade2>] pci_stop_and_remove_bus_device+0x12/0x20
Aug  2 11:31:26 segfault kernel: [  517.244517]  [<ffffffff81447530>] pciehp_unconfigure_device+0xb0/0x1c0
Aug  2 11:31:26 segfault kernel: [  517.244701]  [<ffffffff81446ef4>] pciehp_disable_slot+0x54/0xe0
Aug  2 11:31:26 segfault kernel: [  517.244865]  [<ffffffff8144706f>] pciehp_power_thread+0xef/0x160
Aug  2 11:31:26 segfault kernel: [  517.245069]  [<ffffffff810c0551>] process_one_work+0x211/0x6f0
Aug  2 11:31:26 segfault kernel: [  517.245267]  [<ffffffff810c04e5>] ? process_one_work+0x1a5/0x6f0
Aug  2 11:31:26 segfault kernel: [  517.245443]  [<ffffffff810c0a9b>] worker_thread+0x6b/0x540
Aug  2 11:31:26 segfault kernel: [  517.245625]  [<ffffffff810c0a30>] ? process_one_work+0x6f0/0x6f0
Aug  2 11:31:26 segfault kernel: [  517.245830]  [<ffffffff810c8d38>] kthread+0x108/0x120
Aug  2 11:31:26 segfault kernel: [  517.245987]  [<ffffffff810e1d18>] ? sched_clock_cpu+0x98/0xc0
Aug  2 11:31:26 segfault kernel: [  517.246208]  [<ffffffff810ff71d>] ? trace_hardirqs_on_caller+0x15d/0x200
Aug  2 11:31:26 segfault kernel: [  517.246468]  [<ffffffff810c8c30>] ? insert_kthread_work+0x80/0x80
Aug  2 11:31:26 segfault kernel: [  517.246674]  [<ffffffff818124fc>] ret_from_fork+0x7c/0xb0
Aug  2 11:31:26 segfault kernel: [  517.246828]  [<ffffffff810c8c30>] ? insert_kthread_work+0x80/0x80
Aug  2 11:31:26 segfault kernel: [  517.246998] ---[ end trace 2be177afde0240c3 ]---
Aug  2 11:31:26 segfault kernel: [  517.247284] [drm] radeon: finishing device.
Aug  2 11:31:30 segfault kernel: [  521.609397] CE: hpet increased min_delta_ns to 20115 nsec
Aug  2 11:31:37 segfault kernel: [  528.097313] [TTM] Buffer eviction failed
Aug  2 11:31:38 segfault kernel: [  528.837272] radeon 0000:01:00.0: sa_manager is not empty, clearing anyway
Aug  2 11:31:38 segfault kernel: [  528.840085] radeon 0000:01:00.0: Userspace still has active objects !
Aug  2 11:31:38 segfault kernel: [  528.840309] radeon 0000:01:00.0: ffff88022fda9bd0 ffff88022fda9800 65536 4294967297 force free
Aug  2 11:31:38 segfault kernel: [  528.840582] radeon 0000:01:00.0: ffff88022fdabbd0 ffff88022fdab800 65536 4294967297 force free
Aug  2 11:31:38 segfault kernel: [  528.840889] radeon 0000:01:00.0: ffff88022fdaf3d0 ffff88022fdaf000 16384 4294967297 force free
Aug  2 11:31:38 segfault kernel: [  528.841211] radeon 0000:01:00.0: ffff88022fdaa3d0 ffff88022fdaa000 65536 4294967297 force free
Aug  2 11:31:38 segfault kernel: [  528.841532] ------------[ cut here ]------------
Aug  2 11:31:38 segfault kernel: [  528.841706] WARNING: CPU: 0 PID: 2631 at drivers/gpu/drm/radeon/radeon_gart.c:234 radeon_gart_unbind+0xca/0xe0 [radeon]()
Aug  2 11:31:38 segfault kernel: [  528.842058] trying to unbind memory from uninitialized GART !

....

ACPI Table
==========

[    0.000000] ACPI: RSDP 0x00000000000F6440 000024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 0x00000000BFD49B3A 00009C (v01 LENOVO TP-6F    00003230  LTP 00000000)
[    0.000000] ACPI: FACP 0x00000000BFD49C00 0000F4 (v03 LENOVO TP-6F    00003230 LNVO 00000001)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Pm1aControlBlock: 16/32 (20140424/tbfadt-618)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20140424/tbfadt-699)
[    0.000000] ACPI: DSDT 0x00000000BFD4A00E 00FB01 (v01 LENOVO TP-6F    00003230 MSFT 03000000)
[    0.000000] ACPI: FACS 0x00000000BFD8E000 000040
[    0.000000] ACPI: SSDT 0x00000000BFD49DB4 00025A (v01 LENOVO TP-6F    00003230 MSFT 03000000)
[    0.000000] ACPI: ECDT 0x00000000BFD59B0F 000052 (v01 LENOVO TP-6F    00003230 LNVO 00000001)
[    0.000000] ACPI: APIC 0x00000000BFD59B61 000078 (v01 LENOVO TP-6F    00003230 LNVO 00000001)
[    0.000000] ACPI: MCFG 0x00000000BFD59BD9 00003C (v01 LENOVO TP-6F    00003230 LNVO 00000001)
[    0.000000] ACPI: HPET 0x00000000BFD59C15 000038 (v01 LENOVO TP-6F    00003230 LNVO 00000001)
[    0.000000] ACPI: SLIC 0x00000000BFD59DC2 000176 (v01 LENOVO TP-6F    00003230  LTP 00000000)
[    0.000000] ACPI: BOOT 0x00000000BFD59F38 000028 (v01 LENOVO TP-6F    00003230  LTP 00000001)
[    0.000000] ACPI: ASF! 0x00000000BFD59F60 0000A0 (v16 LENOVO TP-6F    00003230 PTL  00000001)
[    0.000000] ACPI: SSDT 0x00000000BFD8D1FA 000568 (v01 LENOVO TP-6F    00003230 INTL 20050513)
[    0.000000] ACPI: TCPA 0x00000000BFB07000 000032 (v00                 00000000      00000000)
[    0.000000] ACPI: DMAR 0x00000000BFB06000 0000D8 (v01        ?        00000001      00000000)
[    0.000000] ACPI: SSDT 0x00000000BFAD3000 000655 (v01 PmRef  CpuPm    00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 0x00000000BFAD2000 000274 (v01 PmRef  Cpu0Tst  00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 0x00000000BFAD1000 000242 (v01 PmRef  ApTst    00003000 INTL 20050624)

This cascades until it just never recovers and I have to do sysctl magic reset.

Can we get a resolution on this?

Thanks,
Shawn






