Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaBLTVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:21:37 -0500
Received: from mx.ungleich.ch ([77.109.138.221]:55810 "EHLO mx.ungleich.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756AbaBLTVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:21:35 -0500
Date: Wed, 12 Feb 2014 20:21:28 +0100
From: Nico Schottelius <nico-linux-20140212@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Nico Schottelius <nico-linux-20140212@schottelius.org>
Subject: [ACPI] How to debug immediate wakeup after resume?
Message-ID: <20140212192128.GA24378@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20140212@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: artist (Linux 3.12.9-2-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Good day hackers,

sometimes when I close the lid of the Lenovo Yoga 2 Pro, it suspends,
but resumes immediately (while the lid is still closed).

I have seen this happening various times and was now able to
capture the dmesg output of it happening.

I am running 3.12.9-2-ARCH and wondering if there is any good way to
find out, why the notebook wakes up?

Attached are dmesg up and including the last sucessful suspend as well
as dmesg output of suspend and immediate resume.

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-after-suspend

[ 7799.340490] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[ 7799.342235] PM: Syncing filesystems ... done.
[ 7799.715826] PM: Preparing system for mem sleep
[ 7799.716156] Freezing user space processes ... (elapsed 0.001 seconds) done.
[ 7799.717517] Freezing remaining freezable tasks ... (elapsed 0.000 seconds) done.
[ 7799.718276] PM: Entering mem sleep
[ 7799.718315] Suspending console(s) (use no_console_suspend to debug)
[ 7799.749096] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[ 7799.750494] sd 1:0:0:0: [sda] Stopping disk
[ 7799.806084] mei_me 0000:00:16.0: suspend
[ 7800.829205] PM: suspend of devices complete after 1109.766 msecs
[ 7800.829360] PM: late suspend of devices complete after 0.153 msecs
[ 7800.842801] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[ 7800.869243] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[ 7800.882895] PM: noirq suspend of devices complete after 53.489 msecs
[ 7800.883186] ACPI: Preparing to enter system sleep state S3
[ 7800.883480] PM: Saving platform NVS memory
[ 7800.884088] Disabling non-boot CPUs ...
[ 7800.985935] smpboot: CPU 1 is now offline
[ 7801.089360] smpboot: CPU 2 is now offline
[ 7801.090756] smpboot: CPU 3 is now offline
[ 7801.093914] ACPI: Low-level resume complete
[ 7801.093998] PM: Restoring platform NVS memory
[ 7801.094736] Enabling non-boot CPUs ...
[ 7801.094808] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7801.110492] Intel pstate controlling: cpu 1
[ 7801.110572] CPU1 is up
[ 7801.110601] smpboot: Booting Node 0 Processor 2 APIC 0x2
[ 7801.125552] Intel pstate controlling: cpu 2
[ 7801.125609] CPU2 is up
[ 7801.125631] smpboot: Booting Node 0 Processor 3 APIC 0x3
[ 7801.140359] Intel pstate controlling: cpu 3
[ 7801.140410] CPU3 is up
[ 7801.146147] ACPI: Waking up from system sleep state S3
[ 7801.189819] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[ 7801.229854] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[ 7801.256677] PM: noirq resume of devices complete after 106.627 msecs
[ 7801.256797] PM: early resume of devices complete after 0.102 msecs
[ 7801.256818] i915 0000:00:02.0: setting latency timer to 64
[ 7801.256913] snd_hda_intel 0000:00:03.0: irq 60 for MSI/MSI-X
[ 7801.256950] xhci_hcd 0000:00:14.0: setting latency timer to 64
[ 7801.257025] ahci 0000:00:1f.2: setting latency timer to 64
[ 7801.257059] snd_hda_intel 0000:00:1b.0: irq 61 for MSI/MSI-X
[ 7801.257151] ehci-pci 0000:00:1d.0: setting latency timer to 64
[ 7801.257181] mei_me 0000:00:16.0: irq 62 for MSI/MSI-X
[ 7801.265758] dpm_run_callback(): pnp_bus_resume+0x0/0xa0 returns -19
[ 7801.265759] PM: Device 00:06 failed to resume: error -19
[ 7801.576790] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[ 7801.577491] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[ 7801.577827] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[ 7801.583298] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[ 7801.583489] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[ 7801.583575] ata2.00: configured for UDMA/133
[ 7801.583625] sd 1:0:0:0: [sda] Starting disk
[ 7801.670411] usb 1-7: reset full-speed USB device number 13 using xhci_hcd
[ 7801.684417] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173800
[ 7801.684418] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173840
[ 7801.684438] usb 1-7: ep 0x2 - rounding interval to 64 microframes, ep desc says 80 microframes
[ 7801.843931] usb 1-8: reset high-speed USB device number 4 using xhci_hcd
[ 7801.862802] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374a4f00
[ 7802.017248] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[ 7802.031902] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef040
[ 7802.031904] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef000
[ 7802.031909] usb 1-6: ep 0x81 - rounding interval to 128 microframes, ep desc says 160 microframes
[ 7802.031911] usb 1-6: ep 0x1 - rounding interval to 128 microframes, ep desc says 160 microframes
[ 7802.049676] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[ 7802.049816] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[ 7802.190815] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
[ 7802.204659] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401840
[ 7802.204660] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401880
[ 7802.204661] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374018c0
[ 7802.204662] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0f80
[ 7802.204663] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0fc0
[ 7802.205145] btusb 1-4:1.0: no reset_resume for driver btusb?
[ 7802.205146] btusb 1-4:1.1: no reset_resume for driver btusb?
[ 7802.205387] PM: resume of devices complete after 947.821 msecs
[ 7802.206122] PM: Finishing wakeup.
[ 7802.206172] iwlwifi 0000:01:00.0: no hotplug settings from platform
[ 7802.207188] pci_bus 0000:01: Allocating resources
[ 7802.207204] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[ 7802.207211] pci 0000:00:00.0: no hotplug settings from platform
[ 7802.207212] pci 0000:00:00.0: using default PCI settings
[ 7802.207216] i915 0000:00:02.0: no hotplug settings from platform
[ 7802.207217] i915 0000:00:02.0: using default PCI settings
[ 7802.207221] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[ 7802.207223] pci 0000:00:04.0: no hotplug settings from platform
[ 7802.207224] pci 0000:00:04.0: using default PCI settings
[ 7802.207228] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[ 7802.207229] xhci_hcd 0000:00:14.0: using default PCI settings
[ 7802.207234] mei_me 0000:00:16.0: no hotplug settings from platform
[ 7802.207235] mei_me 0000:00:16.0: using default PCI settings
[ 7802.207241] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[ 7802.207243] pcieport 0000:00:1c.0: no hotplug settings from platform
[ 7802.207249] iwlwifi 0000:01:00.0: no hotplug settings from platform
[ 7802.207252] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[ 7802.207269] ehci-pci 0000:00:1d.0: using default PCI settings
[ 7802.207278] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[ 7802.207279] lpc_ich 0000:00:1f.0: using default PCI settings
[ 7802.207288] ahci 0000:00:1f.2: no hotplug settings from platform
[ 7802.207290] ahci 0000:00:1f.2: using default PCI settings
[ 7802.207296] pci 0000:00:1f.3: no hotplug settings from platform
[ 7802.207298] pci 0000:00:1f.3: using default PCI settings
[ 7802.207304] pci 0000:00:1f.6: no hotplug settings from platform
[ 7802.207306] pci 0000:00:1f.6: using default PCI settings
[ 7802.208284] pci_bus 0000:01: Allocating resources
[ 7802.208299] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[ 7802.208307] pci 0000:00:00.0: no hotplug settings from platform
[ 7802.208309] pci 0000:00:00.0: using default PCI settings
[ 7802.208314] i915 0000:00:02.0: no hotplug settings from platform
[ 7802.208316] i915 0000:00:02.0: using default PCI settings
[ 7802.208321] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[ 7802.208324] pci 0000:00:04.0: no hotplug settings from platform
[ 7802.208326] pci 0000:00:04.0: using default PCI settings
[ 7802.208331] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[ 7802.208333] xhci_hcd 0000:00:14.0: using default PCI settings
[ 7802.208339] mei_me 0000:00:16.0: no hotplug settings from platform
[ 7802.208341] mei_me 0000:00:16.0: using default PCI settings
[ 7802.208348] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[ 7802.208351] pcieport 0000:00:1c.0: no hotplug settings from platform
[ 7802.208359] iwlwifi 0000:01:00.0: no hotplug settings from platform
[ 7802.208362] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[ 7802.208364] ehci-pci 0000:00:1d.0: using default PCI settings
[ 7802.208371] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[ 7802.208373] lpc_ich 0000:00:1f.0: using default PCI settings
[ 7802.208382] ahci 0000:00:1f.2: no hotplug settings from platform
[ 7802.208383] ahci 0000:00:1f.2: using default PCI settings
[ 7802.208390] pci 0000:00:1f.3: no hotplug settings from platform
[ 7802.208391] pci 0000:00:1f.3: using default PCI settings
[ 7802.208398] pci 0000:00:1f.6: no hotplug settings from platform
[ 7802.208400] pci 0000:00:1f.6: using default PCI settings
[ 7802.206123] Restarting tasks ... done.
[ 7802.210203] video LNXVIDEO:00: Restoring backlight state
[ 7802.220518] Bluetooth: hci0: read Intel version: 370710018002030d00
[ 7802.220524] Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
[ 7802.316618] Bluetooth: hci0: Intel Bluetooth firmware patch completed and activated
[ 7802.657674] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[ 7805.869520] wlp1s0: authenticate with 6e:ad:f8:22:f5:bd
[ 7805.870271] wlp1s0: send auth to 6e:ad:f8:22:f5:bd (try 1/3)
[ 7805.872569] wlp1s0: authenticated
[ 7805.873595] wlp1s0: associate with 6e:ad:f8:22:f5:bd (try 1/3)
[ 7805.878368] wlp1s0: RX AssocResp from 6e:ad:f8:22:f5:bd (capab=0x431 status=0 aid=1)
[ 7805.879025] wlp1s0: associated
[11362.351020] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[11362.376599] PM: Syncing filesystems ... done.
[11362.572713] PM: Preparing system for mem sleep
[11362.572938] Freezing user space processes ... (elapsed 0.001 seconds) done.
[11362.574313] Freezing remaining freezable tasks ... (elapsed 0.000 seconds) done.
[11362.575193] PM: Entering mem sleep
[11362.575242] Suspending console(s) (use no_console_suspend to debug)
[11362.575501] wlp1s0: deauthenticating from 6e:ad:f8:22:f5:bd by local choice (reason=3)
[11362.602864] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[11362.603396] cfg80211: Calling CRDA to update world regulatory domain
[11362.604267] sd 1:0:0:0: [sda] Stopping disk
[11362.660342] mei_me 0000:00:16.0: suspend
[11363.682770] PM: suspend of devices complete after 1106.424 msecs
[11363.682947] PM: late suspend of devices complete after 0.174 msecs
[11363.696328] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[11363.722825] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[11363.736471] PM: noirq suspend of devices complete after 53.479 msecs
[11363.736762] ACPI: Preparing to enter system sleep state S3
[11363.737055] PM: Saving platform NVS memory
[11363.737638] Disabling non-boot CPUs ...
[11363.839518] smpboot: CPU 1 is now offline
[11363.942934] smpboot: CPU 2 is now offline
[11364.046349] smpboot: CPU 3 is now offline
[11364.049485] ACPI: Low-level resume complete
[11364.049630] PM: Restoring platform NVS memory
[11364.050521] Enabling non-boot CPUs ...
[11364.050591] smpboot: Booting Node 0 Processor 1 APIC 0x1
[11364.066007] Intel pstate controlling: cpu 1
[11364.066080] CPU1 is up
[11364.066108] smpboot: Booting Node 0 Processor 2 APIC 0x2
[11364.080954] Intel pstate controlling: cpu 2
[11364.081010] CPU2 is up
[11364.081032] smpboot: Booting Node 0 Processor 3 APIC 0x3
[11364.095663] Intel pstate controlling: cpu 3
[11364.095710] CPU3 is up
[11364.101265] ACPI: Waking up from system sleep state S3
[11364.143698] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[11364.183730] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[11364.210503] PM: noirq resume of devices complete after 104.358 msecs
[11364.210627] PM: early resume of devices complete after 0.107 msecs
[11364.210648] i915 0000:00:02.0: setting latency timer to 64
[11364.210659] xhci_hcd 0000:00:14.0: setting latency timer to 64
[11364.210680] mei_me 0000:00:16.0: irq 60 for MSI/MSI-X
[11364.210742] ahci 0000:00:1f.2: setting latency timer to 64
[11364.210859] snd_hda_intel 0000:00:1b.0: irq 61 for MSI/MSI-X
[11364.210892] ehci-pci 0000:00:1d.0: setting latency timer to 64
[11364.211057] snd_hda_intel 0000:00:03.0: irq 62 for MSI/MSI-X
[11364.530630] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[11364.624247] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
[11364.638188] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401840
[11364.638189] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401880
[11364.638190] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374018c0
[11364.638191] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0f80
[11364.638192] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0fc0
[11364.638831] btusb 1-4:1.0: no reset_resume for driver btusb?
[11364.638832] btusb 1-4:1.1: no reset_resume for driver btusb?
[11364.718664] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[11364.719027] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[11364.719066] dpm_run_callback(): pnp_bus_resume+0x0/0xa0 returns -19
[11364.719067] PM: Device 00:06 failed to resume: error -19
[11364.724443] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[11364.724608] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[11364.724663] ata2.00: configured for UDMA/133
[11364.724693] sd 1:0:0:0: [sda] Starting disk
[11364.797711] usb 1-7: reset full-speed USB device number 13 using xhci_hcd
[11364.811445] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173800
[11364.811446] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173840
[11364.811451] usb 1-7: ep 0x2 - rounding interval to 64 microframes, ep desc says 80 microframes
[11364.971125] usb 1-8: reset high-speed USB device number 4 using xhci_hcd
[11364.990195] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374a4f00
[11365.144636] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[11365.159683] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef040
[11365.159684] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef000
[11365.159703] usb 1-6: ep 0x81 - rounding interval to 128 microframes, ep desc says 160 microframes
[11365.159704] usb 1-6: ep 0x1 - rounding interval to 128 microframes, ep desc says 160 microframes
[11365.177635] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[11365.177774] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[11365.189851] PM: resume of devices complete after 978.431 msecs
[11365.190193] PM: Finishing wakeup.
[11365.190538] iwlwifi 0000:01:00.0: no hotplug settings from platform
[11365.190194] Restarting tasks ... done.
[11365.191308] video LNXVIDEO:00: Restoring backlight state
[11365.192848] pci_bus 0000:01: Allocating resources
[11365.192865] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[11365.192875] pci 0000:00:00.0: no hotplug settings from platform
[11365.192877] pci 0000:00:00.0: using default PCI settings
[11365.192883] i915 0000:00:02.0: no hotplug settings from platform
[11365.192885] i915 0000:00:02.0: using default PCI settings
[11365.192891] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[11365.192894] pci 0000:00:04.0: no hotplug settings from platform
[11365.192896] pci 0000:00:04.0: using default PCI settings
[11365.192902] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[11365.192904] xhci_hcd 0000:00:14.0: using default PCI settings
[11365.192910] mei_me 0000:00:16.0: no hotplug settings from platform
[11365.192912] mei_me 0000:00:16.0: using default PCI settings
[11365.192919] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[11365.192923] pcieport 0000:00:1c.0: no hotplug settings from platform
[11365.192932] iwlwifi 0000:01:00.0: no hotplug settings from platform
[11365.192936] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[11365.192938] ehci-pci 0000:00:1d.0: using default PCI settings
[11365.192946] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[11365.192947] lpc_ich 0000:00:1f.0: using default PCI settings
[11365.192957] ahci 0000:00:1f.2: no hotplug settings from platform
[11365.192958] ahci 0000:00:1f.2: using default PCI settings
[11365.192965] pci 0000:00:1f.3: no hotplug settings from platform
[11365.192966] pci 0000:00:1f.3: using default PCI settings
[11365.192973] pci 0000:00:1f.6: no hotplug settings from platform
[11365.192975] pci 0000:00:1f.6: using default PCI settings
[11365.194011] pci_bus 0000:01: Allocating resources
[11365.194026] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[11365.194036] pci 0000:00:00.0: no hotplug settings from platform
[11365.194037] pci 0000:00:00.0: using default PCI settings
[11365.194042] i915 0000:00:02.0: no hotplug settings from platform
[11365.194044] i915 0000:00:02.0: using default PCI settings
[11365.194050] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[11365.194053] pci 0000:00:04.0: no hotplug settings from platform
[11365.194055] pci 0000:00:04.0: using default PCI settings
[11365.194060] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[11365.194061] xhci_hcd 0000:00:14.0: using default PCI settings
[11365.194068] mei_me 0000:00:16.0: no hotplug settings from platform
[11365.194070] mei_me 0000:00:16.0: using default PCI settings
[11365.194077] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[11365.194080] pcieport 0000:00:1c.0: no hotplug settings from platform
[11365.194088] iwlwifi 0000:01:00.0: no hotplug settings from platform
[11365.194092] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[11365.194093] ehci-pci 0000:00:1d.0: using default PCI settings
[11365.194101] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[11365.194103] lpc_ich 0000:00:1f.0: using default PCI settings
[11365.194112] ahci 0000:00:1f.2: no hotplug settings from platform
[11365.194113] ahci 0000:00:1f.2: using default PCI settings
[11365.194120] pci 0000:00:1f.3: no hotplug settings from platform
[11365.194121] pci 0000:00:1f.3: using default PCI settings
[11365.194127] pci 0000:00:1f.6: no hotplug settings from platform
[11365.194129] pci 0000:00:1f.6: using default PCI settings
[11365.210445] Bluetooth: hci0: read Intel version: 370710018002030d00
[11365.210475] Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
[11365.310573] Bluetooth: hci0: Intel Bluetooth firmware patch completed and activated
[11365.558119] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[11368.950564] wlp1s0: authenticate with dc:9f:db:3a:f7:72
[11368.951308] wlp1s0: direct probe to dc:9f:db:3a:f7:72 (try 1/3)
[11369.155028] wlp1s0: direct probe to dc:9f:db:3a:f7:72 (try 2/3)
[11369.358524] wlp1s0: direct probe to dc:9f:db:3a:f7:72 (try 3/3)
[11369.561376] wlp1s0: authentication with dc:9f:db:3a:f7:72 timed out
[11382.730500] wlp1s0: authenticate with dc:9f:db:3a:f7:72
[11382.731457] wlp1s0: send auth to dc:9f:db:3a:f7:72 (try 1/3)
[11382.734074] wlp1s0: authenticated
[11382.735379] wlp1s0: associate with dc:9f:db:3a:f7:72 (try 1/3)
[11382.742900] wlp1s0: RX AssocResp from dc:9f:db:3a:f7:72 (capab=0x421 status=0 aid=7)
[11382.744462] wlp1s0: associated
[11416.630106] cfg80211: Calling CRDA to update world regulatory domain
[11420.390095] wlp1s0: authenticate with dc:9f:db:3a:f7:72
[11420.390806] wlp1s0: send auth to dc:9f:db:3a:f7:72 (try 1/3)
[11420.392499] wlp1s0: authenticated
[11420.395700] wlp1s0: associate with dc:9f:db:3a:f7:72 (try 1/3)
[11420.454652] wlp1s0: RX AssocResp from dc:9f:db:3a:f7:72 (capab=0x421 status=0 aid=7)
[11420.457887] wlp1s0: associated
[11425.051211] cfg80211: Calling CRDA to update world regulatory domain
[11428.811324] wlp1s0: authenticate with dc:9f:db:3a:f7:72
[11428.812150] wlp1s0: send auth to dc:9f:db:3a:f7:72 (try 1/3)
[11428.813848] wlp1s0: authenticated
[11428.815858] wlp1s0: associate with dc:9f:db:3a:f7:72 (try 1/3)
[11428.820086] wlp1s0: RX AssocResp from dc:9f:db:3a:f7:72 (capab=0x421 status=0 aid=7)
[11428.829956] wlp1s0: associated
[11574.656808] cfg80211: Calling CRDA to update world regulatory domain
[11578.416803] wlp1s0: authenticate with 6e:ad:f8:22:f5:bd
[11578.417729] wlp1s0: send auth to 6e:ad:f8:22:f5:bd (try 1/3)
[11578.422633] wlp1s0: authenticated
[11578.423327] wlp1s0: associate with 6e:ad:f8:22:f5:bd (try 1/3)
[11578.428160] wlp1s0: RX AssocResp from 6e:ad:f8:22:f5:bd (capab=0x431 status=0 aid=1)
[11578.428846] wlp1s0: associated
[11663.314241] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[11663.315934] PM: Syncing filesystems ... done.
[11663.504940] PM: Preparing system for mem sleep
[11663.505198] Freezing user space processes ... (elapsed 0.001 seconds) done.
[11663.506617] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[11663.507726] PM: Entering mem sleep
[11663.507771] Suspending console(s) (use no_console_suspend to debug)
[11663.508008] wlp1s0: deauthenticating from 6e:ad:f8:22:f5:bd by local choice (reason=3)
[11663.542991] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[11663.543255] cfg80211: Calling CRDA to update world regulatory domain
[11663.544429] sd 1:0:0:0: [sda] Stopping disk
[11663.600180] mei_me 0000:00:16.0: suspend
[11664.629610] PM: suspend of devices complete after 1120.717 msecs
[11664.629779] PM: late suspend of devices complete after 0.167 msecs
[11664.643159] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[11664.669653] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[11664.683302] PM: noirq suspend of devices complete after 53.477 msecs
[11664.683593] ACPI: Preparing to enter system sleep state S3
[11664.683888] PM: Saving platform NVS memory
[11664.684490] Disabling non-boot CPUs ...
[11664.786346] smpboot: CPU 1 is now offline
[11664.889764] smpboot: CPU 2 is now offline
[11664.891161] smpboot: CPU 3 is now offline
[11664.894323] ACPI: Low-level resume complete
[11664.894466] PM: Restoring platform NVS memory
[11664.895360] Enabling non-boot CPUs ...
[11664.895427] smpboot: Booting Node 0 Processor 1 APIC 0x1
[11664.910848] Intel pstate controlling: cpu 1
[11664.910923] CPU1 is up
[11664.910952] smpboot: Booting Node 0 Processor 2 APIC 0x2
[11664.925845] Intel pstate controlling: cpu 2
[11664.925902] CPU2 is up
[11664.925922] smpboot: Booting Node 0 Processor 3 APIC 0x3
[11664.940549] Intel pstate controlling: cpu 3
[11664.940596] CPU3 is up
[11664.946196] ACPI: Waking up from system sleep state S3
[11664.987148] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[11665.027155] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[11665.053949] PM: noirq resume of devices complete after 103.974 msecs
[11665.054072] PM: early resume of devices complete after 0.107 msecs
[11665.054089] i915 0000:00:02.0: setting latency timer to 64
[11665.054101] xhci_hcd 0000:00:14.0: setting latency timer to 64
[11665.054124] mei_me 0000:00:16.0: irq 60 for MSI/MSI-X
[11665.054183] snd_hda_intel 0000:00:03.0: irq 61 for MSI/MSI-X
[11665.054255] snd_hda_intel 0000:00:1b.0: irq 62 for MSI/MSI-X
[11665.054300] ahci 0000:00:1f.2: setting latency timer to 64
[11665.054371] ehci-pci 0000:00:1d.0: setting latency timer to 64
[11665.061818] dpm_run_callback(): pnp_bus_resume+0x0/0xa0 returns -19
[11665.061820] PM: Device 00:06 failed to resume: error -19
[11665.387411] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[11665.388170] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[11665.388511] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[11665.393898] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[11665.394104] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[11665.394185] ata2.00: configured for UDMA/133
[11665.394237] sd 1:0:0:0: [sda] Starting disk
[11665.467632] usb 1-7: reset full-speed USB device number 13 using xhci_hcd
[11665.481437] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173800
[11665.481438] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173840
[11665.481444] usb 1-7: ep 0x2 - rounding interval to 64 microframes, ep desc says 80 microframes
[11665.641164] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
[11665.655074] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401840
[11665.655075] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401880
[11665.655076] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374018c0
[11665.655077] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0f80
[11665.655077] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0fc0
[11665.655691] btusb 1-4:1.0: no reset_resume for driver btusb?
[11665.655692] btusb 1-4:1.1: no reset_resume for driver btusb?
[11665.814557] usb 1-8: reset high-speed USB device number 4 using xhci_hcd
[11665.833605] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374a4f00
[11665.988086] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[11666.002822] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef040
[11666.002823] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef000
[11666.002827] usb 1-6: ep 0x81 - rounding interval to 128 microframes, ep desc says 160 microframes
[11666.002828] usb 1-6: ep 0x1 - rounding interval to 128 microframes, ep desc says 160 microframes
[11666.020419] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[11666.020559] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[11666.032376] PM: resume of devices complete after 977.512 msecs
[11666.032770] PM: Finishing wakeup.
[11666.032792] iwlwifi 0000:01:00.0: no hotplug settings from platform
[11666.033775] pci_bus 0000:01: Allocating resources
[11666.033792] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[11666.033802] pci 0000:00:00.0: no hotplug settings from platform
[11666.033804] pci 0000:00:00.0: using default PCI settings
[11666.033809] i915 0000:00:02.0: no hotplug settings from platform
[11666.033811] i915 0000:00:02.0: using default PCI settings
[11666.033817] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[11666.033820] pci 0000:00:04.0: no hotplug settings from platform
[11666.033822] pci 0000:00:04.0: using default PCI settings
[11666.033827] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[11666.033828] xhci_hcd 0000:00:14.0: using default PCI settings
[11666.033836] mei_me 0000:00:16.0: no hotplug settings from platform
[11666.033837] mei_me 0000:00:16.0: using default PCI settings
[11666.033844] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[11666.033847] pcieport 0000:00:1c.0: no hotplug settings from platform
[11666.033856] iwlwifi 0000:01:00.0: no hotplug settings from platform
[11666.033860] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[11666.033862] ehci-pci 0000:00:1d.0: using default PCI settings
[11666.033870] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[11666.033871] lpc_ich 0000:00:1f.0: using default PCI settings
[11666.033881] ahci 0000:00:1f.2: no hotplug settings from platform
[11666.033882] ahci 0000:00:1f.2: using default PCI settings
[11666.033889] pci 0000:00:1f.3: no hotplug settings from platform
[11666.033890] pci 0000:00:1f.3: using default PCI settings
[11666.033897] pci 0000:00:1f.6: no hotplug settings from platform
[11666.033898] pci 0000:00:1f.6: using default PCI settings
[11666.034947] pci_bus 0000:01: Allocating resources
[11666.034962] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[11666.034971] pci 0000:00:00.0: no hotplug settings from platform
[11666.034973] pci 0000:00:00.0: using default PCI settings
[11666.034978] i915 0000:00:02.0: no hotplug settings from platform
[11666.034980] i915 0000:00:02.0: using default PCI settings
[11666.034986] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[11666.034989] pci 0000:00:04.0: no hotplug settings from platform
[11666.034991] pci 0000:00:04.0: using default PCI settings
[11666.034996] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[11666.034998] xhci_hcd 0000:00:14.0: using default PCI settings
[11666.035004] mei_me 0000:00:16.0: no hotplug settings from platform
[11666.035006] mei_me 0000:00:16.0: using default PCI settings
[11666.035012] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[11666.035015] pcieport 0000:00:1c.0: no hotplug settings from platform
[11666.035023] iwlwifi 0000:01:00.0: no hotplug settings from platform
[11666.035025] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[11666.035027] ehci-pci 0000:00:1d.0: using default PCI settings
[11666.035035] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[11666.035040] lpc_ich 0000:00:1f.0: using default PCI settings
[11666.035052] ahci 0000:00:1f.2: no hotplug settings from platform
[11666.035057] ahci 0000:00:1f.2: using default PCI settings
[11666.035066] pci 0000:00:1f.3: no hotplug settings from platform
[11666.035071] pci 0000:00:1f.3: using default PCI settings
[11666.035081] pci 0000:00:1f.6: no hotplug settings from platform
[11666.035086] pci 0000:00:1f.6: using default PCI settings
[11666.032771] Restarting tasks ... done.
[11666.041273] video LNXVIDEO:00: Restoring backlight state
[11666.047142] Bluetooth: hci0: read Intel version: 370710018002030d00
[11666.047147] Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
[11666.186988] Bluetooth: hci0: Intel Bluetooth firmware patch completed and activated
[11666.785209] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[11669.795133] wlp1s0: authenticate with 6e:ad:f8:22:f5:bd
[11669.796234] wlp1s0: send auth to 6e:ad:f8:22:f5:bd (try 1/3)
[11669.805295] wlp1s0: authenticated
[11669.807684] wlp1s0: associate with 6e:ad:f8:22:f5:bd (try 1/3)
[11669.812038] wlp1s0: RX AssocResp from 6e:ad:f8:22:f5:bd (capab=0x411 status=0 aid=1)
[11669.813466] wlp1s0: associated
[11682.087756] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[12215.227635] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[12215.229432] PM: Syncing filesystems ... done.
[12215.399418] PM: Preparing system for mem sleep
[12215.399627] Freezing user space processes ... (elapsed 0.001 seconds) done.
[12215.401027] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[12215.402158] PM: Entering mem sleep
[12215.402217] Suspending console(s) (use no_console_suspend to debug)
[12215.402474] wlp1s0: deauthenticating from 6e:ad:f8:22:f5:bd by local choice (reason=3)
[12215.432261] cfg80211: Calling CRDA to update world regulatory domain
[12215.432312] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[12215.433674] sd 1:0:0:0: [sda] Stopping disk
[12215.488959] mei_me 0000:00:16.0: suspend
[12216.605814] PM: suspend of devices complete after 1202.390 msecs
[12216.605981] PM: late suspend of devices complete after 0.165 msecs
[12216.619367] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[12216.645857] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[12216.659470] PM: noirq suspend of devices complete after 53.443 msecs
[12216.659761] ACPI: Preparing to enter system sleep state S3
[12216.660057] PM: Saving platform NVS memory
[12216.660675] Disabling non-boot CPUs ...
[12216.762549] smpboot: CPU 1 is now offline
[12216.865975] smpboot: CPU 2 is now offline
[12216.867351] smpboot: CPU 3 is now offline
[12216.870502] ACPI: Low-level resume complete
[12216.870647] PM: Restoring platform NVS memory
[12216.871534] Enabling non-boot CPUs ...
[12216.871599] smpboot: Booting Node 0 Processor 1 APIC 0x1
[12216.886762] Intel pstate controlling: cpu 1
[12216.886841] CPU1 is up
[12216.886871] smpboot: Booting Node 0 Processor 2 APIC 0x2
[12216.901733] Intel pstate controlling: cpu 2
[12216.901787] CPU2 is up
[12216.901809] smpboot: Booting Node 0 Processor 3 APIC 0x3
[12216.916425] Intel pstate controlling: cpu 3
[12216.916471] CPU3 is up
[12216.922028] ACPI: Waking up from system sleep state S3
[12216.966698] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[12217.006723] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[12217.033498] PM: noirq resume of devices complete after 106.348 msecs
[12217.033616] PM: early resume of devices complete after 0.102 msecs
[12217.033637] i915 0000:00:02.0: setting latency timer to 64
[12217.033646] xhci_hcd 0000:00:14.0: setting latency timer to 64
[12217.033719] mei_me 0000:00:16.0: irq 60 for MSI/MSI-X
[12217.033775] snd_hda_intel 0000:00:03.0: irq 61 for MSI/MSI-X
[12217.033776] ahci 0000:00:1f.2: setting latency timer to 64
[12217.033879] snd_hda_intel 0000:00:1b.0: irq 62 for MSI/MSI-X
[12217.033999] ehci-pci 0000:00:1d.0: setting latency timer to 64
[12217.045380] dpm_run_callback(): pnp_bus_resume+0x0/0xa0 returns -19
[12217.045382] PM: Device 00:06 failed to resume: error -19
[12217.366954] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[12217.367714] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[12217.368055] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[12217.373633] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[12217.373970] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[12217.374057] ata2.00: configured for UDMA/133
[12217.374107] sd 1:0:0:0: [sda] Starting disk
[12217.447210] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[12217.461952] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef040
[12217.461953] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef000
[12217.461960] usb 1-6: ep 0x81 - rounding interval to 128 microframes, ep desc says 160 microframes
[12217.461962] usb 1-6: ep 0x1 - rounding interval to 128 microframes, ep desc says 160 microframes
[12217.620591] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
[12217.634455] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401840
[12217.634456] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401880
[12217.634457] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374018c0
[12217.634458] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0f80
[12217.634459] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0fc0
[12217.634926] btusb 1-4:1.0: no reset_resume for driver btusb?
[12217.634927] btusb 1-4:1.1: no reset_resume for driver btusb?
[12217.794169] usb 1-8: reset high-speed USB device number 4 using xhci_hcd
[12217.813235] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374a4f00
[12217.816777] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[12217.816917] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[12217.967593] usb 1-7: reset full-speed USB device number 13 using xhci_hcd
[12217.981368] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173800
[12217.981369] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173840
[12217.981374] usb 1-7: ep 0x2 - rounding interval to 64 microframes, ep desc says 80 microframes
[12217.986545] PM: resume of devices complete after 952.157 msecs
[12217.987196] PM: Finishing wakeup.
[12217.987591] iwlwifi 0000:01:00.0: no hotplug settings from platform
[12217.992577] pci_bus 0000:01: Allocating resources
[12217.992595] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[12217.992605] pci 0000:00:00.0: no hotplug settings from platform
[12217.992607] pci 0000:00:00.0: using default PCI settings
[12217.992613] i915 0000:00:02.0: no hotplug settings from platform
[12217.992615] i915 0000:00:02.0: using default PCI settings
[12217.992621] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[12217.992624] pci 0000:00:04.0: no hotplug settings from platform
[12217.992626] pci 0000:00:04.0: using default PCI settings
[12217.992631] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[12217.992633] xhci_hcd 0000:00:14.0: using default PCI settings
[12217.992640] mei_me 0000:00:16.0: no hotplug settings from platform
[12217.992642] mei_me 0000:00:16.0: using default PCI settings
[12217.992649] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[12217.992653] pcieport 0000:00:1c.0: no hotplug settings from platform
[12217.992661] iwlwifi 0000:01:00.0: no hotplug settings from platform
[12217.992665] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[12217.992667] ehci-pci 0000:00:1d.0: using default PCI settings
[12217.992675] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[12217.992677] lpc_ich 0000:00:1f.0: using default PCI settings
[12217.992686] ahci 0000:00:1f.2: no hotplug settings from platform
[12217.992688] ahci 0000:00:1f.2: using default PCI settings
[12217.992694] pci 0000:00:1f.3: no hotplug settings from platform
[12217.992696] pci 0000:00:1f.3: using default PCI settings
[12217.992703] pci 0000:00:1f.6: no hotplug settings from platform
[12217.992704] pci 0000:00:1f.6: using default PCI settings
[12217.993710] pci_bus 0000:01: Allocating resources
[12217.993723] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[12217.993730] pci 0000:00:00.0: no hotplug settings from platform
[12217.993732] pci 0000:00:00.0: using default PCI settings
[12217.993738] i915 0000:00:02.0: no hotplug settings from platform
[12217.993739] i915 0000:00:02.0: using default PCI settings
[12217.993745] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[12217.993749] pci 0000:00:04.0: no hotplug settings from platform
[12217.993751] pci 0000:00:04.0: using default PCI settings
[12217.993756] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[12217.993757] xhci_hcd 0000:00:14.0: using default PCI settings
[12217.993764] mei_me 0000:00:16.0: no hotplug settings from platform
[12217.993766] mei_me 0000:00:16.0: using default PCI settings
[12217.993773] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[12217.993776] pcieport 0000:00:1c.0: no hotplug settings from platform
[12217.993785] iwlwifi 0000:01:00.0: no hotplug settings from platform
[12217.993788] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[12217.993790] ehci-pci 0000:00:1d.0: using default PCI settings
[12217.993797] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[12217.993799] lpc_ich 0000:00:1f.0: using default PCI settings
[12217.993808] ahci 0000:00:1f.2: no hotplug settings from platform
[12217.993810] ahci 0000:00:1f.2: using default PCI settings
[12217.993816] pci 0000:00:1f.3: no hotplug settings from platform
[12217.993818] pci 0000:00:1f.3: using default PCI settings
[12217.993824] pci 0000:00:1f.6: no hotplug settings from platform
[12217.993826] pci 0000:00:1f.6: using default PCI settings
[12217.987197] Restarting tasks ... done.
[12217.993852] video LNXVIDEO:00: Restoring backlight state
[12217.999338] Bluetooth: hci0: read Intel version: 370710018002030d00
[12217.999368] Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
[12218.149498] Bluetooth: hci0: Intel Bluetooth firmware patch completed and activated
[12218.244341] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[12221.698828] wlp1s0: authenticate with 6e:ad:f8:22:f5:bd
[12221.699564] wlp1s0: send auth to 6e:ad:f8:22:f5:bd (try 1/3)
[12221.701399] wlp1s0: authenticated
[12221.703848] wlp1s0: associate with 6e:ad:f8:22:f5:bd (try 1/3)
[12221.708300] wlp1s0: RX AssocResp from 6e:ad:f8:22:f5:bd (capab=0x411 status=0 aid=1)
[12221.709971] wlp1s0: associated
[12246.711308] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[12247.998520] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[12248.002594] PM: Syncing filesystems ... done.
[12248.423161] PM: Preparing system for mem sleep
[12248.423419] Freezing user space processes ... (elapsed 0.001 seconds) done.
[12248.424813] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[12248.425926] PM: Entering mem sleep
[12248.425970] Suspending console(s) (use no_console_suspend to debug)
[12248.426206] wlp1s0: deauthenticating from 6e:ad:f8:22:f5:bd by local choice (reason=3)
[12248.463065] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[12248.463388] cfg80211: Calling CRDA to update world regulatory domain
[12248.464387] sd 1:0:0:0: [sda] Stopping disk
[12248.520821] mei_me 0000:00:16.0: suspend
[12249.629703] PM: suspend of devices complete after 1202.547 msecs
[12249.629871] PM: late suspend of devices complete after 0.166 msecs
[12249.643255] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[12249.669746] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[12249.683353] PM: noirq suspend of devices complete after 53.438 msecs
[12249.683645] ACPI: Preparing to enter system sleep state S3
[12249.683939] PM: Saving platform NVS memory
[12249.684550] Disabling non-boot CPUs ...
[12249.729737] [drm:hsw_unclaimed_reg_clear] *ERROR* Unknown unclaimed register before writing to c7204
[12249.729740] [drm:hsw_unclaimed_reg_check] *ERROR* Unclaimed write to c7204
[12249.786436] smpboot: CPU 1 is now offline
[12249.889856] smpboot: CPU 2 is now offline
[12249.993271] smpboot: CPU 3 is now offline
[12249.996405] ACPI: Low-level resume complete
[12249.996548] PM: Restoring platform NVS memory
[12249.997425] Enabling non-boot CPUs ...
[12249.997494] smpboot: Booting Node 0 Processor 1 APIC 0x1
[12250.012946] Intel pstate controlling: cpu 1
[12250.013025] CPU1 is up
[12250.013055] smpboot: Booting Node 0 Processor 2 APIC 0x2
[12250.027934] Intel pstate controlling: cpu 2
[12250.027991] CPU2 is up
[12250.028012] smpboot: Booting Node 0 Processor 3 APIC 0x3
[12250.042636] Intel pstate controlling: cpu 3
[12250.042682] CPU3 is up
[12250.048245] ACPI: Waking up from system sleep state S3
[12250.090617] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[12250.130644] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[12250.157415] PM: noirq resume of devices complete after 105.421 msecs
[12250.157534] PM: early resume of devices complete after 0.102 msecs
[12250.157554] i915 0000:00:02.0: setting latency timer to 64
[12250.157655] snd_hda_intel 0000:00:03.0: irq 60 for MSI/MSI-X
[12250.160186] xhci_hcd 0000:00:14.0: setting latency timer to 64
[12250.160253] mei_me 0000:00:16.0: irq 61 for MSI/MSI-X
[12250.160605] ahci 0000:00:1f.2: setting latency timer to 64
[12250.160669] snd_hda_intel 0000:00:1b.0: irq 62 for MSI/MSI-X
[12250.160723] ehci-pci 0000:00:1d.0: setting latency timer to 64
[12250.166395] dpm_run_callback(): pnp_bus_resume+0x0/0xa0 returns -19
[12250.166396] PM: Device 00:06 failed to resume: error -19
[12250.494210] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[12250.494978] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[12250.495294] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[12250.500778] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[12250.501117] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[12250.501204] ata2.00: configured for UDMA/133
[12250.501246] sd 1:0:0:0: [sda] Starting disk
[12250.574458] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[12250.589419] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef040
[12250.589420] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef000
[12250.589441] usb 1-6: ep 0x81 - rounding interval to 128 microframes, ep desc says 160 microframes
[12250.589442] usb 1-6: ep 0x1 - rounding interval to 128 microframes, ep desc says 160 microframes
[12250.747850] usb 1-7: reset full-speed USB device number 13 using xhci_hcd
[12250.761607] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173800
[12250.761608] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173840
[12250.761615] usb 1-7: ep 0x2 - rounding interval to 64 microframes, ep desc says 80 microframes
[12250.921328] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
[12250.935098] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401840
[12250.935099] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401880
[12250.935101] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374018c0
[12250.935102] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0f80
[12250.935103] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0fc0
[12250.935547] btusb 1-4:1.0: no reset_resume for driver btusb?
[12250.935548] btusb 1-4:1.1: no reset_resume for driver btusb?
[12251.094888] usb 1-8: reset high-speed USB device number 4 using xhci_hcd
[12251.113951] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374a4f00
[12251.117559] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[12251.117698] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[12251.129216] PM: resume of devices complete after 970.894 msecs
[12251.129599] PM: Finishing wakeup.
[12251.129931] iwlwifi 0000:01:00.0: no hotplug settings from platform
[12251.129600] Restarting tasks ... done.
[12251.132139] video LNXVIDEO:00: Restoring backlight state
[12251.133866] pci_bus 0000:01: Allocating resources
[12251.133882] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[12251.133893] pci 0000:00:00.0: no hotplug settings from platform
[12251.133895] pci 0000:00:00.0: using default PCI settings
[12251.133901] i915 0000:00:02.0: no hotplug settings from platform
[12251.133903] i915 0000:00:02.0: using default PCI settings
[12251.133908] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[12251.133912] pci 0000:00:04.0: no hotplug settings from platform
[12251.133914] pci 0000:00:04.0: using default PCI settings
[12251.133919] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[12251.133921] xhci_hcd 0000:00:14.0: using default PCI settings
[12251.133928] mei_me 0000:00:16.0: no hotplug settings from platform
[12251.133930] mei_me 0000:00:16.0: using default PCI settings
[12251.133937] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[12251.133941] pcieport 0000:00:1c.0: no hotplug settings from platform
[12251.133949] iwlwifi 0000:01:00.0: no hotplug settings from platform
[12251.133953] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[12251.133955] ehci-pci 0000:00:1d.0: using default PCI settings
[12251.133963] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[12251.133965] lpc_ich 0000:00:1f.0: using default PCI settings
[12251.133974] ahci 0000:00:1f.2: no hotplug settings from platform
[12251.133976] ahci 0000:00:1f.2: using default PCI settings
[12251.133982] pci 0000:00:1f.3: no hotplug settings from platform
[12251.133984] pci 0000:00:1f.3: using default PCI settings
[12251.133991] pci 0000:00:1f.6: no hotplug settings from platform
[12251.133993] pci 0000:00:1f.6: using default PCI settings
[12251.135010] pci_bus 0000:01: Allocating resources
[12251.135023] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[12251.135030] pci 0000:00:00.0: no hotplug settings from platform
[12251.135031] pci 0000:00:00.0: using default PCI settings
[12251.135036] i915 0000:00:02.0: no hotplug settings from platform
[12251.135037] i915 0000:00:02.0: using default PCI settings
[12251.135043] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[12251.135046] pci 0000:00:04.0: no hotplug settings from platform
[12251.135047] pci 0000:00:04.0: using default PCI settings
[12251.135052] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[12251.135053] xhci_hcd 0000:00:14.0: using default PCI settings
[12251.135059] mei_me 0000:00:16.0: no hotplug settings from platform
[12251.135060] mei_me 0000:00:16.0: using default PCI settings
[12251.135067] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[12251.135070] pcieport 0000:00:1c.0: no hotplug settings from platform
[12251.135078] iwlwifi 0000:01:00.0: no hotplug settings from platform
[12251.135080] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[12251.135082] ehci-pci 0000:00:1d.0: using default PCI settings
[12251.135088] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[12251.135090] lpc_ich 0000:00:1f.0: using default PCI settings
[12251.135098] ahci 0000:00:1f.2: no hotplug settings from platform
[12251.135100] ahci 0000:00:1f.2: using default PCI settings
[12251.135106] pci 0000:00:1f.3: no hotplug settings from platform
[12251.135107] pci 0000:00:1f.3: using default PCI settings
[12251.135113] pci 0000:00:1f.6: no hotplug settings from platform
[12251.135115] pci 0000:00:1f.6: using default PCI settings
[12251.149145] Bluetooth: hci0: read Intel version: 370710018002030d00
[12251.149151] Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
[12251.241793] Bluetooth: hci0: Intel Bluetooth firmware patch completed and activated
[12251.254834] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[12252.661656] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[12254.204250] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[12254.860446] wlp1s0: authenticate with 6e:ad:f8:22:f5:bd
[12254.861168] wlp1s0: send auth to 6e:ad:f8:22:f5:bd (try 1/3)
[12254.866401] wlp1s0: authenticated
[12254.867764] wlp1s0: associate with 6e:ad:f8:22:f5:bd (try 1/3)
[12254.872054] wlp1s0: RX AssocResp from 6e:ad:f8:22:f5:bd (capab=0x411 status=0 aid=1)
[12254.872863] wlp1s0: associated
[12254.206606] PM: Syncing filesystems ... done.
[12255.366658] PM: Preparing system for mem sleep
[12255.366751] Freezing user space processes ... (elapsed 0.001 seconds) done.
[12255.368164] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[12255.369274] PM: Entering mem sleep
[12255.369318] Suspending console(s) (use no_console_suspend to debug)
[12255.369556] wlp1s0: deauthenticating from 6e:ad:f8:22:f5:bd by local choice (reason=3)
[12255.418914] cfg80211: Calling CRDA to update world regulatory domain
[12255.419065] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[12255.420366] sd 1:0:0:0: [sda] Stopping disk
[12255.476237] mei_me 0000:00:16.0: suspend
[12256.519111] PM: suspend of devices complete after 1148.651 msecs
[12256.519281] PM: late suspend of devices complete after 0.168 msecs
[12256.532662] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[12256.559154] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[12256.572768] PM: noirq suspend of devices complete after 53.442 msecs
[12256.573060] ACPI: Preparing to enter system sleep state S3
[12256.573354] PM: Saving platform NVS memory
[12256.573946] Disabling non-boot CPUs ...
[12256.675847] smpboot: CPU 1 is now offline
[12256.779264] smpboot: CPU 2 is now offline
[12256.882679] smpboot: CPU 3 is now offline
[12256.885812] ACPI: Low-level resume complete
[12256.885958] PM: Restoring platform NVS memory
[12256.886830] Enabling non-boot CPUs ...
[12256.886896] smpboot: Booting Node 0 Processor 1 APIC 0x1
[12256.902353] Intel pstate controlling: cpu 1
[12256.902430] CPU1 is up
[12256.902459] smpboot: Booting Node 0 Processor 2 APIC 0x2
[12256.917311] Intel pstate controlling: cpu 2
[12256.917367] CPU2 is up
[12256.917389] smpboot: Booting Node 0 Processor 3 APIC 0x3
[12256.932019] Intel pstate controlling: cpu 3
[12256.932065] CPU3 is up
[12256.937611] ACPI: Waking up from system sleep state S3
[12256.980019] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[12257.020050] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[12257.046824] PM: noirq resume of devices complete after 104.621 msecs
[12257.046943] PM: early resume of devices complete after 0.102 msecs
[12257.046962] i915 0000:00:02.0: setting latency timer to 64
[12257.046972] xhci_hcd 0000:00:14.0: setting latency timer to 64
[12257.047042] mei_me 0000:00:16.0: irq 60 for MSI/MSI-X
[12257.047061] snd_hda_intel 0000:00:03.0: irq 61 for MSI/MSI-X
[12257.049119] snd_hda_intel 0000:00:1b.0: irq 62 for MSI/MSI-X
[12257.049666] ehci-pci 0000:00:1d.0: setting latency timer to 64
[12257.049681] ahci 0000:00:1f.2: setting latency timer to 64
[12257.057744] dpm_run_callback(): pnp_bus_resume+0x0/0xa0 returns -19
[12257.057745] PM: Device 00:06 failed to resume: error -19
[12257.380279] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[12257.381019] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[12257.381358] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[12257.386591] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[12257.386744] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[12257.386796] ata2.00: configured for UDMA/133
[12257.386850] sd 1:0:0:0: [sda] Starting disk
[12257.463896] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[12257.478485] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef040
[12257.478486] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef000
[12257.478494] usb 1-6: ep 0x81 - rounding interval to 128 microframes, ep desc says 160 microframes
[12257.478495] usb 1-6: ep 0x1 - rounding interval to 128 microframes, ep desc says 160 microframes
[12257.637254] usb 1-7: reset full-speed USB device number 13 using xhci_hcd
[12257.651018] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173800
[12257.651020] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173840
[12257.651029] usb 1-7: ep 0x2 - rounding interval to 64 microframes, ep desc says 80 microframes
[12257.810732] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
[12257.824503] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401840
[12257.824504] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401880
[12257.824506] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374018c0
[12257.824507] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0f80
[12257.824508] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0fc0
[12257.824910] btusb 1-4:1.0: no reset_resume for driver btusb?
[12257.824911] btusb 1-4:1.1: no reset_resume for driver btusb?
[12257.984272] usb 1-8: reset high-speed USB device number 4 using xhci_hcd
[12258.003348] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374a4f00
[12258.006960] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[12258.007099] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[12258.019058] PM: resume of devices complete after 971.328 msecs
[12258.019430] PM: Finishing wakeup.
[12258.019452] iwlwifi 0000:01:00.0: no hotplug settings from platform
[12258.020218] pci_bus 0000:01: Allocating resources
[12258.020234] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[12258.020243] pci 0000:00:00.0: no hotplug settings from platform
[12258.020245] pci 0000:00:00.0: using default PCI settings
[12258.020250] i915 0000:00:02.0: no hotplug settings from platform
[12258.020251] i915 0000:00:02.0: using default PCI settings
[12258.020257] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[12258.020260] pci 0000:00:04.0: no hotplug settings from platform
[12258.020262] pci 0000:00:04.0: using default PCI settings
[12258.020267] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[12258.020269] xhci_hcd 0000:00:14.0: using default PCI settings
[12258.020275] mei_me 0000:00:16.0: no hotplug settings from platform
[12258.020277] mei_me 0000:00:16.0: using default PCI settings
[12258.020284] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[12258.020288] pcieport 0000:00:1c.0: no hotplug settings from platform
[12258.020296] iwlwifi 0000:01:00.0: no hotplug settings from platform
[12258.020299] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[12258.020301] ehci-pci 0000:00:1d.0: using default PCI settings
[12258.020308] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[12258.020310] lpc_ich 0000:00:1f.0: using default PCI settings
[12258.020319] ahci 0000:00:1f.2: no hotplug settings from platform
[12258.020321] ahci 0000:00:1f.2: using default PCI settings
[12258.020327] pci 0000:00:1f.3: no hotplug settings from platform
[12258.020329] pci 0000:00:1f.3: using default PCI settings
[12258.020335] pci 0000:00:1f.6: no hotplug settings from platform
[12258.020337] pci 0000:00:1f.6: using default PCI settings
[12258.019431] Restarting tasks ... done.
[12258.024580] video LNXVIDEO:00: Restoring backlight state
[12258.025919] pci_bus 0000:01: Allocating resources
[12258.025935] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[12258.025946] pci 0000:00:00.0: no hotplug settings from platform
[12258.025948] pci 0000:00:00.0: using default PCI settings
[12258.025954] i915 0000:00:02.0: no hotplug settings from platform
[12258.025956] i915 0000:00:02.0: using default PCI settings
[12258.025962] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[12258.025965] pci 0000:00:04.0: no hotplug settings from platform
[12258.025967] pci 0000:00:04.0: using default PCI settings
[12258.025972] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[12258.025974] xhci_hcd 0000:00:14.0: using default PCI settings
[12258.025981] mei_me 0000:00:16.0: no hotplug settings from platform
[12258.025982] mei_me 0000:00:16.0: using default PCI settings
[12258.025989] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[12258.025993] pcieport 0000:00:1c.0: no hotplug settings from platform
[12258.026002] iwlwifi 0000:01:00.0: no hotplug settings from platform
[12258.026005] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[12258.026007] ehci-pci 0000:00:1d.0: using default PCI settings
[12258.026015] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[12258.026016] lpc_ich 0000:00:1f.0: using default PCI settings
[12258.026025] ahci 0000:00:1f.2: no hotplug settings from platform
[12258.026027] ahci 0000:00:1f.2: using default PCI settings
[12258.026033] pci 0000:00:1f.3: no hotplug settings from platform
[12258.026034] pci 0000:00:1f.3: using default PCI settings
[12258.026040] pci 0000:00:1f.6: no hotplug settings from platform
[12258.026042] pci 0000:00:1f.6: using default PCI settings
[12258.032040] Bluetooth: hci0: read Intel version: 370710018002030d00
[12258.032046] Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
[12258.128115] Bluetooth: hci0: Intel Bluetooth firmware patch completed and activated
[12258.264360] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[12259.516096] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[12261.764633] wlp1s0: authenticate with 6e:ad:f8:22:f5:bd
[12261.765270] wlp1s0: send auth to 6e:ad:f8:22:f5:bd (try 1/3)
[12261.771484] wlp1s0: authenticated
[12261.773833] wlp1s0: associate with 6e:ad:f8:22:f5:bd (try 1/3)
[12261.778178] wlp1s0: RX AssocResp from 6e:ad:f8:22:f5:bd (capab=0x411 status=0 aid=1)
[12261.779576] wlp1s0: associated
[12265.542157] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[12265.544571] PM: Syncing filesystems ... done.
[12266.661989] PM: Preparing system for mem sleep
[12266.662081] Freezing user space processes ... (elapsed 0.001 seconds) done.
[12266.663499] Freezing remaining freezable tasks ... (elapsed 0.000 seconds) done.
[12266.664452] PM: Entering mem sleep
[12266.664496] Suspending console(s) (use no_console_suspend to debug)
[12266.664733] wlp1s0: deauthenticating from 6e:ad:f8:22:f5:bd by local choice (reason=3)
[12266.692191] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[12266.692437] cfg80211: Calling CRDA to update world regulatory domain
[12266.693485] sd 1:0:0:0: [sda] Stopping disk
[12266.749313] mei_me 0000:00:16.0: suspend
[12267.865448] PM: suspend of devices complete after 1199.765 msecs
[12267.865616] PM: late suspend of devices complete after 0.165 msecs
[12267.878993] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[12267.905491] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[12267.919098] PM: noirq suspend of devices complete after 53.438 msecs
[12267.919390] ACPI: Preparing to enter system sleep state S3
[12267.919685] PM: Saving platform NVS memory
[12267.920293] Disabling non-boot CPUs ...
[12268.022191] smpboot: CPU 1 is now offline
[12268.125602] smpboot: CPU 2 is now offline
[12268.229017] smpboot: CPU 3 is now offline
[12268.232141] ACPI: Low-level resume complete
[12268.232286] PM: Restoring platform NVS memory
[12268.233155] Enabling non-boot CPUs ...
[12268.233222] smpboot: Booting Node 0 Processor 1 APIC 0x1
[12268.248682] Intel pstate controlling: cpu 1
[12268.248761] CPU1 is up
[12268.248791] smpboot: Booting Node 0 Processor 2 APIC 0x2
[12268.263648] Intel pstate controlling: cpu 2
[12268.263704] CPU2 is up
[12268.263726] smpboot: Booting Node 0 Processor 3 APIC 0x3
[12268.278355] Intel pstate controlling: cpu 3
[12268.278404] CPU3 is up
[12268.283991] ACPI: Waking up from system sleep state S3
[12268.326357] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[12268.366385] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[12268.393160] PM: noirq resume of devices complete after 105.901 msecs
[12268.393283] PM: early resume of devices complete after 0.106 msecs
[12268.393302] i915 0000:00:02.0: setting latency timer to 64
[12268.393391] snd_hda_intel 0000:00:03.0: irq 60 for MSI/MSI-X
[12268.396005] xhci_hcd 0000:00:14.0: setting latency timer to 64
[12268.396108] mei_me 0000:00:16.0: irq 61 for MSI/MSI-X
[12268.396331] ahci 0000:00:1f.2: setting latency timer to 64
[12268.396455] snd_hda_intel 0000:00:1b.0: irq 62 for MSI/MSI-X
[12268.396480] ehci-pci 0000:00:1d.0: setting latency timer to 64
[12268.404809] dpm_run_callback(): pnp_bus_resume+0x0/0xa0 returns -19
[12268.404810] PM: Device 00:06 failed to resume: error -19
[12268.716606] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[12268.717547] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[12268.717886] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[12268.723261] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[12268.723726] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[12268.723805] ata2.00: configured for UDMA/133
[12268.723856] sd 1:0:0:0: [sda] Starting disk
[12268.810214] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[12268.824829] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef040
[12268.824831] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef000
[12268.824838] usb 1-6: ep 0x81 - rounding interval to 128 microframes, ep desc says 160 microframes
[12268.824839] usb 1-6: ep 0x1 - rounding interval to 128 microframes, ep desc says 160 microframes
[12268.983771] usb 1-7: reset full-speed USB device number 13 using xhci_hcd
[12268.997420] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173800
[12268.997422] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173840
[12268.997426] usb 1-7: ep 0x2 - rounding interval to 64 microframes, ep desc says 80 microframes
[12269.157067] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
[12269.170842] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401840
[12269.170843] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401880
[12269.170844] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374018c0
[12269.170846] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0f80
[12269.170847] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0fc0
[12269.171262] btusb 1-4:1.0: no reset_resume for driver btusb?
[12269.171263] btusb 1-4:1.1: no reset_resume for driver btusb?
[12269.330650] usb 1-8: reset high-speed USB device number 4 using xhci_hcd
[12269.349707] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374a4f00
[12269.353328] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[12269.353468] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[12269.365352] PM: resume of devices complete after 971.282 msecs
[12269.365704] PM: Finishing wakeup.
[12269.365729] iwlwifi 0000:01:00.0: no hotplug settings from platform
[12269.366788] pci_bus 0000:01: Allocating resources
[12269.366805] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[12269.366815] pci 0000:00:00.0: no hotplug settings from platform
[12269.366817] pci 0000:00:00.0: using default PCI settings
[12269.366823] i915 0000:00:02.0: no hotplug settings from platform
[12269.366824] i915 0000:00:02.0: using default PCI settings
[12269.366830] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[12269.366833] pci 0000:00:04.0: no hotplug settings from platform
[12269.366834] pci 0000:00:04.0: using default PCI settings
[12269.366839] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[12269.366840] xhci_hcd 0000:00:14.0: using default PCI settings
[12269.366847] mei_me 0000:00:16.0: no hotplug settings from platform
[12269.366848] mei_me 0000:00:16.0: using default PCI settings
[12269.366855] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[12269.366858] pcieport 0000:00:1c.0: no hotplug settings from platform
[12269.366866] iwlwifi 0000:01:00.0: no hotplug settings from platform
[12269.366870] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[12269.366871] ehci-pci 0000:00:1d.0: using default PCI settings
[12269.366879] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[12269.366880] lpc_ich 0000:00:1f.0: using default PCI settings
[12269.366889] ahci 0000:00:1f.2: no hotplug settings from platform
[12269.366890] ahci 0000:00:1f.2: using default PCI settings
[12269.366896] pci 0000:00:1f.3: no hotplug settings from platform
[12269.366898] pci 0000:00:1f.3: using default PCI settings
[12269.366904] pci 0000:00:1f.6: no hotplug settings from platform
[12269.366906] pci 0000:00:1f.6: using default PCI settings
[12269.367916] pci_bus 0000:01: Allocating resources
[12269.367930] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[12269.367938] pci 0000:00:00.0: no hotplug settings from platform
[12269.367940] pci 0000:00:00.0: using default PCI settings
[12269.367945] i915 0000:00:02.0: no hotplug settings from platform
[12269.367946] i915 0000:00:02.0: using default PCI settings
[12269.367952] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[12269.367955] pci 0000:00:04.0: no hotplug settings from platform
[12269.367956] pci 0000:00:04.0: using default PCI settings
[12269.367961] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[12269.367963] xhci_hcd 0000:00:14.0: using default PCI settings
[12269.367969] mei_me 0000:00:16.0: no hotplug settings from platform
[12269.367971] mei_me 0000:00:16.0: using default PCI settings
[12269.367978] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[12269.367982] pcieport 0000:00:1c.0: no hotplug settings from platform
[12269.367990] iwlwifi 0000:01:00.0: no hotplug settings from platform
[12269.367993] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[12269.367995] ehci-pci 0000:00:1d.0: using default PCI settings
[12269.368003] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[12269.368005] lpc_ich 0000:00:1f.0: using default PCI settings
[12269.368014] ahci 0000:00:1f.2: no hotplug settings from platform
[12269.368016] ahci 0000:00:1f.2: using default PCI settings
[12269.368022] pci 0000:00:1f.3: no hotplug settings from platform
[12269.368024] pci 0000:00:1f.3: using default PCI settings
[12269.368031] pci 0000:00:1f.6: no hotplug settings from platform
[12269.368032] pci 0000:00:1f.6: using default PCI settings
[12269.365705] Restarting tasks ... done.
[12269.370750] video LNXVIDEO:00: Restoring backlight state
[12269.382211] Bluetooth: hci0: read Intel version: 370710018002030d00
[12269.382216] Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
[12269.478507] Bluetooth: hci0: Intel Bluetooth firmware patch completed and activated
[12270.297891] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[12273.113333] wlp1s0: authenticate with 6e:ad:f8:22:f5:bd
[12273.114041] wlp1s0: send auth to 6e:ad:f8:22:f5:bd (try 1/3)
[12273.118932] wlp1s0: authenticated
[12273.120200] wlp1s0: associate with 6e:ad:f8:22:f5:bd (try 1/3)
[12273.125260] wlp1s0: RX AssocResp from 6e:ad:f8:22:f5:bd (capab=0x411 status=0 aid=1)
[12273.126300] wlp1s0: associated
[12310.336898] mce: [Hardware Error]: Machine check events logged
[12330.824675] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[12352.046965] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[12352.048646] PM: Syncing filesystems ... done.
[12352.274547] PM: Preparing system for mem sleep
[12352.274733] Freezing user space processes ... (elapsed 0.001 seconds) done.
[12352.276131] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[12352.277244] PM: Entering mem sleep
[12352.277283] Suspending console(s) (use no_console_suspend to debug)
[12352.277534] wlp1s0: deauthenticating from 6e:ad:f8:22:f5:bd by local choice (reason=3)
[12352.318304] cfg80211: Calling CRDA to update world regulatory domain
[12352.318372] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[12352.319675] sd 1:0:0:0: [sda] Stopping disk
[12352.375561] mei_me 0000:00:16.0: suspend
[12353.471746] PM: suspend of devices complete after 1193.269 msecs
[12353.471903] PM: late suspend of devices complete after 0.155 msecs
[12353.485283] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[12353.511781] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[12353.525518] PM: noirq suspend of devices complete after 53.570 msecs
[12353.525810] ACPI: Preparing to enter system sleep state S3
[12353.526105] PM: Saving platform NVS memory
[12353.526717] Disabling non-boot CPUs ...
[12353.628483] smpboot: CPU 1 is now offline
[12353.731891] smpboot: CPU 2 is now offline
[12353.835306] smpboot: CPU 3 is now offline
[12353.838461] ACPI: Low-level resume complete
[12353.838609] PM: Restoring platform NVS memory
[12353.839507] Enabling non-boot CPUs ...
[12353.839578] smpboot: Booting Node 0 Processor 1 APIC 0x1
[12353.855111] Intel pstate controlling: cpu 1
[12353.855187] CPU1 is up
[12353.855216] smpboot: Booting Node 0 Processor 2 APIC 0x2
[12353.870068] Intel pstate controlling: cpu 2
[12353.870125] CPU2 is up
[12353.870147] smpboot: Booting Node 0 Processor 3 APIC 0x3
[12353.884764] Intel pstate controlling: cpu 3
[12353.884810] CPU3 is up
[12353.890390] ACPI: Waking up from system sleep state S3
[12353.932648] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[12353.972682] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[12353.999457] PM: noirq resume of devices complete after 104.426 msecs
[12353.999580] PM: early resume of devices complete after 0.107 msecs
[12353.999599] i915 0000:00:02.0: setting latency timer to 64
[12353.999687] snd_hda_intel 0000:00:03.0: irq 60 for MSI/MSI-X
[12354.002245] xhci_hcd 0000:00:14.0: setting latency timer to 64
[12354.002307] mei_me 0000:00:16.0: irq 61 for MSI/MSI-X
[12354.002670] ahci 0000:00:1f.2: setting latency timer to 64
[12354.002745] snd_hda_intel 0000:00:1b.0: irq 62 for MSI/MSI-X
[12354.002876] ehci-pci 0000:00:1d.0: setting latency timer to 64
[12354.010917] dpm_run_callback(): pnp_bus_resume+0x0/0xa0 returns -19
[12354.010919] PM: Device 00:06 failed to resume: error -19
[12354.336247] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[12354.336955] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[12354.337296] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[12354.343080] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[12354.343377] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[12354.343456] ata2.00: configured for UDMA/133
[12354.343507] sd 1:0:0:0: [sda] Starting disk
[12354.416680] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
[12354.430381] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401840
[12354.430382] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401880
[12354.430383] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374018c0
[12354.430384] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0f80
[12354.430385] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0fc0
[12354.430875] btusb 1-4:1.0: no reset_resume for driver btusb?
[12354.430876] btusb 1-4:1.1: no reset_resume for driver btusb?
[12354.589885] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[12354.604614] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef040
[12354.604615] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef000
[12354.604619] usb 1-6: ep 0x81 - rounding interval to 128 microframes, ep desc says 160 microframes
[12354.604627] usb 1-6: ep 0x1 - rounding interval to 128 microframes, ep desc says 160 microframes
[12354.763352] usb 1-8: reset high-speed USB device number 4 using xhci_hcd
[12354.782404] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374a4f00
[12354.785259] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[12354.785399] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[12354.936831] usb 1-7: reset full-speed USB device number 13 using xhci_hcd
[12354.950568] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173800
[12354.950569] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173840
[12354.950574] usb 1-7: ep 0x2 - rounding interval to 64 microframes, ep desc says 80 microframes
[12354.955593] PM: resume of devices complete after 955.239 msecs
[12354.956074] PM: Finishing wakeup.
[12354.956428] iwlwifi 0000:01:00.0: no hotplug settings from platform
[12354.956075] Restarting tasks ... done.
[12354.956739] video LNXVIDEO:00: Restoring backlight state
[12354.958668] pci_bus 0000:01: Allocating resources
[12354.958685] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[12354.958714] pci 0000:00:00.0: no hotplug settings from platform
[12354.958716] pci 0000:00:00.0: using default PCI settings
[12354.958722] i915 0000:00:02.0: no hotplug settings from platform
[12354.958723] i915 0000:00:02.0: using default PCI settings
[12354.958729] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[12354.958732] pci 0000:00:04.0: no hotplug settings from platform
[12354.958734] pci 0000:00:04.0: using default PCI settings
[12354.958739] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[12354.958741] xhci_hcd 0000:00:14.0: using default PCI settings
[12354.958747] mei_me 0000:00:16.0: no hotplug settings from platform
[12354.958749] mei_me 0000:00:16.0: using default PCI settings
[12354.958756] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[12354.958759] pcieport 0000:00:1c.0: no hotplug settings from platform
[12354.958768] iwlwifi 0000:01:00.0: no hotplug settings from platform
[12354.958772] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[12354.958774] ehci-pci 0000:00:1d.0: using default PCI settings
[12354.958781] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[12354.958783] lpc_ich 0000:00:1f.0: using default PCI settings
[12354.958793] ahci 0000:00:1f.2: no hotplug settings from platform
[12354.958795] ahci 0000:00:1f.2: using default PCI settings
[12354.958801] pci 0000:00:1f.3: no hotplug settings from platform
[12354.958803] pci 0000:00:1f.3: using default PCI settings
[12354.958810] pci 0000:00:1f.6: no hotplug settings from platform
[12354.958811] pci 0000:00:1f.6: using default PCI settings
[12354.959863] pci_bus 0000:01: Allocating resources
[12354.959877] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[12354.959886] pci 0000:00:00.0: no hotplug settings from platform
[12354.959887] pci 0000:00:00.0: using default PCI settings
[12354.959892] i915 0000:00:02.0: no hotplug settings from platform
[12354.959893] i915 0000:00:02.0: using default PCI settings
[12354.959898] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[12354.959901] pci 0000:00:04.0: no hotplug settings from platform
[12354.959903] pci 0000:00:04.0: using default PCI settings
[12354.959908] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[12354.959909] xhci_hcd 0000:00:14.0: using default PCI settings
[12354.959915] mei_me 0000:00:16.0: no hotplug settings from platform
[12354.959916] mei_me 0000:00:16.0: using default PCI settings
[12354.959922] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[12354.959925] pcieport 0000:00:1c.0: no hotplug settings from platform
[12354.959934] iwlwifi 0000:01:00.0: no hotplug settings from platform
[12354.959937] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[12354.959938] ehci-pci 0000:00:1d.0: using default PCI settings
[12354.959945] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[12354.959947] lpc_ich 0000:00:1f.0: using default PCI settings
[12354.959956] ahci 0000:00:1f.2: no hotplug settings from platform
[12354.959957] ahci 0000:00:1f.2: using default PCI settings
[12354.959963] pci 0000:00:1f.3: no hotplug settings from platform
[12354.959964] pci 0000:00:1f.3: using default PCI settings
[12354.959970] pci 0000:00:1f.6: no hotplug settings from platform
[12354.959972] pci 0000:00:1f.6: using default PCI settings
[12354.968870] Bluetooth: hci0: read Intel version: 370710018002030d00
[12354.968932] Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
[12355.109806] Bluetooth: hci0: Intel Bluetooth firmware patch completed and activated
[12355.370434] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[12460.461934] mce: [Hardware Error]: Machine check events logged
[13043.616553] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[13043.619865] PM: Syncing filesystems ... done.
[13043.781260] PM: Preparing system for mem sleep
[13043.781485] Freezing user space processes ... (elapsed 0.001 seconds) done.
[13043.782854] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[13043.783952] PM: Entering mem sleep
[13043.783991] Suspending console(s) (use no_console_suspend to debug)
[13043.813919] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[13043.815272] sd 1:0:0:0: [sda] Stopping disk
[13043.870836] mei_me 0000:00:16.0: suspend
[13043.983087] PM: suspend of devices complete after 198.729 msecs
[13043.983201] PM: late suspend of devices complete after 0.112 msecs
[13043.996624] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[13044.023129] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[13044.036772] PM: noirq suspend of devices complete after 53.526 msecs
[13044.037063] ACPI: Preparing to enter system sleep state S3
[13044.037358] PM: Saving platform NVS memory
[13044.037957] Disabling non-boot CPUs ...
[13044.039218] smpboot: CPU 1 is now offline
[13044.040957] smpboot: CPU 2 is now offline
[13044.143159] smpboot: CPU 3 is now offline
[13044.146319] ACPI: Low-level resume complete
[13044.146469] PM: Restoring platform NVS memory
[13044.147360] Enabling non-boot CPUs ...
[13044.147429] smpboot: Booting Node 0 Processor 1 APIC 0x1
[13044.162910] Intel pstate controlling: cpu 1
[13044.162990] CPU1 is up
[13044.163020] smpboot: Booting Node 0 Processor 2 APIC 0x2
[13044.177869] Intel pstate controlling: cpu 2
[13044.177925] CPU2 is up
[13044.177948] smpboot: Booting Node 0 Processor 3 APIC 0x3
[13044.192667] Intel pstate controlling: cpu 3
[13044.192713] CPU3 is up
[13044.198323] ACPI: Waking up from system sleep state S3
[13044.243841] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[13044.283856] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[13044.310638] PM: noirq resume of devices complete after 105.784 msecs
[13044.310757] PM: early resume of devices complete after 0.102 msecs
[13044.310775] i915 0000:00:02.0: setting latency timer to 64
[13044.310841] xhci_hcd 0000:00:14.0: setting latency timer to 64
[13044.310867] mei_me 0000:00:16.0: irq 60 for MSI/MSI-X
[13044.310876] snd_hda_intel 0000:00:03.0: irq 61 for MSI/MSI-X
[13044.310931] ahci 0000:00:1f.2: setting latency timer to 64
[13044.311022] snd_hda_intel 0000:00:1b.0: irq 62 for MSI/MSI-X
[13044.311112] ehci-pci 0000:00:1d.0: setting latency timer to 64
[13044.319432] dpm_run_callback(): pnp_bus_resume+0x0/0xa0 returns -19
[13044.319433] PM: Device 00:06 failed to resume: error -19
[13044.630754] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[13044.631741] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[13044.632080] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[13044.637752] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[13044.637972] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[13044.638024] ata2.00: configured for UDMA/133
[13044.638082] sd 1:0:0:0: [sda] Starting disk
[13044.724366] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
[13044.738345] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401840
[13044.738346] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401880
[13044.738347] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374018c0
[13044.738348] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0f80
[13044.738348] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0fc0
[13044.738980] btusb 1-4:1.0: no reset_resume for driver btusb?
[13044.738981] btusb 1-4:1.1: no reset_resume for driver btusb?
[13044.897726] usb 1-8: reset high-speed USB device number 4 using xhci_hcd
[13044.916792] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374a4f00
[13045.071237] usb 1-7: reset full-speed USB device number 13 using xhci_hcd
[13045.085063] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173800
[13045.085064] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173840
[13045.085069] usb 1-7: ep 0x2 - rounding interval to 64 microframes, ep desc says 80 microframes
[13045.244723] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[13045.259444] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef040
[13045.259445] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef000
[13045.259451] usb 1-6: ep 0x81 - rounding interval to 128 microframes, ep desc says 160 microframes
[13045.259452] usb 1-6: ep 0x1 - rounding interval to 128 microframes, ep desc says 160 microframes
[13045.277159] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[13045.277298] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[13045.288597] PM: resume of devices complete after 977.047 msecs
[13045.288951] PM: Finishing wakeup.
[13045.288974] iwlwifi 0000:01:00.0: no hotplug settings from platform
[13045.289970] pci_bus 0000:01: Allocating resources
[13045.289986] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[13045.289995] pci 0000:00:00.0: no hotplug settings from platform
[13045.289997] pci 0000:00:00.0: using default PCI settings
[13045.290003] i915 0000:00:02.0: no hotplug settings from platform
[13045.290004] i915 0000:00:02.0: using default PCI settings
[13045.290011] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[13045.290014] pci 0000:00:04.0: no hotplug settings from platform
[13045.290016] pci 0000:00:04.0: using default PCI settings
[13045.290021] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[13045.290023] xhci_hcd 0000:00:14.0: using default PCI settings
[13045.290030] mei_me 0000:00:16.0: no hotplug settings from platform
[13045.290032] mei_me 0000:00:16.0: using default PCI settings
[13045.290038] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[13045.290042] pcieport 0000:00:1c.0: no hotplug settings from platform
[13045.290051] iwlwifi 0000:01:00.0: no hotplug settings from platform
[13045.290054] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[13045.290056] ehci-pci 0000:00:1d.0: using default PCI settings
[13045.290064] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[13045.290066] lpc_ich 0000:00:1f.0: using default PCI settings
[13045.290075] ahci 0000:00:1f.2: no hotplug settings from platform
[13045.290077] ahci 0000:00:1f.2: using default PCI settings
[13045.290083] pci 0000:00:1f.3: no hotplug settings from platform
[13045.290085] pci 0000:00:1f.3: using default PCI settings
[13045.290091] pci 0000:00:1f.6: no hotplug settings from platform
[13045.290093] pci 0000:00:1f.6: using default PCI settings
[13045.291079] pci_bus 0000:01: Allocating resources
[13045.291093] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[13045.291101] pci 0000:00:00.0: no hotplug settings from platform
[13045.291103] pci 0000:00:00.0: using default PCI settings
[13045.291108] i915 0000:00:02.0: no hotplug settings from platform
[13045.291109] i915 0000:00:02.0: using default PCI settings
[13045.291115] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[13045.291118] pci 0000:00:04.0: no hotplug settings from platform
[13045.291119] pci 0000:00:04.0: using default PCI settings
[13045.291125] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[13045.291126] xhci_hcd 0000:00:14.0: using default PCI settings
[13045.291132] mei_me 0000:00:16.0: no hotplug settings from platform
[13045.291134] mei_me 0000:00:16.0: using default PCI settings
[13045.291141] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[13045.291144] pcieport 0000:00:1c.0: no hotplug settings from platform
[13045.291152] iwlwifi 0000:01:00.0: no hotplug settings from platform
[13045.291155] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[13045.291157] ehci-pci 0000:00:1d.0: using default PCI settings
[13045.291164] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[13045.291166] lpc_ich 0000:00:1f.0: using default PCI settings
[13045.291174] ahci 0000:00:1f.2: no hotplug settings from platform
[13045.291176] ahci 0000:00:1f.2: using default PCI settings
[13045.291182] pci 0000:00:1f.3: no hotplug settings from platform
[13045.291183] pci 0000:00:1f.3: using default PCI settings
[13045.291189] pci 0000:00:1f.6: no hotplug settings from platform
[13045.291191] pci 0000:00:1f.6: using default PCI settings
[13045.288952] Restarting tasks ... done.
[13045.291995] video LNXVIDEO:00: Restoring backlight state
[13045.302436] Bluetooth: hci0: read Intel version: 370710018002030d00
[13045.302442] Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
[13045.458682] Bluetooth: hci0: Intel Bluetooth firmware patch completed and activated
[13045.921805] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[13205.167071] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[13205.168756] PM: Syncing filesystems ... done.
[13205.339048] PM: Preparing system for mem sleep
[13205.339260] Freezing user space processes ... (elapsed 0.001 seconds) done.
[13205.340514] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[13205.341622] PM: Entering mem sleep
[13205.341667] Suspending console(s) (use no_console_suspend to debug)
[13205.361283] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[13205.362611] sd 1:0:0:0: [sda] Stopping disk
[13205.418844] mei_me 0000:00:16.0: suspend
[13206.448101] PM: suspend of devices complete after 1105.319 msecs
[13206.448267] PM: late suspend of devices complete after 0.164 msecs
[13206.461653] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[13206.488144] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[13206.501879] PM: noirq suspend of devices complete after 53.566 msecs
[13206.502170] ACPI: Preparing to enter system sleep state S3
[13206.502466] PM: Saving platform NVS memory
[13206.503082] Disabling non-boot CPUs ...
[13206.604837] smpboot: CPU 1 is now offline
[13206.708254] smpboot: CPU 2 is now offline
[13206.709641] smpboot: CPU 3 is now offline
[13206.712810] ACPI: Low-level resume complete
[13206.712951] PM: Restoring platform NVS memory
[13206.713821] Enabling non-boot CPUs ...
[13206.713890] smpboot: Booting Node 0 Processor 1 APIC 0x1
[13206.729266] Intel pstate controlling: cpu 1
[13206.729343] CPU1 is up
[13206.729371] smpboot: Booting Node 0 Processor 2 APIC 0x2
[13206.744232] Intel pstate controlling: cpu 2
[13206.744289] CPU2 is up
[13206.744311] smpboot: Booting Node 0 Processor 3 APIC 0x3
[13206.758941] Intel pstate controlling: cpu 3
[13206.758988] CPU3 is up
[13206.764516] ACPI: Waking up from system sleep state S3
[13206.808994] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[13206.849021] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[13206.875795] PM: noirq resume of devices complete after 106.443 msecs
[13206.875919] PM: early resume of devices complete after 0.107 msecs
[13206.875939] i915 0000:00:02.0: setting latency timer to 64
[13206.876027] snd_hda_intel 0000:00:03.0: irq 60 for MSI/MSI-X
[13206.878545] xhci_hcd 0000:00:14.0: setting latency timer to 64
[13206.878713] mei_me 0000:00:16.0: irq 61 for MSI/MSI-X
[13206.878982] ahci 0000:00:1f.2: setting latency timer to 64
[13206.879166] snd_hda_intel 0000:00:1b.0: irq 62 for MSI/MSI-X
[13206.879211] ehci-pci 0000:00:1d.0: setting latency timer to 64
[13206.887118] dpm_run_callback(): pnp_bus_resume+0x0/0xa0 returns -19
[13206.887119] PM: Device 00:06 failed to resume: error -19
[13207.199242] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[13207.200272] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[13207.200613] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[13207.206034] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[13207.206255] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[13207.206308] ata2.00: configured for UDMA/133
[13207.206360] sd 1:0:0:0: [sda] Starting disk
[13207.292926] usb 1-7: reset full-speed USB device number 13 using xhci_hcd
[13207.307004] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173800
[13207.307005] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173840
[13207.307030] usb 1-7: ep 0x2 - rounding interval to 64 microframes, ep desc says 80 microframes
[13207.466231] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
[13207.480056] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401840
[13207.480058] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401880
[13207.480059] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374018c0
[13207.480060] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0f80
[13207.480061] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0fc0
[13207.480435] btusb 1-4:1.0: no reset_resume for driver btusb?
[13207.480436] btusb 1-4:1.1: no reset_resume for driver btusb?
[13207.639692] usb 1-8: reset high-speed USB device number 4 using xhci_hcd
[13207.658739] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374a4f00
[13207.813286] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[13207.828012] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef040
[13207.828013] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef000
[13207.828017] usb 1-6: ep 0x81 - rounding interval to 128 microframes, ep desc says 160 microframes
[13207.828019] usb 1-6: ep 0x1 - rounding interval to 128 microframes, ep desc says 160 microframes
[13207.845309] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[13207.845449] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[13207.857484] PM: resume of devices complete after 980.770 msecs
[13207.857904] PM: Finishing wakeup.
[13207.857927] iwlwifi 0000:01:00.0: no hotplug settings from platform
[13207.858922] pci_bus 0000:01: Allocating resources
[13207.858939] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[13207.858949] pci 0000:00:00.0: no hotplug settings from platform
[13207.858950] pci 0000:00:00.0: using default PCI settings
[13207.858956] i915 0000:00:02.0: no hotplug settings from platform
[13207.858958] i915 0000:00:02.0: using default PCI settings
[13207.858964] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[13207.858967] pci 0000:00:04.0: no hotplug settings from platform
[13207.858968] pci 0000:00:04.0: using default PCI settings
[13207.858974] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[13207.858975] xhci_hcd 0000:00:14.0: using default PCI settings
[13207.858982] mei_me 0000:00:16.0: no hotplug settings from platform
[13207.858984] mei_me 0000:00:16.0: using default PCI settings
[13207.858991] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[13207.858994] pcieport 0000:00:1c.0: no hotplug settings from platform
[13207.859003] iwlwifi 0000:01:00.0: no hotplug settings from platform
[13207.859006] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[13207.859008] ehci-pci 0000:00:1d.0: using default PCI settings
[13207.859016] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[13207.859017] lpc_ich 0000:00:1f.0: using default PCI settings
[13207.859027] ahci 0000:00:1f.2: no hotplug settings from platform
[13207.859029] ahci 0000:00:1f.2: using default PCI settings
[13207.859035] pci 0000:00:1f.3: no hotplug settings from platform
[13207.859037] pci 0000:00:1f.3: using default PCI settings
[13207.859043] pci 0000:00:1f.6: no hotplug settings from platform
[13207.859045] pci 0000:00:1f.6: using default PCI settings
[13207.857905] Restarting tasks ... done.
[13207.859806] video LNXVIDEO:00: Restoring backlight state
[13207.860118] pci_bus 0000:01: Allocating resources
[13207.860133] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[13207.860142] pci 0000:00:00.0: no hotplug settings from platform
[13207.860144] pci 0000:00:00.0: using default PCI settings
[13207.860149] i915 0000:00:02.0: no hotplug settings from platform
[13207.860150] i915 0000:00:02.0: using default PCI settings
[13207.860156] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[13207.860159] pci 0000:00:04.0: no hotplug settings from platform
[13207.860160] pci 0000:00:04.0: using default PCI settings
[13207.860166] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[13207.860167] xhci_hcd 0000:00:14.0: using default PCI settings
[13207.860174] mei_me 0000:00:16.0: no hotplug settings from platform
[13207.860175] mei_me 0000:00:16.0: using default PCI settings
[13207.860182] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[13207.860186] pcieport 0000:00:1c.0: no hotplug settings from platform
[13207.860194] iwlwifi 0000:01:00.0: no hotplug settings from platform
[13207.860197] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[13207.860199] ehci-pci 0000:00:1d.0: using default PCI settings
[13207.860206] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[13207.860208] lpc_ich 0000:00:1f.0: using default PCI settings
[13207.860217] ahci 0000:00:1f.2: no hotplug settings from platform
[13207.860219] ahci 0000:00:1f.2: using default PCI settings
[13207.860225] pci 0000:00:1f.3: no hotplug settings from platform
[13207.860227] pci 0000:00:1f.3: using default PCI settings
[13207.860233] pci 0000:00:1f.6: no hotplug settings from platform
[13207.860235] pci 0000:00:1f.6: using default PCI settings
[13207.873037] Bluetooth: hci0: read Intel version: 370710018002030d00
[13207.873067] Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
[13207.965121] Bluetooth: hci0: Intel Bluetooth firmware patch completed and activated
[13208.066623] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[14835.787382] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[18477.985926] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[18477.987841] PM: Syncing filesystems ... done.
[18478.159739] PM: Preparing system for mem sleep
[18478.160057] Freezing user space processes ... (elapsed 0.001 seconds) done.
[18478.161439] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[18478.162533] PM: Entering mem sleep
[18478.162576] Suspending console(s) (use no_console_suspend to debug)
[18478.192575] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[18478.193978] sd 1:0:0:0: [sda] Stopping disk
[18478.249866] mei_me 0000:00:16.0: suspend
[18479.312507] PM: suspend of devices complete after 1148.753 msecs
[18479.312684] PM: late suspend of devices complete after 0.175 msecs
[18479.326122] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[18479.352567] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[18479.366172] PM: noirq suspend of devices complete after 53.443 msecs
[18479.366464] ACPI: Preparing to enter system sleep state S3
[18479.366761] PM: Saving platform NVS memory
[18479.367383] Disabling non-boot CPUs ...
[18479.469254] smpboot: CPU 1 is now offline
[18479.572678] smpboot: CPU 2 is now offline
[18479.574072] smpboot: CPU 3 is now offline
[18479.577223] ACPI: Low-level resume complete
[18479.577306] PM: Restoring platform NVS memory
[18479.578044] Enabling non-boot CPUs ...
[18479.578114] smpboot: Booting Node 0 Processor 1 APIC 0x1
[18479.593898] Intel pstate controlling: cpu 1
[18479.593977] CPU1 is up
[18479.594005] smpboot: Booting Node 0 Processor 2 APIC 0x2
[18479.608949] Intel pstate controlling: cpu 2
[18479.609006] CPU2 is up
[18479.609028] smpboot: Booting Node 0 Processor 3 APIC 0x3
[18479.623753] Intel pstate controlling: cpu 3
[18479.623803] CPU3 is up
[18479.629557] ACPI: Waking up from system sleep state S3
[18479.669802] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[18479.709837] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[18479.736659] PM: noirq resume of devices complete after 104.033 msecs
[18479.736783] PM: early resume of devices complete after 0.107 msecs
[18479.736802] i915 0000:00:02.0: setting latency timer to 64
[18479.736889] snd_hda_intel 0000:00:03.0: irq 60 for MSI/MSI-X
[18479.736927] xhci_hcd 0000:00:14.0: setting latency timer to 64
[18479.736949] mei_me 0000:00:16.0: irq 61 for MSI/MSI-X
[18479.737024] snd_hda_intel 0000:00:1b.0: irq 62 for MSI/MSI-X
[18479.737060] ahci 0000:00:1f.2: setting latency timer to 64
[18479.737162] ehci-pci 0000:00:1d.0: setting latency timer to 64
[18479.747309] dpm_run_callback(): pnp_bus_resume+0x0/0xa0 returns -19
[18479.747311] PM: Device 00:06 failed to resume: error -19
[18480.070138] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[18480.070862] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[18480.071204] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[18480.076567] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[18480.076721] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[18480.076775] ata2.00: configured for UDMA/133
[18480.076827] sd 1:0:0:0: [sda] Starting disk
[18480.150340] usb 1-8: reset high-speed USB device number 4 using xhci_hcd
[18480.169378] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374a4f00
[18480.323756] usb 1-7: reset full-speed USB device number 13 using xhci_hcd
[18480.337518] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173800
[18480.337520] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173840
[18480.337530] usb 1-7: ep 0x2 - rounding interval to 64 microframes, ep desc says 80 microframes
[18480.497230] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
[18480.511004] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401840
[18480.511006] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401880
[18480.511007] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374018c0
[18480.511008] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0f80
[18480.511010] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0fc0
[18480.511410] btusb 1-4:1.0: no reset_resume for driver btusb?
[18480.511412] btusb 1-4:1.1: no reset_resume for driver btusb?
[18480.670874] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[18480.685453] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef040
[18480.685454] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef000
[18480.685456] usb 1-6: ep 0x81 - rounding interval to 128 microframes, ep desc says 160 microframes
[18480.685459] usb 1-6: ep 0x1 - rounding interval to 128 microframes, ep desc says 160 microframes
[18480.702320] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[18480.702459] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[18480.714471] PM: resume of devices complete after 976.897 msecs
[18480.714825] PM: Finishing wakeup.
[18480.714847] iwlwifi 0000:01:00.0: no hotplug settings from platform
[18480.715841] pci_bus 0000:01: Allocating resources
[18480.715857] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[18480.715867] pci 0000:00:00.0: no hotplug settings from platform
[18480.715868] pci 0000:00:00.0: using default PCI settings
[18480.715874] i915 0000:00:02.0: no hotplug settings from platform
[18480.715875] i915 0000:00:02.0: using default PCI settings
[18480.715881] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[18480.715885] pci 0000:00:04.0: no hotplug settings from platform
[18480.715886] pci 0000:00:04.0: using default PCI settings
[18480.715892] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[18480.715893] xhci_hcd 0000:00:14.0: using default PCI settings
[18480.715900] mei_me 0000:00:16.0: no hotplug settings from platform
[18480.715902] mei_me 0000:00:16.0: using default PCI settings
[18480.715909] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[18480.715912] pcieport 0000:00:1c.0: no hotplug settings from platform
[18480.715921] iwlwifi 0000:01:00.0: no hotplug settings from platform
[18480.715925] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[18480.715926] ehci-pci 0000:00:1d.0: using default PCI settings
[18480.715934] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[18480.715936] lpc_ich 0000:00:1f.0: using default PCI settings
[18480.715945] ahci 0000:00:1f.2: no hotplug settings from platform
[18480.715947] ahci 0000:00:1f.2: using default PCI settings
[18480.715953] pci 0000:00:1f.3: no hotplug settings from platform
[18480.715955] pci 0000:00:1f.3: using default PCI settings
[18480.715971] pci 0000:00:1f.6: no hotplug settings from platform
[18480.715973] pci 0000:00:1f.6: using default PCI settings
[18480.717216] pci_bus 0000:01: Allocating resources
[18480.717231] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[18480.717240] pci 0000:00:00.0: no hotplug settings from platform
[18480.717241] pci 0000:00:00.0: using default PCI settings
[18480.717246] i915 0000:00:02.0: no hotplug settings from platform
[18480.717248] i915 0000:00:02.0: using default PCI settings
[18480.717253] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[18480.717256] pci 0000:00:04.0: no hotplug settings from platform
[18480.717258] pci 0000:00:04.0: using default PCI settings
[18480.717351] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[18480.717353] xhci_hcd 0000:00:14.0: using default PCI settings
[18480.717359] mei_me 0000:00:16.0: no hotplug settings from platform
[18480.717361] mei_me 0000:00:16.0: using default PCI settings
[18480.717367] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[18480.717370] pcieport 0000:00:1c.0: no hotplug settings from platform
[18480.717377] iwlwifi 0000:01:00.0: no hotplug settings from platform
[18480.717381] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[18480.717382] ehci-pci 0000:00:1d.0: using default PCI settings
[18480.717390] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[18480.717392] lpc_ich 0000:00:1f.0: using default PCI settings
[18480.717401] ahci 0000:00:1f.2: no hotplug settings from platform
[18480.717403] ahci 0000:00:1f.2: using default PCI settings
[18480.717409] pci 0000:00:1f.3: no hotplug settings from platform
[18480.717410] pci 0000:00:1f.3: using default PCI settings
[18480.717417] pci 0000:00:1f.6: no hotplug settings from platform
[18480.717418] pci 0000:00:1f.6: using default PCI settings
[18480.714826] Restarting tasks ... done.
[18480.718549] video LNXVIDEO:00: Restoring backlight state
[18480.727543] Bluetooth: hci0: read Intel version: 370710018002030d00
[18480.727547] Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
[18480.825640] Bluetooth: hci0: Intel Bluetooth firmware patch completed and activated
[18481.327810] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[18561.832501] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[18568.025688] PM: Syncing filesystems ... done.
[18568.143466] PM: Preparing system for mem sleep
[18568.143684] Freezing user space processes ... (elapsed 0.001 seconds) done.
[18568.145147] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[18568.146313] PM: Entering mem sleep
[18568.146362] Suspending console(s) (use no_console_suspend to debug)
[18568.165414] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[18568.167584] sd 1:0:0:0: [sda] Stopping disk
[18568.222134] mei_me 0000:00:16.0: suspend
[18569.292177] PM: suspend of devices complete after 1144.667 msecs
[18569.292352] PM: late suspend of devices complete after 0.174 msecs
[18569.305735] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[18569.332231] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[18569.346057] PM: noirq suspend of devices complete after 53.659 msecs
[18569.346348] ACPI: Preparing to enter system sleep state S3
[18569.346643] PM: Saving platform NVS memory
[18569.347262] Disabling non-boot CPUs ...
[18569.448940] smpboot: CPU 1 is now offline
[18569.552341] smpboot: CPU 2 is now offline
[18569.655755] smpboot: CPU 3 is now offline
[18569.658889] ACPI: Low-level resume complete
[18569.659032] PM: Restoring platform NVS memory
[18569.659927] Enabling non-boot CPUs ...
[18569.660000] smpboot: Booting Node 0 Processor 1 APIC 0x1
[18569.675328] Intel pstate controlling: cpu 1
[18569.675408] CPU1 is up
[18569.675437] smpboot: Booting Node 0 Processor 2 APIC 0x2
[18569.690294] Intel pstate controlling: cpu 2
[18569.690351] CPU2 is up
[18569.690372] smpboot: Booting Node 0 Processor 3 APIC 0x3
[18569.704994] Intel pstate controlling: cpu 3
[18569.705040] CPU3 is up
[18569.710612] ACPI: Waking up from system sleep state S3
[18569.753079] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[18569.793130] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[18569.819903] PM: noirq resume of devices complete after 104.925 msecs
[18569.820026] PM: early resume of devices complete after 0.106 msecs
[18569.820048] i915 0000:00:02.0: setting latency timer to 64
[18569.820054] xhci_hcd 0000:00:14.0: setting latency timer to 64
[18569.820126] mei_me 0000:00:16.0: irq 60 for MSI/MSI-X
[18569.820146] snd_hda_intel 0000:00:03.0: irq 61 for MSI/MSI-X
[18569.820192] ahci 0000:00:1f.2: setting latency timer to 64
[18569.820312] snd_hda_intel 0000:00:1b.0: irq 62 for MSI/MSI-X
[18569.820425] ehci-pci 0000:00:1d.0: setting latency timer to 64
[18569.827842] dpm_run_callback(): pnp_bus_resume+0x0/0xa0 returns -19
[18569.827843] PM: Device 00:06 failed to resume: error -19
[18570.140015] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[18570.141086] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[18570.141430] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[18570.146850] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[18570.147162] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[18570.147226] ata2.00: configured for UDMA/133
[18570.160135] sd 1:0:0:0: [sda] Starting disk
[18570.233704] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
[18570.247442] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401840
[18570.247443] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401880
[18570.247443] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374018c0
[18570.247444] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0f80
[18570.247445] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0fc0
[18570.247942] btusb 1-4:1.0: no reset_resume for driver btusb?
[18570.247943] btusb 1-4:1.1: no reset_resume for driver btusb?
[18570.407017] usb 1-7: reset full-speed USB device number 13 using xhci_hcd
[18570.420834] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173800
[18570.420835] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173840
[18570.420846] usb 1-7: ep 0x2 - rounding interval to 64 microframes, ep desc says 80 microframes
[18570.580514] usb 1-8: reset high-speed USB device number 4 using xhci_hcd
[18570.599513] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374a4f00
[18570.753964] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[18570.768741] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef040
[18570.768742] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef000
[18570.768748] usb 1-6: ep 0x81 - rounding interval to 128 microframes, ep desc says 160 microframes
[18570.768749] usb 1-6: ep 0x1 - rounding interval to 128 microframes, ep desc says 160 microframes
[18570.787557] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[18570.787697] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[18570.798472] PM: resume of devices complete after 977.653 msecs
[18570.798894] iwlwifi 0000:01:00.0: no hotplug settings from platform
[18570.799551] pci_bus 0000:01: Allocating resources
[18570.799563] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[18570.799568] pci 0000:00:00.0: no hotplug settings from platform
[18570.799569] pci 0000:00:00.0: using default PCI settings
[18570.799573] i915 0000:00:02.0: no hotplug settings from platform
[18570.799574] i915 0000:00:02.0: using default PCI settings
[18570.799578] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[18570.799580] pci 0000:00:04.0: no hotplug settings from platform
[18570.799581] pci 0000:00:04.0: using default PCI settings
[18570.799585] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[18570.799586] xhci_hcd 0000:00:14.0: using default PCI settings
[18570.799591] mei_me 0000:00:16.0: no hotplug settings from platform
[18570.799592] mei_me 0000:00:16.0: using default PCI settings
[18570.799598] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[18570.799600] pcieport 0000:00:1c.0: no hotplug settings from platform
[18570.799605] iwlwifi 0000:01:00.0: no hotplug settings from platform
[18570.799608] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[18570.799609] ehci-pci 0000:00:1d.0: using default PCI settings
[18570.799615] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[18570.799616] lpc_ich 0000:00:1f.0: using default PCI settings
[18570.799623] ahci 0000:00:1f.2: no hotplug settings from platform
[18570.799624] ahci 0000:00:1f.2: using default PCI settings
[18570.799629] pci 0000:00:1f.3: no hotplug settings from platform
[18570.799629] pci 0000:00:1f.3: using default PCI settings
[18570.799634] pci 0000:00:1f.6: no hotplug settings from platform
[18570.799635] pci 0000:00:1f.6: using default PCI settings
[18570.800266] pci_bus 0000:01: Allocating resources
[18570.800276] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[18570.800280] pci 0000:00:00.0: no hotplug settings from platform
[18570.800281] pci 0000:00:00.0: using default PCI settings
[18570.800284] i915 0000:00:02.0: no hotplug settings from platform
[18570.800285] i915 0000:00:02.0: using default PCI settings
[18570.800290] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[18570.800292] pci 0000:00:04.0: no hotplug settings from platform
[18570.800293] pci 0000:00:04.0: using default PCI settings
[18570.800296] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[18570.800297] xhci_hcd 0000:00:14.0: using default PCI settings
[18570.800302] mei_me 0000:00:16.0: no hotplug settings from platform
[18570.800303] mei_me 0000:00:16.0: using default PCI settings
[18570.800308] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[18570.800310] pcieport 0000:00:1c.0: no hotplug settings from platform
[18570.800316] iwlwifi 0000:01:00.0: no hotplug settings from platform
[18570.800318] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[18570.800319] ehci-pci 0000:00:1d.0: using default PCI settings
[18570.800325] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[18570.800326] lpc_ich 0000:00:1f.0: using default PCI settings
[18570.800333] ahci 0000:00:1f.2: no hotplug settings from platform
[18570.800334] ahci 0000:00:1f.2: using default PCI settings
[18570.800339] pci 0000:00:1f.3: no hotplug settings from platform
[18570.800340] pci 0000:00:1f.3: using default PCI settings
[18570.800345] pci 0000:00:1f.6: no hotplug settings from platform
[18570.800346] pci 0000:00:1f.6: using default PCI settings
[18570.800365] PM: Finishing wakeup.
[18570.800366] Restarting tasks ... done.
[18570.803111] video LNXVIDEO:00: Restoring backlight state
[18570.811812] Bluetooth: hci0: read Intel version: 370710018002030d00
[18570.811844] Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
[18570.913915] Bluetooth: hci0: Intel Bluetooth firmware patch completed and activated
[18571.414387] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[18579.362982] wlp1s0: authenticate with 6e:ad:f8:22:f5:bd
[18579.363896] wlp1s0: send auth to 6e:ad:f8:22:f5:bd (try 1/3)
[18579.372944] wlp1s0: authenticated
[18579.374154] wlp1s0: associate with 6e:ad:f8:22:f5:bd (try 1/3)
[18579.385747] wlp1s0: RX AssocResp from 6e:ad:f8:22:f5:bd (capab=0x431 status=0 aid=1)
[18579.388276] wlp1s0: associated

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-suspend-immediate-resume

[18838.174648] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root
[18838.177261] PM: Syncing filesystems ... done.
[18838.377233] PM: Preparing system for mem sleep
[18838.377483] Freezing user space processes ... (elapsed 0.001 seconds) done.
[18838.378873] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[18838.379915] PM: Entering mem sleep
[18838.379960] Suspending console(s) (use no_console_suspend to debug)
[18838.380199] wlp1s0: deauthenticating from 6e:ad:f8:22:f5:bd by local choice (reason=3)
[18838.414178] cfg80211: Calling CRDA to update world regulatory domain
[18838.414236] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[18838.415584] sd 1:0:0:0: [sda] Stopping disk
[18838.471781] mei_me 0000:00:16.0: suspend
[18839.580931] PM: suspend of devices complete after 1199.770 msecs
[18839.581088] PM: late suspend of devices complete after 0.154 msecs
[18839.594472] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[18839.620980] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[18839.634590] PM: noirq suspend of devices complete after 53.457 msecs
[18839.634881] ACPI: Preparing to enter system sleep state S3
[18839.635177] PM: Saving platform NVS memory
[18839.635786] Disabling non-boot CPUs ...
[18839.737661] smpboot: CPU 1 is now offline
[18839.841078] smpboot: CPU 2 is now offline
[18839.944493] smpboot: CPU 3 is now offline
[18839.947640] ACPI: Low-level resume complete
[18839.947785] PM: Restoring platform NVS memory
[18839.948681] Enabling non-boot CPUs ...
[18839.948752] smpboot: Booting Node 0 Processor 1 APIC 0x1
[18839.964210] Intel pstate controlling: cpu 1
[18839.964290] CPU1 is up
[18839.964320] smpboot: Booting Node 0 Processor 2 APIC 0x2
[18839.979175] Intel pstate controlling: cpu 2
[18839.979233] CPU2 is up
[18839.979256] smpboot: Booting Node 0 Processor 3 APIC 0x3
[18839.993887] Intel pstate controlling: cpu 3
[18839.993933] CPU3 is up
[18839.999479] ACPI: Waking up from system sleep state S3
[18840.041832] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[18840.081869] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[18840.108647] PM: noirq resume of devices complete after 104.653 msecs
[18840.108770] PM: early resume of devices complete after 0.107 msecs
[18840.108790] i915 0000:00:02.0: setting latency timer to 64
[18840.108877] snd_hda_intel 0000:00:03.0: irq 60 for MSI/MSI-X
[18840.111434] xhci_hcd 0000:00:14.0: setting latency timer to 64
[18840.111538] mei_me 0000:00:16.0: irq 61 for MSI/MSI-X
[18840.111855] ahci 0000:00:1f.2: setting latency timer to 64
[18840.111922] snd_hda_intel 0000:00:1b.0: irq 62 for MSI/MSI-X
[18840.111955] ehci-pci 0000:00:1d.0: setting latency timer to 64
[18840.119497] dpm_run_callback(): pnp_bus_resume+0x0/0xa0 returns -19
[18840.119498] PM: Device 00:06 failed to resume: error -19
[18840.445439] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[18840.446423] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[18840.446770] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[18840.452336] ata2.00: ACPI cmd ef/10:09:00:00:00:b0 (SET FEATURES) succeeded
[18840.452674] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[18840.452755] ata2.00: configured for UDMA/133
[18840.478843] sd 1:0:0:0: [sda] Starting disk
[18840.525678] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
[18840.539696] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401840
[18840.539697] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037401880
[18840.539698] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374018c0
[18840.539698] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0f80
[18840.539699] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374c0fc0
[18840.540343] btusb 1-4:1.0: no reset_resume for driver btusb?
[18840.540344] btusb 1-4:1.1: no reset_resume for driver btusb?
[18840.699071] usb 1-8: reset high-speed USB device number 4 using xhci_hcd
[18840.718129] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800374a4f00
[18840.872553] usb 1-6: reset full-speed USB device number 3 using xhci_hcd
[18840.887276] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef040
[18840.887277] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8802510ef000
[18840.887283] usb 1-6: ep 0x81 - rounding interval to 128 microframes, ep desc says 160 microframes
[18840.887285] usb 1-6: ep 0x1 - rounding interval to 128 microframes, ep desc says 160 microframes
[18840.904879] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[18840.905019] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[18841.046082] usb 1-7: reset full-speed USB device number 13 using xhci_hcd
[18841.059851] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173800
[18841.059853] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880234173840
[18841.059858] usb 1-7: ep 0x2 - rounding interval to 64 microframes, ep desc says 80 microframes
[18841.065026] PM: resume of devices complete after 955.482 msecs
[18841.065664] PM: Finishing wakeup.
[18841.065688] iwlwifi 0000:01:00.0: no hotplug settings from platform
[18841.066618] pci_bus 0000:01: Allocating resources
[18841.066635] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[18841.066645] pci 0000:00:00.0: no hotplug settings from platform
[18841.066647] pci 0000:00:00.0: using default PCI settings
[18841.066652] i915 0000:00:02.0: no hotplug settings from platform
[18841.066654] i915 0000:00:02.0: using default PCI settings
[18841.066659] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[18841.066662] pci 0000:00:04.0: no hotplug settings from platform
[18841.066664] pci 0000:00:04.0: using default PCI settings
[18841.066669] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[18841.066670] xhci_hcd 0000:00:14.0: using default PCI settings
[18841.066676] mei_me 0000:00:16.0: no hotplug settings from platform
[18841.066678] mei_me 0000:00:16.0: using default PCI settings
[18841.066685] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[18841.066688] pcieport 0000:00:1c.0: no hotplug settings from platform
[18841.066697] iwlwifi 0000:01:00.0: no hotplug settings from platform
[18841.066700] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[18841.066701] ehci-pci 0000:00:1d.0: using default PCI settings
[18841.066709] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[18841.066711] lpc_ich 0000:00:1f.0: using default PCI settings
[18841.066721] ahci 0000:00:1f.2: no hotplug settings from platform
[18841.066722] ahci 0000:00:1f.2: using default PCI settings
[18841.066729] pci 0000:00:1f.3: no hotplug settings from platform
[18841.066730] pci 0000:00:1f.3: using default PCI settings
[18841.066737] pci 0000:00:1f.6: no hotplug settings from platform
[18841.066738] pci 0000:00:1f.6: using default PCI settings
[18841.067792] pci_bus 0000:01: Allocating resources
[18841.067807] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[18841.067816] pci 0000:00:00.0: no hotplug settings from platform
[18841.067818] pci 0000:00:00.0: using default PCI settings
[18841.067823] i915 0000:00:02.0: no hotplug settings from platform
[18841.067825] i915 0000:00:02.0: using default PCI settings
[18841.067831] snd_hda_intel 0000:00:03.0: no hotplug settings from platform
[18841.067834] pci 0000:00:04.0: no hotplug settings from platform
[18841.067835] pci 0000:00:04.0: using default PCI settings
[18841.067840] xhci_hcd 0000:00:14.0: no hotplug settings from platform
[18841.067842] xhci_hcd 0000:00:14.0: using default PCI settings
[18841.067849] mei_me 0000:00:16.0: no hotplug settings from platform
[18841.067850] mei_me 0000:00:16.0: using default PCI settings
[18841.067857] snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
[18841.067861] pcieport 0000:00:1c.0: no hotplug settings from platform
[18841.067869] iwlwifi 0000:01:00.0: no hotplug settings from platform
[18841.067873] ehci-pci 0000:00:1d.0: no hotplug settings from platform
[18841.067875] ehci-pci 0000:00:1d.0: using default PCI settings
[18841.067883] lpc_ich 0000:00:1f.0: no hotplug settings from platform
[18841.067885] lpc_ich 0000:00:1f.0: using default PCI settings
[18841.067894] ahci 0000:00:1f.2: no hotplug settings from platform
[18841.067895] ahci 0000:00:1f.2: using default PCI settings
[18841.067902] pci 0000:00:1f.3: no hotplug settings from platform
[18841.067903] pci 0000:00:1f.3: using default PCI settings
[18841.067910] pci 0000:00:1f.6: no hotplug settings from platform
[18841.067911] pci 0000:00:1f.6: using default PCI settings
[18841.065665] Restarting tasks ... done.
[18841.069534] video LNXVIDEO:00: Restoring backlight state
[18841.077858] Bluetooth: hci0: read Intel version: 370710018002030d00
[18841.077865] Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
[18841.186986] Bluetooth: hci0: Intel Bluetooth firmware patch completed and activated
[18841.626406] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[18844.670642] wlp1s0: authenticate with 6e:ad:f8:22:f5:bd
[18844.671641] wlp1s0: send auth to 6e:ad:f8:22:f5:bd (try 1/3)
[18844.678431] wlp1s0: authenticated
[18844.678857] wlp1s0: associate with 6e:ad:f8:22:f5:bd (try 1/3)
[18844.683185] wlp1s0: RX AssocResp from 6e:ad:f8:22:f5:bd (capab=0x411 status=0 aid=1)
[18844.684493] wlp1s0: associated
[18866.841316] ACPI: \_SB_.PCI0: Bus check notify on _handle_hotplug_event_root

--ZGiS0Q5IWpPtfppv--
