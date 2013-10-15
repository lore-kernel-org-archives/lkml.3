Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab3JOONY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:13:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47204 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932499Ab3JOONW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:13:22 -0400
Date: Tue, 15 Oct 2013 09:12:21 -0500
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, Vivek Gautam <gautamvivek1987@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <bcousson@baylibre.com>,
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
Message-ID: <20131015141221.GM11380@radagast>
Reply-To: <balbi@ti.com>
References: <1378136591-7463-3-git-send-email-kishon@ti.com>
 <525814A9.7060106@ti.com>
 <525BB8C0.1070802@ti.com>
 <525BC5A9.3060904@ti.com>
 <20131015115741.GD11380@radagast>
 <525D30C2.8060208@ti.com>
 <20131015131934.GG11380@radagast>
 <525D47C3.207@ti.com>
 <20131015135655.GK11380@radagast>
 <525D4B46.4070302@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GEn4szYucjS2InE7"
Content-Disposition: inline
In-Reply-To: <525D4B46.4070302@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GEn4szYucjS2InE7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 15, 2013 at 05:03:50PM +0300, Roger Quadros wrote:
> On 10/15/2013 04:56 PM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Tue, Oct 15, 2013 at 04:48:51PM +0300, Roger Quadros wrote:
> >> On 10/15/2013 04:19 PM, Felipe Balbi wrote:
> >>> Hi,
> >>>
> >>> On Tue, Oct 15, 2013 at 03:10:42PM +0300, Roger Quadros wrote:
> >>>>>>>>> @@ -665,6 +669,9 @@ struct dwc3 {
> >>>>>>>>>  	struct usb_phy		*usb2_phy;
> >>>>>>>>>  	struct usb_phy		*usb3_phy;
> >>>>>>>>> =20
> >>>>>>>>> +	struct phy		*usb2_generic_phy;
> >>>>>>>>> +	struct phy		*usb3_generic_phy;
> >>>>>>>>> +
> >>>>>>>>>  	void __iomem		*regs;
> >>>>>>>>>  	size_t			regs_size;
> >>>>>>>>> =20
> >>>>>>>>>
> >>>>>>>
> >>>>>>> Do you have any suggestions on how to get only individual PHYs? l=
ike only
> >>>>>>> usb2phy or usb3phy?
> >>>>>>
> >>>>>> My earlier understanding was that both PHYs are needed only if .sp=
eed is "super-speed"
> >>>>>> and only usb2phy is needed for "high-speed". But as per Vivek's em=
ail it seems
> >>>>>> Samsung's exynos5 SoC doesn't need usb2phy for "super-speed".
> >>>>>>
> >>>>>> So to keeps things flexible, I can propose the following approach
> >>>>>> - if speed =3D=3D 'high-speed' usb2phy must be present. usb3phy wi=
ll be ignored if supplied.
> >>>>>> - if speed =3D=3D 'super-speed' usb3phy must be present and usb2ph=
y is optional but must be
> >>>>>> initialized if supplied.
> >>>>>> - if speed is not specified, we default to 'super-speed'.
> >>>>>>
> >>>>>> Felipe, does this address the issue you were facing with OMAP5?
> >>>>>
> >>>>> on OMAP5 we cannot skip USB3 PHY initialization. But then it become=
s a
> >>>>> question of supporting a test feature (in OMAP5 case it would be co=
ol to
> >>>>> force controller to lower speeds for testing) or coping with a brok=
en
> >>>>> DTS.
> >>>>>
> >>>>
> >>>> I don't think we can protect ourselves from all possible broken
> >>>> configurations of DTS.
> >>>> I would vote for simplicity and maximum flexibility.
> >>>>
> >>>> So IMO we should just depend on DTS to provide the phys that are
> >>>> needed by the platform.
> >>>> In the driver we initialize whatever PHY is provided and don't
> >>>> complain if any or even all PHYs are missing.
> >>>
> >>> considering that DTS is an ABI, I really think eventually we *will* h=
ave
> >>> broken DTBs burned into ROM and we will have to find ways to work with
> >>> those too. Same thing already happens today with ACPI tables.
> >>>
> >>>> If this is not good enough then could you please suggest an
> >>>> alternative? Thanks.
> >>>
> >>> The alternative would be to mandate nop xceiv for the "missing" PHY, =
but
> >>> that doesn't solve anything, really, as DTS authors might still forget
> >>> about the NOP xceiv and you can argue that forcing NOP xceiv would be=
 a
> >>> SW configuration.
> >>>
> >>> So, perhaps we go with the approach that all PHYs are optional, and
> >>> here's my original patch which makes USB3 PHY optional:
> >>>
> >>> commit 979b84f96e4b7559b596b2933ae198aba267f260
> >>> Author: Felipe Balbi <balbi@ti.com>
> >>> Date:   Sun Jun 30 18:39:23 2013 +0300
> >>>
> >>>     usb: dwc3: core: make USB3 PHY optional
> >>>    =20
> >>>     If we want a port to work at any speed lower
> >>>     than Superspeed, it makes no sense to even
> >>>     initialize/power up the USB3 transceiver,
> >>>     provided it won't be used.
> >>>    =20
> >>>     We can use the oportunity to save some power
> >>>     and leave the superspeed transceiver powered
> >>>     off.
> >>>    =20
> >>>     There is at least one such case which is
> >>>     Texas Instruments' AM437x which has one
> >>>     of its USB3 ports without a matching USB3
> >>>     PHY (that port is hardwired to work on USB2
> >>>     only).
> >>>    =20
> >>>     Signed-off-by: Felipe Balbi <balbi@ti.com>
> >>>
> >>> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> >>> index 74f9cf0..7a5ab93 100644
> >>> --- a/drivers/usb/dwc3/core.c
> >>> +++ b/drivers/usb/dwc3/core.c
> >>> @@ -387,16 +387,34 @@ static int dwc3_probe(struct platform_device *p=
dev)
> >>>  	if (node) {
> >>>  		dwc->maximum_speed =3D of_usb_get_maximum_speed(node);
> >>> =20
> >>> -		dwc->usb2_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
> >>> -		dwc->usb3_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 1);
> >>> +		switch (dwc->maximum_speed) {
> >>> +		case USB_SPEED_SUPER:
> >>> +			dwc->usb2_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
> >>> +			dwc->usb3_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 1);
> >>> +			break;
> >>> +		case USB_SPEED_HIGH:
> >>> +		case USB_SPEED_FULL:
> >>> +		case USB_SPEED_LOW:
> >>> +			dwc->usb2_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
> >>> +			break;
> >>> +		}
> >>> =20
> >>>  		dwc->needs_fifo_resize =3D of_property_read_bool(node, "tx-fifo-re=
size");
> >>>  		dwc->dr_mode =3D of_usb_get_dr_mode(node);
> >>>  	} else if (pdata) {
> >>>  		dwc->maximum_speed =3D pdata->maximum_speed;
> >>> =20
> >>> -		dwc->usb2_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> >>> -		dwc->usb3_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
> >>> +		switch (dwc->maximum_speed) {
> >>> +		case USB_SPEED_SUPER:
> >>> +			dwc->usb2_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> >>> +			dwc->usb3_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
> >>> +			break;
> >>> +		case USB_SPEED_HIGH:
> >>> +		case USB_SPEED_FULL:
> >>> +		case USB_SPEED_LOW:
> >>> +			dwc->usb2_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> >>> +			break;
> >>> +		}
> >>
> >> What if we try to get both PHYs irrespective of 'maximum_speed' but ba=
sed
> >> on presence of phandle/pdata. That way there is some control in the ad=
aptation code (dts/pdata)
> >> as to which PHYs needs to be initialized for that particular instance.
> >>
> >> This is because there doesn't seem to be a consensus between different=
 designs.
> >> e.g. omap5 needs both phys for 'high-speed' whereas exynos5250 needs j=
ust the
> >> usb3 phy for 'super-speed'
> >=20
> > sure, can you write such a patch ? If it gets to my inbox in a couple
> > hours I guess I can still review and take it upstream on v3.13,
> > otherwise it's only on v3.14 :-(
>=20
> As this patch from Kishon is already touching this area, it would be best=
 if
> he can send a v2 with this feature.

Alright, and so I'll wait a little longer.

cheers

--=20
balbi

--GEn4szYucjS2InE7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSXU1FAAoJEIaOsuA1yqRE4SIQAIMET2fN8R2zIzoyw/Qxw6Il
NKef46MI74REcm0VhEblkFE7U+f8+5X07CFXFp8P1LUAtCqYQh2mt9uBndr5mBlJ
bFFABGjKRkeucXGOHPL8Zl4Da19vgW9YL2hn4J5FbGMPXHlEWKGmG2ooNSxjmcuz
bz2cycnnqU9I38YjFFXJg5E5mCKsBQUf4QKkBcoheb5G/uS1fbqef9ezRgw8Q/lx
tT9ws8PKSTXnHMDv+6MOXaJMjfBdk3tABe3zSTdRRB1k9KhfCoEqI4F1Jlje3rX5
+EH2ncGIV/1beZf7zv+Q5Re0JbJxF4lAIhHhbOA768ZcnCremy2G/S44rRqI6B3N
jVse3R+l9N2Lkows92Nr18s2zSFIV+6/H/Na2PWrX6hHMcLuZ51dU5o8gYmTFhH/
qKE/Qj0/OOVJVVH3y9JgmOGSJ/eNx6RK6kivihDl1uwEym79A+QlaPNXAUsbpzkT
iU+ekzNnoYkhcfLyvpsdvNC6AiWkXBXIuYyWtCuK1V1rrJne9o9d9/wkPghTq6vg
YAZC2jWnzQdit4GbisZbhPaD1sxmppG0lahxw7zpG5CJjF4pFThJo3IhalRQDZfd
iRf4j/vSQ7t9EEqEvRQGrXmxwm1Z7/tV87O6ypbQFbgCVkGkuZWRWTkerj0p3cyW
joik+TfU5zrsseFk9XIR
=yh9i
-----END PGP SIGNATURE-----

--GEn4szYucjS2InE7--
