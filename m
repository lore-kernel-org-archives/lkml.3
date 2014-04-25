Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbaDYSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 14:25:56 -0400
Received: from mail.kernel.org ([198.145.19.201]:58681 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbaDYSZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 14:25:47 -0400
Date: Fri, 25 Apr 2014 20:25:36 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCHv3 07/14] HSI: Add common DT binding for HSI client devices
Message-ID: <20140425182535.GB22721@earth.universe>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
 <1396053110-21639-8-git-send-email-sre@kernel.org>
 <20140419191612.GG5148@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <20140419191612.GG5148@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 19, 2014 at 09:16:12PM +0200, Pavel Machek wrote:
> On Sat 2014-03-29 01:31:43, Sebastian Reichel wrote:
> > Implement and document generic DT bindings for HSI clients.
> >=20
> > Signed-off-by: Sebastian Reichel <sre@kernel.org>
>=20
> Reviewed-by: Pavel Machek <pavel@ucw.cz>
>=20
> > diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
> > index 07e1639..5973906 100644
> > --- a/drivers/hsi/hsi.c
> > +++ b/drivers/hsi/hsi.c
> > @@ -26,8 +26,14 @@
> >  #include <linux/slab.h>
> >  #include <linux/string.h>
> >  #include <linux/notifier.h>
> > +#include <linux/of.h>
> > +#include <linux/of_device.h>
> >  #include "hsi_core.h"
>=20
>=20
> > +	err =3D hsi_of_property_parse_mode(client, "hsi-mode", &mode);
> > +	if (err) {
> > +		err =3D hsi_of_property_parse_mode(client, "hsi-rx-mode",
> > +						 &cl->rx_cfg.mode);
> > +		if (err)
> > +			goto err;
> > +
> > +		err =3D hsi_of_property_parse_mode(client, "hsi-tx-mode",
> > +						 &cl->tx_cfg.mode);
> > +		if (err)
> > +			goto err;
>=20
> Will this need some #ifdef CONFIG_OF?

It would only be needed to reduce the amount of kernel code for
disabled Device Tree. I don't think its worth it, since there is no
platform in the mainline kernel, which uses HSI without DT.

-- Sebastian

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTWqifAAoJENju1/PIO/qaqTMP/RurK4MvmYaf+TBeEsZY1QWN
Kxb4+o8O6hWkhAhNIrXEVNunJ/TwgR2tYo+fyhYS5HSzngs8uDo5qqDnXVHsSDnm
LXbXfnpBduhpYZ4v74XCQ09eeX/dyYaJRFQi22wP3E3PUZqNMFIHK7zAC2Ggdocd
6rz+f+NZrW/BEEx079UYb4DSq4x4vZ/H5CWfncsKVdxZnh5tO6ixfx0XlXJ0U/T3
b1Qpl55zNheVih5uiDyW0XDurrbfcquCpt90FDhNueWGnz59UGMfbke1W/7UU3vG
+d7Xk8PP/ZqyvHjRXvXr34WAXK7mS5LnP0ewO2ta6XnU3xMOwgyef1dYtKqRPf2R
qTLea7uOnmqdyKGiHqrKW47okWA4sueJHp4khy8f9E2mWOD7Xq7gfYMGBDD62M1z
3jjJG4TCF0smONNh/b3kgPn8ayVaL7l7eJazWEzk6AOMWigQyXQ6sAyM99vuPunU
jzswVHEwEDBnUxz2009/5KjA3R1H4ll9V61p7WDiiGMd/BBRHpySJB6ueAvNsJOV
3cJhCzbKNlpxM5afVOOM/sAZ/2Wgu6nZxDJU7warnaCTYRzOuMXUsOXICw5MEDlo
yYj9m3eECT7G4BtU9ugCs/VZ1yJPJyDOIwNbUa2NQeXb7hZtIoTcQHD7h3nlOboP
f1WojDKwCjBc3C/CrpEF
=cMrF
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
