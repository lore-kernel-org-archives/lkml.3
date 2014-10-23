Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbaJWUwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 16:52:50 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62661 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932301AbaJWUws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 16:52:48 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Francis Moreau <francis.moro@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: kernel 3.17.1: fail to use USB3 device after resuming from suspend
Date: Thu, 23 Oct 2014 23:13:16 +0200
Message-ID: <3246508.csL4NlCXV0@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <544961F6.8050609@gmail.com>
References: <544961F6.8050609@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 23, 2014 10:15:50 PM Francis Moreau wrote:
> Hello,
> 
> After resuming from a suspend (to RAM), I can't use an external USB hard
> drive anymore, the kernel seems to fail to detect it.
> 
> Here is the kernel log when doing a suspend/resume cycle.
> 
> [Oct23 22:03] wlp2s0: deauthenticating from 92:23:b1:f9:54:e4 by local
> choice (Reason: 3=DEAUTH_LEAVING)
> [  +0.025152] cfg80211: Calling CRDA to update world regulatory domain
> [  +0.052636] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
> [  +0.071175] PM: Syncing filesystems ... done.
> [  +0.099223] PM: Preparing system for mem sleep
> [  +0.000347] Freezing user space processes ... (elapsed 0.001 seconds)
> done.
> [  +0.001406] Freezing remaining freezable tasks ... (elapsed 0.001
> seconds) done.
> [  +0.001083] PM: Entering mem sleep
> [  +0.000017] Suspending console(s) (use no_console_suspend to debug)
> [  +0.000264] sd 4:0:0:0: [sdb] Synchronizing SCSI cache
> [  +0.000036] sd 4:0:0:0: [sdb] Stopping disk
> [  +0.000004] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [  +0.000049] sd 0:0:0:0: [sda] Stopping disk
> [  +1.058316] PM: suspend of devices complete after 1057.429 msecs
> [  +0.013434] PM: late suspend of devices complete after 13.410 msecs
> [  +0.000875] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
> [  +0.000013] r8169 0000:03:00.2: System wakeup enabled by ACPI
> [  +0.000101] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
> [  +0.000047] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
> [  +0.012356] PM: noirq suspend of devices complete after 13.373 msecs
> [  +0.000401] ACPI: Preparing to enter system sleep state S3
> [  +0.002149] PM: Saving platform NVS memory
> [  +0.000006] Disabling non-boot CPUs ...
> [  +0.000075] intel_pstate CPU 1 exiting
> [  +0.001363] kvm: disabling virtualization on CPU1
> [  +0.000028] smpboot: CPU 1 is now offline
> [  +0.000436] intel_pstate CPU 2 exiting
> [  +0.001348] kvm: disabling virtualization on CPU2
> [  +0.100773] smpboot: CPU 2 is now offline
> [  +0.000322] intel_pstate CPU 3 exiting
> [  +0.001260] kvm: disabling virtualization on CPU3
> [  +0.101855] smpboot: CPU 3 is now offline
> [  +0.000246] intel_pstate CPU 4 exiting
> [  +0.001181] kvm: disabling virtualization on CPU4
> [  +0.102021] smpboot: CPU 4 is now offline
> [  +0.000396] intel_pstate CPU 5 exiting
> [  +0.001242] kvm: disabling virtualization on CPU5
> [  +0.101801] smpboot: CPU 5 is now offline
> [  +0.000292] intel_pstate CPU 6 exiting
> [  +0.001301] kvm: disabling virtualization on CPU6
> [  +0.101880] smpboot: CPU 6 is now offline
> [  +0.000496] intel_pstate CPU 7 exiting
> [  +0.001265] kvm: disabling virtualization on CPU7
> [  +0.101649] smpboot: CPU 7 is now offline
> [  +0.002022] ACPI: Low-level resume complete
> [  +0.000043] PM: Restoring platform NVS memory
> [  +0.000342] Enabling non-boot CPUs ...
> [  +0.000047] x86: Booting SMP configuration:
> [  +0.000002] smpboot: Booting Node 0 Processor 1 APIC 0x2
> [  +0.011516] kvm: enabling virtualization on CPU1
> [  +0.002301] CPU1 is up
> [  +0.000025] smpboot: Booting Node 0 Processor 2 APIC 0x4
> [  +0.011466] kvm: enabling virtualization on CPU2
> [  +0.002307] CPU2 is up
> [  +0.000022] smpboot: Booting Node 0 Processor 3 APIC 0x6
> [  +0.011469] kvm: enabling virtualization on CPU3
> [  +0.002305] CPU3 is up
> [  +0.000022] smpboot: Booting Node 0 Processor 4 APIC 0x1
> [  +0.011483] kvm: enabling virtualization on CPU4
> [  +0.002298] CPU4 is up
> [  +0.000018] smpboot: Booting Node 0 Processor 5 APIC 0x3
> [  +0.011437] kvm: enabling virtualization on CPU5
> [  +0.002305] CPU5 is up
> [  +0.000017] smpboot: Booting Node 0 Processor 6 APIC 0x5
> [  +0.011550] kvm: enabling virtualization on CPU6
> [  +0.002297] CPU6 is up
> [  +0.000017] smpboot: Booting Node 0 Processor 7 APIC 0x7
> [  +0.011457] kvm: enabling virtualization on CPU7
> [  +0.002312] CPU7 is up
> [  +0.006813] ACPI: Waking up from system sleep state S3
> [  +0.046539] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
> [  +0.000267] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
> [  +0.000123] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
> [  +0.000053] PM: noirq resume of devices complete after 13.005 msecs
> [  +0.000523] PM: early resume of devices complete after 0.479 msecs
> [  +0.000120] mei_me 0000:00:16.0: irq 28 for MSI/MSI-X
> [  +0.000047] r8169 0000:03:00.2: System wakeup disabled by ACPI
> [  +0.000097] snd_hda_intel 0000:00:1b.0: irq 29 for MSI/MSI-X
> [  +0.003073] rtc_cmos 00:02: System wakeup disabled by ACPI
> [  +0.008776] sd 4:0:0:0: [sdb] Starting disk
> [  +0.000009] sd 0:0:0:0: [sda] Starting disk
> [  +0.053104] r8169 0000:03:00.2 enp3s0f2: link down
> [  +0.254016] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
> [  +0.000016] xhci_hcd 0000:00:14.0: Setup ERROR: setup context command
> for slot 1.
> [  +0.000003] usb 1-4: hub failed to enable device, error -22
> [  +0.019787] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  +0.002347] ata3.00: configured for UDMA/100
> [  +0.004325] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  +0.014796] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
> succeeded
> [  +0.000004] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
> LOCK) filtered out
> [  +0.000002] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
> CONFIGURATION OVERLAY) filtered out
> [  +0.036236] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
> succeeded
> [  +0.000004] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
> LOCK) filtered out
> [  +0.000003] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
> CONFIGURATION OVERLAY) filtered out
> [  +0.002230] ata5.00: configured for UDMA/133
> [  +0.080235] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
> [  +0.000014] xhci_hcd 0000:00:14.0: Setup ERROR: setup context command
> for slot 1.
> [  +0.000002] usb 1-4: hub failed to enable device, error -22
> [  +0.160144] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
> [  +0.015695] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with
> disabled ep ffff880405d77900
> [  +0.000003] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with
> disabled ep ffff880405d77948
> [  +0.000001] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with
> disabled ep ffff880405d77990
> [  +0.000002] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with
> disabled ep ffff880405ece3c0
> [  +0.000001] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with
> disabled ep ffff880405ece408

