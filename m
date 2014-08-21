Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaHUG67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 02:58:59 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:38380 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbaHUG65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 02:58:57 -0400
Date: Thu, 21 Aug 2014 08:58:54 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        wni@nvidia.com
Subject: Re: [PATCH v2 1/5] of: Add descriptions of thermtrip properties to
 Tegra PMC bindings
Message-ID: <20140821065853.GE4486@ulmo>
References: <1407933685-12404-1-git-send-email-mperttunen@nvidia.com>
 <1407933685-12404-2-git-send-email-mperttunen@nvidia.com>
 <53F50231.5010605@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dFWYt1i2NyOo1oI9"
Content-Disposition: inline
In-Reply-To: <53F50231.5010605@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dFWYt1i2NyOo1oI9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 02:16:49PM -0600, Stephen Warren wrote:
> On 08/13/2014 06:41 AM, Mikko Perttunen wrote:
> >Hardware-triggered thermal reset requires configuring the I2C
> >reset procedure. This configuration is read from the device tree,
> >so document the relevant properties in the binding documentation.
>=20
> >diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-=
pmc.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
>=20
> >+Hardware-triggered thermal reset:
> >+On Tegra30, Tegra114 and Tegra124, if the 'i2c-thermtrip' subnode exist=
s,
> >+hardware-triggered thermal reset will be enabled.
>=20
> "will be enabled" sounds like SW behaviour, whereas DT is suppose to
> describe HW, and leave SW to define its own behaviour. I would suggest:
>=20
> Optional sub-nodes:
> i2c-thermtrip: Describes how to power off the system in the event of a
>   thermal emergency.
>=20
> >+Required properties for hardware-triggered thermal reset (inside 'i2c-t=
hermtrip'):
>=20
> Simpler might be:
>=20
> Required properties for i2c-thermtrip node:
>=20
> >+- nvidia,pmu : Phandle to power management unit / PMIC handling poweroff
> >+- nvidia,reg-addr : I2C register address to write poweroff command to
> >+- nvidia,reg-data : Poweroff command to write to PMU
>=20
> Why are both the PMU/PMIC phandle and the register address/data required?=
 I
> thought the purpose of having the phandle was to allow the register addre=
ss
> and data to be queried from the PMU/PMIC driver.
>=20
> To me, it seems much simpler to get rid of the phandle and just hard-code
> the I2C bus number, address, and data into this node, rather than having =
to
> go query it from the PMU/PMIC driver, then find the I2C controller, then
> query it for its ID (and hope that all HW modules that talk to I2C
> controllers directly use the same numbering scheme...)

I originally requested this to be changed. It seems wrong to duplicate
information about the PMIC in both the PMIC device tree node and the
i2c-thermtrip node if we can get the same information from the driver
directly (via the phandle). It certainly requires a little more code,
but at the advantage of not having to figure out the I2C controller
hardware number and I2C slave addresses when writing the i2c-thermtrip
node.

Thierry

--dFWYt1i2NyOo1oI9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9ZitAAoJEN0jrNd/PrOh5AIQAKAzWYyZBKE3hdtEkt6Z/7Al
0tjfhWWOBhNApkzDR7n2AX20ZIHfm1wjDjyeW+pvulsZ8+Ztk79FDwIf6k+vbhiP
xn3iKUXY1QFFy3OmZAxdZWbeBgwqBkGJzH6bwN3BfDQkau+ALXNVgMMY9Eo8O2hh
QZuTRvBphMPsuDM5fJy1eUCjTxaaCxlaK6y6PO1Leshztj2TykOS7J/2OZrWRLLy
6Uk3mv2KRBNZvN/8mT5X/7cyFAsF9eAjcfipDtSf7u+AUGaT0X1ckFkbMlLlJXQ7
qxaXjH/EG4vd85rWeGCG+bKHC3LkjF4DpZjCuVr+9S1wHZu7GqtRaImgGH31etNl
h12Fcm9r3P3gWbIElWDW9mxdeSd5RLrGuYche5zamyZ1ALkAqFP0QSG15w6mW2SU
WspCu6z1bGjubSiVn52dZPApPpYEPz7i/HkIiiE8FhFhE+XiPK/68W0A0RaEp0hB
gX8mqlSg5R83UCh0MjPceqBrXoRP6ZMBe6I7j8umh20RAMCwfKj5FS6jLACv6Ios
N2h634uosCl2kLVahw+9eZbGieyog/C6E/YJHalnDHdKg/HV5Rjs3KL1gkSfSoIV
OGxyO2+gkM+YriagMbXMC0ZLl9jy+zcGuYtybaEZNoa773Px6xItcas0RpBXFP8g
4go5rR96j3GzIyMAxm/U
=uKsO
-----END PGP SIGNATURE-----

--dFWYt1i2NyOo1oI9--
