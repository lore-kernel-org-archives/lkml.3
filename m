Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab3JJPcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:32:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50178 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab3JJPck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:32:40 -0400
Date: Thu, 10 Oct 2013 10:31:54 -0500
From: Felipe Balbi <balbi@ti.com>
To: Matt Porter <matt.porter@linaro.org>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 3/5] usb: phy: add Broadcom Kona USB control driver
Message-ID: <20131010153154.GG28375@radagast>
Reply-To: <balbi@ti.com>
References: <1381140752-312-1-git-send-email-matt.porter@linaro.org>
 <1381140752-312-4-git-send-email-matt.porter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TdkiTnkLhLQllcMS"
Content-Disposition: inline
In-Reply-To: <1381140752-312-4-git-send-email-matt.porter@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TdkiTnkLhLQllcMS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 07, 2013 at 06:12:30AM -0400, Matt Porter wrote:
> Broadcom BCM281xx parts have a PHY control block that
> operates in conjunction with the DWC2 USB OTG. This driver
> exposes an API that allows control of power/reset for a
> connected USB PHY.
>=20
> Signed-off-by: Matt Porter <matt.porter@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> ---
>  .../devicetree/bindings/usb/bcm-kona-usb-ctrl.txt  |  12 ++
>  drivers/usb/phy/Kconfig                            |   5 +
>  drivers/usb/phy/Makefile                           |   1 +
>  drivers/usb/phy/bcm-kona-usb.h                     |  31 +++++
>  drivers/usb/phy/phy-bcm-kona-ctrl.c                | 151 +++++++++++++++=
++++++
>  5 files changed, 200 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/usb/bcm-kona-usb-ct=
rl.txt
>  create mode 100644 drivers/usb/phy/bcm-kona-usb.h
>  create mode 100644 drivers/usb/phy/phy-bcm-kona-ctrl.c
>=20
> diff --git a/Documentation/devicetree/bindings/usb/bcm-kona-usb-ctrl.txt =
b/Documentation/devicetree/bindings/usb/bcm-kona-usb-ctrl.txt
> new file mode 100644
> index 0000000..98163f6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/bcm-kona-usb-ctrl.txt
> @@ -0,0 +1,12 @@
> +BROADCOM KONA USB CONTROL
> +
> +Required properties:
> + - compatible: brcm,kona-ctrl-usb
> + - reg: offset and length of the USB control registers
> +
> +Example:
> +
> +	usbctl: usbctl@3f130000 {
> +		compatible =3D "brcm,kona-ctrl-usb";
> +		reg =3D <0x3f130000 0x28>;
> +	};
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index d5589f9..2b7b4f1 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -100,6 +100,11 @@ config AM335X_PHY_USB
>  	  This driver provides PHY support for that phy which part for the
>  	  AM335x SoC.
> =20
> +config BCM_KONA_CTRL_USB
> +	tristate
> +	help
> +	  Enable this to support the Broadcom Kona USB control block
> +
>  config SAMSUNG_USBPHY
>  	tristate
>  	help
> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
> index 2135e85..98c545e 100644
> --- a/drivers/usb/phy/Makefile
> +++ b/drivers/usb/phy/Makefile
> @@ -15,6 +15,7 @@ obj-$(CONFIG_NOP_USB_XCEIV)		+=3D phy-generic.o
>  obj-$(CONFIG_OMAP_CONTROL_USB)		+=3D phy-omap-control.o
>  obj-$(CONFIG_AM335X_CONTROL_USB)	+=3D phy-am335x-control.o
>  obj-$(CONFIG_AM335X_PHY_USB)		+=3D phy-am335x.o
> +obj-$(CONFIG_BCM_KONA_CTRL_USB)		+=3D phy-bcm-kona-ctrl.o
>  obj-$(CONFIG_OMAP_USB2)			+=3D phy-omap-usb2.o
>  obj-$(CONFIG_OMAP_USB3)			+=3D phy-omap-usb3.o
>  obj-$(CONFIG_SAMSUNG_USBPHY)		+=3D phy-samsung-usb.o
> diff --git a/drivers/usb/phy/bcm-kona-usb.h b/drivers/usb/phy/bcm-kona-us=
b.h
> new file mode 100644
> index 0000000..4563dd6
> --- /dev/null
> +++ b/drivers/usb/phy/bcm-kona-usb.h
> @@ -0,0 +1,31 @@
> +/*
> + * bcm_kona_usb.h -- Broadcom Kona USB header file
> + *
> + * Copyright (C) 2013 Linaro Limited
> + * Matt Porter <matt.porter@linaro.org>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __BCM_KONA_USB_H
> +#define __BCM_KONA_USB_H
> +
> +#include <linux/usb/phy.h>
> +
> +struct bcm_kona_usb {
> +	struct usb_phy phy;
> +	struct device *dev;
> +	struct device *ctrl_dev;
> +};
> +
> +extern struct device *bcm_kona_get_ctrl_dev(void);
> +extern void bcm_kona_ctrl_usb_phy_power(struct device *, int);

looks like a job for extcon fwk.

> diff --git a/drivers/usb/phy/phy-bcm-kona-ctrl.c b/drivers/usb/phy/phy-bc=
m-kona-ctrl.c
> new file mode 100644
> index 0000000..d2936b6
> --- /dev/null
> +++ b/drivers/usb/phy/phy-bcm-kona-ctrl.c
> @@ -0,0 +1,151 @@
> +/*
> + * phy-bcm-kona-ctrl.c - Broadcom Kona USB Control Driver
> + *
> + * Based on phy-omap-control.c
> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
> + * Copyright (C) 2013 Linaro Limited
> + * Matt Porter <matt.porter@linaro.org>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/of.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/clk.h>
> +
> +#include "bcm-kona-usb.h"
> +
> +#define OTGCTL_OTGSTAT2		(1 << 31)
> +#define OTGCTL_OTGSTAT1		(1 << 30)
> +#define OTGCTL_PRST_N_SW	(1 << 11)
> +#define OTGCTL_HRESET_N		(1 << 10)
> +#define OTGCTL_UTMI_LINE_STATE1	(1 << 9)
> +#define OTGCTL_UTMI_LINE_STATE0	(1 << 8)
> +
> +#define P1CTL_SOFT_RESET	(1 << 1)
> +#define P1CTL_NON_DRIVING	(1 << 0)
> +
> +struct bcm_kona_usb_ctrl_regs {
> +	u32 ctrl;
> +	u32 cfg;
> +	u32 p1ctl;
> +	u32 status;
> +	u32 bc_cfg;
> +	u32 tp_in;
> +	u32 tp_out;
> +	u32 phy_ctrl;
> +	u32 usbreg;
> +	u32 usbproben;
> +};
> +
> +struct bcm_kona_ctrl_usb {
> +	struct device *dev;
> +	struct bcm_kona_usb_ctrl_regs *regs;
> +};
> +
> +static struct bcm_kona_ctrl_usb *ctrl_usb;
> +
> +/**
> + * bcm_kona_ctrl_dev - returns the device pointer for this control device
> + *
> + * This API should be called to get the device pointer for the Kona USB
> + * control device. This device pointer should be used when calling the
> + * exported bcm_kona_ctrl_usb_phy_power() API.
> + */
> +struct device *bcm_kona_get_ctrl_dev(void)
> +{
> +	if (!ctrl_usb)
> +		return ERR_PTR(-ENODEV);
> +
> +	return ctrl_usb->dev;
> +}
> +EXPORT_SYMBOL_GPL(bcm_kona_get_ctrl_dev);

