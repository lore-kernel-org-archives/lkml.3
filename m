Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbaBBASw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 19:18:52 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63918 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754874AbaBBASY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 19:18:24 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 0/13] ACPI / hotplug / PCI: Updates on top of changes merged recently
Date: Sun, 02 Feb 2014 01:19:33 +0100
Message-ID: <1935791.liE9ZlzmO9@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <2217793.001RY6hKlo@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 27, 2014 01:37:17 AM Rafael J. Wysocki wrote:
> Hi All,
> 
> ACPIPHP can be simplified a bit on top of some PCI and ACPI changes merged
> recently and the following series of patches implements those simplifications:
> 
> [1/11] Fix up two kerneldoc comments in acpiphp_glue.c.
> [2/11] Get rid of an unnecessary label in register_slot().
> [3/11] Drop acpiphp_bus_trim() and use acpi_bus_trim() instead of it directly.
> [4/11] Move the acpi_bus_get_device() call out of acpiphp_no_hotplug().
> [5/11] Store struct acpi_device pointers instead of ACPI handles in struct acpiphp_context.
> [6/11] Drop acpiphp_bus_add() (which has only one user).
> [7/11] Drop crit_sect mutexes (that are redundant).
> [8/11] Clean up the usage of the slot variable in hotplug_event().
> [9/11] Drop dev_in_slot() and rework disable_slot() to walk bus->devices directly.
> [10/11] Use acpi_handle_debug() in hotplug_event() instead of open-coded stuff.
> [11/11] Drop handle argument from the member functions of struct acpi_dock_ops.
> 
> All of that is relateively straightforward, but I have some more intrusive changes
> on top of it in the works.  They will be posted separately later this week.

I've learned a couple of things since I sent this patchset.  First, all
bus->devices list walks that may remove PCI devices should be done in reverse
order or they can crash if virtual functions are involved.  Second, hotplug_event()
(in acpiphp_glue.c) has to acquire pci_rescan_remove_lock by itself, because it
may be called from multiple places and all of them need that lock to be held.
That is done by patches [1-2/13] which I'm planning to push as fixes for 3.14-rc2.

The rest is pretty much the same as last time except that the old patch [9/11]
became [3/13] in this series and it has been changed so that the list is walked in
reverse order.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
