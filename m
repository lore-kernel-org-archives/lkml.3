Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab3FMDgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 23:36:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36025 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932343Ab3FMDgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 23:36:12 -0400
Message-ID: <1371094554.10688.42.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] USB: serial/ftdi_sio.c Fix kernel oops
From: Ben Hutchings <ben@decadent.org.uk>
To: Lotfi Manseur <lotfi.manseur@gmail.com>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wojciech M Zabolotny <W.Zabolotny@elka.pw.edu.pl>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Lotfi Manseur <lotfi.manseur@imag.fr>, Willy Tarreau <w@1wt.eu>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Jun 2013 04:35:54 +0100
In-Reply-To: <1370610872-1309-1-git-send-email-lotfi.manseur@imag.fr>
References: <1370610872-1309-1-git-send-email-lotfi.manseur@imag.fr>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-RG/DP9eDkh7Ck3G+E8y+"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RG/DP9eDkh7Ck3G+E8y+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-06-07 at 15:14 +0200, Lotfi Manseur wrote:
> Handle null termios in ftdi_set_termios(), introduced in
> commit 552f6bf1bb0eda0011c0525dd587aa9e7ba5b846
> This has been corrected in the mainline by
> commits c515598e0f5769916c31c00392cc2bfe6af74e55 and
> a816e3113b63753c330ca4751ea1d208e93e3015.
>=20
> This is to be fixed in longterm 2.6.32.60 and 3.4.47.
> This bug has been found with coccinelle.
>=20
> Signed-off-by: Lotfi Manseur <lotfi.manseur@imag.fr>
> Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>

I've queued up those changes for 3.2.  This backported version seems
nicer, but we generally prefer to use patches that are as close as
possible to those in mainline.

Ben.

> ---
>  drivers/usb/serial/ftdi_sio.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.=
c
> index c374beb..615bd9e 100644
> --- a/drivers/usb/serial/ftdi_sio.c
> +++ b/drivers/usb/serial/ftdi_sio.c
> @@ -2364,7 +2364,8 @@ static void ftdi_set_termios(struct tty_struct *tty=
,
> =20
>  	cflag =3D termios->c_cflag;
> =20
> -	if (old_termios->c_cflag =3D=3D termios->c_cflag
> +	if (old_termios
> +	    && old_termios->c_cflag =3D=3D termios->c_cflag
>  	    && old_termios->c_ispeed =3D=3D termios->c_ispeed
>  	    && old_termios->c_ospeed =3D=3D termios->c_ospeed)
>  		goto no_c_cflag_changes;
> @@ -2373,7 +2374,8 @@ static void ftdi_set_termios(struct tty_struct *tty=
,
>  	   ftdi_sio_read_bulk_callback  - need to examine what this means -
>  	   don't see any problems yet */
> =20
> -	if ((old_termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)) =3D=3D
> +	if (old_termios &&
> +	    (old_termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)) =3D=3D
>  	    (termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)))
>  		goto no_data_parity_stop_changes;
> =20

--=20
Ben Hutchings
friends: People who know you well, but like you anyway.

--=-RG/DP9eDkh7Ck3G+E8y+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbk+Gue/yOyVhhEJAQoxDhAAzQvzJ+HMnNWXZmd8Mexeoraaz4RPLsSZ
DzgZnKaD/aSsp46Y3wYAp8SCooDQME4iKgVgEzDP3p2DIKrymCaXsa8fZ/pkbdjE
7IXCKEjtp9qzPXgfQAMm+6HEREe/v5jCsUHc2/0O0xYv+P8KgEXsftytXfeujuP/
5+OvsdLVmeNFvMYYIGrbec3uvSfYsRnwwqq531hXDdA8ciz6TTJyiR4Q146pprUr
THEkMPJwSnh3ZedyJdw0ja/dp8t3roeyCHeXVdN64PZnenkh6lbPpsckHEHbMn69
JhPkVYjMcKCwzqf9cgP2lu+/iIzGHRrwMTn8wCN+2VK/gbRa2AVpTRN44L1z4TCQ
HhdjrgqxLbXoCXgLb+CC9XBOwQG5O7Yh/Pu6odVlADvcv95j9UmTI9KWzI4iG9DI
ljZPJVyYvBZaxzXHFgCzHtbkNs6askW14xJvJswN2WDB8LWnMkyVKTHzbIXGR2YR
k38lJwmdIahrr6AJbVXyxPBBIJhI1u19N7SSGaTxWp/I2p9rMEkwH/ghm2Q9ihW1
VeumX3R6MivABEn7MnzhlbgwKSNTmTALqrkck6ZAV2opeXLsWdsQZILUR8d7sF/l
uKv1pW/tFDIARBa6tGm4cRdQfjYRuBQourun5YqP1af2FHCx0v/lft7b/Jtb3Xl2
Ysd2OlDaYC0=
=xd+0
-----END PGP SIGNATURE-----

--=-RG/DP9eDkh7Ck3G+E8y+--
