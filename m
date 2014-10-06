Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaJFKIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 06:08:47 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62939 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaJFKIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 06:08:46 -0400
Date: Mon, 6 Oct 2014 12:08:42 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/pwm/Kconfig: Let PWM_CLPS711X depend on HAS_IOMEM
Message-ID: <20141006100842.GC25202@ulmo>
References: <542FC27A.8050006@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vEao7xgI/oilGqZ+"
Content-Disposition: inline
In-Reply-To: <542FC27A.8050006@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vEao7xgI/oilGqZ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 04, 2014 at 05:48:42PM +0800, Chen Gang wrote:
> PWM_CLPS711X needs HAS_IOMEM, so depend on it, the related error (with
> allmodconfig under um):
>=20
>     MODPOST 1205 modules
>   ERROR: "devm_ioremap_resource" [drivers/pwm/pwm-clps711x.ko] undefined!
>   ERROR: "devm_ioremap" [drivers/net/phy/mdio-bcm-unimac.ko] undefined!
>=20
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/pwm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 3865dfb..de1ffb5 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -82,7 +82,7 @@ config PWM_BFIN
> =20
>  config PWM_CLPS711X
>  	tristate "CLPS711X PWM support"
> -	depends on ARCH_CLPS711X || COMPILE_TEST
> +	depends on (ARCH_CLPS711X || COMPILE_TEST) && HAS_IOMEM

Applied, thanks. I modified this slightly and put HAS_IOMEM on a line of
its own. This is in my opinion (slightly) more readable and matches what
we already have for other drivers.

Thierry

--vEao7xgI/oilGqZ+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUMmoqAAoJEN0jrNd/PrOhPu8P/jpKj19BR1wH5gP0s8k3Sg04
n8SGlc9BQEbGKOOCcP8hct0x3S6Uk3WkxaraOr8Ee3JOlfS5GFSucxSHXMydqF8u
fMTiOEtjTTwBKNtP2rnTl6fn/arvoO2HSL1lhiU31UOzN/UCe+/2XDqUStUxGuAP
qiP1gvazqg2mDPdS+BuhhucZHLhow1NRITcFIxqumAvFza2uPTVc8QfFuWzjO+xX
/NFwk2bOLGUl0oSIlRdnKs6h5TAXklbXOHNTbS2MG9qTNKp/BnnVA/PSq1Ix2hPR
2ThHFKkx6AJlV3I8eH31zKBzuJqvDRJsOiucwtMyYRxqsu0PLINeeiTbgeBR9MXm
XdeE1L3le9rVsrRFr/cDkeLv8SpIcgSZ32/Ol/vGt58jpSj/3zzbyQBRJPBsnGbG
i+XlNCYOykpSXIG2PjEINQCtipmFAioNdT3gE4Ih/1ccFeOEOZtWm6Wb+H+E/B8l
dWdLsYwomhJADvOndc/3lcSZpzZcl2z5hN4CoH5jNME0YhUaxdbMt/JNeb7ZspL1
M+wgv0m798IcwpKZGtAsXf/UUS/isYa8amZMCaazWCxeuyydWt2wHXzjRGEBcWT4
TrbmaxSrPTeTwyYUByBN3fNnEkk3N8Xcs1UWxP9npFYbJfi4kcJQ89oWr2L4Jx+x
Q1Pto9yJXcKk7ybPQCbQ
=w71G
-----END PGP SIGNATURE-----

--vEao7xgI/oilGqZ+--
