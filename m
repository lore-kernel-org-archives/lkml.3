Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199Ab3JONW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:22:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60956 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759127Ab3JONWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:22:54 -0400
Date: Tue, 15 Oct 2013 08:22:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>, "balbi@ti.com" <balbi@ti.com>,
        "kishon@ti.com" <kishon@ti.com>, "rob@landley.net" <rob@landley.net>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH] phy: omap: Adapt phy-omap-usb2 for AM437x
Message-ID: <20131015132245.GH11380@radagast>
Reply-To: <balbi@ti.com>
References: <1381754603-11581-1-git-send-email-george.cherian@ti.com>
 <20131014143259.GD31708@e106331-lin.cambridge.arm.com>
 <525CE928.4060405@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ewQ5hdP4CtoTt3oD"
Content-Disposition: inline
In-Reply-To: <525CE928.4060405@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ewQ5hdP4CtoTt3oD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 15, 2013 at 12:35:12PM +0530, George Cherian wrote:
> Hi Mark,
>=20
> Fixed all your comments and already sent a V2.
>=20
>=20
> On 10/14/2013 8:03 PM, Mark Rutland wrote:
> >On Mon, Oct 14, 2013 at 01:43:23PM +0100, George Cherian wrote:
> >>This patch adds a compatible for AM437x "ti,am43xx-usb2" to
> >>reuse the same phy-omap-usb2 driver.
> >>
> >>Also updated the documentation to add the new compatible.
> >>
> >>Signed-off-by: George Cherian <george.cherian@ti.com>
> >>---
> >>  Documentation/devicetree/bindings/usb/usb-phy.txt |  2 +-
> >>  drivers/phy/phy-omap-usb2.c                       | 13 ++++++++++---
> >>  2 files changed, 11 insertions(+), 4 deletions(-)
> >>
> >>diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Docume=
ntation/devicetree/bindings/usb/usb-phy.txt
> >>index c0245c8..d5a7f21 100644
> >>--- a/Documentation/devicetree/bindings/usb/usb-phy.txt
> >>+++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
> >>@@ -3,7 +3,7 @@ USB PHY
> >>  OMAP USB2 PHY
> >>  Required properties:
> >>- - compatible: Should be "ti,omap-usb2"
> >>+ - compatible: Should be "ti,omap-usb2" or "ti,am437x-usb2"
> >In case this needs to be modified in future, it might be best to split
> >this up one per line, with a brief description of when it applies:
> >
> >- compatible: Should contain one of:
> >   * "ti,omap-usb2" for ____ systems
> >   * "ti,am437x-usb2" for ____ systems
> >
> >>   - reg : Address and length of the register set for the device.
> >>   - #phy-cells: determine the number of cells that should be given in =
the
> >>     phandle while referencing this phy.
> >>diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
> >>index bfc5c33..0529c83 100644
> >>--- a/drivers/phy/phy-omap-usb2.c
> >>+++ b/drivers/phy/phy-omap-usb2.c
> >>@@ -29,6 +29,7 @@
> >>  #include <linux/delay.h>
> >>  #include <linux/usb/omap_control_usb.h>
> >>  #include <linux/phy/phy.h>
> >>+#include <linux/of.h>
> >>  #include <linux/of_platform.h>
> >>  /**
> >>@@ -172,7 +173,10 @@ static int omap_usb2_probe(struct platform_device =
*pdev)
> >>  	phy->dev		=3D &pdev->dev;
> >>  	phy->phy.dev		=3D phy->dev;
> >>-	phy->phy.label		=3D "omap-usb2";
> >>+	if (of_device_is_compatible(node, "ti,am437x-usb2"))
> >>+		phy->phy.label		=3D "am437x-usb2";
> >>+	else
> >>+		phy->phy.label		=3D "omap-usb2";
> >Instead of having this check here, you could put together a struct
> >containing the data applying to a particular compatible string, and
> >associate it with the compatible string using of_device_id::data.
> >
> >That means we don't need to duplicate the compatible strings, and it's
> >easier to extend in future.
> >
> >>  	phy->phy.set_suspend	=3D omap_usb2_suspend;
> >>  	phy->phy.otg		=3D otg;
> >>  	phy->phy.type		=3D USB_PHY_TYPE_USB2;
> >>@@ -201,8 +205,10 @@ static int omap_usb2_probe(struct platform_device =
*pdev)
> >>  	otg->set_host		=3D omap_usb_set_host;
> >>  	otg->set_peripheral	=3D omap_usb_set_peripheral;
> >>-	otg->set_vbus		=3D omap_usb_set_vbus;
> >>-	otg->start_srp		=3D omap_usb_start_srp;
> >>+	if (of_device_is_compatible(node, "ti,omap-usb2")) {
> >>+		otg->set_vbus		=3D omap_usb_set_vbus;
> >>+		otg->start_srp		=3D omap_usb_start_srp;
> >>+	}
> >Similarly here.

so you prefer the driver data approach ? I would rather have feature
flags as driver_data instead of passing function pointers. In fact I
have suggested that on another thread which reached linux-usb.

--=20
balbi

--ewQ5hdP4CtoTt3oD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSXUGkAAoJEIaOsuA1yqRECYEP/0Rh+LqLMoGjMd9Ggv6t+thz
N9E8TnJA64ePzVdKJQ6YUrnhT5rNgAfGi49vAUhdODBTAiyQOjoQIMDK4H/v5xCc
SdLqjN5kugl1zP1HkEBaDPhjY3ZIibDXz3a2Ke61TPJexuJc0X8kb93BgK9FZSOi
PzxXGD1GC3OcMS2hmPosz0eI/sPPG3Yg/1DnSWTKZCRiNKSLZrJzXZPSlc1r60oU
8aBBSujEmsQCLISBAxlDnScAWHwY5wJ8sRC3AQRFHpMwmvUwW5KPxDmxqaN7leKf
GFFvU2ucOA+9AU3KSOrFJr8tE4THPhbIO/o6DFaxx2filBxukK3dJYxGheL9PRNX
2nC/DtX6Mt36X/5GoIn26qVl+iskmsXSRaftBQMPOH3qLRKOO6QwinzKQoJv2W0I
IexXJp56X35lsJUew9c3XXI+J3fxHqY1CAbMMt5zpubEOQCvXDUq6seg1iz3EMhR
84+fs++tkHMZ0thMvBE1fvkeK19m518Z0s17EYhZ32fEupYmc3hA3c5OS/Y22DbK
Hp2mpPwvNA7z2yZiVtgFLJRlw9FeZZQTxKeJH91mx2UL4TB200wwnODsCda6nSOG
jHGcmD+8KOY4PWDsugnuym3yugV5UYUAq53B5N0LADAJoqXL1oHSLtd5ynhzBM2/
XEMiUutx2s9kjIUyf+VA
=8d2C
-----END PGP SIGNATURE-----

--ewQ5hdP4CtoTt3oD--
