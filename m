Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaIPJtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:49:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61363 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbaIPJtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:49:49 -0400
Date: Tue, 16 Sep 2014 10:54:19 +0100
From: "Carlos R. Mafra" <crmafra@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>
Subject: Re: External monitor issues with 3.17-rc4 and i915 module
Message-ID: <20140916095419.GA8548@linux-g29b.site>
References: <20140909215430.GA3710@linux-g29b.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909215430.GA3710@linux-g29b.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, the same happens with 3.17-rc5. The kernel is unfortunately
unusable with my external monitor because after some plug, unplug
and suspend to RAM cycles the behaviour is not good (sometimes
it freezes, sometimes X needs a restart).

Sorry to ask, but is there someone looking at this? I can provide
more information if necessary.

On Tue,  9 Sep 2014 at 22:54:30 +0100, Carlos R. Mafra wrote:
> There is an issue with the latest kernel 3.17-rc4 regarding my external
> monitor.
> 
> I boot my laptop and plug the external monitor with the VGA cable and
> it works fine. Then I unplug the monitor and suspend to RAM. When the
> laptop resumes there are a bunch of warnings in 'dmesg' (see below).
> 
> After that the laptop becomes unreliable. Sometimes I get a blanck
> screen when going fullscreen in a flash video, sometimes the laptop
> freezes when I reconnect the monitor and do (DP3 is the monitor and
> eDP1 is the laptop):
> 
> xrandr --output DP3 --auto
> xrandr --output eDP1 --off
> 
> I think the freeze is reproducible after the second command above,
> but I haven't tried many times.
> 
> The laptop is a Macbook Pro with retina display and it uses the 'i915'
> module. The full dmesg and kernel config are here:
> 
> http://damtp.cam.ac.uk/user/crm66/dmesg-3.17-rc4.txt
> http://damtp.cam.ac.uk/user/crm66/config-3.17-rc4.txt
> 
> I can test patches and give more information if needed.
> 
> 
> The warnings from the above 'dmesg' are below:
> 
> 
> [  664.192589] [drm:intel_dp_start_link_train] *ERROR* failed to enable link training
> [  664.195181] [drm:intel_dp_complete_link_train] *ERROR* failed to start channel equalization
> [  664.213900] [drm:cpt_verify_modeset] *ERROR* mode set failed: pipe B stuck
> [  664.213921] ------------[ cut here ]------------
> [  664.213926] WARNING: CPU: 2 PID: 2601 at /home/mafra/linux-2.6/drivers/gpu/drm/i915/intel_display.c:10587 intel_modeset_check_state+0x600/0x790()
> [  664.213927] encoder's hw state doesn't match sw tracking (expected 1, found 0)
> [  664.213944] Modules linked in: ctr ccm arc4 nls_iso8859_1 nls_cp437 b43 vfat fat mac80211 snd_hda_codec_hdmi snd_hda_codec_cirrus snd_hda_codec_generic cfg80211 snd_hda_intel snd_hda_controller snd_hda_codec uvcvideo x86_pkg_temp_thermal snd_hwdep snd_pcm crc32c_intel ghash_clmulni_intel videobuf2_core rfkill videobuf2_vmalloc ssb videobuf2_memops bcm5974 snd_timer rtc_cmos
> [  664.213947] CPU: 2 PID: 2601 Comm: kworker/u8:87 Not tainted 3.17.0-rc4+ #45
> [  664.213948] Hardware name: Apple Inc. MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS MBP102.88Z.0106.B01.1208311637 08/31/2012
> [  664.213952] Workqueue: events_unbound async_run_entry_fn
> [  664.213954]  0000000000000009 ffff880230d33b68 ffffffff816f6d76 ffff880230d33bb0
> [  664.213956]  ffff880230d33ba0 ffffffff81067343 0000000000000001 ffff880261eda338
> [  664.213958]  ffff880261eda000 ffff880261f8f000 ffff880261eda308 ffff880230d33c00
> [  664.213958] Call Trace:
> [  664.213963]  [<ffffffff816f6d76>] dump_stack+0x4d/0x6f
> [  664.213965]  [<ffffffff81067343>] warn_slowpath_common+0x73/0x90
> [  664.213967]  [<ffffffff810673a7>] warn_slowpath_fmt+0x47/0x50
> [  664.213969]  [<ffffffff814714e0>] intel_modeset_check_state+0x600/0x790
> [  664.213971]  [<ffffffff81473627>] intel_modeset_setup_hw_state+0x857/0xd40
> [  664.213974]  [<ffffffff81417be9>] __i915_drm_thaw+0x159/0x1d0
> [  664.213976]  [<ffffffff814187f3>] i915_resume+0x23/0x40
> [  664.213977]  [<ffffffff81418820>] i915_pm_resume+0x10/0x20
> [  664.213980]  [<ffffffff8134af2a>] pci_pm_resume+0x7a/0x110
> [  664.213982]  [<ffffffff8134aeb0>] ? pci_pm_resume_noirq+0xb0/0xb0
> [  664.213985]  [<ffffffff814b43ef>] dpm_run_callback+0x3f/0x80
> [  664.213986]  [<ffffffff814b4970>] device_resume+0x90/0x260
> [  664.213988]  [<ffffffff814b4b58>] async_resume+0x18/0x40
> [  664.213990]  [<ffffffff810834f2>] async_run_entry_fn+0x32/0x130
> [  664.213992]  [<ffffffff8107bf46>] process_one_work+0x166/0x390
> [  664.213994]  [<ffffffff8107c51b>] worker_thread+0x11b/0x490
> [  664.213996]  [<ffffffff8107c400>] ? rescuer_thread+0x290/0x290
> [  664.213998]  [<ffffffff81080f1d>] kthread+0xcd/0xf0
> [  664.214001]  [<ffffffff81080e50>] ? kthread_create_on_node+0x170/0x170
> [  664.214003]  [<ffffffff816ff22c>] ret_from_fork+0x7c/0xb0
> [  664.214005]  [<ffffffff81080e50>] ? kthread_create_on_node+0x170/0x170
> [  664.214006] ---[ end trace 41c18eff292a7632 ]---
> [  664.214025] [drm:intel_pipe_config_compare] *ERROR* mismatch in has_dp_encoder (expected 1, found 0)
> [  664.214026] ------------[ cut here ]------------
> [  664.214030] WARNING: CPU: 2 PID: 2601 at /home/mafra/linux-2.6/drivers/gpu/drm/i915/intel_display.c:10659 check_crtc_state+0x215/0x330()
> [  664.214030] pipe state doesn't match!
> [  664.214040] Modules linked in: ctr ccm arc4 nls_iso8859_1 nls_cp437 b43 vfat fat mac80211 snd_hda_codec_hdmi snd_hda_codec_cirrus snd_hda_codec_generic cfg80211 snd_hda_intel snd_hda_controller snd_hda_codec uvcvideo x86_pkg_temp_thermal snd_hwdep snd_pcm crc32c_intel ghash_clmulni_intel videobuf2_core rfkill videobuf2_vmalloc ssb videobuf2_memops bcm5974 snd_timer rtc_cmos
> [  664.214042] CPU: 2 PID: 2601 Comm: kworker/u8:87 Tainted: G        W      3.17.0-rc4+ #45
> [  664.214043] Hardware name: Apple Inc. MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS MBP102.88Z.0106.B01.1208311637 08/31/2012
> [  664.214044] Workqueue: events_unbound async_run_entry_fn
> [  664.214046]  0000000000000009 ffff880230d33898 ffffffff816f6d76 ffff880230d338e0
> [  664.214048]  ffff880230d338d0 ffffffff81067343 ffff880261f57708 ffff880230d33968
> [  664.214050]  ffff880261eda000 ffff880261f57000 ffff880261eda338 ffff880230d33930
> [  664.214050] Call Trace:
> [  664.214052]  [<ffffffff816f6d76>] dump_stack+0x4d/0x6f
> [  664.214054]  [<ffffffff81067343>] warn_slowpath_common+0x73/0x90
> [  664.214055]  [<ffffffff810673a7>] warn_slowpath_fmt+0x47/0x50
> [  664.214058]  [<ffffffff81460047>] ? intel_pipe_config_compare+0x657/0xbb0
> [  664.214060]  [<ffffffff81461ce5>] check_crtc_state+0x215/0x330
> [  664.214063]  [<ffffffff8147115f>] intel_modeset_check_state+0x27f/0x790
> [  664.214065]  [<ffffffff81473627>] intel_modeset_setup_hw_state+0x857/0xd40
> [  664.214067]  [<ffffffff81417be9>] __i915_drm_thaw+0x159/0x1d0
> [  664.214069]  [<ffffffff814187f3>] i915_resume+0x23/0x40
> [  664.214070]  [<ffffffff81418820>] i915_pm_resume+0x10/0x20
> [  664.214072]  [<ffffffff8134af2a>] pci_pm_resume+0x7a/0x110
> [  664.214074]  [<ffffffff8134aeb0>] ? pci_pm_resume_noirq+0xb0/0xb0
> [  664.214075]  [<ffffffff814b43ef>] dpm_run_callback+0x3f/0x80
> [  664.214077]  [<ffffffff814b4970>] device_resume+0x90/0x260
> [  664.214079]  [<ffffffff814b4b58>] async_resume+0x18/0x40
> [  664.214081]  [<ffffffff810834f2>] async_run_entry_fn+0x32/0x130
> [  664.214082]  [<ffffffff8107bf46>] process_one_work+0x166/0x390
> [  664.214084]  [<ffffffff8107c51b>] worker_thread+0x11b/0x490
> [  664.214086]  [<ffffffff8107c400>] ? rescuer_thread+0x290/0x290
> [  664.214088]  [<ffffffff81080f1d>] kthread+0xcd/0xf0
> [  664.214090]  [<ffffffff81080e50>] ? kthread_create_on_node+0x170/0x170
> [  664.214092]  [<ffffffff816ff22c>] ret_from_fork+0x7c/0xb0
> [  664.214094]  [<ffffffff81080e50>] ? kthread_create_on_node+0x170/0x170
> [  664.214095] ---[ end trace 41c18eff292a7633 ]---
> [  664.366982] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
> [  664.425187] PM: resume of devices complete after 886.347 msecs
> [  664.425432] PM: Finishing wakeup.
> [  664.425433] Restarting tasks ... done.
> [  664.449620] cfg80211: World regulatory domain updated:
> [  664.449624] cfg80211:  DFS Master region: unset
> [  664.449625] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
> [  664.449628] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
> [  664.449629] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
> [  664.449630] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm), (N/A)
> [  664.449632] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
> [  664.449633] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
> [  666.305520] PM: Syncing filesystems ... done.
> [  666.839919] PM: Preparing system for mem sleep
> [  666.840028] Freezing user space processes ... (elapsed 0.001 seconds) done.
> [  666.841447] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
> [  666.842604] PM: Entering mem sleep
> [  666.842619] Suspending console(s) (use no_console_suspend to debug)
> [  666.842888] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [  666.847506] sd 0:0:0:0: [sda] Stopping disk
> [  667.258444] ------------[ cut here ]------------
> [  667.258449] WARNING: CPU: 2 PID: 2631 at /home/mafra/linux-2.6/drivers/gpu/drm/i915/intel_dp.c:3266 intel_dp_link_down+0x1cb/0x200()
> [  667.258464] Modules linked in: ctr ccm arc4 nls_iso8859_1 nls_cp437 b43 vfat fat mac80211 snd_hda_codec_hdmi snd_hda_codec_cirrus snd_hda_codec_generic cfg80211 snd_hda_intel snd_hda_controller snd_hda_codec uvcvideo x86_pkg_temp_thermal snd_hwdep snd_pcm crc32c_intel ghash_clmulni_intel videobuf2_core rfkill videobuf2_vmalloc ssb videobuf2_memops bcm5974 snd_timer rtc_cmos
> [  667.258466] CPU: 2 PID: 2631 Comm: kworker/u8:117 Tainted: G        W      3.17.0-rc4+ #45
> [  667.258467] Hardware name: Apple Inc. MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS MBP102.88Z.0106.B01.1208311637 08/31/2012
> [  667.258470] Workqueue: events_unbound async_run_entry_fn
> [  667.258472]  0000000000000009 ffff8802284f3b90 ffffffff816f6d76 0000000000000000
> [  667.258474]  ffff8802284f3bc8 ffffffff81067343 ffff880261f00000 ffff880261eda000
> [  667.258475]  0000000000080304 0000000000000003 ffff880261f8f0e0 ffff8802284f3bd8
> [  667.258476] Call Trace:
> [  667.258480]  [<ffffffff816f6d76>] dump_stack+0x4d/0x6f
> [  667.258483]  [<ffffffff81067343>] warn_slowpath_common+0x73/0x90
> [  667.258484]  [<ffffffff81067415>] warn_slowpath_null+0x15/0x20
> [  667.258486]  [<ffffffff8148447b>] intel_dp_link_down+0x1cb/0x200
> [  667.258488]  [<ffffffff81489100>] intel_disable_dp+0x60/0x70
> [  667.258490]  [<ffffffff8146ec7a>] ironlake_crtc_disable+0x14a/0x7a0
> [  667.258492]  [<ffffffff81415bce>] ? drm_modeset_lock+0x2e/0xe0
> [  667.258494]  [<ffffffff81468871>] intel_crtc_control+0x41/0x100
> [  667.258496]  [<ffffffff814184fa>] i915_drm_freeze+0xaa/0x1f0
> [  667.258497]  [<ffffffff8141877a>] i915_pm_suspend+0x2a/0x50
> [  667.258500]  [<ffffffff8134b281>] pci_pm_suspend+0x71/0x1d0
> [  667.258501]  [<ffffffff8134b210>] ? pci_pm_suspend_noirq+0x250/0x250
> [  667.258504]  [<ffffffff814b43ef>] dpm_run_callback+0x3f/0x80
> [  667.258506]  [<ffffffff814b514b>] __device_suspend+0xfb/0x3d0
> [  667.258507]  [<ffffffff814b557a>] async_suspend+0x1a/0xa0
> [  667.258509]  [<ffffffff810834f2>] async_run_entry_fn+0x32/0x130
> [  667.258511]  [<ffffffff8107bf46>] process_one_work+0x166/0x390
> [  667.258513]  [<ffffffff8107c51b>] worker_thread+0x11b/0x490
> [  667.258515]  [<ffffffff8107c400>] ? rescuer_thread+0x290/0x290
> [  667.258517]  [<ffffffff81080f1d>] kthread+0xcd/0xf0
> [  667.258519]  [<ffffffff81080e50>] ? kthread_create_on_node+0x170/0x170
> [  667.258521]  [<ffffffff816ff22c>] ret_from_fork+0x7c/0xb0
> [  667.258523]  [<ffffffff81080e50>] ? kthread_create_on_node+0x170/0x170
> [  667.258524] ---[ end trace 41c18eff292a7634 ]---
> [  667.359739] ------------[ cut here ]------------
> [  667.359742] WARNING: CPU: 2 PID: 2631 at /home/mafra/linux-2.6/drivers/gpu/drm/i915/intel_display.c:994 intel_wait_for_pipe_off+0x19e/0x1b0()
> [  667.359743] pipe_off wait timed out
> [  667.359753] Modules linked in: ctr ccm arc4 nls_iso8859_1 nls_cp437 b43 vfat fat mac80211 snd_hda_codec_hdmi snd_hda_codec_cirrus snd_hda_codec_generic cfg80211 snd_hda_intel snd_hda_controller snd_hda_codec uvcvideo x86_pkg_temp_thermal snd_hwdep snd_pcm crc32c_intel ghash_clmulni_intel videobuf2_core rfkill videobuf2_vmalloc ssb videobuf2_memops bcm5974 snd_timer rtc_cmos
> [  667.359754] CPU: 2 PID: 2631 Comm: kworker/u8:117 Tainted: G        W      3.17.0-rc4+ #45
> [  667.359755] Hardware name: Apple Inc. MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS MBP102.88Z.0106.B01.1208311637 08/31/2012
> [  667.359757] Workqueue: events_unbound async_run_entry_fn
> [  667.359758]  0000000000000009 ffff8802284f3b58 ffffffff816f6d76 ffff8802284f3ba0
> [  667.359760]  ffff8802284f3b90 ffffffff81067343 ffff880261f00000 0000000000071008
> [  667.359761]  0000000100059a43 ffff880261eda330 ffff880261eda338 ffff8802284f3bf0
> [  667.359762] Call Trace:
> [  667.359763]  [<ffffffff816f6d76>] dump_stack+0x4d/0x6f
> [  667.359765]  [<ffffffff81067343>] warn_slowpath_common+0x73/0x90
> [  667.359767]  [<ffffffff810673a7>] warn_slowpath_fmt+0x47/0x50
> [  667.359769]  [<ffffffff8146494e>] intel_wait_for_pipe_off+0x19e/0x1b0
> [  667.359771]  [<ffffffff81464a03>] intel_disable_pipe+0xa3/0xb0
> [  667.359772]  [<ffffffff8146ebc0>] ironlake_crtc_disable+0x90/0x7a0
> [  667.359774]  [<ffffffff81415bce>] ? drm_modeset_lock+0x2e/0xe0
> [  667.359775]  [<ffffffff81468871>] intel_crtc_control+0x41/0x100
> [  667.359777]  [<ffffffff814184fa>] i915_drm_freeze+0xaa/0x1f0
> [  667.359779]  [<ffffffff8141877a>] i915_pm_suspend+0x2a/0x50
> [  667.359780]  [<ffffffff8134b281>] pci_pm_suspend+0x71/0x1d0
> [  667.359782]  [<ffffffff8134b210>] ? pci_pm_suspend_noirq+0x250/0x250
> [  667.359783]  [<ffffffff814b43ef>] dpm_run_callback+0x3f/0x80
> [  667.359785]  [<ffffffff814b514b>] __device_suspend+0xfb/0x3d0
> [  667.359786]  [<ffffffff814b557a>] async_suspend+0x1a/0xa0
> [  667.359788]  [<ffffffff810834f2>] async_run_entry_fn+0x32/0x130
> [  667.359790]  [<ffffffff8107bf46>] process_one_work+0x166/0x390
> [  667.359791]  [<ffffffff8107c51b>] worker_thread+0x11b/0x490
> [  667.359793]  [<ffffffff8107c400>] ? rescuer_thread+0x290/0x290
> [  667.359795]  [<ffffffff81080f1d>] kthread+0xcd/0xf0
> [  667.359797]  [<ffffffff81080e50>] ? kthread_create_on_node+0x170/0x170
> [  667.359798]  [<ffffffff816ff22c>] ret_from_fork+0x7c/0xb0
> [  667.359800]  [<ffffffff81080e50>] ? kthread_create_on_node+0x170/0x170
> [  667.359801] ---[ end trace 41c18eff292a7635 ]---
> [  667.411757] [drm:ironlake_disable_pch_transcoder] *ERROR* failed to disable transcoder B
> [  668.391132] PM: suspend of devices complete after 1547.997 msecs
> [  668.402077] PM: late suspend of devices complete after 10.935 msecs
> [  668.404859] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
> [  668.404982] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
> [  668.405075] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
> [  668.416046] PM: noirq suspend of devices complete after 13.961 msecs
> [  668.416640] ACPI: Preparing to enter system sleep state S3
> [  668.720199] PM: Saving platform NVS memory
> [  668.720201] Disabling non-boot CPUs ...
> [  668.721386] smpboot: CPU 1 is now offline
> [  668.723032] smpboot: CPU 2 is now offline
> [  668.724401] smpboot: CPU 3 is now offline
> [  668.725511] ACPI: Low-level resume complete
> [  668.725549] PM: Restoring platform NVS memory
> [  668.725860] Enabling non-boot CPUs ...
> [  668.725925] x86: Booting SMP configuration:
> [  668.725926] smpboot: Booting Node 0 Processor 1 APIC 0x2
> [  668.749781] CPU1 is up
> [  668.753563] smpboot: Booting Node 0 Processor 2 APIC 0x1
> [  668.775414] CPU2 is up
> [  668.775467] smpboot: Booting Node 0 Processor 3 APIC 0x3
> [  668.799051] CPU3 is up
> [  668.801941] ACPI: Waking up from system sleep state S3
> [  670.820148] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
> [  670.820151] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
> [  670.820189] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
> [  670.820531] PM: noirq resume of devices complete after 11.356 msecs
> [  670.820803] PM: early resume of devices complete after 0.254 msecs
> [  670.821144] snd_hda_intel 0000:00:1b.0: irq 31 for MSI/MSI-X
> [  670.821365] sd 0:0:0:0: [sda] Starting disk
> [  670.822629] rtc_cmos 00:02: System wakeup disabled by ACPI
> [  671.128004] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  671.128535] ata1.00: unexpected _GTF length (8)
> [  671.128933] ata1.00: unexpected _GTF length (8)
> [  671.129025] ata1.00: configured for UDMA/133
> [  671.474815] [drm:intel_dp_start_link_train] *ERROR* failed to enable link training
> [  671.477422] [drm:intel_dp_complete_link_train] *ERROR* failed to start channel equalization
> [  671.496088] [drm:cpt_verify_modeset] *ERROR* mode set failed: pipe B stuck
> [  671.496109] ------------[ cut here ]------------
> [  671.496114] WARNING: CPU: 0 PID: 2634 at /home/mafra/linux-2.6/drivers/gpu/drm/i915/intel_display.c:10587 intel_modeset_check_state+0x600/0x790()
> [  671.496115] encoder's hw state doesn't match sw tracking (expected 1, found 0)
> [  671.496132] Modules linked in: ctr ccm arc4 nls_iso8859_1 nls_cp437 b43 vfat fat mac80211 snd_hda_codec_hdmi snd_hda_codec_cirrus snd_hda_codec_generic cfg80211 snd_hda_intel snd_hda_controller snd_hda_codec uvcvideo x86_pkg_temp_thermal snd_hwdep snd_pcm crc32c_intel ghash_clmulni_intel videobuf2_core rfkill videobuf2_vmalloc ssb videobuf2_memops bcm5974 snd_timer rtc_cmos
> [  671.496134] CPU: 0 PID: 2634 Comm: kworker/u8:120 Tainted: G        W      3.17.0-rc4+ #45
> [  671.496135] Hardware name: Apple Inc. MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS MBP102.88Z.0106.B01.1208311637 08/31/2012
> [  671.496139] Workqueue: events_unbound async_run_entry_fn
> [  671.496142]  0000000000000009 ffff880228463b68 ffffffff816f6d76 ffff880228463bb0
> [  671.496144]  ffff880228463ba0 ffffffff81067343 0000000000000001 ffff880261eda338
> [  671.496145]  ffff880261eda000 ffff880261f8f000 ffff880261eda308 ffff880228463c00
> [  671.496146] Call Trace:
> [  671.496150]  [<ffffffff816f6d76>] dump_stack+0x4d/0x6f
> [  671.496153]  [<ffffffff81067343>] warn_slowpath_common+0x73/0x90
> [  671.496154]  [<ffffffff810673a7>] warn_slowpath_fmt+0x47/0x50
> [  671.496156]  [<ffffffff814714e0>] intel_modeset_check_state+0x600/0x790
> [  671.496158]  [<ffffffff81473627>] intel_modeset_setup_hw_state+0x857/0xd40
> [  671.496161]  [<ffffffff81417be9>] __i915_drm_thaw+0x159/0x1d0
> [  671.496163]  [<ffffffff814187f3>] i915_resume+0x23/0x40
> [  671.496165]  [<ffffffff81418820>] i915_pm_resume+0x10/0x20
> [  671.496167]  [<ffffffff8134af2a>] pci_pm_resume+0x7a/0x110
> [  671.496169]  [<ffffffff8134aeb0>] ? pci_pm_resume_noirq+0xb0/0xb0
> [  671.496172]  [<ffffffff814b43ef>] dpm_run_callback+0x3f/0x80
> [  671.496174]  [<ffffffff814b4970>] device_resume+0x90/0x260
> [  671.496176]  [<ffffffff814b4b58>] async_resume+0x18/0x40
> [  671.496177]  [<ffffffff810834f2>] async_run_entry_fn+0x32/0x130
> [  671.496180]  [<ffffffff8107bf46>] process_one_work+0x166/0x390
> [  671.496182]  [<ffffffff8107c51b>] worker_thread+0x11b/0x490
> [  671.496184]  [<ffffffff8107c400>] ? rescuer_thread+0x290/0x290
> [  671.496186]  [<ffffffff81080f1d>] kthread+0xcd/0xf0
> [  671.496188]  [<ffffffff81080e50>] ? kthread_create_on_node+0x170/0x170
> [  671.496191]  [<ffffffff816ff22c>] ret_from_fork+0x7c/0xb0
> [  671.496193]  [<ffffffff81080e50>] ? kthread_create_on_node+0x170/0x170
> [  671.496194] ---[ end trace 41c18eff292a7636 ]---
> [  671.496213] [drm:intel_pipe_config_compare] *ERROR* mismatch in has_dp_encoder (expected 1, found 0)
> [  671.496213] ------------[ cut here ]------------
> [  671.496217] WARNING: CPU: 0 PID: 2634 at /home/mafra/linux-2.6/drivers/gpu/drm/i915/intel_display.c:10659 check_crtc_state+0x215/0x330()
> [  671.496218] pipe state doesn't match!
> [  671.496228] Modules linked in: ctr ccm arc4 nls_iso8859_1 nls_cp437 b43 vfat fat mac80211 snd_hda_codec_hdmi snd_hda_codec_cirrus snd_hda_codec_generic cfg80211 snd_hda_intel snd_hda_controller snd_hda_codec uvcvideo x86_pkg_temp_thermal snd_hwdep snd_pcm crc32c_intel ghash_clmulni_intel videobuf2_core rfkill videobuf2_vmalloc ssb videobuf2_memops bcm5974 snd_timer rtc_cmos
> [  671.496229] CPU: 0 PID: 2634 Comm: kworker/u8:120 Tainted: G        W      3.17.0-rc4+ #45
> [  671.496230] Hardware name: Apple Inc. MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS MBP102.88Z.0106.B01.1208311637 08/31/2012
> [  671.496232] Workqueue: events_unbound async_run_entry_fn
> [  671.496233]  0000000000000009 ffff880228463898 ffffffff816f6d76 ffff8802284638e0
> [  671.496235]  ffff8802284638d0 ffffffff81067343 ffff880261f57708 ffff880228463968
> [  671.496237]  ffff880261eda000 ffff880261f57000 ffff880261eda338 ffff880228463930
> [  671.496237] Call Trace:
> [  671.496239]  [<ffffffff816f6d76>] dump_stack+0x4d/0x6f
> [  671.496240]  [<ffffffff81067343>] warn_slowpath_common+0x73/0x90
> [  671.496242]  [<ffffffff810673a7>] warn_slowpath_fmt+0x47/0x50
> [  671.496245]  [<ffffffff81460047>] ? intel_pipe_config_compare+0x657/0xbb0
> [  671.496247]  [<ffffffff81461ce5>] check_crtc_state+0x215/0x330
> [  671.496250]  [<ffffffff8147115f>] intel_modeset_check_state+0x27f/0x790
> [  671.496251]  [<ffffffff81473627>] intel_modeset_setup_hw_state+0x857/0xd40
> [  671.496253]  [<ffffffff81417be9>] __i915_drm_thaw+0x159/0x1d0
> [  671.496255]  [<ffffffff814187f3>] i915_resume+0x23/0x40
> [  671.496256]  [<ffffffff81418820>] i915_pm_resume+0x10/0x20
> [  671.496258]  [<ffffffff8134af2a>] pci_pm_resume+0x7a/0x110
> [  671.496259]  [<ffffffff8134aeb0>] ? pci_pm_resume_noirq+0xb0/0xb0
> [  671.496261]  [<ffffffff814b43ef>] dpm_run_callback+0x3f/0x80
> [  671.496263]  [<ffffffff814b4970>] device_resume+0x90/0x260
> [  671.496265]  [<ffffffff814b4b58>] async_resume+0x18/0x40
> [  671.496266]  [<ffffffff810834f2>] async_run_entry_fn+0x32/0x130
> [  671.496268]  [<ffffffff8107bf46>] process_one_work+0x166/0x390
> [  671.496270]  [<ffffffff8107c51b>] worker_thread+0x11b/0x490
> [  671.496271]  [<ffffffff8107c400>] ? rescuer_thread+0x290/0x290
> [  671.496273]  [<ffffffff81080f1d>] kthread+0xcd/0xf0
> [  671.496275]  [<ffffffff81080e50>] ? kthread_create_on_node+0x170/0x170
> [  671.496277]  [<ffffffff816ff22c>] ret_from_fork+0x7c/0xb0
> [  671.496279]  [<ffffffff81080e50>] ? kthread_create_on_node+0x170/0x170
> [  671.496280] ---[ end trace 41c18eff292a7637 ]---
> [  671.497104] PM: resume of devices complete after 676.117 msecs
> [  671.498302] PM: Finishing wakeup.
> [  671.498303] Restarting tasks ... done.
