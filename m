Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3CKTTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:19:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51548 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738Ab3CKTTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:19:41 -0400
Date: Mon, 11 Mar 2013 20:19:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, e1000-devel@lists.sourceforge.net,
        Bruce Allan <bruce.w.allan@intel.com>
Subject: e1000e + suspend, 3.9-rc2
Message-ID: <20130311191936.GD5000@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	e1000-devel@lists.sourceforge.net,
	Bruce Allan <bruce.w.allan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When I try to suspend with 3.9-rc2, it fails to do so and returns back
to the prompt. Below's what's in dmesg.

Jeff, am I assuming correctly that the fixes I was testing last week
haven't trickled upstream yet?

If so, then it's a no biggie, I'll wait. This mail is then just FYI.

Thanks.

[ 1294.992955] PM: Syncing filesystems ... done.
[ 1295.002976] Freezing user space processes ... (elapsed 0.01 seconds) done.
[ 1295.014973] PM: Preallocating image memory... done (allocated 153845 pages)
[ 1295.187511] PM: Allocated 615380 kbytes in 0.17 seconds (3619.88 MB/s)
[ 1295.187529] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[ 1295.199398] Suspending console(s) (use no_console_suspend to debug)
[ 1295.200746] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 1 ep 0 with no TDs queued?
[ 1295.764171] e1000e 0000:00:19.0 eth0: Hardware Error						<--- ***
[ 1296.599206] pci_pm_freeze(): e1000_suspend+0x0/0x20 returns -2				<--- ***
[ 1296.599208] dpm_run_callback(): pci_pm_freeze+0x0/0xc0 returns -2				<--- ***


