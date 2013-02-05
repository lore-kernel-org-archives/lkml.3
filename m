Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab3BEJMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:12:01 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50308 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3BEJL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:11:58 -0500
Date: Tue, 5 Feb 2013 11:11:45 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 01/30] USB: EHCI: split ehci-omap out to a separate driver
Message-ID: <20130205091145.GI32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cf0hFtnykp6aONGL"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-2-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cf0hFtnykp6aONGL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:02PM +0200, Roger Quadros wrote:
> From: Alan Stern <stern@rowland.harvard.edu>
>=20
> This patch (as1645) converts ehci-omap over to the new "ehci-hcd is a
> library" approach, so that it can coexist peacefully with other EHCI
> platform drivers and can make use of the private area allocated at
> the end of struct ehci_hcd.
>=20
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

for ehci-omap:

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/host/Kconfig     |    2 +-
>  drivers/usb/host/Makefile    |    1 +
>  drivers/usb/host/ehci-hcd.c  |    6 +---
>  drivers/usb/host/ehci-omap.c |   76 +++++++++++++++++++-----------------=
------
>  4 files changed, 37 insertions(+), 48 deletions(-)
>=20
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 3a21c5d..11e102e 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -155,7 +155,7 @@ config USB_EHCI_MXC
>  	  Variation of ARC USB block used in some Freescale chips.
> =20
>  config USB_EHCI_HCD_OMAP
> -	bool "EHCI support for OMAP3 and later chips"
> +	tristate "EHCI support for OMAP3 and later chips"
>  	depends on USB_EHCI_HCD && ARCH_OMAP
>  	default y
>  	---help---
> diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
> index 001fbff..56de410 100644
> --- a/drivers/usb/host/Makefile
> +++ b/drivers/usb/host/Makefile
> @@ -27,6 +27,7 @@ obj-$(CONFIG_USB_EHCI_HCD)	+=3D ehci-hcd.o
>  obj-$(CONFIG_USB_EHCI_PCI)	+=3D ehci-pci.o
>  obj-$(CONFIG_USB_EHCI_HCD_PLATFORM)	+=3D ehci-platform.o
>  obj-$(CONFIG_USB_EHCI_MXC)	+=3D ehci-mxc.o
> +obj-$(CONFIG_USB_EHCI_HCD_OMAP)	+=3D ehci-omap.o
> =20
>  obj-$(CONFIG_USB_OXU210HP_HCD)	+=3D oxu210hp-hcd.o
>  obj-$(CONFIG_USB_ISP116X_HCD)	+=3D isp116x-hcd.o
> diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
> index 09537b2..5a35246 100644
> --- a/drivers/usb/host/ehci-hcd.c
> +++ b/drivers/usb/host/ehci-hcd.c
> @@ -1251,11 +1251,6 @@ MODULE_LICENSE ("GPL");
>  #define PLATFORM_DRIVER		ehci_hcd_sh_driver
>  #endif
> =20
> -#ifdef CONFIG_USB_EHCI_HCD_OMAP
> -#include "ehci-omap.c"
> -#define        PLATFORM_DRIVER         ehci_hcd_omap_driver
> -#endif
> -
>  #ifdef CONFIG_PPC_PS3
>  #include "ehci-ps3.c"
>  #define	PS3_SYSTEM_BUS_DRIVER	ps3_ehci_driver
> @@ -1345,6 +1340,7 @@ MODULE_LICENSE ("GPL");
>  	!IS_ENABLED(CONFIG_USB_EHCI_HCD_PLATFORM) && \
>  	!IS_ENABLED(CONFIG_USB_CHIPIDEA_HOST) && \
>  	!IS_ENABLED(CONFIG_USB_EHCI_MXC) && \
> +	!IS_ENABLED(CONFIG_USB_EHCI_HCD_OMAP) && \
>  	!defined(PLATFORM_DRIVER) && \
>  	!defined(PS3_SYSTEM_BUS_DRIVER) && \
>  	!defined(OF_PLATFORM_DRIVER) && \
> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
> index b96a4bf..30fc482 100644
> --- a/drivers/usb/host/ehci-omap.c
> +++ b/drivers/usb/host/ehci-omap.c
> @@ -36,6 +36,9 @@
>   *	- convert to use hwmod and runtime PM
>   */
> =20
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
>  #include <linux/usb/ulpi.h>
> @@ -43,6 +46,10 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/gpio.h>
>  #include <linux/clk.h>
> +#include <linux/usb.h>
> +#include <linux/usb/hcd.h>
> +
> +#include "ehci.h"
> =20
>  #include <linux/platform_data/usb-omap.h>
> =20
> @@ -57,9 +64,11 @@
>  #define	EHCI_INSNREG05_ULPI_EXTREGADD_SHIFT		8
>  #define	EHCI_INSNREG05_ULPI_WRDATA_SHIFT		0
> =20
> -/*----------------------------------------------------------------------=
---*/
> +#define DRIVER_DESC "OMAP-EHCI Host Controller driver"
> =20
> -static const struct hc_driver ehci_omap_hc_driver;
> +static const char hcd_name[] =3D "ehci-omap";
> +
> +/*----------------------------------------------------------------------=
---*/
> =20
> =20
>  static inline void ehci_write(void __iomem *base, u32 reg, u32 val)
> @@ -166,6 +175,12 @@ static void disable_put_regulator(
>  /* configure so an HC device and id are always provided */
>  /* always called with process context; sleeping is OK */
> =20
> +static struct hc_driver __read_mostly ehci_omap_hc_driver;
> +
> +static const struct ehci_driver_overrides ehci_omap_overrides __initdata=
 =3D {
> +	.reset =3D		omap_ehci_init,
> +};
> +
>  /**
>   * ehci_hcd_omap_probe - initialize TI-based HCDs
>   *
> @@ -315,56 +330,33 @@ static struct platform_driver ehci_hcd_omap_driver =
=3D {
>  	/*.suspend		=3D ehci_hcd_omap_suspend, */
>  	/*.resume		=3D ehci_hcd_omap_resume, */
>  	.driver =3D {
> -		.name		=3D "ehci-omap",
> +		.name		=3D hcd_name,
>  	}
>  };
> =20
>  /*----------------------------------------------------------------------=
---*/
> =20
> -static const struct hc_driver ehci_omap_hc_driver =3D {
> -	.description		=3D hcd_name,
> -	.product_desc		=3D "OMAP-EHCI Host Controller",
> -	.hcd_priv_size		=3D sizeof(struct ehci_hcd),
> -
> -	/*
> -	 * generic hardware linkage
> -	 */
> -	.irq			=3D ehci_irq,
> -	.flags			=3D HCD_MEMORY | HCD_USB2,
> -
> -	/*
> -	 * basic lifecycle operations
> -	 */
> -	.reset			=3D omap_ehci_init,
> -	.start			=3D ehci_run,
> -	.stop			=3D ehci_stop,
> -	.shutdown		=3D ehci_shutdown,
> -
> -	/*
> -	 * managing i/o requests and associated device resources
> -	 */
> -	.urb_enqueue		=3D ehci_urb_enqueue,
> -	.urb_dequeue		=3D ehci_urb_dequeue,
> -	.endpoint_disable	=3D ehci_endpoint_disable,
> -	.endpoint_reset		=3D ehci_endpoint_reset,
> +static int __init ehci_omap_init(void)
> +{
> +	if (usb_disabled())
> +		return -ENODEV;
> =20
> -	/*
> -	 * scheduling support
> -	 */
> -	.get_frame_number	=3D ehci_get_frame,
> +	pr_info("%s: " DRIVER_DESC "\n", hcd_name);
> =20
> -	/*
> -	 * root hub support
> -	 */
> -	.hub_status_data	=3D ehci_hub_status_data,
> -	.hub_control		=3D ehci_hub_control,
> -	.bus_suspend		=3D ehci_bus_suspend,
> -	.bus_resume		=3D ehci_bus_resume,
> +	ehci_init_driver(&ehci_omap_hc_driver, &ehci_omap_overrides);
> +	return platform_driver_register(&ehci_hcd_omap_driver);
> +}
> +module_init(ehci_omap_init);
> =20
> -	.clear_tt_buffer_complete =3D ehci_clear_tt_buffer_complete,
> -};
> +static void __exit ehci_omap_cleanup(void)
> +{
> +	platform_driver_unregister(&ehci_hcd_omap_driver);
> +}
> +module_exit(ehci_omap_cleanup);
> =20
>  MODULE_ALIAS("platform:omap-ehci");
>  MODULE_AUTHOR("Texas Instruments, Inc.");
>  MODULE_AUTHOR("Felipe Balbi <felipe.balbi@nokia.com>");
> =20
> +MODULE_DESCRIPTION(DRIVER_DESC);
> +MODULE_LICENSE("GPL");
> --=20
> 1.7.4.1
>=20