definitely a job for extcon ;-)

> +void bcm_kona_ctrl_usb_phy_power(struct device *dev, int on)
> +{
> +	struct bcm_kona_ctrl_usb *ctrl =3D dev_get_drvdata(dev);
> +	u32 val;
> +
> +	val =3D readl(&ctrl->regs->ctrl);
> +	if (on) {
> +		/* Configure and power PHY */
> +		val &=3D ~(OTGCTL_OTGSTAT2 | OTGCTL_OTGSTAT1 |
> +			 OTGCTL_UTMI_LINE_STATE1 | OTGCTL_UTMI_LINE_STATE0);
> +		val |=3D OTGCTL_PRST_N_SW | OTGCTL_HRESET_N;
> +		writel(val, &ctrl->regs->ctrl);
> +
> +		/* Soft reset PHY */
> +		val =3D readl(&ctrl->regs->p1ctl);
> +		val &=3D ~P1CTL_NON_DRIVING;
> +		val |=3D P1CTL_SOFT_RESET;
> +		writel(val, &ctrl->regs->p1ctl);
> +		writel(val & ~P1CTL_SOFT_RESET, &ctrl->regs->p1ctl);
> +		/* Reset needs to be asserted for 2ms */
> +		mdelay(2);
> +		writel(val | P1CTL_SOFT_RESET, &ctrl->regs->p1ctl);
> +	} else {
> +		val &=3D ~(OTGCTL_PRST_N_SW | OTGCTL_HRESET_N);
> +		writel(val, &ctrl->regs->ctrl);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(bcm_kona_ctrl_usb_phy_power);

what a hack :-)

Please use phy->init() and phy->exit() callbacks. In fact, please use
Kishon's generic PHY layer.

--=20
balbi

--TdkiTnkLhLQllcMS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSVshpAAoJEIaOsuA1yqREM9AP/1T6Kb4ciAYbm13o1Uo2iSxr
nVMgaVUqL2iSf9F5TWki2aDm4uqLWs1StPdIuYSWviVLZePOBKiFZZYaRwupfLIX
UFlBDN0/YEakIIjePpmWHMP5KLqWEB2kRCEtJGz0VrGIM7pgYeF7pPwm7UkxI9Ox
o+/x08LYBQ8HwePmPVvEPLg9uagYAgtawnEOzHkJywjAbP2VH/FjtMeOuHQhwj1z
YWaEP2QWMTc8yRlmkULjC1teg6hEjhgqK3nKbWfo+wGbANe0SZM+087XpwSjtAn4
K5EXauQxsTsTwzAsFdyBrrRzL2goQ/R9EugZxb8tqO5c1eudGRqauGtKz6oQ5tKB
HldcFRdMyLESkFj0slKmPTCDcFPK5wVAZKdONpRSQ2ttNFB2NscfZpzB9NBMpxhV
XUXTmLm6NBR54phFY/WnfzP+fubQ+0t+Nr45lAGj8GVDATwOl2V2A+BA6ynn9PMX
1hNYH7fsJgvS5v6U6tEZYBuv4Vt5EJBro7L4QhlNyLa9J5Y4XbsjPcnCh4aLbYAw
xtP65FdQy3o/8SL/CVOIs3QRmrISwmx3W72jTXeKn65bEoEeJ0G+OX0F9/oXdbiY
+LwXwUpwDD4xabfv7Jq54jiktHUduFwIU1+YXCSCxHO2tvqdb+sHc0oxhoUAAJ5Z
Nzl4yywhBuF5XWUJuaGJ
=DU+Z
-----END PGP SIGNATURE-----

--TdkiTnkLhLQllcMS--
