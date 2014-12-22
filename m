Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaLVQAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:00:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60101 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328AbaLVQAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:00:36 -0500
Date: Mon, 22 Dec 2014 09:59:36 -0600
From: Felipe Balbi <balbi@ti.com>
To: Sneeker Yeh <sneeker.yeh@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, Hans de Goede <hdegoede@redhat.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        David Mosberger <davidm@egauge.net>,
        Peter Griffin <peter.griffin@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: Re: [PATCH 2/3] usb: dwc3: add Fujitsu Specific Glue layer
Message-ID: <20141222155936.GB12815@saruman>
Reply-To: <balbi@ti.com>
References: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <1418695828-605-3-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Content-Disposition: inline
In-Reply-To: <1418695828-605-3-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 16, 2014 at 10:10:27AM +0800, Sneeker Yeh wrote:
> This patch adds support for Synopsis DesignWare USB3 IP Core found
> on Fujitsu Socs.
>=20
> Signed-off-by: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
> ---
>  .../devicetree/bindings/usb/fujitsu-dwc3.txt       |   25 +++
>  drivers/usb/dwc3/Kconfig                           |   11 ++
>  drivers/usb/dwc3/Makefile                          |    1 +
>  drivers/usb/dwc3/dwc3-mb86s70.c                    |  194 ++++++++++++++=
++++++
>  4 files changed, 231 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/usb/fujitsu-dwc3.txt
>  create mode 100644 drivers/usb/dwc3/dwc3-mb86s70.c
>=20
> diff --git a/Documentation/devicetree/bindings/usb/fujitsu-dwc3.txt b/Doc=
umentation/devicetree/bindings/usb/fujitsu-dwc3.txt
> new file mode 100644
> index 0000000..df77f91
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/fujitsu-dwc3.txt
> @@ -0,0 +1,25 @@
> +FUJITSU GLUE COMPONENTS
> +
> +MB86S7x DWC3 GLUE
> + - compatible : Should be "fujitsu,mb86s70-dwc3"
> + - clocks: from common clock binding, handle to usb clock.
> + - clock-names: from common clock binding.
> + - #address-cells, #size-cells : Must be present if the device has sub-n=
odes
> + - ranges: the child address space are mapped 1:1 onto the parent addres=
s space
> + - #stream-id-cells : handle to use "arm,mmu-400" ARM IOMMU driver
> +
> +Sub-nodes:
> +The dwc3 core should be added as subnode to MB86S7x dwc3 glue.
> +- dwc3 :
> +   The binding details of dwc3 can be found in:
> +   Documentation/devicetree/bindings/usb/dwc3.txt
> +
> +usb3host: mb86s70_usb3host {
> +	compatible =3D "fujitsu,mb86s70-dwc3";
> +	clocks =3D <&clk_alw_1_1>;
> +	clock-names =3D "bus_clk";
> +	#address-cells =3D <2>;
> +	#size-cells =3D <1>;
> +	ranges;
> +	#stream-id-cells =3D <0>;
> +};
> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> index 58b5b2c..3390d42 100644
> --- a/drivers/usb/dwc3/Kconfig
> +++ b/drivers/usb/dwc3/Kconfig
> @@ -61,6 +61,17 @@ config USB_DWC3_EXYNOS
>  	  Recent Exynos5 SoCs ship with one DesignWare Core USB3 IP inside,
>  	  say 'Y' or 'M' if you have one such device.
> =20
> +config USB_DWC3_MB86S70
> +	tristate "MB86S70 Designware USB3 Platform code"
> +	default USB_DWC3
> +	help
> +	  MB86S7X SOC ship with DesignWare Core USB3 IP inside,
> +	  this implementation also integrated Fujitsu USB PHY inside
> +	  this Core USB3 IP.
> +
> +	  say 'Y' or 'M' if you have one such device.
> +
> +
>  config USB_DWC3_PCI
>  	tristate "PCIe-based Platforms"
>  	depends on PCI
> diff --git a/drivers/usb/dwc3/Makefile b/drivers/usb/dwc3/Makefile
> index bb34fbc..05d1de2 100644
> --- a/drivers/usb/dwc3/Makefile
> +++ b/drivers/usb/dwc3/Makefile
> @@ -38,3 +38,4 @@ obj-$(CONFIG_USB_DWC3_PCI)		+=3D dwc3-pci.o
>  obj-$(CONFIG_USB_DWC3_KEYSTONE)		+=3D dwc3-keystone.o
>  obj-$(CONFIG_USB_DWC3_QCOM)		+=3D dwc3-qcom.o
>  obj-$(CONFIG_USB_DWC3_ST)		+=3D dwc3-st.o
> +obj-$(CONFIG_USB_DWC3_MB86S70)		+=3D dwc3-mb86s70.o
> diff --git a/drivers/usb/dwc3/dwc3-mb86s70.c b/drivers/usb/dwc3/dwc3-mb86=
s70.c
> new file mode 100644
> index 0000000..241c5bd
> --- /dev/null
> +++ b/drivers/usb/dwc3/dwc3-mb86s70.c
> @@ -0,0 +1,194 @@
> +/**
> + * dwc3-mb86s70.c - Fujitsu mb86s70 DWC3 Specific Glue layer
> + *
> + * Copyright (c) 2013 - 2014 FUJITSU SEMICONDUCTOR LIMITED
> + *		http://jp.fujitsu.com/group/fsl
> + *
> + * Author: Alice Chan <Alice.Chan@tw.fujitsu.com>
> + * based on dwc3-exynos.c
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/interrupt.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/clk.h>
> +
> +struct dwc3_mb86s70 {
> +	struct device	*dev;
> +	struct clk		**clk_table;

please align these.

> +};
> +
> +/* return 0 means successful */

