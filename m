Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab3LBW17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 17:27:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab3LBW14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 17:27:56 -0500
Date: Mon, 2 Dec 2013 23:27:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: WARNING at intel_display.c:9948 during suspend
Message-ID: <alpine.LNX.2.00.1312022324260.24931@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting this during suspend with latest Linus' git (HEAD == af91706). 

 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 5397 at drivers/gpu/drm/i915/intel_display.c:9948 intel_get_pipe_from_connector+0x4a/0x50 [i915]()
 Modules linked in: ctr ccm af_packet tun iptable_mangle xt_DSCP nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables rfcomm cpufreq_conservative bnep cpufreq_userspace cpufreq_powersave iTCO_wdt iTCO_vendor_support kvm_intel kvm snd_hda_codec_conexant iwldvm mac80211 thinkpad_acpi snd_seq sg iwlwifi snd_seq_device snd_hda_intel snd_hda_codec snd_hwdep btusb bluetooth cfg80211 pcspkr snd_pcm i2c_i801 lpc_ich mfd_core rfkill snd_timer ehci_pci snd_page_alloc e1000e snd ptp pps_core wmi battery soundcore ac tpm_tis tpm acpi_cpufreq autofs4 uhci_hcd ehci_hcd i915 usbcore usb_common drm_kms_helper drm i2c_algo_bit video button edd fan processor ata_generic thermal thermal_sys
 CPU: 0 PID: 5397 Comm: kworker/u8:3 Not tainted 3.13.0-rc2-00001-gaf91706 #1
 Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
 Workqueue: events_unbound async_run_entry_fn
  00000000000026dc ffff8800229c1ab8 ffffffff8158f73b ffff8800229c1af8
  ffffffff8104d527 ffff8800229c1b08 ffff880035f8b4c0 ffff880079558000
  ffff880037cbc000 ffffffffffffffff ffff880035f8b4c0 ffff8800229c1b08
 Call Trace:
  [<ffffffff8158f73b>] dump_stack+0x72/0x87
  [<ffffffff8104d527>] warn_slowpath_common+0x87/0xb0
  [<ffffffff8104d565>] warn_slowpath_null+0x15/0x20
  [<ffffffffa0173cda>] intel_get_pipe_from_connector+0x4a/0x50 [i915]
  [<ffffffffa019c32b>] intel_panel_disable_backlight+0x2b/0x1a0 [i915]
  [<ffffffffa0186cce>] intel_disable_lvds+0x4e/0x190 [i915]
  [<ffffffffa017ca49>] i9xx_crtc_disable+0x2a9/0x3b0 [i915]
  [<ffffffffa013d0da>] i915_drm_freeze+0xda/0x160 [i915]
  [<ffffffffa013d1a8>] i915_pm_freeze+0x28/0x50 [i915]
  [<ffffffff813209f8>] pci_pm_freeze+0x58/0xd0
  [<ffffffff813209a0>] ? pci_pm_poweroff+0xf0/0xf0
  [<ffffffff813e932f>] dpm_run_callback+0x4f/0xa0
  [<ffffffff813e958f>] __device_suspend+0xef/0x280
  [<ffffffff813ead6a>] async_suspend+0x1a/0xa0
  [<ffffffff81078765>] async_run_entry_fn+0x45/0x140
  [<ffffffff8106b194>] process_one_work+0x204/0x470
  [<ffffffff8106b0e3>] ? process_one_work+0x153/0x470
  [<ffffffff81591940>] ? __mutex_unlock_slowpath+0xf0/0x180
  [<ffffffff8106c596>] worker_thread+0x126/0x3b0
  [<ffffffff8109b0ed>] ? trace_hardirqs_on+0xd/0x10
  [<ffffffff8106c470>] ? manage_workers+0x1a0/0x1a0
  [<ffffffff810726ed>] kthread+0xed/0x100
  [<ffffffff81072600>] ? __init_kthread_worker+0x70/0x70
  [<ffffffff8159d8bc>] ret_from_fork+0x7c/0xb0
  [<ffffffff81072600>] ? __init_kthread_worker+0x70/0x70
 ---[ end trace 8a2e5e8955c55372 ]---
 PM: freeze of devices complete after 407.505 msecs
 PM: late freeze of devices complete after 2.719 msecs
 PM: noirq freeze of devices complete after 3.789 msecs
 Disabling non-boot CPUs ...
 kvm: disabling virtualization on CPU1
 smpboot: CPU 1 is now offline
 PM: Creating hibernation image:
 PM: Need to copy 164506 pages

-- 
Jiri Kosina
SUSE Labs
