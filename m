Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbaD1Oaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:30:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48059 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065AbaD1Oa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:30:29 -0400
Date: Mon, 28 Apr 2014 09:29:51 -0500
From: Felipe Balbi <balbi@ti.com>
To: Matt Porter <mporter@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>, Barry Song <baohua@kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: l2c: prima2: only call l2x0_of_init() on matching
 nodes
Message-ID: <20140428142950.GB30292@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398644860-22973-1-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
Content-Disposition: inline
In-Reply-To: <1398644860-22973-1-git-send-email-mporter@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 27, 2014 at 08:27:40PM -0400, Matt Porter wrote:
> l2x0_of_init() is executed unconditionally within the sirfsoc_l2x0_init()
> early initcall. In a multi v7 kernel this causes bcm281xx and bcm21664
> platform to fail boot since they have their own pre l2x0 init sequence
> that is required. Fix this by checking that a matching OF ID is present
> before calling l2x0_of_init().
>=20
> Reported-by: Kevin Hilman <khilman@linaro.org>
> Signed-off-by: Matt Porter <mporter@linaro.org>
> ---
> Applies against next-20140424 to fix the issue introduced in
> 50655e6 ARM: l2c: prima2: remove cache size override
>=20
>  arch/arm/mach-prima2/l2x0.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/mach-prima2/l2x0.c b/arch/arm/mach-prima2/l2x0.c
> index 09f68f0..1c2ed15 100644
> --- a/arch/arm/mach-prima2/l2x0.c
> +++ b/arch/arm/mach-prima2/l2x0.c
> @@ -8,10 +8,24 @@
> =20
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> +#include <linux/of.h>
>  #include <asm/hardware/cache-l2x0.h>
> =20
> +static const struct of_device_id sirf_l2x0_ids[] __initconst =3D {
> +	{ .compatible =3D "sirf,prima2-pl310-cache" },
> +	{ .compatible =3D "sirf,marco-pl310-cache" },

that same commit removed these two from DTS, did you test with old DTS,
btw any chance ?

--=20
balbi

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTXmXeAAoJEIaOsuA1yqRENDwP/0NgVpoO1SS4T3BK1py8AbFF
RGefxBt/kjef1+sxLXlECT9DIu0qC6ceOJ42scpt/xIxQZdoKt8AgjUsRVZi1zOh
aFtrhkdekIcKIWNO68yPYMlKVEyscRKTKdQYIgItX69CpKTfm6MIIXjTdPA9b1vK
GXY/S8hdS61Sez+mM/livPaBksmu0MFHWJFM54T+WqrxpCC9EQkMh0xetJ2OW63b
aXtVJWI4LZuzs2KLm3gKkGdh0oRfwKI4eMRcmjkiaSpGl41xDpxFEzFr2bdBdMdQ
RSpq8bVQT2K2+bZ585cFpQM4WMeexkocjFOSx/E+LS10KtYLzRJ5TWjaiKpmS69r
UkX9j3iGXdeOWLG1Uo3Bqj0eM04zJXfq9UEKjPQmYtcD1VqJH95eEfeUe1mo0dLR
ImxKw6ANHrfGYHmdV9SCEXh6BNs+DTKVx1QFNHIxCBiJKkDOqcdPRXLRJKKOdQQK
mvFa1cwRNxdyMgh+3uudp9JUSJ0QzvNIEz2WeYSvKzFpGTxRDrYluY74plo5JlII
kLGD6isCIOPj3VXG/dNSq6wCzTr9DPaSdOmA6zXFK+rw97dzXTNArhCQ1wa5ojIp
1merjh70vz5lfROmJ8KVNA0VVfjn7OkmdWW6/C73qoWKkRshixOl+ca6J+59jtcq
hC+ZRcapOV6z/VIt3IvM
=vIM6
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--