this comment is unnecessary :-)

> +static int dwc3_mb86s70_clk_control(struct device *dev, bool on)
> +{
> +	int ret, i;
> +	struct clk *clk;
> +
> +	if (!on)
> +		goto clock_off;
> +
> +	for (i =3D 0;; i++) {
> +		clk =3D of_clk_get(dev->of_node, i);

you could count the number of properties first, then allocate clk_table
to the exact size.

> +		if (IS_ERR(clk))
> +			break;
> +
> +		ret =3D clk_prepare_enable(clk);
> +		if (ret) {
> +			dev_err(dev, "failed to enable clock[%d]\n", i);
> +			goto clock_off;
> +		}
> +	}
> +
> +	return 0;
> +
> +clock_off:
> +	for (i =3D 0;; i++) {
> +		clk =3D of_clk_get(dev->of_node, i);
> +		if (IS_ERR(clk))
> +			break;
> +
> +		clk_disable_unprepare(clk);
> +	}
> +
> +	return on;
> +}
> +
> +static int dwc3_mb86s70_remove_child(struct device *dev, void *unused)
> +{
> +	struct platform_device *pdev =3D to_platform_device(dev);
> +
> +	of_device_unregister(pdev);
> +
> +	return 0;
> +}
> +
> +static u64 dwc3_mb86s70_dma_mask =3D DMA_BIT_MASK(32);

why ? Use dma_coerce_mask_and_coherent().

> +
> +static int dwc3_mb86s70_probe(struct platform_device *pdev)
> +{
> +	struct dwc3_mb86s70	*mb86s70;
> +	struct device		*dev =3D &pdev->dev;
> +	struct device_node	*node =3D dev->of_node;
> +	int			ret;
> +
> +	mb86s70 =3D devm_kzalloc(dev, sizeof(*mb86s70), GFP_KERNEL);
> +	if (!mb86s70) {
> +		ret =3D -ENOMEM;
> +		goto err;
> +	}
> +
> +	dev->dma_mask =3D &dwc3_mb86s70_dma_mask;
> +
> +	platform_set_drvdata(pdev, mb86s70);
> +
> +	mb86s70->dev =3D dev;
> +
> +	/* resume driver for clock, power */
> +	pm_runtime_enable(&pdev->dev);
> +	ret =3D pm_runtime_get_sync(&pdev->dev);

here's a slightly better way (add error checking where necessary):

	dwc3_mb86s70_clk_control(dev, true);
	pm_runtime_set_active(dev);
	pm_runtime_enable(dev);
	pm_runtime_get(dev);


> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "get_sync failed with err %d\n", ret);
> +		goto err;

