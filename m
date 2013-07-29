Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3G2MUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:20:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60108 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab3G2MUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:20:36 -0400
Date: Mon, 29 Jul 2013 15:20:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <george.cherian@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/4] usb: phy: rename nop_usb_xceiv => usb_phy_gen_xceiv
Message-ID: <20130729122022.GF24801@radagast>
Reply-To: <balbi@ti.com>
References: <1374869757-923-1-git-send-email-bigeasy@linutronix.de>
 <1374869757-923-2-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="juZjCTNxrMaZdGZC"
Content-Disposition: inline
In-Reply-To: <1374869757-923-2-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--juZjCTNxrMaZdGZC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2013 at 10:15:54PM +0200, Sebastian Andrzej Siewior wrote:
> The "nop" driver isn't a do-nothing-stub but supports a couple functions
> like clock on/off or is able to use a voltage regulator. This patch
> simply renames the driver to "generic" since it is easy possible to
> extend it by a simple function istead of writing a complete driver.
>=20
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

to me, this is great but I need Tony's Ack for it. Let's Cc Tony and
linux-omap

> ---
>  arch/arm/mach-omap2/board-omap3beagle.c      |  2 +-
>  arch/arm/mach-omap2/board-omap3evm.c         |  2 +-
>  arch/arm/mach-omap2/board-omap3pandora.c     |  2 +-
>  arch/arm/mach-omap2/usb-host.c               |  8 +++---
>  drivers/usb/dwc3/dwc3-exynos.c               |  6 ++--
>  drivers/usb/dwc3/dwc3-pci.c                  |  6 ++--
>  drivers/usb/phy/Makefile                     |  2 +-
>  drivers/usb/phy/{phy-nop.c =3D> phy-generic.c} | 42 ++++++++++++++------=
--------
>  include/linux/usb/nop-usb-xceiv.h            |  2 +-
>  9 files changed, 36 insertions(+), 36 deletions(-)
>  rename drivers/usb/phy/{phy-nop.c =3D> phy-generic.c} (84%)
>=20
> diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap=
2/board-omap3beagle.c
> index 04c1165..f595b23 100644
> --- a/arch/arm/mach-omap2/board-omap3beagle.c
> +++ b/arch/arm/mach-omap2/board-omap3beagle.c
> @@ -279,7 +279,7 @@ static struct regulator_consumer_supply beagle_vsim_s=
upply[] =3D {
>  static struct gpio_led gpio_leds[];
> =20
>  /* PHY's VCC regulator might be added later, so flag that we need it */
> -static struct nop_usb_xceiv_platform_data hsusb2_phy_data =3D {
> +static struct usb_phy_gen_xceiv_platform_data hsusb2_phy_data =3D {
>  	.needs_vcc =3D true,
>  };
> =20
> diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/b=
oard-omap3evm.c
> index 8c02626..5d98ef0 100644
> --- a/arch/arm/mach-omap2/board-omap3evm.c
> +++ b/arch/arm/mach-omap2/board-omap3evm.c
> @@ -468,7 +468,7 @@ struct wl12xx_platform_data omap3evm_wlan_data __init=
data =3D {
>  static struct regulator_consumer_supply omap3evm_vaux2_supplies[] =3D {
>  	REGULATOR_SUPPLY("VDD_CSIPHY1", "omap3isp"),	/* OMAP ISP */
>  	REGULATOR_SUPPLY("VDD_CSIPHY2", "omap3isp"),	/* OMAP ISP */
> -	REGULATOR_SUPPLY("vcc", "nop_usb_xceiv.2"),	/* hsusb port 2 */
> +	REGULATOR_SUPPLY("vcc", "usb_phy_gen_xceiv.2"),	/* hsusb port 2 */
>  	REGULATOR_SUPPLY("vaux2", NULL),
>  };
> =20
> diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-oma=
p2/board-omap3pandora.c
> index b1547a0..d2b455e 100644
> --- a/arch/arm/mach-omap2/board-omap3pandora.c
> +++ b/arch/arm/mach-omap2/board-omap3pandora.c
> @@ -352,7 +352,7 @@ static struct regulator_consumer_supply pandora_vcc_l=
cd_supply[] =3D {
>  };
> =20
>  static struct regulator_consumer_supply pandora_usb_phy_supply[] =3D {
> -	REGULATOR_SUPPLY("vcc", "nop_usb_xceiv.2"),	/* hsusb port 2 */
> +	REGULATOR_SUPPLY("vcc", "usb_phy_gen_xceiv.2"),	/* hsusb port 2 */
>  };
> =20
>  /* ads7846 on SPI and 2 nub controllers on I2C */
> diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/usb-hos=
t.c
> index 2eb19d4..b54bd06 100644
> --- a/arch/arm/mach-omap2/usb-host.c
> +++ b/arch/arm/mach-omap2/usb-host.c
> @@ -349,7 +349,7 @@ static struct fixed_voltage_config hsusb_reg_config =
=3D {
>  	/* .init_data filled later */
>  };
> =20
> -static const char *nop_name =3D "nop_usb_xceiv"; /* NOP PHY driver */
> +static const char *nop_name =3D "usb_phy_gen_xceiv"; /* NOP PHY driver */
>  static const char *reg_name =3D "reg-fixed-voltage"; /* Regulator driver=
 */
> =20
>  /**
> @@ -460,9 +460,9 @@ int usbhs_init_phys(struct usbhs_phy_data *phy, int n=
um_phys)
>  		pdevinfo.name =3D nop_name;
>  		pdevinfo.id =3D phy->port;
>  		pdevinfo.data =3D phy->platform_data;
> -		pdevinfo.size_data =3D sizeof(struct nop_usb_xceiv_platform_data);
> -
> -		scnprintf(phy_id, MAX_STR, "nop_usb_xceiv.%d",
> +		pdevinfo.size_data =3D
> +			sizeof(struct usb_phy_gen_xceiv_platform_data);
> +		scnprintf(phy_id, MAX_STR, "usb_phy_gen_xceiv.%d",
>  					phy->port);
>  		pdev =3D platform_device_register_full(&pdevinfo);
>  		if (IS_ERR(pdev)) {
> diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exyno=
s.c
> index 9a8a5e1..1a83fb3 100644
> --- a/drivers/usb/dwc3/dwc3-exynos.c
> +++ b/drivers/usb/dwc3/dwc3-exynos.c
> @@ -38,13 +38,13 @@ struct dwc3_exynos {
> =20
>  static int dwc3_exynos_register_phys(struct dwc3_exynos *exynos)
>  {
> -	struct nop_usb_xceiv_platform_data pdata;
> +	struct usb_phy_gen_xceiv_platform_data pdata;
>  	struct platform_device	*pdev;
>  	int			ret;
> =20
>  	memset(&pdata, 0x00, sizeof(pdata));
> =20
> -	pdev =3D platform_device_alloc("nop_usb_xceiv", PLATFORM_DEVID_AUTO);
> +	pdev =3D platform_device_alloc("usb_phy_gen_xceiv", PLATFORM_DEVID_AUTO=
);
>  	if (!pdev)
>  		return -ENOMEM;
> =20
> @@ -55,7 +55,7 @@ static int dwc3_exynos_register_phys(struct dwc3_exynos=
 *exynos)
>  	if (ret)
>  		goto err1;
> =20
> -	pdev =3D platform_device_alloc("nop_usb_xceiv", PLATFORM_DEVID_AUTO);
> +	pdev =3D platform_device_alloc("usb_phy_gen_xceiv", PLATFORM_DEVID_AUTO=
);
>  	if (!pdev) {
>  		ret =3D -ENOMEM;
>  		goto err1;
> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> index 5d746e5..12b8276 100644
> --- a/drivers/usb/dwc3/dwc3-pci.c
> +++ b/drivers/usb/dwc3/dwc3-pci.c
> @@ -38,13 +38,13 @@ struct dwc3_pci {
> =20
>  static int dwc3_pci_register_phys(struct dwc3_pci *glue)
>  {
> -	struct nop_usb_xceiv_platform_data pdata;
> +	struct usb_phy_gen_xceiv_platform_data pdata;
>  	struct platform_device	*pdev;
>  	int			ret;
> =20
>  	memset(&pdata, 0x00, sizeof(pdata));
> =20
> -	pdev =3D platform_device_alloc("nop_usb_xceiv", 0);
> +	pdev =3D platform_device_alloc("usb_phy_gen_xceiv", 0);
>  	if (!pdev)
>  		return -ENOMEM;
> =20
> @@ -55,7 +55,7 @@ static int dwc3_pci_register_phys(struct dwc3_pci *glue)
>  	if (ret)
>  		goto err1;
> =20
> -	pdev =3D platform_device_alloc("nop_usb_xceiv", 1);
> +	pdev =3D platform_device_alloc("usb_phy_gen_xceiv", 1);
>  	if (!pdev) {
>  		ret =3D -ENOMEM;
>  		goto err1;
> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
> index 070eca3..24c5816 100644
> --- a/drivers/usb/phy/Makefile
> +++ b/drivers/usb/phy/Makefile
> @@ -14,7 +14,7 @@ phy-fsl-usb2-objs			:=3D phy-fsl-usb.o phy-fsm-usb.o
>  obj-$(CONFIG_FSL_USB2_OTG)		+=3D phy-fsl-usb2.o
>  obj-$(CONFIG_ISP1301_OMAP)		+=3D phy-isp1301-omap.o
>  obj-$(CONFIG_MV_U3D_PHY)		+=3D phy-mv-u3d-usb.o
> -obj-$(CONFIG_NOP_USB_XCEIV)		+=3D phy-nop.o
> +obj-$(CONFIG_NOP_USB_XCEIV)		+=3D phy-generic.o
>  obj-$(CONFIG_OMAP_CONTROL_USB)		+=3D phy-omap-control.o
>  obj-$(CONFIG_OMAP_USB2)			+=3D phy-omap-usb2.o
>  obj-$(CONFIG_OMAP_USB3)			+=3D phy-omap-usb3.o
> diff --git a/drivers/usb/phy/phy-nop.c b/drivers/usb/phy/phy-generic.c
> similarity index 84%
> rename from drivers/usb/phy/phy-nop.c
> rename to drivers/usb/phy/phy-generic.c
> index 55445e5d..57a0bf0 100644
> --- a/drivers/usb/phy/phy-nop.c
> +++ b/drivers/usb/phy/phy-generic.c
> @@ -36,7 +36,7 @@
>  #include <linux/regulator/consumer.h>
>  #include <linux/of.h>
> =20
> -struct nop_usb_xceiv {
> +struct usb_phy_gen_xceiv {
>  	struct usb_phy phy;
>  	struct device *dev;
>  	struct clk *clk;
> @@ -50,9 +50,9 @@ void usb_nop_xceiv_register(void)
>  {
>  	if (pd)
>  		return;
> -	pd =3D platform_device_register_simple("nop_usb_xceiv", -1, NULL, 0);
> +	pd =3D platform_device_register_simple("usb_phy_gen_xceiv", -1, NULL, 0=
);
>  	if (!pd) {
> -		printk(KERN_ERR "Unable to register usb nop transceiver\n");
> +		pr_err("Unable to register generic usb transceiver\n");
>  		return;
>  	}
>  }
> @@ -72,7 +72,7 @@ static int nop_set_suspend(struct usb_phy *x, int suspe=
nd)
> =20
>  static int nop_init(struct usb_phy *phy)
>  {
> -	struct nop_usb_xceiv *nop =3D dev_get_drvdata(phy->dev);
> +	struct usb_phy_gen_xceiv *nop =3D dev_get_drvdata(phy->dev);
> =20
>  	if (!IS_ERR(nop->vcc)) {
>  		if (regulator_enable(nop->vcc))
> @@ -93,7 +93,7 @@ static int nop_init(struct usb_phy *phy)
> =20
>  static void nop_shutdown(struct usb_phy *phy)
>  {
> -	struct nop_usb_xceiv *nop =3D dev_get_drvdata(phy->dev);
> +	struct usb_phy_gen_xceiv *nop =3D dev_get_drvdata(phy->dev);
> =20
>  	if (!IS_ERR(nop->reset)) {
>  		/* Assert RESET */
> @@ -139,11 +139,11 @@ static int nop_set_host(struct usb_otg *otg, struct=
 usb_bus *host)
>  	return 0;
>  }
> =20
> -static int nop_usb_xceiv_probe(struct platform_device *pdev)
> +static int usb_phy_gen_xceiv_probe(struct platform_device *pdev)
>  {
>  	struct device *dev =3D &pdev->dev;
> -	struct nop_usb_xceiv_platform_data *pdata =3D pdev->dev.platform_data;
> -	struct nop_usb_xceiv	*nop;
> +	struct usb_phy_gen_xceiv_platform_data *pdata =3D pdev->dev.platform_da=
ta;
> +	struct usb_phy_gen_xceiv	*nop;
>  	enum usb_phy_type	type =3D USB_PHY_TYPE_USB2;
>  	int err;
>  	u32 clk_rate =3D 0;
> @@ -245,9 +245,9 @@ static int nop_usb_xceiv_probe(struct platform_device=
 *pdev)
>  	return err;
>  }
> =20
> -static int nop_usb_xceiv_remove(struct platform_device *pdev)
> +static int usb_phy_gen_xceiv_remove(struct platform_device *pdev)
>  {
> -	struct nop_usb_xceiv *nop =3D platform_get_drvdata(pdev);
> +	struct usb_phy_gen_xceiv *nop =3D platform_get_drvdata(pdev);
> =20
>  	if (!IS_ERR(nop->clk))
>  		clk_unprepare(nop->clk);
> @@ -264,29 +264,29 @@ static const struct of_device_id nop_xceiv_dt_ids[]=
 =3D {
> =20
>  MODULE_DEVICE_TABLE(of, nop_xceiv_dt_ids);
> =20
> -static struct platform_driver nop_usb_xceiv_driver =3D {
> -	.probe		=3D nop_usb_xceiv_probe,
> -	.remove		=3D nop_usb_xceiv_remove,
> +static struct platform_driver usb_phy_gen_xceiv_driver =3D {
> +	.probe		=3D usb_phy_gen_xceiv_probe,
> +	.remove		=3D usb_phy_gen_xceiv_remove,
>  	.driver		=3D {
> -		.name	=3D "nop_usb_xceiv",
> +		.name	=3D "usb_phy_gen_xceiv",
>  		.owner	=3D THIS_MODULE,
>  		.of_match_table =3D nop_xceiv_dt_ids,
>  	},
>  };
> =20
> -static int __init nop_usb_xceiv_init(void)
> +static int __init usb_phy_gen_xceiv_init(void)
>  {
> -	return platform_driver_register(&nop_usb_xceiv_driver);
> +	return platform_driver_register(&usb_phy_gen_xceiv_driver);
>  }
> -subsys_initcall(nop_usb_xceiv_init);
> +subsys_initcall(usb_phy_gen_xceiv_init);
> =20
> -static void __exit nop_usb_xceiv_exit(void)
> +static void __exit usb_phy_gen_xceiv_exit(void)
>  {
> -	platform_driver_unregister(&nop_usb_xceiv_driver);
> +	platform_driver_unregister(&usb_phy_gen_xceiv_driver);
>  }
> -module_exit(nop_usb_xceiv_exit);
> +module_exit(usb_phy_gen_xceiv_exit);
> =20
> -MODULE_ALIAS("platform:nop_usb_xceiv");
> +MODULE_ALIAS("platform:usb_phy_gen_xceiv");
>  MODULE_AUTHOR("Texas Instruments Inc");
>  MODULE_DESCRIPTION("NOP USB Transceiver driver");
>  MODULE_LICENSE("GPL");
> diff --git a/include/linux/usb/nop-usb-xceiv.h b/include/linux/usb/nop-us=
b-xceiv.h
> index 148d351..11d85b9 100644
> --- a/include/linux/usb/nop-usb-xceiv.h
> +++ b/include/linux/usb/nop-usb-xceiv.h
> @@ -3,7 +3,7 @@
> =20
>  #include <linux/usb/otg.h>
> =20
> -struct nop_usb_xceiv_platform_data {
> +struct usb_phy_gen_xceiv_platform_data {
>  	enum usb_phy_type type;
>  	unsigned long clk_rate;
> =20
> --=20
> 1.8.3.2
>=20

--=20
balbi

--juZjCTNxrMaZdGZC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR9l4GAAoJEIaOsuA1yqREoGYP/jnVIeP6JCwXKIXwqt4YprPF
t+afV1kJzAn9lk34Be70vit54+Mq1YcthzMYaLDmDpjRkwmeW1KqZ9NJIpwjkYxL
/g+SwGqlYBcS7G4iCEwray0ZyTtSrzdVf8Y5aeAI/Zq6CEZsyB01PNVPl91foVC9
0Arkz1Syjq7Mvb9/GELgoVWQedoj4eAdmGI8EeIZmxnE0OZNUWItB8qAY1VOB2ae
DamP4dOlR7hVokj5iB+Vfy8GQD/udjVnxvo1XoM+l8c+ulqptECt70o5uwvCoqaj
hHLR0O22yGCATjCJwbMwW8DPHvFx8CXK1lcxxhEHa/quBCoIHLHZwXx7KESnFY6M
WufKfEP4KkhXr3KsHYV30GhGDM8p30seAo+rXpPxcbrfSiaR9qwkaXV3hpbMKEwZ
4V4dytMHsY5qadReTXfwXzIomVTM66DtLYjtFzsf8tLphsyn7nPW8fuoV4wdIPh4
blqnVcLmeGKv+OjWhnUAT4WZzjYJh4aaQCmi0Z9ToC31jiUWSN9M2AhE0Gu0fbMC
lo4wJp5TUhAJb1gQtQmC07wIl7LKr9NqCJW9Pq1gq4htBwgIXZhkljHxg3Pi5uQ8
xNhKcb66BWq3xcgAYy5lh1T6twD5II6k8dGrds6SL1VWWWKdoy+SlMofS4k7FtGh
dikbpNWmM/tcewMDlZpy
=C4vw
-----END PGP SIGNATURE-----

--juZjCTNxrMaZdGZC--