The above messages look suspicious to me, but I'm not a USB expert.
CCing linux-usb and linux-pm.

> [  +0.001376] PM: resume of devices complete after 655.778 msecs
> [  +0.001102] PM: Finishing wakeup.
> [  +0.000002] Restarting tasks ... done.
> [  +0.008460] video LNXVIDEO:00: Restoring backlight state
> [  +0.269354] IPv6: ADDRCONF(NETDEV_UP): enp3s0f2: link is not ready
> [  +0.067225] r8169 0000:03:00.2 enp3s0f2: link down
> [  +0.000036] IPv6: ADDRCONF(NETDEV_UP): enp3s0f2: link is not ready
> [  +0.041454] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
> [  +0.007433] iwlwifi 0000:02:00.0: Radio type=0x2-0x0-0x0
> [  +0.052615] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
> [  +0.645784] wlp2s0: authenticate with 92:23:b1:f9:54:e4
> [  +0.010244] wlp2s0: send auth to 92:23:b1:f9:54:e4 (try 1/3)
> [  +0.002563] wlp2s0: authenticated
> [  +0.000151] iwlwifi 0000:02:00.0 wlp2s0: disabling HT/VHT due to
> WEP/TKIP use
> [  +0.000942] wlp2s0: associate with 92:23:b1:f9:54:e4 (try 1/3)
> [  +0.002687] wlp2s0: RX AssocResp from 92:23:b1:f9:54:e4 (capab=0x411
> status=0 aid=4)
> [  +0.019814] wlp2s0: associated
> [  +0.000027] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready
> [  +0.257801] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  +0.006493] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
> succeeded
> [  +0.000006] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
> LOCK) filtered out
> [  +0.000004] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
> CONFIGURATION OVERLAY) filtered out
> [  +0.012908] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
> succeeded
> [  +0.000022] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
> LOCK) filtered out
> [  +0.000003] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
> CONFIGURATION OVERLAY) filtered out
> [  +0.006284] ata1.00: configured for UDMA/133
> ^[[B[Oct23 22:04] usb 2-2: new SuperSpeed USB device number 2 using xhci_hcd
> [  +0.034951] usb-storage 2-2:1.0: USB Mass Storage device detected
> [  +0.000233] scsi host6: usb-storage 2-2:1.0
> [  +0.000138] usbcore: registered new interface driver usb-storage
> [  +0.001865] usbcore: registered new interface driver uas
> [  +1.330800] usb 2-2: USB disconnect, device number 2
> 
> The xHCI controller is:
> 
> 00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
> Family USB xHCI Host Controller (rev 04) (prog-if 30 [XHCI])
> 	Subsystem: CLEVO/KAPOK Computer Device 0550
> 	Flags: bus master, medium devsel, latency 0, IRQ 26
> 	Memory at f7d00000 (64-bit, non-prefetchable) [size=64K]
> 	Capabilities: [70] Power Management version 2
> 	Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
> 	Kernel driver in use: xhci_hcd
> 	Kernel modules: xhci_hcd
> 
> 
> Please let me know if you need more information.
> 
> Thanks

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
