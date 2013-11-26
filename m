Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab3KZSKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:10:15 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:63933 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab3KZSKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:10:12 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: balbi@ti.com
Subject: Re: BUG: usb: obex in g_nokia.ko causing kernel panic
Date: Tue, 26 Nov 2013 19:10:08 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        freemangordon@abv.bg, Sebastian Reichel <sre@ring0.de>
References: <201311191151.17153@pali> <201311261828.05990@pali> <20131126173953.GQ24310@saruman.home>
In-Reply-To: <20131126173953.GQ24310@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1961162.PLKbNHumOs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311261910.08537@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1961162.PLKbNHumOs
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 26 November 2013 18:39:54 Felipe Balbi wrote:
> Hi,
>=20
> On Tue, Nov 26, 2013 at 06:28:05PM +0100, Pali Roh=C3=A1r wrote:
>=20
> [ snip ]
>=20
> > > > (above dump is from 3.12-rc5 kernel)
> > >=20
> > > looks like it's trying to do i2c transfers from atomic.
> > > But why only when obex is enabled ? Makes no sense. What
> > > do you have on userland ? Is there anything trying to
> > > access the obex interface ? Was the USB cable attached at
> > > that time ?
> >=20
> > Yes, only when initliaizing obex. Other is ok. Problem is
> > there with Maemo userland and also with clean userland
> > (rescueOS) where is only busybox and some simple init
> > scripts. On Maemo maybe something is trying to access obex,
> > but on rescueOS for sure nothing. Problem happends when
> > cable is attached and also when not =3D always.
>=20
> As a debug effort, can you apply hack below and see if it
> "helps" ?
>=20
> diff --git a/drivers/usb/gadget/f_obex.c
> b/drivers/usb/gadget/f_obex.c index ad39f1d..4af2f06 100644
> --- a/drivers/usb/gadget/f_obex.c
> +++ b/drivers/usb/gadget/f_obex.c
> @@ -267,10 +267,12 @@ static void obex_connect(struct gserial
> *g) if (!obex->can_activate)
>  		return;
>=20
> +#if 0
>  	status =3D usb_function_activate(&g->func);
>  	if (status)
>  		DBG(cdev, "obex ttyGS%d function activate --> %d\n",
>  			obex->port_num, status);
> +#endif
>  }
>=20
>  static void obex_disconnect(struct gserial *g)
> @@ -282,10 +284,12 @@ static void obex_disconnect(struct
> gserial *g) if (!obex->can_activate)
>  		return;
>=20
> +#if 0
>  	status =3D usb_function_deactivate(&g->func);
>  	if (status)
>  		DBG(cdev, "obex ttyGS%d function deactivate --> %d\n",
>  			obex->port_num, status);
> +#endif
>  }
>=20
>  /*-----------------------------------------------------------
> --------------*/ @@ -372,6 +376,7 @@ static int
> obex_bind(struct usb_configuration *c, struct usb_function
> *f) if (status)
>  		goto fail;
>=20
> +#if 0
>  	/* Avoid letting this gadget enumerate until the userspace
>  	 * OBEX server is active.
>  	 */
> @@ -381,6 +386,7 @@ static int obex_bind(struct
> usb_configuration *c, struct usb_function *f) obex->port_num,
> status);
>  	else
>  		obex->can_activate =3D true;
> +#endif
>=20
>=20
>  	DBG(cdev, "obex ttyGS%d: %s speed IN/%s OUT/%s\n",

Hi, with above patch g_nokia.ko working and not crashing.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1961162.PLKbNHumOs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKU5AAACgkQi/DJPQPkQ1LzYQCcD124GO/TUNTU7NxRav2SCbEm
wmgAniugNnJob81ciHGWiK3kY6XIR5Fq
=Ar8n
-----END PGP SIGNATURE-----

--nextPart1961162.PLKbNHumOs--
