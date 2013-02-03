Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab3BCOrI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:47:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:32822 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604Ab3BCOrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:47:03 -0500
Date: Sun, 3 Feb 2013 15:46:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Slaby <jslaby@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130203144656.GB5844@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>,
	Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>
References: <20130129202848.GE25415@pd.tnic>
 <3066730.6MVSAfNyye@vostro.rjw.lan>
 <20130131131034.GF4926@pd.tnic>
 <2293454.v8QRHr8txR@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2293454.v8QRHr8txR@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 12:04:46AM +0100, Rafael J. Wysocki wrote:
> The [2/5] is at: https://patchwork.kernel.org/patch/2001211/
> 
> The other two are attached.  I suppose the ordering doesn't matter.

Ok, the eth link cable hotplugging issue seems fixed, plugging and
unplugging the cable works as expected.

The issue I triggered earlier:

> BUT(!), if I start powertop and set all tunables in the "Tunables" tab
> to "Good", then suspend to disk, when I resume I get the NMI and this
> time the unknown reason is 0x3c.

... still happens:

[  123.250870] PM: Creating hibernation image:
[  123.504940] PM: Need to copy 95667 pages						<--- suspend to disk
[  123.252841] Enabling non-boot CPUs ...						<--- resume
[  123.254021] SMP alternatives: lockdep: fixing up alternatives
[  123.254026] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  123.275566] CPU1 is up
[  123.275697] SMP alternatives: lockdep: fixing up alternatives
[  123.275699] smpboot: Booting Node 0 Processor 2 APIC 0x2
[  123.297581] CPU2 is up
[  123.297699] SMP alternatives: lockdep: fixing up alternatives
[  123.297701] smpboot: Booting Node 0 Processor 3 APIC 0x3
[  123.319358] CPU3 is up
[  123.321928] i915 0000:00:02.0: power state changed by ACPI to D0
[  123.321992] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[  123.333256] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[  123.344541] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[  123.345012] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[  123.345744] PM: noirq restore of devices complete after 24.061 msecs
[  123.346684] PM: early restore of devices complete after 0.836 msecs
[  123.389863] i915 0000:00:02.0: setting latency timer to 64
[  123.389870] xhci_hcd 0000:00:14.0: setting latency timer to 64
[  123.389887] ehci-pci 0000:00:1a.0: setting latency timer to 64
[  123.389907] usb usb3: root hub lost power or was reset
[  123.389908] usb usb1: root hub lost power or was reset
[  123.389909] usb usb2: root hub lost power or was reset
[  123.390034] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[  123.390171] xhci_hcd 0000:00:14.0: irq 45 for MSI/MSI-X
[  123.390308] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[  123.391013] ehci-pci 0000:00:1d.0: setting latency timer to 64
[  123.391038] usb usb4: root hub lost power or was reset
[  123.393798] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[  123.394115] ahci 0000:00:1f.2: setting latency timer to 64
[  123.394229] iwlwifi 0000:03:00.0: RF_KILL bit toggled to disable radio.
[  123.394923] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[  123.697314] usb 3-1: reset high-speed USB device number 2 using ehci-pci
[  123.698252] ata2: SATA link down (SStatus 0 SControl 300)
[  123.699286] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  123.701259] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  123.701287] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  123.701291] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  123.702699] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  123.702703] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  123.703222] ata5: SATA link down (SStatus 0 SControl 300)
[  123.704603] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  123.704606] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  123.705938] ata3.00: configured for UDMA/100
[  123.706033] sd 2:0:0:0: [sdb] Starting disk
[  123.706041] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  123.706045] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  123.735336] ata1.00: configured for UDMA/133
[  123.735662] sd 0:0:0:0: [sda] Starting disk
[  123.912740] usb 4-1: reset high-speed USB device number 2 using ehci-pci
[  124.129520] PM: restore of devices complete after 741.589 msecs
[  124.174684] Restarting tasks ... done.
[  124.177521] video LNXVIDEO:00: Restoring backlight state
[  124.186033] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3cold
[  124.214931] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3cold
[  124.214970] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3cold
[  124.394882] Uhhuh. NMI received for unknown reason 3c on CPU 0.				<--- FUN.
[  124.394890] Do you have a strange power saving mode enabled?
[  124.394892] Dazed and confused, but trying to continue
[  124.407438] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[  127.035581] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[  127.135668] ehci-pci 0000:00:1a.0: setting latency timer to 64
[  127.135910] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[  127.146500] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3cold
[  127.236381] ehci-pci 0000:00:1d.0: setting latency timer to 64
[  127.236658] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[  127.247244] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3cold
[  127.337137] xhci_hcd 0000:00:14.0: setting latency timer to 64
[  127.348286] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[  127.348975] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3cold
[  129.255203] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
[  129.255215] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
