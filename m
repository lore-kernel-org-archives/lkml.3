Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaB1Pud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:50:33 -0500
Received: from top.free-electrons.com ([176.31.233.9]:52582 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752332AbaB1Pub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:50:31 -0500
Date: Fri, 28 Feb 2014 16:50:28 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: atmel_usba: Fix crashed during stopping
 when DEBUG is enabled
Message-ID: <20140228155027.GC2974@piout.net>
References: <1393598066-4016-1-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <1393598066-4016-1-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Gregory,

On 28/02/2014 at 15:34:01 +0100, Gregory CLEMENT wrote :
> The debug trace in the atmel_usba_stop function made the assumption
> that the driver pointer passed in parameter was not NULL. Since the
> commit "usb: gadget: udc-core: fix a regression during gadget driver
> unbinding", it was no more always true. This lead to a kernel crash.
>=20
> This commit now use the driver pointer stored in udc which fixes this
> issue.
>=20
> Since the commit which have triggered this issue was backported to the
> 3.2 stable branch, then this one should also be backported to the same
> kernel.
>=20
> Cc: stable@vger.kernel.org # v3.2+
> Fixes: 511f3c5326ea (usb: gadget: udc-core: fix a regression during gadge=
t driver unbinding)
> ---
>  drivers/usb/gadget/atmel_usba_udc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atm=
el_usba_udc.c
> index 52771d4c44bc..167843de2d8a 100644
> --- a/drivers/usb/gadget/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/atmel_usba_udc.c
> @@ -1827,12 +1827,12 @@ static int atmel_usba_stop(struct usb_gadget *gad=
get,
>  	toggle_bias(0);
>  	usba_writel(udc, CTRL, USBA_DISABLE_MASK);
> =20
> -	udc->driver =3D NULL;
> -
>  	clk_disable_unprepare(udc->hclk);
>  	clk_disable_unprepare(udc->pclk);
> =20
> -	DBG(DBG_GADGET, "unregistered driver `%s'\n", driver->driver.name);
> +	DBG(DBG_GADGET, "unregistered driver `%s'\n", udc->driver->driver.name);
> +
> +	udc->driver =3D NULL;

Shouldn't we get rid of that assignment as it is done in
usb_gadget_remove_driver() anyway ?

> =20
>  	return 0;
>  }
> --=20
> 1.8.1.2
>=20

--=20
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCAAGBQJTELBDAAoJEKbNnwlvZCyzKnsQALtqY0XDBGJbBZMsK9M0o/jN
3tS3ZuuxcwH3GB8LGcZKnkzuWxF4RQ1ZoNGYSwZUx+u6efccLew1u9GRGceL0fcp
455TofGkaTPGAYGLs8TeYfSgeXy+VCgFnZhr6Bpihxu6zqohw+sDLqIoGj25jxDi
xyKRO4H2kSRwhI7BXS3YqsA6EaU3d+aFL2tTQ3Ze4uIsLL+BqJo4hVlhkjmMxy17
T1MxhM671Fccf7Vf+HxewX/Ywh/6V30d4UYUTcXnD16R7CC1AHvkqowB8LUwYw5c
5WRWi8pLEho87XRkMhtu7Q8bQfpinZvZ6TqjjPoDdfskVOTCrsMWm9Q0u7lAlmk2
aOQNDkJ8jW7aiFBAbpxRHMrTGySxn63sH0IzcaSirWgeZrfuBee5oN4OBPaF3oRo
JQVk6zHIItAqu6b/QaYfR1dXrPEe1bKBXFahnZ2KRYF/pXSQ3U0KUOoiSDJuhqKz
HFI31Yb6XvPmXEd7n7CDGjOATRpLmoPgCgs0aPxjvc12BXPlrqjpBTF4zfGzRDVL
d2ckmhnb01CoUi0rzafNOCu2icAZw5lDxzq8gfYEoyY2xMnK/C358UGXNv2qIcZy
Mh6Fn/0a1UziijwUzS60h5h71tWw/SetDula89ppExk1K7uDKA16UStjXY9fbrLm
oHAtGmKuEFZhPbs5PlSp
=+Vx1
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
