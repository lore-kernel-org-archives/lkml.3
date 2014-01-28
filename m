Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbaA1Xue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:50:34 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54430 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755971AbaA1Xu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:50:29 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH 0/5][RFT] ACPI / hotplug / PCI: Consolidation of ACPIPHP with ACPI core device hotplug
Date: Wed, 29 Jan 2014 00:57:06 +0100
Message-ID: <1693151.2qrLZHyp0o@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1508034.JFmpIOzjVZ@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <1508034.JFmpIOzjVZ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 28, 2014 11:10:30 PM Rafael J. Wysocki wrote:
> Hi All,
> 
> It looks like there's time for more adventurous stuff. :-)
> 
> The following series is on top of the one I sent on Sunday:
> 
> https://lkml.org/lkml/2014/1/26/191
> 
> The final outcome of the patches below is that all ACPI hotplug notifications
> for PCI devices and for core system things like CPU, memory, PCI roots etc.,
> will be dispatched from acpi_bus_notify() and it is not necessary to install a
> separate hotplug notify handler for each device any more.
> 
> [1/5] Attach ACPIPHP hotplug contexts to struct acpi_device objects.
> [2/5] Introduce wrappers for installing and removing hotplug notify handlers
>       (those wrappers go away later on, but they are useful for separating
>        changes).
> [3/5] Consolidate ACPI hotplug signaling for PCI and ACPI core.
> [4/5] Simplify notify handle registration wrapper.
> [5/5] Dispatch ACPI hotplug notifications for "core" devices and PCI from acpi_bus_notify().

Unfortunately, I realized that patches [3-5/5] were buggy.  The bugs were
kind of subtle and might not be easy to reproduce, but they were bugs anyway. :-)

A respin of the whole series follows.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
