Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3AaIM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 03:12:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58165 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab3AaIM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 03:12:26 -0500
Date: Thu, 31 Jan 2013 09:12:18 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/1] dma: pl330: Convert to devm_ioremap_resource()
Message-ID: <20130131081218.GA3171@avionic-0098.mockup.avionic-design.de>
References: <1359616024-11640-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <1359616024-11640-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:8flmKN07fu6Q0dl8tRBMDJA1vFtrc0CqNjnOi6MGVtz
 edms+DvkrvCFGOkx4/5GxS4VQnW8d2R5QzKSfftdY3gxLFWn/p
 8niWF8/bSvqRu0QxpShxg+TAC+WoV8WyGStVrYTM5pC0PL07Vg
 Ns2g3L4I6NgFacSLvpTMk24xaEaRsX1L7c51yMaxLS1loZ2pZp
 1g12Zi58LnJjxSpImTqy4029XfZ57nREKGVDJCBeddC6+xn9gj
 MapbPDAwlWSXQWPSdwL24Ia5T8MPCy1QC2wTBFUHz6IDDL7+HC
 AYHYHry2kkVW3gVlZuk9yYnDFuxoYPdOAJVIlFv86icQqoJtU5
 93NQ9SBJbxEI2VLEn+fnUjubEEIw/ndAhQxaI9Ur7QAvAePGzF
 TQjZfFwSVwbGwL7WC/VlWuYhifYonQuZh8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2013 at 12:37:04PM +0530, Sachin Kamat wrote:
> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.
>=20
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> This change is based against linux-next tree (20130128).
> This change however introduces the followign sparse warning:
> drivers/dma/pl330.c:2883:22: warning: incorrect type in argument 1 (diffe=
rent address spaces)
> drivers/dma/pl330.c:2883:22:    expected void const *ptr
> drivers/dma/pl330.c:2883:22:    got void [noderef] <asn:2>*base
> drivers/dma/pl330.c:2884:34: warning: incorrect type in argument 1 (diffe=
rent address spaces)
> drivers/dma/pl330.c:2884:34:    expected void const *ptr
> drivers/dma/pl330.c:2884:34:    got void [noderef] <asn:2>*base
> ---
>  drivers/dma/pl330.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 316a43e..142fe4d 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -25,6 +25,7 @@
>  #include <linux/amba/pl330.h>
>  #include <linux/scatterlist.h>
>  #include <linux/of.h>
> +#include <linux/err.h>
> =20
>  #include "dmaengine.h"
>  #define PL330_MAX_CHAN		8
> @@ -2878,9 +2879,9 @@ pl330_probe(struct amba_device *adev, const struct =
amba_id *id)
>  	pi->mcbufsz =3D pdat ? pdat->mcbuf_sz : 0;
> =20
>  	res =3D &adev->res;
> -	pi->base =3D devm_request_and_ioremap(&adev->dev, res);
> -	if (!pi->base)
> -		return -ENXIO;
> +	pi->base =3D devm_ioremap_resource(&adev->dev, res);
> +	if (IS_ERR(pi->base))
> +		return PTR_ERR(pi->base);
> =20
>  	amba_set_drvdata(adev, pdmac);
> =20

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRCidiAAoJEN0jrNd/PrOhqvoQALhj4Z2AGuNXbPaOjif/yjTR
Ux2JCXogz/arFPkM1YK66h4wkd5ZnnQBawmTyHdudW5zxJqZsL6XTDxB27uB+CD2
fby7fE9uzqApOXy+bNm25uB0ILehB4vMpym3fpE3RKppi7N4yRDPzCSjZqQgVq+W
IxihVWINDlvUXsvKP4xRJYSO1ew4iMdvMsPjrGt9BnB9VuAEYWe/Dyt0Gvh+/fgU
zl9FfUsw3LtO37FuXiGKk/6qCKulV896QcyKJkH7YnYKVs3p/z4cj4AwCkQzeXCc
e621Y6D0rsmxR4pbHUVinxDXx1O0rdMkW/uz4YbeMYqxwBcN3kwlnY68v8mk03Zn
BTHm62b1Dv9ZW1cl7TFlrH6EecLPZm/LTQAeASMjvUldSiOsD3Zp/obYs2iT3Al8
NSZZ6c3Bjvn0ZOpfheZOLa/s9z4ZeszlSZTNs/qEAj6+ZS7yxXsAAlmuY2v9z/+E
n9iuNRsxZIgDEU7mBMWIYcn1+0wGK/wsQ59isMwQRyclEcrW5yWe3MpQRyLgYLZU
ssX+Sb5Ce8jhjfsC8OwU7ssvaOfaqSoBC17FLKxwRyFJjes5sDbGHFL6ZrRIK6bi
J13sLP2THY16oqrytzj8QXP0DxXU1Sl92Fbz83zV9GEtk9XlbAuqcsSCzQjdDHqT
4vbiOaI8++OeLHwYpeDS
=aqM2
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