--=20
balbi

--cf0hFtnykp6aONGL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREMzRAAoJEIaOsuA1yqREMl8QAI0ryBy8g9GYcuMgFVH2HKai
7Z6U7smRfBzGuWrNHpGW3It/ayKyKuxNRf9CeFbStdiM9GOGTCW1klpGPjPJcL6/
FH06BbqtLRC2saDYHeaZyRj51+wvOwXsKCJbveWtLBEusHXc2jm+Oda+cZfg73DA
nU1CjCuGYaxzvTuGOEYmz/Dnpv1PkVAokxdCXe/ig5EIzID9lFzd3/6XLorNz2e3
5kvUr2lJgZU6iXNzAS7iA66D+fZB/0/MiaIf1+gn2YpafokWvcV/HfnGvd99V8GG
g99zIMbW4/O6KWNJp9/R2tWHb1z82H5AreaaPooju5AF6pWDXAV0veKX4dIU1dxE
E15A+2YVSrCeCVUSNBFIalZU+UhSMwyRSe5zqRyJ0KI2ucaparMbHe0LW/W//gCe
lKHZFxMjPN0skx/Peh8C/J6iqrCdwv12Ubq7rDJuJLtJTzliS006VB7uA72CtW9T
W//BGHyZou4+3qCg9iyj76XC7tHJdnNOyYToX7Eyn8SE7DsgKnRERb3HqFehFmoK
opwtNbbVt3KSUZQ26KLG9ig52OkYOefe8OmPSovNftJNAHCFvH85GDaNxYrE6334
qM2IYfC6HLiinnZqMPCYiVvzuj1J0La2DoqVh7aoEolP/QxcFS5Di+6zqX7NZaJy
keZerm6jtx/hGxqFGk+z
=QXHf
-----END PGP SIGNATURE-----

--cf0hFtnykp6aONGL--
