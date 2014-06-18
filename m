Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966418AbaFRMpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:45:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53093 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966162AbaFRMpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:45:14 -0400
Date: Wed, 18 Jun 2014 14:44:26 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v4 4/7] regulator: axp20x: reset probe data before each
 probe
Message-ID: <20140618124426.GU19730@lukather>
References: <1402990723-28138-1-git-send-email-boris.brezillon@free-electrons.com>
 <1402990723-28138-5-git-send-email-boris.brezillon@free-electrons.com>
 <20140617204449.GD19730@lukather>
 <53A13BBF.7090202@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AHVSF3we4xtO5oi5"
Content-Disposition: inline
In-Reply-To: <53A13BBF.7090202@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AHVSF3we4xtO5oi5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2014 at 09:11:59AM +0200, Boris BREZILLON wrote:
>=20
> On 17/06/2014 22:44, Maxime Ripard wrote:
> > On Tue, Jun 17, 2014 at 09:38:40AM +0200, Boris BREZILLON wrote:
> >> The init_data and of_node fields of the axp2xx_matches tables are fill=
ed
> >> at each device probe by the axp20x_regulator_parse_dt function (which =
then
> >> calls the of_regulator_match function).
> >> This means we can probe a new device and consider data initialized dur=
ing
> >> the probe of another device as valid.
> >>
> >> Reset init_data and of_node field to NULL before each probe in order to
> >> avoid this kind of issue.
> >>
> >> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> >> ---
> >>  drivers/regulator/axp20x-regulator.c | 9 +++++++++
> >>  1 file changed, 9 insertions(+)
> >>
> >> diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/=
axp20x-regulator.c
> >> index 7a30f49..d42bf6d 100644
> >> --- a/drivers/regulator/axp20x-regulator.c
> >> +++ b/drivers/regulator/axp20x-regulator.c
> >> @@ -324,6 +324,15 @@ static int axp20x_regulator_probe(struct platform=
_device *pdev)
> >>  		nregulators =3D AXP20X_REG_ID_MAX;
> >>  	}
> >> =20
> >> +	/*
> >> +	 * Reset matches table (this table might have been modified by a
> >> +	 * previous AXP2xx device probe).
> >> +	 */
> >> +	for (i =3D 0; i < nmatches; i++) {
> >> +		matches[i].init_data =3D NULL;
> >> +		matches[i].of_node =3D NULL;
> >> +	}
> >> +
> > That looks rather hackish, especially since we've never been in such a
> > case yet, since we have a single PMIC in our system.
>=20
> Even if something is unlikely to happen, it doesn't mean it's impossible.
> I'm pretty sure there are (or will be) some systems containing several
> identical PMICs in the wild, and fixing this possible bug now prevents
> us (or other developers) from having a big headache debugging this in
> the future.
>=20
> BTW, what is hackish in this code ?

Pretty what Hans was saying, either you think that there will only be
one single instance of the driver, and using a global definition is
fine, or you can have several instances of the driver, and in this
case you'll use a dynamic allocation, but you seem to be stuck in
between.

I understand that you might not want to redeclare by hand the whole
match content, so maybe you can just use memcpy from the global
definition then.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--AHVSF3we4xtO5oi5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToYmqAAoJEBx+YmzsjxAgI9AP/RnF0HKC0jDgeeSyTcHpnJPL
S9J5hf5koJeKv0xvuijRgMnkkFfSIrVHDFqC6x3hFTTvrzEPSahj35zbG4Afc2US
Qo7r+TJIwqIFdWtyEsfeRScB/21mM7XGaRXZ3VFzWvfBpsUhXy0JHVao9eTnmGvS
Gvhs4mX5BN3NU+FMaayA8xDfP65mSRdqWKYU0M4EgOqELDe6CVBY64yz+jM7yBmS
lfL6hqRmXqHghseSwG++FAQlFxaB+nO0DMRQmyqXXl4ymQf6mbNuS4690xuerGyf
vWivovNCGVRt1jL1UyIcyHjBFAXMRneB/xVuqjQ0AawYrg2JQvRZJPu2CQlolb/k
iNukra9qJi5PffNyC2ZHIxrXtbC1QJFF/Fv7OjkGQdKuktM9c4dPQ8BR/g43gi1Q
X/EEanLdIm5uvhhI3UF0uKcGnd8mi/cREm39pf1mKOLMeddG0PmTv2n4hPs7nlif
7aFi4j1Hwd88ZZfEoGMzIf/8bFt9UG6/wAkRJpC3wxNaWIr/KKOxoKNWg6DZqnum
lD/mHeaVjKGNdQjtcd2czGZTn5+Ov2yMst8f18rfZTEgPIHIgbl+jP6PXyQfxmxe
XR7fOVIe4mLDvpGsLhHJq5eLi46KQ6TetU3aUBXLYANodQiBhEM2D2XpR4lQFB7K
idI9e/Z6giokVwNhkHxk
=kqOj
-----END PGP SIGNATURE-----

--AHVSF3we4xtO5oi5--
