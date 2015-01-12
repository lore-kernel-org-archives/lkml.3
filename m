Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbbALQqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:46:03 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41589 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752039AbbALQqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:46:00 -0500
Date: Mon, 12 Jan 2015 11:39:18 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [RFC][PATCH] PCI / PM: Avoid resuming PCI devices during system
 suspend
In-Reply-To: <1654338.pQ8g9cpnmS@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1501121134480.1707-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2015, Rafael J. Wysocki wrote:

> On Thursday, January 08, 2015 10:51:06 AM Alan Stern wrote:
> > On Thu, 8 Jan 2015, Rafael J. Wysocki wrote:
> > 
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > Commit f25c0ae2b4c4 (ACPI / PM: Avoid resuming devices in ACPI PM
> > > domain during system suspend) modified the ACPI PM domain's system
> > > suspend callbacks to allow devices attached to it to be left in the
> > > runtime-suspended state during system suspend so as to optimize
> > > the suspend process.
> > > 
> > > This was based on the general mechanism introduced by commit
> > > aae4518b3124 (PM / sleep: Mechanism to avoid resuming runtime-suspended
> > > devices unnecessarily).
> > > 
> > > Extend that approach to PCI devices by modifying the PCI bus type's
> > > ->prepare callback to return 1 for devices that are runtime-suspended
> > > when it is being executed and that are in a suitable power state and
> > > need not be resumed going forward.
> > 
> > Does this correctly handle PCI devices that aren't included in the ACPI
> > tables?  For example, add-on PCI cards?
> 
> Well, it would if it took the case when a device was configured for remote
> wakeup at run time but was not supposed to wakeup the system from sleep into
> account.
> 
> That needs to be checked in pci_dev_keep_suspended() rather than in the platform
> callback to cover all devices.
> 
> Updated patch follows.
> 
> Rafael

This looks better, thank you.

Alan Stern


