Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab3KRV0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 16:26:52 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57556 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751301Ab3KRV0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 16:26:49 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/3] ACPI / hotplug: Fix PCI host bridge hot removal
Date: Mon, 18 Nov 2013 22:39:25 +0100
Message-ID: <11362197.FWMPl6Gp0A@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1384798205.1791.14.camel@misato.fc.hp.com>
References: <2434673.zhjYZOTQ4A@vostro.rjw.lan> <3206422.AfXMUDqMXZ@vostro.rjw.lan> <1384798205.1791.14.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 18, 2013 11:10:05 AM Toshi Kani wrote:
> On Thu, 2013-11-14 at 00:16 +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Since the PCI host bridge scan handler does not set hotplug.enabled,
> > the check of it in acpi_bus_device_eject() effectively prevents the
> > root bridge hot removal from working after commit a3b1b1ef78cd
> > (ACPI / hotplug: Merge device hot-removal routines).  However, that
> > check is not necessary, because the other acpi_bus_device_eject()
> > users, acpi_hotplug_notify_cb and acpi_eject_store(), do the same
> > check by themselves before executing that function.
> > 
> > For this reason, remove the scan handler check from
> > acpi_bus_device_eject() to make PCI hot bridge hot removal work
> > again.
> 
> I am curious why the PCI host bridge scan handler does not set
> hotplug.enabled.  Is this how it disables hotplug via sysfs eject but
> enables via ACPI notification? 

It just doesn't register for hotplug at all.  I guess it could set that
bit alone, but then it would be quite confusing and the check is not
necessary anyway.

Thanks,
Rafael

