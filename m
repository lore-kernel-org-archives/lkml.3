Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916AbaAaWNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 17:13:04 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39441 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290AbaAaWNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 17:13:02 -0500
Date: Fri, 31 Jan 2014 16:11:19 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <ivan.khoronzhuk@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: keystone: switch to use runtime pm
Message-ID: <20140131221118.GE2502@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140131164534.GL20736@saruman.home>
 <Pine.LNX.4.44L0.1401311608590.12368-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p8PhoBjPxaQXD0vg"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1401311608590.12368-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--p8PhoBjPxaQXD0vg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2014 at 04:13:19PM -0500, Alan Stern wrote:
> On Fri, 31 Jan 2014, Felipe Balbi wrote:
>=20
> > probe()
> > {
> > 	...
> >=20
> > 	clk_get(dev, "fck");
> > 	clk_prepare(clk);
> > 	clk_enable(clk);
> > 	pm_runtime_set_active(dev);
> > 	pm_runtime_enable(dev);
> > 	pm_runtime_get_sync(dev);
> > 	...
> > }
>=20
> > note that because of pm_runtime_set_active() that first
> > pm_runtime_get_sync() in probe() will simply increase the reference
> > counter without calling my ->runtime_resume() callback, which is exactly
> > what we want, as that would completely avoid situations of bad context
> > being restored because of that initial pm_runtime_get_sync().
>=20
> Very minor note...  A slightly better way to do the same thing is:
>=20
> 	pm_runtime_set_active(dev);
> 	pm_runtime_get_noresume(dev);
> 	pm_runtime_enable(dev);
>=20
> The get_noresume says that you want to increment the usage counter
> without performing any callbacks, and doing it before the
> pm_runtime_enable avoids any window during which a runtime suspend
> might somehow occur.

aha, that's perfect :-) Thanks Alan.

--=20
balbi

--p8PhoBjPxaQXD0vg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS7B+GAAoJEIaOsuA1yqREP40P/1agEQcM6KWxst76rStk5YJ3
bS9IVeT1xd1JN4BYW/8ICbfpBj2+upxtfRJgrrb2/kvViulOrh79gRb4w96dhhd1
EZ3J1LDMHrBglH7xamjYEH7UWi2nxj0I1z6FKITZqN/0i9qPxeqKuh5yZjOZh/8u
nWHzSeFOWiOdQ5E9f1w4k9BnwYYpiNdH8sGaeQvbxBesraJ24xTH04A6uFRno+KG
TvPqVRKG4Koorwyb1cjeT/1nxsfbyzHzn8tX/wuecSs1uRwoT/GwIgbe+aRtzP+v
bL5Adg3W783D75nIJV9/CwEgZW7EwApy4vTwbD5V5Et7bRuC9/JW/zTB6P+lZ69Z
zqh2O7qxlrTYnf/e/MEESRes13WHNaqMk+zeQx71fF57ERrUmMcME7ugxQdy1ZmC
KYpaAVZEUNAMUX9CFMSHUqTUEfpQIP8w3aC0401qxJ8WjTeQX4LrhRWMtdHZSE5o
qzptYtmEAqaOBXbKXK1lF+WeDlG9j3lFziXoJIPiRSbfwxGi1Ngsg5mnsPvYz44n
Egi8zZRADil9SAvxkn3DhyUfPq5QMTz9m2qWkusjspjHnRO87IHprJsceOK9AFxD
oEMdBFNTZ5w7CkL1kdj8ssDAqesdG7y/lhUFuoQ32yfD4Q5K24nhgL3DNPD9/w2s
hSr0RoW8tMPiVw9G95VQ
=j6jY
-----END PGP SIGNATURE-----

--p8PhoBjPxaQXD0vg--
