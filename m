Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbaDLDj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 23:39:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37437 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706AbaDLDjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 23:39:55 -0400
Date: Fri, 11 Apr 2014 22:37:18 -0500
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kishon@ti.com>, <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <kgene.kim@samsung.com>, <t.figa@samsung.com>, <k.debski@samsung.com>,
        <jg1.han@samsung.com>, <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH] phy: exynos5-usbdrd: Add facility to toggle vbus gpio
 on/off
Message-ID: <20140412033718.GA18777@saruman.home>
Reply-To: <balbi@ti.com>
References: <1397044485-26483-1-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <1397044485-26483-1-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 09, 2014 at 05:24:45PM +0530, Vivek Gautam wrote:
> Adding support to enable/disable VBUS hooked to a gpio
> to enable vbus supply on the port.
>=20
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>=20
> Based on 'phy-exynos5-usbdrd' patches:
> [PATCH V4 0/5] Add Exynos5 USB 3.0 phy driver based on generic PHY framew=
ork
> http://www.spinics.net/lists/linux-usb/msg105507.html
>=20
>  drivers/phy/phy-exynos5-usbdrd.c |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-u=
sbdrd.c
> index ff54a7c..5ca7485 100644
> --- a/drivers/phy/phy-exynos5-usbdrd.c
> +++ b/drivers/phy/phy-exynos5-usbdrd.c
> @@ -18,6 +18,7 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> +#include <linux/of_gpio.h>
>  #include <linux/phy/phy.h>
>  #include <linux/platform_device.h>
>  #include <linux/mutex.h>
> @@ -176,6 +177,7 @@ struct exynos5_usbdrd_phy {
>  	struct clk *ref_clk;
>  	unsigned long ref_rate;
>  	unsigned int refclk_reg;
> +	int gpio;
>  };
> =20
>  #define to_usbdrd_phy(inst) \
> @@ -460,6 +462,9 @@ static int exynos5_usbdrd_phy_power_on(struct phy *ph=
y)
>  	if (!IS_ERR(phy_drd->usb30_sclk))
>  		clk_prepare_enable(phy_drd->usb30_sclk);
> =20
> +	/* Toggle VBUS gpio - on */
> +	gpio_set_value(phy_drd->gpio, 1);

It seems like you'd be better off using a regulator_enable() call for
this.

--=20
balbi

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTSLTuAAoJEIaOsuA1yqREZQUQAJ7ez8ZDZBRAzn3wjiUQNYfp
GO3QGVWSsbQe80ONOjde+hOKkCf1cW/mVYgU4Yz4/kZ0J9TuwFTtGWvC+Y8kRGOH
Ti/gxDCrDu3P7f1TBw3yF8PXNyNU1iuFAiKVQesNzOt8PT7TsRAESLrYQGCX9AnK
r/MqoN7bbdrFucQ7UxqPMMIReR+HJGUYDv8hcjjpPeffoPi70yVm4/Kf4rloi8Zy
E/bS9Q1gvSGHx8oVtTZ0ejww6b6f8Jz1yLNa8Bq01ag+kkmqaAI9Aj4379BiV67a
UeOCdER3vJAaYQp9sgINx3r0+fLNZ1K5Fk0DXgpU+i+TZfzGYfK2zlXVXV/lwS/n
C9A7K5VOiYWR56pS4EdcH9UKotF5OnHio6XkSp+a5FK7DpJ1nG1A5qusWl4tTrOo
QlgdnCXLzNUO0htQKo0GRUxQG8LKHFRp22JWw0r3aJHpfDpUmdgj0MHUR634thqt
N4F6pvrrl6WYrIOj7e+RCMzYC1qWj1vpKSzGENOLI/zCTlAX/3rxi0V5xMAOEQvb
LqdSiDU09xqkG5N6h/r1RsWwmAbeQRqFKTnHMLsT8agNA6U7CNyvVBq3UnAodU/A
nG/JUXgdw8M9oxcb9x0XtLvdnRi7xci01A3/NBwkFpJPyh5+mUJPHqa1VYHjRiSC
POXfoGYZKhsMCUCA5lSr
=sVm9
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
