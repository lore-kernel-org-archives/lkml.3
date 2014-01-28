Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbaA1WG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:06:57 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61838 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932134AbaA1WFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:05:36 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 0/5][RFT] ACPI / hotplug / PCI: Consolidation of ACPIPHP with ACPI core device hotplug
Date: Tue, 28 Jan 2014 23:10:30 +0100
Message-ID: <1508034.JFmpIOzjVZ@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <2217793.001RY6hKlo@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

It looks like there's time for more adventurous stuff. :-)

The following series is on top of the one I sent on Sunday:

https://lkml.org/lkml/2014/1/26/191

The final outcome of the patches below is that all ACPI hotplug notifications
for PCI devices and for core system things like CPU, memory, PCI roots etc.,
will be dispatched from acpi_bus_notify() and it is not necessary to install a
separate hotplug notify handler for each device any more.

[1/5] Attach ACPIPHP hotplug contexts to struct acpi_device objects.
[2/5] Introduce wrappers for installing and removing hotplug notify handlers
      (those wrappers go away later on, but they are useful for separating
       changes).
[3/5] Consolidate ACPI hotplug signaling for PCI and ACPI core.
[4/5] Simplify notify handle registration wrapper.
[5/5] Dispatch ACPI hotplug notifications for "core" devices and PCI from acpi_bus_notify().

The ACPIPHP part of this has been tested on Acer Aspire S5 with Thunderbolt
hotplug, but if you have access to systems with hot-removable CPUs, PCI host
bridges and such things, please check if the above changes don't break them.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
