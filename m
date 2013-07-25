Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab3GYQOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:14:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58129 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981Ab3GYQOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:14:10 -0400
Date: Thu, 25 Jul 2013 19:14:06 +0300
From: Felipe Balbi <balbi@ti.com>
To: Olof Johansson <olof@lixom.net>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: at91_udc: Check gpio lookup results
Message-ID: <20130725161406.GD31835@radagast>
Reply-To: <balbi@ti.com>
References: <1374605750-29565-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7CZp05NP8/gJM8Cl"
Content-Disposition: inline
In-Reply-To: <1374605750-29565-1-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7CZp05NP8/gJM8Cl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 23, 2013 at 11:55:50AM -0700, Olof Johansson wrote:
> This resolves the following valid build warning:
>=20
> drivers/usb/gadget/at91_udc.c:1685:34: warning: 'flags' may be used unini=
tialized in this function [-Wmaybe-uninitialized]
>=20
> I switched from ? : to !! mostly to save from wrapping the lines while
> I was at it.
>=20
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>=20
> Felipe, this would be nice to see fixed for 3.11 but I'd argue that it's
> been here long enough to not really be needed for -stable.
>=20
>  drivers/usb/gadget/at91_udc.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
> index 073b938..f3dbcd0 100644
> --- a/drivers/usb/gadget/at91_udc.c
> +++ b/drivers/usb/gadget/at91_udc.c
> @@ -1682,12 +1682,20 @@ static void at91udc_of_init(struct at91_udc *udc,
> =20
>  	board->vbus_pin =3D of_get_named_gpio_flags(np, "atmel,vbus-gpio", 0,
>  						  &flags);
> -	board->vbus_active_low =3D (flags & OF_GPIO_ACTIVE_LOW) ? 1 : 0;
> +	if (board->vbus_pin < 0)
> +		pr_err("%s: Failed to get atmel,vbus-gpio property\n",
> +		       np->full_name);
> +	else
> +		board->vbus_active_low =3D !!(flags & OF_GPIO_ACTIVE_LOW);

should you even continue if you can't get the gpio ? If this gpio is
optional, then it's not really and error, rather a debugging or
informational message.

BTW, this vbus-gpio looks, to me at least, like a fixed regulator
controlled by a GPIO, no ?

--=20
balbi

--7CZp05NP8/gJM8Cl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8U7NAAoJEIaOsuA1yqREjRUP/3/3eGzVxYMp23uJbFbcKMm1
g9KFaKbPeKmCPOOW3i+QFuriOIyWJCtSknhk/95lfx1DXJO++wNOevdNqOTtVmCO
3u3JT3R+ENBeo2jsbfzpNGcrEZEHoc/HinfZD39fWyTkiXgWxAOQU/VRIV4KuGpq
7+tWKXjv0tyIQ1FcGA1HGEcJ1tvi9XtpTJvK4JpHY62En5Rw0sh2zzZXcCk/CcZM
BgEcUPAhQ7gjgYwpV7ZDOmXIjIvJgBiRyIs8/SqhJfN2aw5yydugzZIxHFV60c3Q
tsQFbUcGBUtT6jCjOSWRok4TzjDRTELw7vZcA/7daJ1PYNxCnRyLXEIdRRC9cIb+
d+Sq/htXecQVYh/EHeqTLkB9jBnYXdkinb028MhV3WW0yTAsB0w2HuDOEE/AqJ4f
FnFRMxeqweOcYH/pu2pM07O0b5/NKcFnVpZJ9Ag68vUt2yVvwdBBztSj8sDrh6V0
0GeS2EmPBsHQDNxWzse+b3tcUMcDgg8mrgwA4vEwFCJzO3aSCF8XmMmTx2HyCL5P
YfbPfj/hjCGI5c+lk7T0UtRlrQUvsM3Dc86asgQMH0fepdnVHKj2ebIo9aPbGjBR
QxqluAxeaRkfWVaEp1nwOJopZ8rR99zz70OsTVOTZzPrU351+ssRAglJM9atM8GQ
EBhUm5f4jS/LjwM4MJoj
=fneF
-----END PGP SIGNATURE-----

--7CZp05NP8/gJM8Cl--
