Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbaIWPER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:04:17 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:58744 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbaIWPEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:04:11 -0400
Date: Tue, 23 Sep 2014 17:04:08 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Vidya Sagar <sagar.tv@gmail.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Jason Cooper <jason@lakedaemon.net>, Will Deacon <will.deacon@arm.com>,
        Stephen Warren <swarren@nvidia.com>, Krishna Thota <kthota@nvidia.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] ARM: fix debug prints relevant to PCI devices
Message-ID: <20140923150407.GJ5982@ulmo>
References: <1410085687-11273-1-git-send-email-vidyas@nvidia.com>
 <CAErSpo7CX3XiuNZO8tXYVN2tUJudObFKVBthHfxf9mPS6hE6Cg@mail.gmail.com>
 <20140923140635.GR5182@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g3RkK9jYN81zD2N+"
Content-Disposition: inline
In-Reply-To: <20140923140635.GR5182@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--g3RkK9jYN81zD2N+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2014 at 03:06:35PM +0100, Russell King - ARM Linux wrote:
> On Tue, Sep 23, 2014 at 07:56:01AM -0600, Bjorn Helgaas wrote:
> > This doesn't require any coordination with the PCI core, so I was just
> > leaving this up to the arch.  But I guess I can at least give you my
> > opinion :)
>=20
> However, PCI core people have more knowledge of the issues here than I do.
>=20
> > > diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
> > > index 17a26c1..03c56ba 100644
> > > --- a/arch/arm/kernel/bios32.c
> > > +++ b/arch/arm/kernel/bios32.c
> > > @@ -290,6 +290,7 @@ void pcibios_fixup_bus(struct pci_bus *bus)
> > >  {
> > >         struct pci_dev *dev;
> > >         u16 features =3D PCI_COMMAND_SERR | PCI_COMMAND_PARITY | PCI_=
COMMAND_FAST_BACK;
> > > +       bool has_pcie_dev =3D false;
> > >
> > >         /*
> > >          * Walk the devices on this bus, working out what we can
> > > @@ -298,6 +299,8 @@ void pcibios_fixup_bus(struct pci_bus *bus)
> > >         list_for_each_entry(dev, &bus->devices, bus_list) {
> > >                 u16 status;
> > >
> > > +               if (!has_pcie_dev)
> > > +                       has_pcie_dev =3D pci_is_pcie(dev);
> > >                 pci_read_config_word(dev, PCI_STATUS, &status);
> > >
> > >                 /*
> > > @@ -354,9 +357,11 @@ void pcibios_fixup_bus(struct pci_bus *bus)
> > >
> > >         /*
> > >          * Report what we did for this bus
> > > +        * (only if the bus doesn't have any PCIe devices)
> > >          */
> > > -       printk(KERN_INFO "PCI: bus%d: Fast back to back transfers %sa=
bled\n",
> > > -               bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en=
" : "dis");
> > > +       if (!has_pcie_dev)
> > > +               pr_info("PCI: bus%d: Fast back to back transfers %sab=
led\n",
> > > +                       bus->number, (features & PCI_COMMAND_FAST_BAC=
K) ? "en" : "dis");
> >=20
> > My first choice would be to just drop the printk altogether.
>=20
> It can be useful information.
>=20
> > If we want to keep the printk, it should be enough to test "bus->self
> > && !pci_is_pcie(bus->self)" to see whether Fast Back-to-Back can be
> > enabled.
>=20
> This is exactly the kind of issue that needs to be picked up by core
> PCI people.

I agree. Wouldn't it be more useful to move this into the core?
Disabling fast back-to-back transfers hardly seems like an ARM-
specific "fixup" to me.

Thierry

--g3RkK9jYN81zD2N+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUIYvnAAoJEN0jrNd/PrOhTbMP/2/uFIWG3pWyQWrSYehyV8/+
HcoWcBdsxh6MytFHwxO75YmgB4c6SXdM6Cez4MEaFJDSs3rgrymgZiky8pqO9Ytz
erNwQdMgCIs+Yie/lo1zQGrQYLW+rcci8GyHrhExR8niU2WPE42JILeAuXwJAiLv
k3S8iwGCVC3Uuzvy1WLHZA2BISoqoayFOfVSRTLpfbhqyNBkd+zwnyzzbRTQzVre
I6WjvwunWYbdzsaStNI/MsdpPpCimMhB+M3OXWsGd60MFeNkKTSFfpoAc9D6eyYB
W1MbFmV4sMqI4QAPtb7DONpMsQMUqa2ZiA3Od+3a6aB04neoblzpwnDipDze1bkV
Xqs3vZf3S/46jO4WYaHh0/6YjrqNm4zJc0onqNnrMCkEDMChsGqGtI80IPtCm2hR
caRz+T6/iVbblpNavscBldz/H1zkiJ7JHlZAGa4Y/8OA9JEIvILhAdNpCY4Hsg/r
UG6fRr4gb7he8gTaIMEOf7QXE0sQ/SJzMD73FA0BS/wtks9Jgd7RoArgIlAYeLYC
IZmpHiIK4qbCYMbjLt7iC0q03ZBWob2mvXeLcoRoc6BLOkk2HK8bdElfZEUDjWm+
t/Wrdc5Bn86scsZcbOzklTMLnceQTVNnCx26LLQ+68pJ0rHq71Hoi4qOmBvHr/R5
qYQti6tMepTFr+dTYNUF
=i7Kv
-----END PGP SIGNATURE-----

--g3RkK9jYN81zD2N+--
