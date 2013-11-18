Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766Ab3KRSOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:14:52 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:31737 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3KRSOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:14:44 -0500
Message-ID: <1384798205.1791.14.camel@misato.fc.hp.com>
Subject: Re: [PATCH 2/3] ACPI / hotplug: Fix PCI host bridge hot removal
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Date: Mon, 18 Nov 2013 11:10:05 -0700
In-Reply-To: <3206422.AfXMUDqMXZ@vostro.rjw.lan>
References: <2434673.zhjYZOTQ4A@vostro.rjw.lan>
	 <3206422.AfXMUDqMXZ@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-14 at 00:16 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Since the PCI host bridge scan handler does not set hotplug.enabled,
> the check of it in acpi_bus_device_eject() effectively prevents the
> root bridge hot removal from working after commit a3b1b1ef78cd
> (ACPI / hotplug: Merge device hot-removal routines).  However, that
> check is not necessary, because the other acpi_bus_device_eject()
> users, acpi_hotplug_notify_cb and acpi_eject_store(), do the same
> check by themselves before executing that function.
> 
> For this reason, remove the scan handler check from
> acpi_bus_device_eject() to make PCI hot bridge hot removal work
> again.

I am curious why the PCI host bridge scan handler does not set
hotplug.enabled.  Is this how it disables hotplug via sysfs eject but
enables via ACPI notification?  

Thanks,
-Toshi


