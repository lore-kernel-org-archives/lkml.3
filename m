Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaHFBjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 21:39:46 -0400
Received: from ozlabs.org ([103.22.144.67]:43406 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107AbaHFBjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 21:39:44 -0400
Date: Wed, 6 Aug 2014 11:39:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pratyush Anand <pratyush.anand@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <treding@nvidia.com>
Subject: Re: linux-next: build failure after merge of the usb tree
Message-ID: <20140806113935.6728d15c@canb.auug.org.au>
In-Reply-To: <20140724074452.GB11963@kroah.com>
References: <20140724170755.035cea1c@canb.auug.org.au>
	<20140724074452.GB11963@kroah.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/l9Zh7_pExo38Nh.L_/_Ohy3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/l9Zh7_pExo38Nh.L_/_Ohy3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 24 Jul 2014 00:44:52 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Thu, Jul 24, 2014 at 05:07:55PM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> >=20
> > After merging the usb tree, today's linux-next build (x86_64 allmodconf=
ig)
> > failed like this:
> >=20
> > drivers/phy/phy-spear1310-miphy.c: In function 'spear1310_miphy_probe':
> > drivers/phy/phy-spear1310-miphy.c:232:14: warning: passing argument 2 o=
f 'devm_phy_create' from incompatible pointer type
> >   priv->phy =3D devm_phy_create(dev, &spear1310_miphy_ops, NULL);
> >               ^
> > In file included from drivers/phy/phy-spear1310-miphy.c:21:0:
> > include/linux/phy/phy.h:164:13: note: expected 'struct device_node *' b=
ut argument is of type 'struct phy_ops *'
> >  struct phy *devm_phy_create(struct device *dev, struct device_node *no=
de,
> >              ^
> > drivers/phy/phy-spear1310-miphy.c:232:14: error: too few arguments to f=
unction 'devm_phy_create'
> >   priv->phy =3D devm_phy_create(dev, &spear1310_miphy_ops, NULL);
> >               ^
> > In file included from drivers/phy/phy-spear1310-miphy.c:21:0:
> > include/linux/phy/phy.h:164:13: note: declared here
> >  struct phy *devm_phy_create(struct device *dev, struct device_node *no=
de,
> >              ^
> > drivers/phy/phy-spear1340-miphy.c: In function 'spear1340_miphy_probe':
> > drivers/phy/phy-spear1340-miphy.c:264:14: warning: passing argument 2 o=
f 'devm_phy_create' from incompatible pointer type
> >   priv->phy =3D devm_phy_create(dev, &spear1340_miphy_ops, NULL);
> >               ^
> > In file included from drivers/phy/phy-spear1340-miphy.c:21:0:
> > include/linux/phy/phy.h:164:13: note: expected 'struct device_node *' b=
ut argument is of type 'struct phy_ops *'
> >  struct phy *devm_phy_create(struct device *dev, struct device_node *no=
de,
> >              ^
> > drivers/phy/phy-spear1340-miphy.c:264:14: error: too few arguments to f=
unction 'devm_phy_create'
> >   priv->phy =3D devm_phy_create(dev, &spear1340_miphy_ops, NULL);
> >               ^
> > In file included from drivers/phy/phy-spear1340-miphy.c:21:0:
> > include/linux/phy/phy.h:164:13: note: declared here
> >  struct phy *devm_phy_create(struct device *dev, struct device_node *no=
de,
> >              ^
> >=20
> > Caused by commit f0ed817638b5 ("phy: core: Let node ptr of PHY point to
> > PHY and not of PHY provider") interacting with commit 64562e99477f
> > ("phy: Add drivers for PCIe and SATA phy on SPEAr13xx") from the
> > arm-soc tree.
> >=20
> > I fixed that up and then got:
> >=20
> > drivers/pinctrl/pinctrl-tegra-xusb.c: In function 'tegra_xusb_padctl_pr=
obe':
> > drivers/pinctrl/pinctrl-tegra-xusb.c:913:8: warning: passing argument 2=
 of 'devm_phy_create' from incompatible pointer type
> >   phy =3D devm_phy_create(&pdev->dev, &pcie_phy_ops, NULL);
> >         ^
> > In file included from drivers/pinctrl/pinctrl-tegra-xusb.c:18:0:
> > include/linux/phy/phy.h:164:13: note: expected 'struct device_node *' b=
ut argument is of type 'const struct phy_ops *'
> >  struct phy *devm_phy_create(struct device *dev, struct device_node *no=
de,
> >              ^
> > drivers/pinctrl/pinctrl-tegra-xusb.c:913:8: error: too few arguments to=
 function 'devm_phy_create'
> >   phy =3D devm_phy_create(&pdev->dev, &pcie_phy_ops, NULL);
> >         ^
> > In file included from drivers/pinctrl/pinctrl-tegra-xusb.c:18:0:
> > include/linux/phy/phy.h:164:13: note: declared here
> >  struct phy *devm_phy_create(struct device *dev, struct device_node *no=
de,
> >              ^
> > drivers/pinctrl/pinctrl-tegra-xusb.c:922:8: warning: passing argument 2=
 of 'devm_phy_create' from incompatible pointer type
> >   phy =3D devm_phy_create(&pdev->dev, &sata_phy_ops, NULL);
> >         ^
> > In file included from drivers/pinctrl/pinctrl-tegra-xusb.c:18:0:
> > include/linux/phy/phy.h:164:13: note: expected 'struct device_node *' b=
ut argument is of type 'const struct phy_ops *'
> >  struct phy *devm_phy_create(struct device *dev, struct device_node *no=
de,
> >              ^
> > drivers/pinctrl/pinctrl-tegra-xusb.c:922:8: error: too few arguments to=
 function 'devm_phy_create'
> >   phy =3D devm_phy_create(&pdev->dev, &sata_phy_ops, NULL);
> >         ^
> > In file included from drivers/pinctrl/pinctrl-tegra-xusb.c:18:0:
> > include/linux/phy/phy.h:164:13: note: declared here
> >  struct phy *devm_phy_create(struct device *dev, struct device_node *no=
de,
> >              ^
> >=20
> > From an interaction with commit dc0a39386687 ("pinctrl: Add NVIDIA
> > Tegra XUSB pad controller support") from the arm-soc tree.
> >=20
> > Final merge fix patch:
>=20
> Ugh, what a mess, sorry about that.  I'll keep this around for if I end
> up merging with Linus after these other trees get merged.

Since the usb tree has gone upstream, this merge fix patch is now
needed when the arm-soc tree is merged.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/l9Zh7_pExo38Nh.L_/_Ohy3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT4YddAAoJEMDTa8Ir7ZwV5I0QAIXVtJ1570jYuRjamkLFSMmP
JaThgXjZw2GsH121g0G+2vtF/nuvRqkV/0rO80CujeVhXsHfaFpJ2IDMEb+p/UIb
B1ZL1hLmYFedXl1XbRZwckrZwUKOz1f8y174nWF0+3pbizIKMOf8f+8lZJkBQ2/1
UsYUHTyQA5mYIGoslUq3SnAvtZu0HawvhYA23bpHmTIhWpsqiISNppl52ZW28K+7
C7x3FJcFmaFQsZketBNLRWM0pAeip4nQGXMlBWxS9BoVYgB4srJwoGEST3j/5tE9
uEzSOnlXrfPGz4aIR1Ak8WYq0UBF0WztLSC/gw/uD8+SDHYC4iwTH1iEkvKVkLSQ
h8xDol2b4512Bw7fDKkcZCoJ+vz3oEW9eVaaxIMgX45QUYpQpBBPrkHCsDvoXL/B
LF7vMpeh1YVoGD6r82Reef06cBKRQQNHFym7/hJmmt6eSZhWngA5XLTttj+jNrqF
f0UlBF5+mudsZrhpjVICHUdJ48c/MifTuo3FwfwwcuP4bRdE8y0W54V3lEcRenL1
BBpsQvztd0dusYm79u34en5QmsilIY4ZNoglY8Qni3E7lb2FjAewdCs0wZr8NB88
TAlSY43s1LQo/mpqHKQLl/B4ZjQny1k9r7pyOGmQqxeyyd/55IkWIZ70disfn8KP
2BtJhJn0IU93Lr9+O/8c
=GZd1
-----END PGP SIGNATURE-----

--Sig_/l9Zh7_pExo38Nh.L_/_Ohy3--
