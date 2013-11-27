Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab3K0BUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:20:12 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50581 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759549Ab3K0BUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:20:05 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 0/4] ACPI / bind: Simplify child devices lookup
Date: Wed, 27 Nov 2013 02:32:53 +0100
Message-ID: <6140633.otq91cJcVd@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1385514717.1791.197.camel@misato.fc.hp.com>
References: <2610478.KxPMyuOMok@vostro.rjw.lan> <8065346.ZtkoVh8DW8@vostro.rjw.lan> <1385514717.1791.197.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 26, 2013 06:11:57 PM Toshi Kani wrote:
> On Wed, 2013-11-27 at 02:02 +0100, Rafael J. Wysocki wrote:
> > On Tuesday, November 26, 2013 05:33:28 PM Toshi Kani wrote:
> > > On Wed, 2013-11-27 at 01:27 +0100, Rafael J. Wysocki wrote:
> > > > On Tuesday, November 26, 2013 05:00:42 PM Toshi Kani wrote:
> > > > > On Mon, 2013-11-25 at 01:09 +0100, Rafael J. Wysocki wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > The following series of four patches (on top of current linux-pm.git/bleeding-edge)
> > > > > > rework child device lookup in drivers/acpi/glue.c and related things:
> > > > > > 
> > > > > > [1/4] ACPI / bind: Simplify child device lookup
> > > > > > [2/4] PCI/ ACPI: Use acpi_find_child_device() for child device lookup
> > > > > > [3/4] ACPI / bind: Redefine acpi_get_child()
> > > > > > [4/4] ACPI / bind: Redefine acpi_preset_companion()
> > > > > 
> > > > > This patchset caused the attached panic during boot on a system.
> > > > > acpi_pci_find_device() called acpi_find_child_device() with
> > > > > ACPI_COMPANION(dev->parent) being a NULL pointer when scanning bus 0xf.
> > > > > 
> > > > > This bus 0xf seems to be a chipset internal bus, which is not intended
> > > > > for the OS to use.  Therefore, ACPI does not list its PCI bridge device.
> > > > > 
> > > > > # lspci -tv
> > > > >    :
> > > > >  +-[0000:0f]-+-08.0  Intel Corporation Ivytown QPI Link 0
> > > > >  |           +-08.2  Intel Corporation Ivytown QPI Link 0
> > > > >    :
> > > > > 
> > > > > However, pcibios_fixup_peer_bridges(), called from pci_subsys_init(),
> > > > > finds this bus as it scans all the buses from 0 to pcibios_last_bus.
> > > > > Hence, this dev->parent does not have an associated ACPI device object. 
> > > > 
> > > > Thanks for the report!
> > > > 
> > > > I've dropped the patches from bleeding-edge for now.
> > > > 
> > > > Does "[1/4] ACPI / bind: Simplify child device lookup" alone work on that
> > > > system?
> > > 
> > > Yes, the system boots fine with 1/4 alone.
> > 
> > Thanks!
> > 
> > Can you please check if the following modified [2/4] also works on top of it?
> 
> Yes, it works fine.
> 
> Thanks for the quick fix!

No problem. :-)

[3/4] and [4/4] on top of this one should work too.

Thanks,
Rafael