if get_sync() fails, you still need to call pm_runtime_put_sync(); In
this case, you also need to call pm_runtime_disable();

> +	}
> +
> +	if (node) {
> +		ret =3D of_platform_populate(node, NULL, NULL, dev);
> +		if (!ret)
> +			return 0;
> +		dev_err(dev, "failed to add dwc3 core\n");
> +	}
> +	dev_err(dev, "no device node, failed to add dwc3 core\n");
> +	ret =3D -ENODEV;
> +
> +err:
> +	return ret;
> +}
> +
> +static int dwc3_mb86s70_remove(struct platform_device *pdev)
> +{
> +	device_for_each_child(&pdev->dev, NULL, dwc3_mb86s70_remove_child);
> +
> +	pm_runtime_put_sync(&pdev->dev);
> +	pm_runtime_disable(&pdev->dev);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id mb86s70_dwc3_match[] =3D {
> +	{ .compatible =3D "fujitsu,mb86s70-dwc3" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, mb86s70_dwc3_match);
> +
> +#ifdef CONFIG_PM
> +#ifdef CONFIG_PM_RUNTIME
> +static int dwc3_mb86s70_runtime_suspend(struct device *dev)
> +{
> +	dwc3_mb86s70_clk_control(dev, false);
> +
> +	return 0;
> +}
> +
> +static int  dwc3_mb86s70_runtime_resume(struct device *dev)
> +{
> +	dwc3_mb86s70_clk_control(dev, true);
> +
> +	return 0;
> +}
> +#endif /* CONFIG_PM_RUNTIME */
> +static int dwc3_mb86s70_suspend(struct device *dev)
> +{
> +	if (pm_runtime_status_suspended(dev))
> +		return 0;
> +
> +	return dwc3_mb86s70_runtime_suspend(dev);

ok, this is a bit confusing and, in fact, wrong. You're not dealing with
wakeups (which are mandatory on runtime_pm and option on system sleep).

It's okay to have a common function called by both runtime_pm and
system_sleep methods, but calling your runtime_pm handler is a bit odd.

last but not least, I need to see results of this running on top of
v3.19-rc1. Are you using both host and peripheral modes or only one mode
for now ?

--=20
balbi

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmD/oAAoJEIaOsuA1yqREkuoQAK3gp6EDgskf5vU9lZ24mjB6
6xignxiAYu8IVOUFiBuj416vOctuwCU9x6lz8PH5doxMlbdomE31PCETDaKwSl47
iWscAG9MF2gjSs/7K8vXDxUGO5X/HO6vBIRYY35E1biZhV10Xpp6ABxcbMPqkVSR
jvlyIZ2zfJOSCFopkSroZt5YT6JRQTRdmmvos42JfCaICmqHm6QTk31kWGpTymq+
uqSzs/GToLTF7/zMaJwRFopXcIfS6mjAY8C0nlNkHx1DBDc8Ygcq/cC3jvVcBw5x
UeG/XCTcuxsPn/pTEH5t3HOUMFDxtY/EDQeuH9yYTLECiGb0AD2got5rOuEpdBKy
Hlslqvtp5wBRfjyndIIamH0BO8mn6erl67CV5tsnNmQ+jFaaqdhNRyzVZbjig6Ud
+UqwnQUkRBF+LWooycCNtSpxVAISKh75l67ZvM1uIDtcsm14Cr6TEzXiZ+Ys0Huw
hjuBciz/ASgozJOuZiN0PsO+LOv+yx8c7A/HDDkb4tMbcjK3pTqfTM+0ZOfuIY12
q/gULKmvopeyg/ONzBBkucMqr7M7x7JNOgxlAk/J0kToAhAMOErg5jtHfRtraA2U
Wnvel0cawC8dNDYPJOITfH6tYomjk9XGhvhToJcQu1mQlF12oI2Ax9rlX2yFnWL2
UUIjXfAoVPnsMH+z35mI
=A6ot
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
