Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbaBBRHV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 12:07:21 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60450 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752139AbaBBRG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 12:06:26 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Robert Moore <robert.moore@intel.com>
Subject: [PATCH v3 0/7] ACPI / hotplug / PCI: Consolidation of ACPIPHP with ACPI core device hotplug
Date: Sun, 02 Feb 2014 18:11:19 +0100
Message-ID: <5157096.hCmU2aoKCT@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1519631.YS65c9Af2C@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <1693151.2qrLZHyp0o@vostro.rjw.lan> <1519631.YS65c9Af2C@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 02, 2014 01:52:26 AM Rafael J. Wysocki wrote:
> On Wednesday, January 29, 2014 12:57:06 AM Rafael J. Wysocki wrote:
> > On Tuesday, January 28, 2014 11:10:30 PM Rafael J. Wysocki wrote:
> > > Hi All,
> > > 
> > > It looks like there's time for more adventurous stuff. :-)
> > > 
> > > The following series is on top of the one I sent on Sunday:
> > > 
> > > https://lkml.org/lkml/2014/1/26/191
> > > 
> > > The final outcome of the patches below is that all ACPI hotplug notifications
> > > for PCI devices and for core system things like CPU, memory, PCI roots etc.,
> > > will be dispatched from acpi_bus_notify() and it is not necessary to install a
> > > separate hotplug notify handler for each device any more.
> > > 
> > > [1/5] Attach ACPIPHP hotplug contexts to struct acpi_device objects.
> > > [2/5] Introduce wrappers for installing and removing hotplug notify handlers
> > >       (those wrappers go away later on, but they are useful for separating
> > >        changes).
> > > [3/5] Consolidate ACPI hotplug signaling for PCI and ACPI core.
> > > [4/5] Simplify notify handle registration wrapper.
> > > [5/5] Dispatch ACPI hotplug notifications for "core" devices and PCI from acpi_bus_notify().
> > 
> > Unfortunately, I realized that patches [3-5/5] were buggy.  The bugs were
> > kind of subtle and might not be easy to reproduce, but they were bugs anyway. :-)
> > 
> > A respin of the whole series follows.
> 
> After the Mika's testing it turned out that they were more buggy than I had
> though.  Oh well.
> 
> The following patchset is a reworked version of the previous one.  Functionality-wise
> the final result should be very similar, but not exactly the same.
> 
> [1/6] Fix a theoretical race condition in acpi_hotplug_notify_cb().
> [2/6] Move the hotplug context lock definition to the ACPI core (from ACPIPHP).
> [3/6] Consolidate ACPI hotplug signaling for PCI and ACPI core (this is a combination
>       of patches [1-3/5] from the previous series).
> [4/6] Rework the handling of eject requests in the ACPI core.
> [5/6] Simplify a routine for installing hotplug notify handlers.
> [6/6] Dispatch ACPI hotplug notifications for "core" devices and PCI from acpi_bus_notify().
> 
> This is on top of https://lkml.org/lkml/2014/2/1/123 which in turn is on top of
> the current mainline.
> 
> For the adventurous all this stuff is on the test-next branch of linux-pm.git.

As stated in the message at http://marc.info/?l=linux-acpi&m=139135963030012&w=4 ,
patch [1/6] was actaully wrong and the whole patchset had to be reworked for that
reason.  What follows is an entirely new version:

[1/7] Add a new function to ACPICA allowing a callback to be executed under the
      namespace mutex after calling acpi_ns_get_attached_data().

[2/7] Use the new ACPICA's function to fix a couple of potential races related
      to ACPI notifies.

[3/7] Same as [2/6] above.
[4/7] Same as [3/6] above, rebased.
[5/7] Same as [4/6] above.
[6/7] Same as [5/6] above.
[7/7] Dispatch ACPI hotplug notifications for "core" devices and PCI from
      acpi_bus_notify().  This actually is different from [6/6] above, although
      it serves the same purpose.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
