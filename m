Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaBJAhj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 19:37:39 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50077 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751732AbaBJAhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 19:37:38 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Wu <lekensteyn@gmail.com>
Cc: Bastien Traverse <bastien.traverse@gmail.com>,
        linux-kernel@vger.kernel.org, francis.moro@gmail.com,
        linux-pm@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: 3.12: ethernet controller missing after resuming from suspend to RAM
Date: Mon, 10 Feb 2014 01:52:14 +0100
Message-ID: <1521445.Je1ql4ndX7@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1395731.XHixqRiN3E@al>
References: <52F2CC7B.80406@gmail.com> <2150349.jTafhT0LGH@vostro.rjw.lan> <1395731.XHixqRiN3E@al>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 10, 2014 12:18:16 AM Peter Wu wrote:
> On Sunday 09 February 2014 22:46:05 Rafael J. Wysocki wrote:
> > That most likely would single out one of the ACPIPHP commits without giving
> > us much clue about what's going on.
> > 
> > I fail to see what the connection between those changes and system resume
> > is, however.
> > 
> > Please replace all pr_debug() calls in hotplug_notify() with pr_info() and
> > see if you get any events from there.
> 
> I could not find a hotplug_notify function in the kernel tree, but I
> have dyndbg enabled. Booting with `pci_hotplug.debug=Y
> pci_hotplug.debug_acpi=Y pci_hotplug.dyndbg acpiphp.dyndbg` gives me
> only a few acpiphp_glue messages. After resume:
> 
> [   55.492261] CPU3 is up
> [   55.494710] ACPI: Waking up from system sleep state S3
> [   56.187298] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
> [   56.213939] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
> [   56.240614] xhci_hcd 0000:02:00.0: System wakeup disabled by ACPI
> [   56.294230] PM: noirq resume of devices complete after 133.375 msecs
> [   56.294507] PM: early resume of devices complete after 0.231 msecs
> [   56.294798] pcieport 0000:00:1c.1: System wakeup disabled by ACPI
> [   56.296628] iwlwifi 0000:05:00.0: RF_KILL bit toggled to enable radio.
> [   56.404258] snd_hda_intel 0000:00:1b.0: irq 48 for MSI/MSI-X
> [   56.627043] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   56.627929] ata1.00: configured for UDMA/133
> [   56.628044] sd 0:0:0:0: [sda] Starting disk
> [   56.633730] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [   56.640403] ata5: SATA link down (SStatus 0 SControl 300)
> [   56.802771] ata2.00: configured for UDMA/100
> [   57.737542] PM: resume of devices complete after 1443.847 msecs
> [   57.737951] PM: Finishing wakeup.
> [   57.737957] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP03
> [   57.737960] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP03
> [   57.738080] iwlwifi 0000:05:00.0: no hotplug settings from platform
> [   57.737963] Restarting tasks ... done.
> [   57.740480] video LNXVIDEO:00: Restoring backlight state
> [   57.740487] video LNXVIDEO:01: Restoring backlight state
> [   58.203311] ACPI: \_SB_.AC__: ACPI_NOTIFY_BUS_CHECK event: unsupported
> [   58.204080] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP01
> [   58.204083] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP01
> [   58.204121] xhci_hcd 0000:02:00.0: no hotplug settings from platform
> [   58.204132] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP02
> [   58.204134] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP02
> [   58.209339] jme 0000:04:00.5: irq 50 for MSI/MSI-X
> [   58.233503] jme 0000:04:00.5 eth0: Link is down
> [   58.233578] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   58.235113] iwlwifi 0000:05:00.0: L1 Enabled; Disabling L0S
> [   58.242131] iwlwifi 0000:05:00.0: Radio type=0x1-0x3-0x1
> [   58.346311] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   58.392764] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP03
> [   58.392766] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP03
> [   58.392874] iwlwifi 0000:05:00.0: no hotplug settings from platform
> 
> RP02 is the ACPI Device for 00:1c.1 [1].
> 
> Could the following commit have something to do with it?
> 
> commit 4ebe34503baa0644c9352bcd76d4cf573bffe206
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Tue Jul 16 22:10:35 2013 +0200
> 
>     ACPI / hotplug / PCI: Check for new devices on enabled slots

This one, or another one in that series.  I rather suspect

ab1225901da2 Revert "ACPI / hotplug / PCI: Avoid doing too much for spurious notifies"

from Mika, but it really doesn't matter.

Can you please check the patch below (it is on top of 3.14-rc1, but I think it'll
still apply to 3.13) and report back?

Rafael


---
 drivers/pci/hotplug/acpiphp_glue.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -555,10 +555,10 @@ static void __ref enable_slot(struct acp
 	struct pci_dev *dev;
 	struct pci_bus *bus = slot->bus;
 	struct acpiphp_func *func;
-	int max, pass;
+	int nr_found, max, pass, bridges_scanned = 0;
 	LIST_HEAD(add_list);
 
-	acpiphp_rescan_slot(slot);
+	nr_found = acpiphp_rescan_slot(slot);
 	max = acpiphp_max_busnr(bus);
 	for (pass = 0; pass < 2; pass++) {
 		list_for_each_entry(dev, &bus->devices, bus_list) {
@@ -574,9 +574,14 @@ static void __ref enable_slot(struct acp
 					__pci_bus_size_bridges(dev->subordinate,
 							       &add_list);
 				}
+				bridges_scanned++;
 			}
 		}
 	}
+	/* Nothing more to do here if there are no new devices on this bus. */
+	if (!nr_found && !bridges_scanned && (slot->flags & SLOT_ENABLED))
+		return;
+
 	__pci_bus_assign_resources(bus, &add_list, NULL);
 
 	acpiphp_sanitize_bus(bus);

