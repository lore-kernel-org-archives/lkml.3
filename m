Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab3IFUeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 16:34:13 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:61213 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3IFUeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 16:34:11 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH v2] ADP1653 board code for Nokia RX-51
Date: Fri, 6 Sep 2013 22:34:05 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.0; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201302171616.50152@pali> <20130217190303.GC2317@blackmetal.musicnaut.iki.fi> <201303062112.06417@pali>
In-Reply-To: <201303062112.06417@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1696311.H7yyvhgxLS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309062234.05878@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1696311.H7yyvhgxLS
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 06 March 2013 21:12:06 Pali Roh=C3=A1r wrote:
> On Sunday 17 February 2013 20:03:03 Aaro Koskinen wrote:
> > Hi,
> >=20
> > On Sun, Feb 17, 2013 at 04:16:49PM +0100, Pali Roh=C3=A1r wrote:
> > > I'm sending ADP1653 flash torch board code for Nokia
> > > RX-51. Kernel driver ADP1653 is already in upstream
> > > kernel. Board code was extracted from this big camera
> > > meego patch:
> > >=20
> > > https://api.pub.meego.com/public/source/CE:Adaptation:N900
> > > /k
> > > ernel-adaptation-n900/linux-2.6-Camera-for-Meego-N900-Ada
> > > pta tion-kernel-2.6.37-patch.patch
> >=20
> > You need to sign-off the patch.
>=20
> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
>=20
> > > --- /dev/null
> > > +++ b/arch/arm/mach-omap2/board-rx51-camera.c
> >=20
> > I'm not sure if adding a new file is sensible. There are
> > already 3 board files for RX-51, which I think is overkill.
>=20
> You can see that camera board code is big, so code was moved
> to separate file. Because not all camera drivers are
> upstreamed yet there is no camera support in RX-51 board
> code. Current peripheral file for RX-51 is big too and split
> camera code into separate file can be usefull...
>=20
> > > @@ -0,0 +1,177 @@
> > > +/*
> > > + * arch/arm/mach-omap2/board-rx51-camera.c
> > > + *
> > > + * Copyright (C) 2008 Nokia Corporation
> > > + *
> > > + * Contact: Sakari Ailus <sakari.ailus@nokia.com>
> > > + *          Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
> >=20
> > You should put these people to CC... Just to see if the
> > addresses are still valid (which I doubt).
>=20
> Ok, trying :-)
>=20
> > > +static int __init rx51_adp1653_init(void)
> > > +{
> > > +	int err;
> > > +
> > > +	err =3D gpio_request(ADP1653_GPIO_ENABLE, "adp1653
> > > enable"); +	if (err) {
> > > +		printk(KERN_ERR ADP1653_NAME
> > > +		       " Failed to request EN gpio\n");
> > > +		err =3D -ENODEV;
> > > +		goto err_omap_request_gpio;
> > > +	}
> > > +
> > > +	err =3D gpio_request(ADP1653_GPIO_INT, "adp1653
> > > interrupt"); +	if (err) {
> > > +		printk(KERN_ERR ADP1653_NAME " Failed to request IRQ
> > > gpio\n"); +		err =3D -ENODEV;
> > > +		goto err_omap_request_gpio_2;
> > > +	}
> > > +
> > > +	err =3D gpio_request(ADP1653_GPIO_STROBE, "adp1653
> > > strobe"); +	if (err) {
> > > +		printk(KERN_ERR ADP1653_NAME
> > > +		       " Failed to request STROBE gpio\n");
> > > +		err =3D -ENODEV;
> > > +		goto err_omap_request_gpio_3;
> > > +	}
> > > +
> > > +	gpio_direction_output(ADP1653_GPIO_ENABLE, 0);
> > > +	gpio_direction_input(ADP1653_GPIO_INT);
> > > +	gpio_direction_output(ADP1653_GPIO_STROBE, 0);
> >=20
> > gpio_request_array() should be used.
>=20
> Ok, fixing this.
>=20
> > > +void __init rx51_camera_init(void)
> > > +{
> > > +	if (rx51_camera_hw_init()) {
> > > +		printk(KERN_WARNING "%s: Unable to initialize
> > > camera\n", +		       __func__);
> > > +		return;
> > > +	}
> > > +
> > > +	if (omap3_init_camera(&rx51_isp_platform_data) < 0)
> > > +		printk(KERN_WARNING "%s: Unable to register camera
> > > platform " +		       "device\n", __func__);
> >=20
> > pr_warn() should be used.
> >=20
> > A.
>=20
> Fixed too.
>=20
> Here is new version v2 of this patch:
>=20
> diff --git a/arch/arm/mach-omap2/Kconfig
> b/arch/arm/mach-omap2/Kconfig index 41b581f..268fa57 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -287,6 +287,7 @@ config MACH_NOKIA_RX51
>  	depends on ARCH_OMAP3
>  	default y
>  	select OMAP_PACKAGE_CBB
> +	select VIDEO_ADP1653 if VIDEO_OMAP3 &&
> VIDEO_HELPER_CHIPS_AUTO
>=20
>  config MACH_OMAP_ZOOM2
>  	bool "OMAP3 Zoom2 board"
> diff --git a/arch/arm/mach-omap2/Makefile
> b/arch/arm/mach-omap2/Makefile index 947cafe..f20f693 100644
> --- a/arch/arm/mach-omap2/Makefile
> +++ b/arch/arm/mach-omap2/Makefile
> @@ -236,6 +236,7 @@ obj-$(CONFIG_MACH_NOKIA_RM680)		+=3D
> board-rm680.o sdram-nokia.o obj-$(CONFIG_MACH_NOKIA_RX51)		+=3D
> board-rx51.o sdram-nokia.o obj-$(CONFIG_MACH_NOKIA_RX51)	=09
+=3D
> board-rx51-peripherals.o obj-$(CONFIG_MACH_NOKIA_RX51)		+=3D
> board-rx51-video.o +obj-$(CONFIG_MACH_NOKIA_RX51)		+=3D
> board-rx51-camera.o obj-$(CONFIG_MACH_OMAP_ZOOM2)		+=3D
> board-zoom.o board-zoom-peripherals.o
> obj-$(CONFIG_MACH_OMAP_ZOOM2)		+=3D board-zoom-display.o
> obj-$(CONFIG_MACH_OMAP_ZOOM2)		+=3D board-zoom-debugboard.o
> diff --git a/arch/arm/mach-omap2/board-rx51-camera.c
> b/arch/arm/mach-omap2/board-rx51-camera.c new file mode
> 100644
> index 0000000..80057ab
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-rx51-camera.c
> @@ -0,0 +1,152 @@
> +/*
> + * arch/arm/mach-omap2/board-rx51-camera.c
> + *
> + * Copyright (C) 2008 Nokia Corporation
> + *
> + * Contact: Sakari Ailus <sakari.ailus@nokia.com>
> + *          Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
> + *
> + * This program is free software; you can redistribute it
> and/or + * modify it under the terms of the GNU General
> Public License + * version 2 as published by the Free
> Software Foundation. + *
> + * This program is distributed in the hope that it will be
> useful, but + * WITHOUT ANY WARRANTY; without even the
> implied warranty of + * MERCHANTABILITY or FITNESS FOR A
> PARTICULAR PURPOSE.  See the GNU + * General Public License
> for more details.
> + *
> + * You should have received a copy of the GNU General Public
> License + * along with this program; if not, write to the
> Free Software + * Foundation, Inc., 51 Franklin St, Fifth
> Floor, Boston, MA + * 02110-1301 USA
> + *
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/delay.h>
> +#include <linux/gpio.h>
> +
> +#include "../../../drivers/media/platform/omap3isp/isp.h"
> +
> +#include <media/adp1653.h>
> +
> +#include "devices.h"
> +
> +#define ADP1653_GPIO_ENABLE	88	/* Used for resetting ADP1653
> */ +#define ADP1653_GPIO_INT	167	/* Fault interrupt */
> +#define ADP1653_GPIO_STROBE	126	/* Pin used in cam_strobe
> mode -> +					 * control using ISP drivers */
> +
> +static struct gpio rx51_adp1653_gpios[] __initdata =3D {
> +	{ ADP1653_GPIO_ENABLE,	GPIOF_OUT_INIT_LOW,	"adp1653=20
enable"
> }, +	{ ADP1653_GPIO_INT,	GPIOF_IN,		"adp1653 interrupt" },
> +	{ ADP1653_GPIO_STROBE,	GPIOF_OUT_INIT_LOW,	"adp1653=20
strobe"
> }, +};
> +
> +static int __init rx51_adp1653_init(void)
> +{
> +	int ret;
> +
> +	ret =3D gpio_request_array(rx51_adp1653_gpios,
> +				 ARRAY_SIZE(rx51_adp1653_gpios));
> +	if (ret < 0) {
> +		pr_err(ADP1653_NAME ": Failed to request gpios\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __init rx51_camera_hw_init(void)
> +{
> +	int rval;
> +
> +	rval =3D rx51_adp1653_init();
> +	if (rval)
> +		return rval;
> +
> +	return 0;
> +}
> +
> +/*
> + *
> + * ADP1653
> + *
> + */
> +
> +static int rx51_adp1653_power(struct v4l2_subdev *subdev, int
> on) +{
> +	gpio_set_value(ADP1653_GPIO_ENABLE, on);
> +	if (on) {
> +		/* Some delay is apparently required. */
> +		udelay(20);
> +	}
> +
> +	return 0;
> +}
> +
> +static struct adp1653_platform_data
> rx51_adp1653_platform_data =3D { +	.power			 =3D
> rx51_adp1653_power,
> +	/* Must be limited to 500 ms in RX-51 */
> +	.max_flash_timeout	 =3D 500000,		/* us */
> +	/* Must be limited to 320 mA in RX-51 B3 and newer hardware
> */ +	.max_flash_intensity	 =3D
> ADP1653_FLASH_INTENSITY_REG_TO_mA(19), +	/* Must be limited
> to 50 mA in RX-51 */
> +	.max_torch_intensity	 =3D
> ADP1653_FLASH_INTENSITY_REG_TO_mA(1),
> +	.max_indicator_intensity =3D
> ADP1653_INDICATOR_INTENSITY_REG_TO_uA(
> +		ADP1653_REG_OUT_SEL_ILED_MAX),
> +};
> +
> +/*
> + *
> + * Init it all
> + *
> + */
> +
> +#define ADP1653_I2C_BUS_NUM		2
> +
> +static struct i2c_board_info rx51_camera_i2c_devices[] =3D {
> +	{
> +		I2C_BOARD_INFO(ADP1653_NAME, ADP1653_I2C_ADDR),
> +		.platform_data =3D &rx51_adp1653_platform_data,
> +	},
> +};
> +
> +static struct isp_subdev_i2c_board_info
> rx51_camera_primary_subdevs[] =3D { +	{
> +		.board_info =3D &rx51_camera_i2c_devices[0],
> +		.i2c_adapter_id =3D ADP1653_I2C_BUS_NUM,
> +	},
> +	{ NULL, 0, },
> +};
> +
> +static struct isp_v4l2_subdevs_group rx51_camera_subdevs[] =3D
> { +	{
> +		.subdevs =3D rx51_camera_primary_subdevs,
> +		.interface =3D ISP_INTERFACE_CCP2B_PHY1,
> +		.bus =3D { .ccp2 =3D {
> +			.strobe_clk_pol		=3D 0,
> +			.crc			=3D 1,
> +			.ccp2_mode		=3D 1,
> +			.phy_layer		=3D 1,
> +			.vpclk_div		=3D 1,
> +		} },
> +	},
> +	{ NULL, 0, },
> +};
> +
> +static struct isp_platform_data rx51_isp_platform_data =3D {
> +	.subdevs =3D rx51_camera_subdevs,
> +};
> +
> +void __init rx51_camera_init(void)
> +{
> +	if (rx51_camera_hw_init()) {
> +		pr_warn("%s: Unable to initialize camera\n", __func__);
> +		return;
> +	}
> +
> +	if (omap3_init_camera(&rx51_isp_platform_data) < 0)
> +		pr_warn("%s: Unable to register camera platform "
> +		       "device\n", __func__);
> +}
> diff --git a/arch/arm/mach-omap2/board-rx51.c
> b/arch/arm/mach-omap2/board-rx51.c index d0374ea..92117a13
> 100644
> --- a/arch/arm/mach-omap2/board-rx51.c
> +++ b/arch/arm/mach-omap2/board-rx51.c
> @@ -75,6 +75,7 @@ static struct platform_device leds_gpio =3D {
>  */
>=20
>  extern void __init rx51_peripherals_init(void);
> +extern void __init rx51_camera_init(void);
>=20
>  #ifdef CONFIG_OMAP_MUX
>  static struct omap_board_mux board_mux[] __initdata =3D {
> @@ -100,6 +101,7 @@ static void __init rx51_init(void)
>=20
>  	usb_musb_init(&musb_board_data);
>  	rx51_peripherals_init();
> +	rx51_camera_init();
>=20
>  	/* Ensure SDRC pins are mux'd for self-refresh */
>  	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);

Ping, can you review this patch v2?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1696311.H7yyvhgxLS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlIqPD0ACgkQi/DJPQPkQ1KJUgCfYz1SQDNtIdbUmXH47fK135Be
9wEAnAkeKwmT3M9+2YeBcfXNJoX5UFs0
=5jxi
-----END PGP SIGNATURE-----

--nextPart1696311.H7yyvhgxLS--
