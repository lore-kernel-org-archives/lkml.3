Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaBRVkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:40:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38057 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaBRVkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:40:13 -0500
Date: Tue, 18 Feb 2014 22:40:07 +0100
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        stable@vger.kernel.org
Subject: Re: [PATCH] regulator: core bugfix: Use normal enable for always_on
 regulators
Message-ID: <20140218214007.GE10590@pengutronix.de>
References: <1392577256-20475-1-git-send-email-mpa@pengutronix.de>
 <20140218001420.GF2669@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wTWi5aaYRw9ix9vO"
Content-Disposition: inline
In-Reply-To: <20140218001420.GF2669@sirena.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:29:14 up 178 days,  7:00, 46 users,  load average: 0.05, 0.05,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wTWi5aaYRw9ix9vO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2014 at 09:14:20AM +0900, Mark Brown wrote:
> On Sun, Feb 16, 2014 at 08:00:56PM +0100, Markus Pargmann wrote:
>=20
> Please use more standard subject lines, don't do things like "core
> bugfix", just write a normal changelog.

Okay, will fix.

>=20
> > +static int _regulator_do_enable_no_delay(struct regulator_dev *rdev)
> > +{
> > +	int ret;
> > +
> > +	if (rdev->ena_pin) {
> > +		ret =3D regulator_ena_gpio_ctrl(rdev, true);
> > +		if (ret < 0)
> > +			return ret;
> > +		rdev->ena_gpio_state =3D 1;
> > +	} else if (rdev->desc->ops->enable) {
> > +		ret =3D rdev->desc->ops->enable(rdev);
> > +	} else {
> > +		ret =3D -EINVAL;
> > +	}
> > +
> > +	return ret;
> > +}
>=20
> I don't understand this.  Why is this called _no_delay() and why don't
> we want to delay when applying constraints?  We don't want to ever be in
> a position where we think a supply is enabled but it has in fact not
> finished ramping, and of course enable() may in fact be blocking anyway.

I tried not to modify the current behaviour of the core driver for
non-gpio regulators. Before this patch only ops->enable() was called
which also didn't have a delay. So I seperated the non-delay enable
function to have the same behaviour for normal regulators.

Also the constraints are applied when registering a new regulator. For
"boot-on" we should not delay because this regulator is already on by
definition. But I am not sure what to do with always-on regulators?

Thanks,

Markus


--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--wTWi5aaYRw9ix9vO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTA9M3AAoJEEpcgKtcEGQQZ+kP/j6q5PfmjTcW2kXnIpfdro2N
9wKBaTcued2v1+dnANfGEpLR74p/xnc8Pvbf906Ix315h7/hjqCRVZIUNZ5mkHEr
eIqFOe2Hn96WUokCnpMcZdmSNSDto9i3ENdDhcMS9AO4aw+Y0UaVefcdouVOG8IW
DUsWHxeR6YBnL/2nfCSrfc/mvpx4Ew5MxlkUKJUWoGiuCPQaGKJpTwT2cTOHTfeE
9Yw+zxDIT9XBo8EHiI3BgieUDvkgDVw57CiuDWNXubkNsPIR5UTcivqsPEwSA4VE
/bokBAYMV3wK7xgniYrIC/5Xqz2sIi3mg8R/odMcP5qENcQ0pV2h+HscnHc9gGxe
q9/5QLY6fk77bgPyEs9M3DYc5rbZL3lSpsei9UGBHZ+PG72io9QiIzIBBftlUb+M
B7JKNA8eo65Urpu+7GeDTr/GvfihA3MQRKZI0RDe3n451iz+A8yufedYbWKq/Zdm
l3S5bQGk3dir0rLlR71+oZdojU4IO3piU0VG0G+Rr3FNO3YaE3lJt/Vk780Domam
/dM0o/lKlqhEHURLHvPXgT/AX+vbZknLgdeXt1DW708etSg9m/EHCknM+YKIZKPT
JCCNNl/m9Yzk5OT8JV51R9fzcPx5mPUyDUDiIwUmz5XIN9WX2mi1m/xq+6zTeOSD
Rn/7vXaj/S1Sm3ciEINt
=wexj
-----END PGP SIGNATURE-----

--wTWi5aaYRw9ix9vO--