[ 1296.599212] PM: Device 0000:00:19.0 failed to freeze async: error -2
[ 1296.659254] xhci_hcd 0000:00:14.0: setting latency timer to 64
[ 1296.659272] ehci-pci 0000:00:1d.0: setting latency timer to 64
[ 1296.659282] ehci-pci 0000:00:1a.0: setting latency timer to 64
[ 1296.659294] usb usb1: root hub lost power or was reset
[ 1296.659295] usb usb2: root hub lost power or was reset
[ 1296.659303] usb usb3: root hub lost power or was reset
[ 1296.659308] i915 0000:00:02.0: setting latency timer to 64
[ 1296.659316] usb usb4: root hub lost power or was reset
[ 1296.659370] xhci_hcd 0000:00:14.0: Slot 1 endpoint 2 not removed from BW list!
[ 1296.659580] xhci_hcd 0000:00:14.0: irq 44 for MSI/MSI-X
[ 1296.659874] ahci 0000:00:1f.2: setting latency timer to 64
[ 1296.663218] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[ 1296.663219] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[ 1296.670498] snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[ 1296.964331] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[ 1296.965388] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 1296.965393] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 1296.966335] ata2: SATA link down (SStatus 0 SControl 300)
[ 1296.967626] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 1296.967630] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 1296.968326] usb 3-1: reset high-speed USB device number 2 using ehci-pci
[ 1296.968368] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1296.968480] ata1.00: configured for UDMA/133
[ 1296.969113] sd 0:0:0:0: [sda] Starting disk
[ 1296.969137] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 1296.969141] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 1296.969306] ata5: SATA link down (SStatus 0 SControl 300)
[ 1296.970071] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 1296.970075] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 1296.970402] ata3.00: configured for UDMA/100
[ 1296.970566] sd 2:0:0:0: [sdb] Starting disk
[ 1297.184472] usb 4-1: reset high-speed USB device number 2 using ehci-pci
[ 1297.550690] usb 1-2: reset low-speed USB device number 2 using xhci_hcd
[ 1297.564794] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880211766300
[ 1297.564804] usb 1-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[ 1297.569277] PM: restore of devices complete after 910.002 msecs
[ 1297.573285] Restarting tasks ... done.
[ 1297.577501] video LNXVIDEO:00: Restoring backlight state
[ 1298.066775] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[ 1301.986071] PM: Syncing filesystems ... done.
[ 1301.999421] Freezing user space processes ... (elapsed 0.01 seconds) done.
[ 1302.012647] PM: Preallocating image memory... done (allocated 153541 pages)
[ 1302.177618] PM: Allocated 614164 kbytes in 0.16 seconds (3838.52 MB/s)
[ 1302.178208] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[ 1302.190493] Suspending console(s) (use no_console_suspend to debug)
[ 1302.192179] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 1 ep 0 with no TDs queued?
[ 1302.751858] e1000e 0000:00:19.0 eth0: Hardware Error
[ 1302.959582] ------------[ cut here ]------------
[ 1302.959587] WARNING: at kernel/irq/manage.c:1249 __free_irq+0xa3/0x1e0()
[ 1302.959588] Hardware name: 2320CTO
[ 1302.959588] Trying to free already-free IRQ 20
[ 1302.959612] Modules linked in: cpufreq_powersave cpufreq_userspace cpufreq_conservative cpufreq_stats uinput loop hid_generic usbhid hid arc4 coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel xts aes_x86_64 lrw gf128mul ablk_helper cryptd iTCO_wdt iTCO_vendor_support snd_hda_codec_hdmi snd_hda_codec_realtek microcode sdhci_pci snd_hda_intel snd_hda_codec lpc_ich snd_hwdep mfd_core sdhci snd_pcm i2c_i801 pcspkr mmc_core thinkpad_acpi snd_page_alloc battery ac nvram snd_timer led_class snd ehci_pci soundcore xhci_hcd ehci_hcd wmi acpi_cpufreq mperf processor thermal [last unloaded: cfg80211]
[ 1302.959613] Pid: 3966, comm: kworker/u:49 Not tainted 3.9.0-rc2+ #32
[ 1302.959614] Call Trace:
[ 1302.959618]  [<ffffffff8103f53f>] warn_slowpath_common+0x7f/0xc0
[ 1302.959620]  [<ffffffff8103f636>] warn_slowpath_fmt+0x46/0x50
[ 1302.959623]  [<ffffffff815ac69e>] ? _raw_spin_lock_irqsave+0x4e/0x60
[ 1302.959624]  [<ffffffff810bcef5>] ? __free_irq+0x55/0x1e0
[ 1302.959625]  [<ffffffff810bcf43>] __free_irq+0xa3/0x1e0
[ 1302.959627]  [<ffffffff810bd0d4>] free_irq+0x54/0xc0
[ 1302.959630]  [<ffffffff8142e26d>] e1000_free_irq+0x7d/0x90
[ 1302.959631]  [<ffffffff8143a3a7>] __e1000_shutdown+0x97/0x880
[ 1302.959633]  [<ffffffff815b0ac9>] ? sub_preempt_count+0x79/0xd0
[ 1302.959634]  [<ffffffff8143abe7>] e1000_suspend+0x17/0x20
[ 1302.959637]  [<ffffffff812a4445>] pci_pm_freeze+0x55/0xc0
[ 1302.959638]  [<ffffffff812a43f0>] ? pci_pm_resume_noirq+0xd0/0xd0
[ 1302.959640]  [<ffffffff813ca1e5>] dpm_run_callback.isra.5+0x25/0x50
[ 1302.959642]  [<ffffffff813ca973>] __device_suspend+0xe3/0x200
[ 1302.959643]  [<ffffffff813caaaf>] async_suspend+0x1f/0xa0
[ 1302.959645]  [<ffffffff8106c29b>] async_run_entry_fn+0x3b/0x140
[ 1302.959648]  [<ffffffff8105d5ad>] process_one_work+0x1ed/0x510
[ 1302.959649]  [<ffffffff8105d54b>] ? process_one_work+0x18b/0x510
[ 1302.959651]  [<ffffffff8105ed55>] worker_thread+0x115/0x390
[ 1302.959652]  [<ffffffff8105ec40>] ? manage_workers+0x300/0x300
[ 1302.959654]  [<ffffffff810653ca>] kthread+0xea/0xf0
[ 1302.959656]  [<ffffffff810652e0>] ? kthread_create_on_node+0x160/0x160
[ 1302.959657]  [<ffffffff815b4a1c>] ret_from_fork+0x7c/0xb0
[ 1302.959659]  [<ffffffff810652e0>] ? kthread_create_on_node+0x160/0x160
[ 1302.959660] ---[ end trace 65d7a9f7d60cfc59 ]---
[ 1303.582835] pci_pm_freeze(): e1000_suspend+0x0/0x20 returns -2
[ 1303.582836] dpm_run_callback(): pci_pm_freeze+0x0/0xc0 returns -2
[ 1303.582839] PM: Device 0000:00:19.0 failed to freeze async: error -2
[ 1303.637977] xhci_hcd 0000:00:14.0: setting latency timer to 64
[ 1303.637986] ehci-pci 0000:00:1a.0: setting latency timer to 64
[ 1303.638000] usb usb1: root hub lost power or was reset
[ 1303.638002] usb usb2: root hub lost power or was reset
[ 1303.638015] usb usb3: root hub lost power or was reset
[ 1303.638017] i915 0000:00:02.0: setting latency timer to 64
[ 1303.638090] xhci_hcd 0000:00:14.0: Slot 1 endpoint 2 not removed from BW list!
[ 1303.638280] xhci_hcd 0000:00:14.0: irq 44 for MSI/MSI-X
[ 1303.638407] ehci-pci 0000:00:1d.0: setting latency timer to 64
[ 1303.638439] usb usb4: root hub lost power or was reset
[ 1303.638621] ahci 0000:00:1f.2: setting latency timer to 64
[ 1303.641895] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[ 1303.642323] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[ 1303.649289] snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[ 1303.945201] ata2: SATA link down (SStatus 0 SControl 300)
[ 1303.945243] usb 3-1: reset high-speed USB device number 2 using ehci-pci
[ 1303.945260] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1303.945937] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 1303.945942] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 1303.946876] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 1303.946880] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 1303.947205] ata3.00: configured for UDMA/100
[ 1303.947357] sd 2:0:0:0: [sdb] Starting disk
[ 1303.948182] ata5: SATA link down (SStatus 0 SControl 300)
[ 1303.950186] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[ 1303.951521] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 1303.951525] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 1303.954302] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 1303.954306] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 1303.955467] ata1.00: configured for UDMA/133
[ 1303.955614] sd 0:0:0:0: [sda] Starting disk
[ 1304.161332] usb 4-1: reset high-speed USB device number 2 using ehci-pci
[ 1304.527527] usb 1-2: reset low-speed USB device number 2 using xhci_hcd
[ 1304.541319] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880211766300
[ 1304.541329] usb 1-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[ 1304.545981] PM: restore of devices complete after 907.843 msecs
[ 1304.610202] Restarting tasks ... done.
[ 1304.611516] video LNXVIDEO:00: Restoring backlight state
[ 1305.064547] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
