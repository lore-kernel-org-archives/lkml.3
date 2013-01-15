Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab3AOMJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:09:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64015 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab3AOMJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:09:21 -0500
Date: Tue, 15 Jan 2013 13:08:55 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Andrew Murray <andrew.murray@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Message-ID: <20130115120855.GA5637@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130111154516.GA25335@avionic-0098.adnet.avionic-design.de>
 <20130112123640.GA22505@avionic-0098.adnet.avionic-design.de>
 <201301122112.25772.arnd@arndb.de>
 <20130113095806.GA31966@avionic-0098.adnet.avionic-design.de>
 <20130114095706.GA23467@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <20130114095706.GA23467@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:2bCvxZFsIi8Fl6yosiCvabg9vLAbTXpx8CMLwv7pBTI
 mKJC4Vs5pxe1+z/HDOYkib5PGJXTmExV78yeZUTWLk5YLoZpXF
 5V/TXGmgweUGNyNLTdRP5H90C1cONIp4ds1zbgvGAcMy4Dibij
 IT3qysxh09xpHRPxnicJz+sw2wi1D9PSAuBevPA6ppI2+Tf4sw
 p3gtqzwp+cVxbLdE192wc8pxXwDt8irmruix5YeZ/Kbo7i1l+I
 +T5Ht45ds6w6Wurtz0ufKzRDl2Te8lpCXvzq1xEpqWFuNbWi2N
 CXMhDql+4l38AfpfYLK38Dzbp5uavEs1jj/NSkxm6D/0VnsTia
 bxdK7Dzuj1o5NrO+8pkKUA6euB93ZLmgbuh6eCjeAENKvTTPT+
 mode46VVb41vXifyiDn3yfRk9zIgvYUGvk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 14, 2013 at 09:57:07AM +0000, Andrew Murray wrote:
> On Sun, Jan 13, 2013 at 09:58:06AM +0000, Thierry Reding wrote:
> > On Sat, Jan 12, 2013 at 09:12:25PM +0000, Arnd Bergmann wrote:
> > > On Saturday 12 January 2013, Thierry Reding wrote:
> > > > > I already hinted at that in one of the other subthreads. Having s=
uch a
> > > > > multiplex would also allow the driver to be built as a module. I =
had
> > > > > already thought about this when I was working on an earlier versi=
on of
> > > > > these patches. Basically these would be two ops attached to the h=
ost
> > > > > bridge, and the generic arch_setup_msi_irq() could then look that=
 up
> > > > > given the struct pci_dev that is passed to it and call this new p=
er-
> > > > > host bridge .setup_msi_irq().
> > > >=20
> > > > struct pci_ops looks like a good place to put these. They'll be
> > > > available from each struct pci_bus, so should be easy to call from
> > > > arch_setup_msi_irq().
> > > >=20
> > > > Any objections?
> > > >=20
> > >=20
> > > struct pci_ops has a long history of being specifically about
> > > config space read/write operations, so on the one hand it does
> > > not feel like the right place to put interrupt specific operations,
> > > but on the other hand, the name sounds appropriate and I cannot
> > > think of any other place to put this, so it's fine with me.
> > >=20
> > > The only alternative I can think of is to introduce a new
> > > structure next to it in struct pci_bus, but that feels a bit
> > > pointless. Maybe Bjorn has a preference one way or the other.
> >=20
> > The name pci_ops is certainly generic enough. Also the comment above the
> > structure declaration says "Low-level architecture-dependent routines",
> > which applies to the MSI functions as well.
>=20
> I've previously looked into this. It seems that architectures handle this
> in different ways, some use vector tables, others use a multiplex and oth=
ers
> just let the end user implement the callback directly.
>=20
> I've made an attempt to find a more common way. Though my implementation,=
 which
> I will try to share later today for reference provides a registration fun=
ction
> in drivers/pci/msi.c to provide implementations of the
> (setup|teardown)_msi_irq(s) ops. This seems slightly better than the curr=
ent
> approach and doesn't break existing users - but is still ugly.
>=20
> At present the PCI and MSI frameworks are largely uncoupled from each oth=
er and
> so I was keen to not pollute PCI structures (e.g. pci_ops) with MSI ops. =
Just
> because most PCI host bridges also provide MSI support I don't think ther=
e is a
> reason why they should always come as a pair or be provided by the same c=
hip.
>=20
> Perhaps the solution is to support MSI controller drivers and a means to
> associate them with PCI host controller drivers?

I'm not sure I follow you're reasoning here. Is it possible to use MSIs
without PCI? If not then I think there's little sense in keeping the
implementations separate.

Furthermore, if MSI controller and PCI host bridge are separate entities
how do you look up the MSI controller given a PCI device?

Thierry

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ9UbXAAoJEN0jrNd/PrOhPUMQAKNhspoQI51u1sXnZ0ln3ibR
FLBRqTURtkSryRPqcuc+trnITfOMi7McsACOGsPVRzU3NwZpxrH+vENZuIWEtMjP
pt++wG60l2oiOBVKkumxD/qDS/q7FBPC+0eD6vaXq5Nk8zG/NDSzvgCY0EY7kfnD
rgNXAFhHZTGN3srxM7ZVc3IkMZt43Q5F5yaCiy1GOhR9dnpUK/taOwo821rcx+Tf
0agNyrafnD3nfP51cAIzjAWIeaPt467L0xU3O1byrh+BnOufwlMhUQmMOrgXtmf4
XQBg0Al9JCS382heYvArCIcj/UI2EILtMdJp9V567vQ3dIA1k0pQ7IiZRez3zjFW
3uhzUrI2W2MFR/kBOVkf3LoWxx+L+ja0Ur70KOR5BtH/tp4qAQmkWy2HJMh7WmL9
UlvSsmNqL5FkU470tv7+uPDgJYmhVnWUhn/e2CskagT60ngfmvGo3s5xGDKMKWUt
aGL36UR1G0xWzJTC2dgfggMfvWV0fq+HXRMe5wF7wW5ftxqnW2t8V8Q+gjLF/+k1
faCMJld6ueA0h0sz0zVKlacBgo0ocT5Q8KxlMFnTSsvizvmHe5MYIxXDGb6zC8gL
jZfF+VeG4WXtMTl/eO3UbOi5lEg/rH1PVbGMSW0Tg65BBEGGldMu0l2DIsMsyBCd
Fv0lXQVkotmB8gKfpzss
=0RFY
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
