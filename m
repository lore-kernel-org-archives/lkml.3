Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984Ab3JOL6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:58:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48595 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583Ab3JOL6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:58:35 -0400
Date: Tue, 15 Oct 2013 06:57:41 -0500
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <balbi@ti.com>,
        Vivek Gautam <gautamvivek1987@gmail.com>, <bcousson@baylibre.com>,
        <tony@atomide.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] usb: dwc3: adapt dwc3 core to use Generic PHY
 Framework
Message-ID: <20131015115741.GD11380@radagast>
Reply-To: <balbi@ti.com>
References: <1378136591-7463-1-git-send-email-kishon@ti.com>
 <1378136591-7463-3-git-send-email-kishon@ti.com>
 <525814A9.7060106@ti.com>
 <525BB8C0.1070802@ti.com>
 <525BC5A9.3060904@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qGV0fN9tzfkG3CxV"
Content-Disposition: inline
In-Reply-To: <525BC5A9.3060904@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qGV0fN9tzfkG3CxV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 14, 2013 at 01:21:29PM +0300, Roger Quadros wrote:
> +Vivek
>=20
> On 10/14/2013 12:26 PM, Kishon Vijay Abraham I wrote:
> > Hi Roger,
> >=20
> > On Friday 11 October 2013 08:39 PM, Roger Quadros wrote:
> >> Hi,
> >>
> >> On 09/02/2013 06:43 PM, Kishon Vijay Abraham I wrote:
> >>> Adapted dwc3 core to use the Generic PHY Framework. So for init, exit,
> >>> power_on and power_off the following APIs are used phy_init(), phy_ex=
it(),
> >>> phy_power_on() and phy_power_off().
> >>>
> >>> However using the old USB phy library wont be removed till the PHYs o=
f all
> >>> other SoC's using dwc3 core is adapted to the Generic PHY Framework.
> >>>
> >>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >>> ---
> >>>  Documentation/devicetree/bindings/usb/dwc3.txt |    6 ++-
> >>>  drivers/usb/dwc3/Kconfig                       |    1 +
> >>>  drivers/usb/dwc3/core.c                        |   49 ++++++++++++++=
++++++++++
> >>>  drivers/usb/dwc3/core.h                        |    7 ++++
> >>>  4 files changed, 61 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documen=
tation/devicetree/bindings/usb/dwc3.txt
> >>> index e807635..471366d 100644
> >>> --- a/Documentation/devicetree/bindings/usb/dwc3.txt
> >>> +++ b/Documentation/devicetree/bindings/usb/dwc3.txt
> >>> @@ -6,11 +6,13 @@ Required properties:
> >>>   - compatible: must be "snps,dwc3"
> >>>   - reg : Address and length of the register set for the device
> >>>   - interrupts: Interrupts used by the dwc3 controller.
> >>> +
> >>> +Optional properties:
> >>>   - usb-phy : array of phandle for the PHY device.  The first element
> >>>     in the array is expected to be a handle to the USB2/HS PHY and
> >>>     the second element is expected to be a handle to the USB3/SS PHY
> >>> -
> >>> -Optional properties:
> >>> + - phys: from the *Generic PHY* bindings
> >>> + - phy-names: from the *Generic PHY* bindings
> >>>   - tx-fifo-resize: determines if the FIFO *has* to be reallocated.
> >>> =20
> >>>  This is usually a subnode to DWC3 glue to which it is connected.
> >>> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> >>> index cfc16dd..ad7ce83 100644
> >>> --- a/drivers/usb/dwc3/Kconfig
> >>> +++ b/drivers/usb/dwc3/Kconfig
> >>> @@ -3,6 +3,7 @@ config USB_DWC3
> >>>  	depends on (USB || USB_GADGET) && GENERIC_HARDIRQS && HAS_DMA
> >>>  	depends on EXTCON
> >>>  	select USB_PHY
> >>> +	select GENERIC_PHY
> >>>  	select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
> >>>  	help
> >>>  	  Say Y or M here if your system has a Dual Role SuperSpeed
> >>> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> >>> index 428c29e..485d365 100644
> >>> --- a/drivers/usb/dwc3/core.c
> >>> +++ b/drivers/usb/dwc3/core.c
> >>> @@ -82,6 +82,12 @@ static void dwc3_core_soft_reset(struct dwc3 *dwc)
> >>> =20
> >>>  	usb_phy_init(dwc->usb2_phy);
> >>>  	usb_phy_init(dwc->usb3_phy);
> >>
> >> How about adding
> >> +	if (dwc->usb2_phy)
> >> +		usb_phy_init(dwc->usb2_phy);
> >> +	if (dwc->usb3_phy)
> >> +		usb_phy_init(dwc->usb3_phy);
> >=20
> > Thankfully that usb_phy_init will check if phy is NULL.
> >>
> >> both usb phy and generic phy shouldn't be present together.
> >=20
> > ok.
> >>
> >>> +
> >>> +	if (dwc->usb2_generic_phy)
> >>> +		phy_init(dwc->usb2_generic_phy);
> >>> +	if (dwc->usb3_generic_phy)
> >>> +		phy_init(dwc->usb3_generic_phy);
> >>> +
> >>>  	mdelay(100);
> >>> =20
> >>>  	/* Clear USB3 PHY reset */
> >>> @@ -343,6 +349,11 @@ static void dwc3_core_exit(struct dwc3 *dwc)
> >>>  {
> >>>  	usb_phy_shutdown(dwc->usb2_phy);
> >>>  	usb_phy_shutdown(dwc->usb3_phy);
> >>
> >> here as well
> >>
> >>> +
> >>> +	if (dwc->usb2_generic_phy)
> >>> +		phy_power_off(dwc->usb2_generic_phy);
> >>> +	if (dwc->usb3_generic_phy)
> >>> +		phy_power_off(dwc->usb3_generic_phy);
> >>>  }
> >>> =20
> >>>  #define DWC3_ALIGN_MASK		(16 - 1)
> >>> @@ -427,6 +438,23 @@ static int dwc3_probe(struct platform_device *pd=
ev)
> >>>  		dwc->usb3_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
> >>>  	}
> >>> =20
> >>> +	if (of_property_read_bool(node, "phys") || pdata->has_phy) {
> >>> +		dwc->usb2_generic_phy =3D devm_phy_get(dev, "usb2-phy");
> >>> +		if (IS_ERR(dwc->usb2_generic_phy)) {
> >>> +			dev_err(dev, "no usb2 phy configured yet");
> >>> +			return PTR_ERR(dwc->usb2_generic_phy);
> >>> +		}
> >>> +
> >>> +		dwc->usb3_generic_phy =3D devm_phy_get(dev, "usb3-phy");
> >>> +		if (IS_ERR(dwc->usb3_generic_phy)) {
> >>> +			dev_err(dev, "no usb3 phy configured yet");
> >>> +			return PTR_ERR(dwc->usb3_generic_phy);
> >>> +		}
> >>
> >> better to add
> >> +		/* Don't use USB PHY if generic PHY was found */
> >> +		dwc->usb2_phy =3D dwc->usb3_phy =3D NULL;
> >=20
> > ok.
> >>
> >>> +	} else {
> >>
> >> not required as we've used kzalloc for dwc.
> >>
> >>> +		dwc->usb2_generic_phy =3D NULL;
> >>> +		dwc->usb3_generic_phy =3D NULL;
> >>> +	}
> >>> +
> >>>  	/* default to superspeed if no maximum_speed passed */
> >>>  	if (dwc->maximum_speed =3D=3D USB_SPEED_UNKNOWN)
> >>>  		dwc->maximum_speed =3D USB_SPEED_SUPER;
> >>> @@ -450,6 +478,11 @@ static int dwc3_probe(struct platform_device *pd=
ev)
> >>
> >> if (dwc->usb2_phy)
> >>
> >>>  	usb_phy_set_suspend(dwc->usb2_phy, 0);
> >>
> >> if (dwc->usb3_phy)
> >>
> >>>  	usb_phy_set_suspend(dwc->usb3_phy, 0);
> >>> =20
> >>> +	if (dwc->usb2_generic_phy)
> >>> +		phy_power_on(dwc->usb2_generic_phy);
> >>> +	if (dwc->usb3_generic_phy)
> >>> +		phy_power_on(dwc->usb3_generic_phy);
> >>> +
> >>>  	spin_lock_init(&dwc->lock);
> >>>  	platform_set_drvdata(pdev, dwc);
> >>> =20
> >>> @@ -576,6 +609,11 @@ static int dwc3_remove(struct platform_device *p=
dev)
> >>
> >> if (dwc->usb2_phy)
> >>>  	usb_phy_set_suspend(dwc->usb2_phy, 1);
> >>
> >> if (dwc->usb3_phy)
> >>>  	usb_phy_set_suspend(dwc->usb3_phy, 1);
> >>> =20
> >>> +	if (dwc->usb2_generic_phy)
> >>> +		phy_power_off(dwc->usb2_generic_phy);
> >>> +	if (dwc->usb3_generic_phy)
> >>> +		phy_power_off(dwc->usb3_generic_phy);
> >>> +
> >>>  	pm_runtime_put(&pdev->dev);
> >>>  	pm_runtime_disable(&pdev->dev);
> >>> =20
> >>> @@ -673,6 +711,11 @@ static int dwc3_suspend(struct device *dev)
> >>
> >> if (dwc->usb3_phy)
> >>>  	usb_phy_shutdown(dwc->usb3_phy);
> >>
> >> if (dwc->usb2_phy)
> >>>  	usb_phy_shutdown(dwc->usb2_phy);
> >>> =20
> >>> +	if (dwc->usb2_generic_phy)
> >>> +		phy_exit(dwc->usb2_generic_phy);
> >>> +	if (dwc->usb3_generic_phy)
> >>> +		phy_exit(dwc->usb3_generic_phy);
> >>> +
> >>>  	return 0;
> >>>  }
> >>> =20
> >>> @@ -683,6 +726,12 @@ static int dwc3_resume(struct device *dev)
> >>> =20
> >>
> >> if (dwc->usb3_phy)
> >>>  	usb_phy_init(dwc->usb3_phy);
> >>
> >> if (dwc->usb2_phy)
> >>>  	usb_phy_init(dwc->usb2_phy);
> >>> +
> >>> +	if (dwc->usb2_generic_phy)
> >>> +		phy_init(dwc->usb2_generic_phy);
> >>> +	if (dwc->usb3_generic_phy)
> >>> +		phy_init(dwc->usb3_generic_phy);
> >>> +
> >>>  	msleep(100);
> >>> =20
> >>>  	spin_lock_irqsave(&dwc->lock, flags);
> >>> diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
> >>> index f8af8d4..01ec7d7 100644
> >>> --- a/drivers/usb/dwc3/core.h
> >>> +++ b/drivers/usb/dwc3/core.h
> >>> @@ -31,6 +31,8 @@
> >>>  #include <linux/usb/gadget.h>
> >>>  #include <linux/usb/otg.h>
> >>> =20
> >>> +#include <linux/phy/phy.h>
> >>> +
> >>>  /* Global constants */
> >>>  #define DWC3_EP0_BOUNCE_SIZE	512
> >>>  #define DWC3_ENDPOINTS_NUM	32
> >>> @@ -613,6 +615,8 @@ struct dwc3_scratchpad_array {
> >>>   * @dr_mode: requested mode of operation
> >>>   * @usb2_phy: pointer to USB2 PHY
> >>>   * @usb3_phy: pointer to USB3 PHY
> >>> + * @usb2_generic_phy: pointer to USB2 PHY
> >>> + * @usb3_generic_phy: pointer to USB3 PHY
> >>>   * @dcfg: saved contents of DCFG register
> >>>   * @gctl: saved contents of GCTL register
> >>>   * @is_selfpowered: true when we are selfpowered
> >>> @@ -665,6 +669,9 @@ struct dwc3 {
> >>>  	struct usb_phy		*usb2_phy;
> >>>  	struct usb_phy		*usb3_phy;
> >>> =20
> >>> +	struct phy		*usb2_generic_phy;
> >>> +	struct phy		*usb3_generic_phy;
> >>> +
> >>>  	void __iomem		*regs;
> >>>  	size_t			regs_size;
> >>> =20
> >>>
> >=20
> > Do you have any suggestions on how to get only individual PHYs? like on=
ly
> > usb2phy or usb3phy?
>=20
> My earlier understanding was that both PHYs are needed only if .speed is =
"super-speed"
> and only usb2phy is needed for "high-speed". But as per Vivek's email it =
seems
> Samsung's exynos5 SoC doesn't need usb2phy for "super-speed".
>=20
> So to keeps things flexible, I can propose the following approach
> - if speed =3D=3D 'high-speed' usb2phy must be present. usb3phy will be i=
gnored if supplied.
> - if speed =3D=3D 'super-speed' usb3phy must be present and usb2phy is op=
tional but must be
> initialized if supplied.
> - if speed is not specified, we default to 'super-speed'.
>=20
> Felipe, does this address the issue you were facing with OMAP5?

on OMAP5 we cannot skip USB3 PHY initialization. But then it becomes a
question of supporting a test feature (in OMAP5 case it would be cool to
force controller to lower speeds for testing) or coping with a broken
DTS.

--=20
balbi

--qGV0fN9tzfkG3CxV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSXS21AAoJEIaOsuA1yqREodMP/A0ufh1exo/M2LV5OLsIZ2xB
T2i97Squ9OEdRe1fLfGq9z36ze8FsGcT33zekaXkgc5UzVMQxPW0Ys7L+7IL10J1
JmghTUGc9j8+yg1R/WaGDXt5k7VlfM5xLjPzrwWdkd7jQNd5eSBAJ9DVWxYx2g63
CuHo2N7X2vVAgm9Z0OJwEB5XedgDHsZFd8oxjIlp8xrbm5pcsR3RW5Kr461pfely
Gw6ExZ7l4GsLnz8NecqWsfASU23b5b1xPqahcH8JeYU2kVrrPsPOs2ZLnzBD7Ra/
sxIJTWIOkkWlu1lEbJFMdSDJ7g4xP1GTob8vfLsAA5H3agJVl5STsk+WLcXfLe2N
ow/oHHdhRkrRtet0x5tkEgVGi9eRj2x45XvVTqcKaFa2gXN6v7FnanGQshOb63oY
Q+iXwiLIgS8cjOirXbtgzMDgUTshjucN68vNHPhxuPs6GZfHboN7UYxQWdXPCvUq
KG5T7TTb2khngOMbHA67bltYV0mOLW3RWeK2BxC256ADg84XUiPvLJ43F5+WnLzo
m9AooTnjB8J4Kqhkk9fSd/0ID61gSnA7GZuQkQo6dPzaubfwgVj4H/pjIOt3LG+h
PlaLDgekpzKAwnSYiAylI6ItQuqXo7AeLo16RBIC08FNuSxkZuvZKzMXamajbTOE
pyjNpq/zYiJVAJWEecgb
=+yKA
-----END PGP SIGNATURE-----

--qGV0fN9tzfkG3CxV--
