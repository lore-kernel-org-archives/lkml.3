Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab3FNKxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 06:53:18 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:47551 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3FNKxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 06:53:16 -0400
Date: Fri, 14 Jun 2013 12:53:11 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        linux-pci@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V5 1/3] pci: Add PCIe driver for Samsung Exynos
Message-ID: <20130614105310.GA19060@manwe>
References: <000b01ce6839$0f0455d0$2d0d0170$@samsung.com>
 <13685067.uPzcc2y1CU@wuerfel>
 <000001ce68d7$ca762200$5f626600$@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <000001ce68d7$ca762200$5f626600$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 14, 2013 at 05:18:46PM +0900, Jingoo Han wrote:
> On Thursday, June 13, 2013 11:14 PM, Arnd Bergmann wrote:
> > On Thursday 13 June 2013 22:22:31 Jingoo Han wrote:
[...]
> > > +static int __exit exynos_pcie_remove(struct platform_device *pdev)
> > > +{
> > > +	struct pcie_port *pp =3D platform_get_drvdata(pdev);
> > > +
> > > +	clk_disable_unprepare(pp->bus_clk);
> > > +	clk_disable_unprepare(pp->clk);
> > > +
> > > +	return 0;
> > > +}
> >=20
> > You also don't remove the PCI devices here, as mentioned in an earlier
> > review.
>=20
> I reviewed Marvell PCIe driver and Tegra PCIe driver; however,
> I cannot know what you mean.
>=20
> Could let me know which additional functions are needed?

We don't currently do that on Tegra either. pci-mvebu doesn't do that
either, but they don't implement the driver's .remove() in the first
place.

I think the biggest missing piece is pci_common_exit(), the counterpart
of pci_common_init(), to cleanup a host bridge on ARM. I haven't looked
in detail at the other architectures, but I suspect there must be some
code to call when a host bridge is removed.

Looking at drivers/pci/remove.c, it seems like pci_remove_root_bus()
might be what we're looking at. It isn't exported so it can't be used by
modules, but that can be changed. Is that how a host bridge is typically
removed from the system?

Thierry

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRuvYWAAoJEN0jrNd/PrOhkAgQAJTtOn0GJ8ho/oFuRmDVC/bk
sc2guYC3/M2NK6JHpZFjb5Etylru0j6dC+8ivPH7uQlYg6AOZuOpSGk1bwmE8geM
rzy0nRQw3JiPwtCY9rNT1NC9d4pVlfTRjzJJ6b4kfazE9ia0SyHFodbdbZER0dU0
WuL+F2cWHYYDtYibEHRlBxG7fGPSrXnETE68kvMUCErBwMnyzsv+DXVhz1aN+F4c
ZugaoEx3FFREGByxrS8msFjaoLca38ZRqA7mVRiaz+3ArghRwTGo+KTO2ArGsb5e
J3gGqgJTUEWB3sDj3XLxaUQvCYHcd0dgHRDiAKE1iGZ3s3M8eQ/EaqemL9Utxx/w
75LFWUhOaMjFFfQZJ2L+KA2FS/XQyUC4G4CVh0CtLoOaJMw2HbgqMy6fSUd9Cm5s
jVDaxbtYGULrYpywxhgxQi1UwkjsGgA3Yq0hWowlKTqBtE3elZ8l2BqbMzMf+Yko
DUKBVRahRl+PB7Wc5OZsoWrnQ64LeErhzDW15018+Cdrq6QOr5QzQUqvl6yMBl08
C/Rk45vLkTpwmzUkVw8ZafybmKH4qCG6XUFkLnMON1BgxE1lvkcbTDqsOW0IREQs
gpFKyCpkbJV1xzRzf7w+Fg53ezNXtE1Xu8Gq2WWV052boBCvMq/bIb4juINceBpI
QbE9icw15Vwu5aW7b/Eb
=MlcV
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
