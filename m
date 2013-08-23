Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3HWJXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 05:23:08 -0400
Received: from mail-bk0-f65.google.com ([209.85.214.65]:49814 "EHLO
	mail-bk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab3HWJXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 05:23:04 -0400
Date: Fri, 23 Aug 2013 11:22:38 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Pratyush Anand <pratyush.anand@st.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        Siva Reddy Kallam <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH V2] PCI: exynos: add support for MSI
Message-ID: <20130823092238.GJ3535@ulmo>
References: <003d01ce9fc6$9c0f1c20$d42d5460$%han@samsung.com>
 <20130823083539.GB3937@pratyush-vbox>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XigHxYirkHk2Kxsx"
Content-Disposition: inline
In-Reply-To: <20130823083539.GB3937@pratyush-vbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XigHxYirkHk2Kxsx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 23, 2013 at 02:05:39PM +0530, Pratyush Anand wrote:
> On Fri, Aug 23, 2013 at 02:04:20PM +0800, Jingoo Han wrote:
[...]
> > +
> >  static struct hw_pci dw_pci;
> >=20
> >  unsigned long global_io_offset;
> > @@ -144,6 +152,205 @@ int dw_pcie_wr_own_conf(struct pcie_port *pp, int=
 where, int size,
> >         return ret;
> >  }
> >=20
>=20
> [...]
>=20
> >  int dw_pcie_link_up(struct pcie_port *pp)
> >  {
> >         if (pp->ops->link_up)
> > @@ -225,6 +432,13 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> >                 return -EINVAL;
> >         }
> >=20
> > +       if (IS_ENABLED(CONFIG_PCI_MSI)) {
> > +               if (of_property_read_u32(np, "msi-base", &pp->msi_irq_s=
tart)) {
> > +                       dev_err(pp->dev, "Failed to parse the number of=
 lanes\n");
> > +                       return -EINVAL;
> > +               }
> > +       }
> > +
>=20
> What if an implementor want to use irq_domain method for msi_irq_start
> allocation? Is it fine to return error if msi-base is not passed from
> dt?

I agree. This should be using an IRQ domain to represent the MSI
controller. Both Tegra and Marvell drivers do that already and if Exynos
can follow that same path it will increase the chances of refactoring
common bits.

Also the error message doesn't quite match up with what the code is
doing. =3D)

Thierry

--XigHxYirkHk2Kxsx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSFyneAAoJEN0jrNd/PrOhDAIQAKOeEA49U2PfcVhTnerHhzez
U7eFZ4i+C39l/qcGEqckiq7QkDI7osqJBhlmjYjXBLGXaJuWy5lVpWd0OY8RK8Xs
jqfKDvO5K6BAq7+djYFF4s/tTXBE756OXx2vnUXxlla67roeqCS6x/yFZto5MmD5
HxlDXs0PdZOtsQ4RiS6qRu8BvUwYdGsa1mwcxWgdsoVeqXu5e93NojyQtJorUdLo
JhiAM5koWX/6Ms8v3HrxghVxRsu+5+pOalFA5hwNrW3uylmEGjOVxuSVVe+zIonA
ztxRXKHN7y3AFuCD7mLJegRW3Ffp37oTUfJI4DgzBnUHtl8iFJ2jj667in8syvnJ
84YyxUxEyr/z2ZhTMR+ZPT5hhM77FXXA4GZgaIL+wQIHzIYamX55qyqSt+qJiL4d
NEhMwsDVa9Hi98PeimtLLqe1xNQg4wEaiVdGOOJtdsxue5ZjphUKH9lDq9GHYCwg
H3DSf/r5tm386Lk7GpSJKP9GjdJ1VisXmnGM3QKheyNmU0odhR30Stfmb/0WYKPE
3HDRamcY8n1Hez7aAzjMfAeBfgOCnnBX36IwyurDjsXesNK8u8vcf3jZyoC67Wfm
O9UAV2fKvxxSsSBNXewzVvj8W/pkZ/3gQU1vXWz6EtpGpmcYKakVKwGFARXK8QvJ
Xv7iRE1L+M2U3mtH6i0P
=8SnG
-----END PGP SIGNATURE-----

--XigHxYirkHk2Kxsx--
