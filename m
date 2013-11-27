Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab3K0BQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:16:47 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:30980 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab3K0BQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:16:43 -0500
Message-ID: <1385514717.1791.197.camel@misato.fc.hp.com>
Subject: Re: [PATCH 0/4] ACPI / bind: Simplify child devices lookup
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>
Date: Tue, 26 Nov 2013 18:11:57 -0700
In-Reply-To: <8065346.ZtkoVh8DW8@vostro.rjw.lan>
References: <2610478.KxPMyuOMok@vostro.rjw.lan>
	 <3773077.bfZR2z09sY@vostro.rjw.lan>
	 <1385512408.1791.196.camel@misato.fc.hp.com>
	 <8065346.ZtkoVh8DW8@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-27 at 02:02 +0100, Rafael J. Wysocki wrote:
> On Tuesday, November 26, 2013 05:33:28 PM Toshi Kani wrote:
> > On Wed, 2013-11-27 at 01:27 +0100, Rafael J. Wysocki wrote:
> > > On Tuesday, November 26, 2013 05:00:42 PM Toshi Kani wrote:
> > > > On Mon, 2013-11-25 at 01:09 +0100, Rafael J. Wysocki wrote:
> > > > > Hi,
> > > > > 
> > > > > The following series of four patches (on top of current linux-pm.git/bleeding-edge)
> > > > > rework child device lookup in drivers/acpi/glue.c and related things:
> > > > > 
> > > > > [1/4] ACPI / bind: Simplify child device lookup
> > > > > [2/4] PCI/ ACPI: Use acpi_find_child_device() for child device lookup
> > > > > [3/4] ACPI / bind: Redefine acpi_get_child()
> > > > > [4/4] ACPI / bind: Redefine acpi_preset_companion()
> > > > 
> > > > This patchset caused the attached panic during boot on a system.
> > > > acpi_pci_find_device() called acpi_find_child_device() with
> > > > ACPI_COMPANION(dev->parent) being a NULL pointer when scanning bus 0xf.
> > > > 
> > > > This bus 0xf seems to be a chipset internal bus, which is not intended
> > > > for the OS to use.  Therefore, ACPI does not list its PCI bridge device.
> > > > 
> > > > # lspci -tv
> > > >    :
> > > >  +-[0000:0f]-+-08.0  Intel Corporation Ivytown QPI Link 0
> > > >  |           +-08.2  Intel Corporation Ivytown QPI Link 0
> > > >    :
> > > > 
> > > > However, pcibios_fixup_peer_bridges(), called from pci_subsys_init(),
> > > > finds this bus as it scans all the buses from 0 to pcibios_last_bus.
> > > > Hence, this dev->parent does not have an associated ACPI device object. 
> > > 
> > > Thanks for the report!
> > > 
> > > I've dropped the patches from bleeding-edge for now.
> > > 
> > > Does "[1/4] ACPI / bind: Simplify child device lookup" alone work on that
> > > system?
> > 
> > Yes, the system boots fine with 1/4 alone.
> 
> Thanks!
> 
> Can you please check if the following modified [2/4] also works on top of it?

Yes, it works fine.

Thanks for the quick fix!
-Toshi


