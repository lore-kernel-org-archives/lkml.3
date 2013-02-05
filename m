Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3BEJZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:25:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37077 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab3BEJZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:25:35 -0500
Date: Tue, 5 Feb 2013 11:25:24 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 08/30] mfd: omap-usb-host: Remove PHY reset handling code
Message-ID: <20130205092523.GQ32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-9-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7kD9y3RnPUgTZee0"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-9-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7kD9y3RnPUgTZee0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:09PM +0200, Roger Quadros wrote:
> PHY reset GPIO handling will be done in the PHY driver
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/mfd/omap-usb-host.c |   47 -------------------------------------=
------
>  1 files changed, 0 insertions(+), 47 deletions(-)
>=20
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 0874352..502a779 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -430,24 +430,10 @@ static unsigned omap_usbhs_rev2_hostconfig(struct u=
sbhs_hcd_omap *omap,
>  static void omap_usbhs_init(struct device *dev)
>  {
>  	struct usbhs_hcd_omap		*omap =3D dev_get_drvdata(dev);
> -	struct usbhs_omap_platform_data	*pdata =3D omap->pdata;
>  	unsigned			reg;
> =20
>  	dev_dbg(dev, "starting TI HSUSB Controller\n");
> =20
> -	if (pdata->phy_reset) {
> -		if (gpio_is_valid(pdata->reset_gpio_port[0]))
> -			gpio_request_one(pdata->reset_gpio_port[0],
> -					 GPIOF_OUT_INIT_LOW, "USB1 PHY reset");
> -
> -		if (gpio_is_valid(pdata->reset_gpio_port[1]))
> -			gpio_request_one(pdata->reset_gpio_port[1],
> -					 GPIOF_OUT_INIT_LOW, "USB2 PHY reset");
> -
> -		/* Hold the PHY in RESET for enough time till DIR is high */
> -		udelay(10);
> -	}
> -
>  	pm_runtime_get_sync(dev);
> =20
>  	reg =3D usbhs_read(omap->uhh_base, OMAP_UHH_HOSTCONFIG);
> @@ -476,37 +462,8 @@ static void omap_usbhs_init(struct device *dev)
>  	dev_dbg(dev, "UHH setup done, uhh_hostconfig=3D%x\n", reg);
> =20
>  	pm_runtime_put_sync(dev);
> -	if (pdata->phy_reset) {
> -		/* Hold the PHY in RESET for enough time till
> -		 * PHY is settled and ready
> -		 */
> -		udelay(10);
> -
> -		if (gpio_is_valid(pdata->reset_gpio_port[0]))
> -			gpio_set_value_cansleep
> -				(pdata->reset_gpio_port[0], 1);
> -
> -		if (gpio_is_valid(pdata->reset_gpio_port[1]))
> -			gpio_set_value_cansleep
> -				(pdata->reset_gpio_port[1], 1);
> -	}
> -}
> -
> -static void omap_usbhs_deinit(struct device *dev)
> -{
> -	struct usbhs_hcd_omap		*omap =3D dev_get_drvdata(dev);
> -	struct usbhs_omap_platform_data	*pdata =3D omap->pdata;
> -
> -	if (pdata->phy_reset) {
> -		if (gpio_is_valid(pdata->reset_gpio_port[0]))
> -			gpio_free(pdata->reset_gpio_port[0]);
> -
> -		if (gpio_is_valid(pdata->reset_gpio_port[1]))
> -			gpio_free(pdata->reset_gpio_port[1]);
> -	}
>  }
> =20
> -
>  /**
>   * usbhs_omap_probe - initialize TI-based HCDs
>   *
> @@ -710,8 +667,6 @@ static int usbhs_omap_probe(struct platform_device *p=
dev)
>  	return 0;
> =20
>  err_alloc:
> -	omap_usbhs_deinit(&pdev->dev);
> -
>  	for (i =3D 0; i < omap->nports; i++) {
>  		if (!IS_ERR(omap->utmi_clk[i]))
>  			clk_put(omap->utmi_clk[i]);
> @@ -756,8 +711,6 @@ static int usbhs_omap_remove(struct platform_device *=
pdev)
>  	struct usbhs_hcd_omap *omap =3D platform_get_drvdata(pdev);
>  	int i;
> =20
> -	omap_usbhs_deinit(&pdev->dev);
> -
>  	for (i =3D 0; i < omap->nports; i++) {
>  		if (!IS_ERR(omap->utmi_clk[i]))
>  			clk_put(omap->utmi_clk[i]);
> --=20
> 1.7.4.1
>=20

--=20
balbi

--7kD9y3RnPUgTZee0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENADAAoJEIaOsuA1yqREVgAP+gJMc+iMwSeuGMU78KScZUzc
in5XFWUdngWtijuGEb2KrXOUR2jksTa5qP3jdJKo67l2wQ/m4P3IhAKZPz4GxnR/
yp3kXnBNbwMfv8NEB0Uov1QliRB4mcmggeuGbz49s5feVBuuWQMhBveFw9hjzXyz
C3NqEbu/VMqBPcG2wPhtF7gnk6FNRHOSKbtAkeWQBEWfDgo0J4NceNf5MkJEnNAI
xryyQa0njulSx0cGNm9YwJ0h5IZFFIK9H9OKStYXC+Rs+HU0gCJg7Xsjcy5gDTaG
rMxRd98O2U5dYPHcdM9KMjJGJCJUkgd+nolQg8v0guMeBfiD/KEwx/GFu2yWC5YL
TjnFLVHpXwrxo/fDBFWPfkFGw5o83IcOEx2YipxSEEVpUh7TFguKCYgW09SA+bpZ
dNwQMaCC0GFq7dT4V8q/MmepEPQVenFo4IPTfJEFIaFsJh1D7f4dPxD1gOr+7V8h
efqBH7DlflDWN5UjUBMGMGmc6T+M+3CFvQOCuvrq1ksy0p4S5fVkzoEkVVzoIvsm
cynk9foBWFEF/88mlPC5k+YufM1nlPA33AeGXQoxW8mtulD29UVQVj5ts/I4rBob
R9cjo6OUsGBBLJQ3hFpQM3Fu9tlfEZqzVp2vJMZ5Vd/7Kq3NL9pRzAq5iRfyjjXp
mSB97hM1yGZjTOU6lv6n
=eDSc
-----END PGP SIGNATURE-----

--7kD9y3RnPUgTZee0--
