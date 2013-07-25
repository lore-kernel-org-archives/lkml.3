Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab3GYTAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:00:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37501 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757138Ab3GYTA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:00:29 -0400
Date: Thu, 25 Jul 2013 22:00:23 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: <balbi@ti.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 8/9] usb: phy: tegra: Use DT helpers for phy_type
Message-ID: <20130725190023.GA26858@radagast>
Reply-To: <balbi@ti.com>
References: <1374777489-13093-1-git-send-email-ttynkkynen@nvidia.com>
 <1374777489-13093-9-git-send-email-ttynkkynen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <1374777489-13093-9-git-send-email-ttynkkynen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 25, 2013 at 09:38:08PM +0300, Tuomas Tynkkynen wrote:
> Use the new of_usb_get_phy_mode helper function for parsing phy_type
> from the device tree.
>=20
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> ---
>  drivers/usb/phy/phy-tegra-usb.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-=
usb.c
> index fb5bc8c..fb469f1 100644
> --- a/drivers/usb/phy/phy-tegra-usb.c
> +++ b/drivers/usb/phy/phy-tegra-usb.c
> @@ -31,6 +31,7 @@
>  #include <linux/of_gpio.h>
>  #include <linux/usb/otg.h>
>  #include <linux/usb/ulpi.h>
> +#include <linux/usb/of.h>
>  #include <asm/mach-types.h>
>  #include <linux/usb/ehci_def.h>
>  #include <linux/usb/tegra_usb_phy.h>
> @@ -860,6 +861,7 @@ static int tegra_usb_phy_probe(struct platform_device=
 *pdev)
>  	struct resource *res;
>  	struct tegra_usb_phy *tegra_phy =3D NULL;
>  	struct device_node *np =3D pdev->dev.of_node;
> +	enum usb_phy_interface phy_type;
>  	int err;
> =20
>  	tegra_phy =3D devm_kzalloc(&pdev->dev, sizeof(*tegra_phy), GFP_KERNEL);
> @@ -884,12 +886,12 @@ static int tegra_usb_phy_probe(struct platform_devi=
ce *pdev)
>  	tegra_phy->is_legacy_phy =3D
>  		of_property_read_bool(np, "nvidia,has-legacy-mode");
> =20
> -	err =3D of_property_match_string(np, "phy_type", "ulpi");
> -	if (err < 0) {
> +	phy_type =3D of_usb_get_phy_mode(np);
> +	if (phy_type =3D=3D USBPHY_INTERFACE_MODE_UTMI) {

can you add one more patch to your series converting this to a switch ?
I can apply this one as is, but this really looks like a good fit for a
switch statement

--=20
balbi

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8XXHAAoJEIaOsuA1yqRE2cAP/3XTtv/WdmrqXIGZB7Oh5mHG
wLkj7dqZxsPqyWy3sIcG6efKT9igUrBGpNtV+8oLfi1Yc6iqytIiWWYAWkko5l26
332pLzGQ+YWQr8lIeMDsbfsMs9ManZk7nFYjnQAPSV80b1odbOXo02UsY/8QXRva
XQZEFfBRGBKM/35Xa6i0ndIAfNZZQWOjcZH7ZZLX1nRgUZsOLgLWJorM/3j36sOf
lvH6uhJ2GSgJgiJO9V61oQBo7wWXyDfVM8hujFALnHgK7xfpGwzackD5GLynUUrL
+OhHW0SNBaz+vO1V0ePS5m+RH47epSvHwXx9CF/YiORGMzjx8zvSxE9WlQjR0voX
bO2AvA5c4n/LsJnZ1cdLcGrRiNefK0baWnMsbHKKtAp2kDqtKEGr884VMNwaCnDt
lSwiHyShlO/jOg/7r9nLU52KTpf56EImVlgpnxX8rHsAB2w27GQoHH39tyjDz5VE
3yD4lqJG0PfSYg6ovph8WDqa3FGH/QFxGp9hHCSs2pORdJc4WJswaJ1U7Tv8C3lF
RY0OR4NuQu4LoCwAJSmaVfET3nTqhJkXZEnVt7zCqo1WbPCUruzldcKoWcjtJm6S
3gPQuvx4nc+EqyaSJqFi3LssgZ9pHgAeOAkcVm8dfiyDTGCzJ8lc1QgffwsCUxqL
rr4wg1o8IeriY21b7YJu
=yJWk
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
