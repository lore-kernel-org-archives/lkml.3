Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab3KZRks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:40:48 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55872 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab3KZRkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:40:46 -0500
Date: Tue, 26 Nov 2013 11:39:54 -0600
From: Felipe Balbi <balbi@ti.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        <freemangordon@abv.bg>, Sebastian Reichel <sre@ring0.de>
Subject: Re: BUG: usb: obex in g_nokia.ko causing kernel panic
Message-ID: <20131126173953.GQ24310@saruman.home>
Reply-To: <balbi@ti.com>
References: <201311191151.17153@pali>
 <20131126171606.GO24310@saruman.home>
 <201311261828.05990@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Ocr+Jy+jPJR1APa"
Content-Disposition: inline
In-Reply-To: <201311261828.05990@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/Ocr+Jy+jPJR1APa
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 26, 2013 at 06:28:05PM +0100, Pali Roh=E1r wrote:

[ snip ]

> > > (above dump is from 3.12-rc5 kernel)
> >=20
> > looks like it's trying to do i2c transfers from atomic. But
> > why only when obex is enabled ? Makes no sense. What do you
> > have on userland ? Is there anything trying to access the
> > obex interface ? Was the USB cable attached at that time ?
>=20
> Yes, only when initliaizing obex. Other is ok. Problem is there=20
> with Maemo userland and also with clean userland (rescueOS) where=20
> is only busybox and some simple init scripts. On Maemo maybe=20
> something is trying to access obex, but on rescueOS for sure=20
> nothing. Problem happends when cable is attached and also when=20
> not =3D always.

As a debug effort, can you apply hack below and see if it "helps" ?

diff --git a/drivers/usb/gadget/f_obex.c b/drivers/usb/gadget/f_obex.c
index ad39f1d..4af2f06 100644
--- a/drivers/usb/gadget/f_obex.c
+++ b/drivers/usb/gadget/f_obex.c
@@ -267,10 +267,12 @@ static void obex_connect(struct gserial *g)
 	if (!obex->can_activate)
 		return;
=20
+#if 0
 	status =3D usb_function_activate(&g->func);
 	if (status)
 		DBG(cdev, "obex ttyGS%d function activate --> %d\n",
 			obex->port_num, status);
+#endif
 }
=20
 static void obex_disconnect(struct gserial *g)
@@ -282,10 +284,12 @@ static void obex_disconnect(struct gserial *g)
 	if (!obex->can_activate)
 		return;
=20
+#if 0
 	status =3D usb_function_deactivate(&g->func);
 	if (status)
 		DBG(cdev, "obex ttyGS%d function deactivate --> %d\n",
 			obex->port_num, status);
+#endif
 }
=20
 /*------------------------------------------------------------------------=
-*/
@@ -372,6 +376,7 @@ static int obex_bind(struct usb_configuration *c, struc=
t usb_function *f)
 	if (status)
 		goto fail;
=20
+#if 0
 	/* Avoid letting this gadget enumerate until the userspace
 	 * OBEX server is active.
 	 */
@@ -381,6 +386,7 @@ static int obex_bind(struct usb_configuration *c, struc=
t usb_function *f)
 			obex->port_num, status);
 	else
 		obex->can_activate =3D true;
+#endif
=20
=20
 	DBG(cdev, "obex ttyGS%d: %s speed IN/%s OUT/%s\n",

--=20
balbi

--/Ocr+Jy+jPJR1APa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlNzpAAoJEIaOsuA1yqREIfcP/0uDR8zNFcYPlQw83JEc8P+1
kXFRysWkGnyVfTvF7vDXmKpZAKqp+nizD9HfAzBGbdcwThwm9/68eo2BYlULObYQ
KBS5zivz+Hc6KG19KHB/n2l/sheKwuncJ8afkHQIElGn8ng49wbij4ow1zGk6rhF
XD1y8GzR8QyZA23vSA5tEER2zZDmWYblPC9+62PvoOvggqx/GRDaV4WvFWTCncpC
9fXBzvPlqL9BLY2UAuOXUA4BcJPhYfqtFgIHYRVueVHyK0MNQv8aaQulfsIanpRo
1IU38k+bi2oY/lcbibM92KBS21P5wIAYff3TB8JOQ3Dlr48r6MEZEr6wp43unOgf
fyDU8uN5C/gvBcn2Nu6o9Oczm177zPT7p3GG7eRaUEuHrPOaIgrPBUaOPtNpX1MA
Xf9ro6scYr9k8OwXDkjaRmCzs+caS+bj1Ssa03H/Gw6K+jpjwz/m+59HBeCykPCM
7VQnSQWEfNZGb/EcVszjrAettLcglUEfgcsq6BRSYBNGyJ1GR8o9SD/hLNs9za0i
MaCzjCBNMLwvt3vZ4nn29NETMMm2JFsYY/zzACkSt/BET44XDlV4xJV2eYkrfo6t
x14hBRNJ1AA8Lx8yZgdby7oC5r1+F18ha28YFo5Q1lwtq2vZwGhxw5x0kZA1bdx9
R71Q1AZa2DubnuLFGvD2
=AwJp
-----END PGP SIGNATURE-----

--/Ocr+Jy+jPJR1APa--
