Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3AKM7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 07:59:25 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56750 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab3AKM7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 07:59:23 -0500
Date: Fri, 11 Jan 2013 14:58:41 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: Doug Anderson <dianders@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <yulgon.kim@samsung.com>, <linux-samsung-soc@vger.kernel.org>,
        Praveen Paneri <p.paneri@samsung.com>, <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <kishon@ti.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <stern@rowland.harvard.edu>, <rob.herring@calxeda.com>,
        <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v5 2/4] usb: phy: samsung: Add host phy support to
 samsung-phy driver
Message-ID: <20130111125841.GB12715@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
 <1355841786-13307-3-git-send-email-gautam.vivek@samsung.com>
 <CAD=FV=WMjqszsTQja82_uZc4Ue50TfTmSNO2yOhSMCX1w1L5Dg@mail.gmail.com>
 <CAFp+6iHYRRS3uSWnmdqBvfOgUDKKJUzMvqoj1HP2uXS=Fdaifg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5/uDoXvLw7AC5HRs"
Content-Disposition: inline
In-Reply-To: <CAFp+6iHYRRS3uSWnmdqBvfOgUDKKJUzMvqoj1HP2uXS=Fdaifg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 11, 2013 at 06:10:48PM +0530, Vivek Gautam wrote:
> Hi Doug,
>=20
> Sorry!!  for the delayed response.
>=20
>=20
> On Thu, Dec 20, 2012 at 4:31 AM, Doug Anderson <dianders@chromium.org> wr=
ote:
> > Vivek,
> >
> > I don't really have a good 10000 foot view about how all of the USB
> > bits fit together, but a few detail-oriented comments below.
> >
> >
> > On Tue, Dec 18, 2012 at 6:43 AM, Vivek Gautam <gautam.vivek@samsung.com=
> wrote:
> >> This patch adds host phy support to samsung-usbphy.c and
> >> further adds support for samsung's exynos5250 usb-phy.
> >>
> >> Signed-off-by: Praveen Paneri <p.paneri@samsung.com>
> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> >> ---
> >>  .../devicetree/bindings/usb/samsung-usbphy.txt     |   25 +-
> >>  drivers/usb/phy/Kconfig                            |    2 +-
> >>  drivers/usb/phy/samsung-usbphy.c                   |  465 +++++++++++=
+++++++--
> >>  include/linux/usb/samsung_usb_phy.h                |   13 +
> >>  4 files changed, 454 insertions(+), 51 deletions(-)
> >>
> >> diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt =
b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> >> index a7b28b2..2ec5400 100644
> >> --- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> >> +++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> >> @@ -1,23 +1,38 @@
> >>  * Samsung's usb phy transceiver
> >>
> >> -The Samsung's phy transceiver is used for controlling usb otg phy for
> >> -s3c-hsotg usb device controller.
> >> +The Samsung's phy transceiver is used for controlling usb phy for
> >> +s3c-hsotg as well as ehci-s5p and ohci-exynos usb controllers
> >> +across Samsung SOCs.
> >>  TODO: Adding the PHY binding with controller(s) according to the under
> >>  developement generic PHY driver.
> >>
> >>  Required properties:
> >> +
> >> +Exynos4210:
> >>  - compatible : should be "samsung,exynos4210-usbphy"
> >>  - reg : base physical address of the phy registers and length of memo=
ry mapped
> >>         region.
> >>
> >> +Exynos5250:
> >> +- compatible : should be "samsung,exynos5250-usbphy"
> >> +- reg : base physical address of the phy registers and length of memo=
ry mapped
> >> +       region.
> >> +
> >>  Optional properties:
> >>  - samsung,usb-phyhandle : should point to usb-phyhandle sub-node whic=
h provides
> >>                         binding data to enable/disable device PHY hand=
led by
> >> -                       PMU register.
> >> +                       PMU register; or to configure usb2.0 phy handl=
ed by
> >> +                       SYSREG.
> >>
> >>                         Required properties:
> >>                         - compatible : should be "samsung,usbdev-phyct=
rl" for
> >> -                                       DEVICE type phy.
> >> +                                      DEVICE type phy; or
> >> +                                      should be "samsung,usbhost-phyc=
trl" for
> >> +                                      HOST type phy; or
> >> +                                      should be "samsung,usb-phycfg" =
for
> >> +                                      USB2.0 PHY_CFG.
> >>                         - samsung,phyhandle-reg: base physical address=
 of
> >> -                                               PHY_CONTROL register i=
n PMU.
> >> +                                                PHY_CONTROL register =
in PMU;
> >> +                                                or USB2.0 PHY_CFG reg=
ister
> >> +                                                in SYSREG.
> >>  - samsung,enable-mask : should be '1'
> >> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> >> index 17ad743..13c0eaf 100644
> >> --- a/drivers/usb/phy/Kconfig
> >> +++ b/drivers/usb/phy/Kconfig
> >> @@ -47,7 +47,7 @@ config USB_RCAR_PHY
> >>
> >>  config SAMSUNG_USBPHY
> >>         bool "Samsung USB PHY controller Driver"
> >> -       depends on USB_S3C_HSOTG
> >> +       depends on USB_S3C_HSOTG || USB_EHCI_S5P || USB_OHCI_EXYNOS
> >>         select USB_OTG_UTILS
> >>         help
> >>           Enable this to support Samsung USB phy controller for samsung
> >> diff --git a/drivers/usb/phy/samsung-usbphy.c b/drivers/usb/phy/samsun=
g-usbphy.c
> >> index 4ceabe3..621348a 100644
> >> --- a/drivers/usb/phy/samsung-usbphy.c
> >> +++ b/drivers/usb/phy/samsung-usbphy.c
> >> @@ -5,7 +5,8 @@
> >>   *
> >>   * Author: Praveen Paneri <p.paneri@samsung.com>
> >>   *
> >> - * Samsung USB2.0 High-speed OTG transceiver, talks to S3C HS OTG con=
troller
> >> + * Samsung USB-PHY transceiver; talks to S3C HS OTG controller, EHCI-=
S5P and
> >> + * OHCI-EXYNOS controllers.
> >>   *
> >>   * This program is free software; you can redistribute it and/or modi=
fy
> >>   * it under the terms of the GNU General Public License version 2 as
> >> @@ -24,7 +25,7 @@
> >>  #include <linux/err.h>
> >>  #include <linux/io.h>
> >>  #include <linux/of.h>
> >> -#include <linux/usb/otg.h>
> >> +#include <linux/usb/samsung_usb_phy.h>
> >>  #include <linux/platform_data/samsung-usbphy.h>
> >>
> >>  /* Register definitions */
> >> @@ -56,6 +57,103 @@
> >>  #define RSTCON_HLINK_SWRST                     (0x1 << 1)
> >>  #define RSTCON_SWRST                           (0x1 << 0)
> >>
> >> +/* EXYNOS5 */
> >> +#define EXYNOS5_PHY_HOST_CTRL0                 (0x00)
> >> +
> >> +#define HOST_CTRL0_PHYSWRSTALL                 (0x1 << 31)
> >> +
> >> +#define HOST_CTRL0_REFCLKSEL_MASK              (0x3)
> >> +#define HOST_CTRL0_REFCLKSEL_XTAL              (0x0 << 19)
> >> +#define HOST_CTRL0_REFCLKSEL_EXTL              (0x1 << 19)
> >> +#define HOST_CTRL0_REFCLKSEL_CLKCORE           (0x2 << 19)
> >> +
> >> +#define HOST_CTRL0_FSEL_MASK                   (0x7 << 16)
> >> +#define HOST_CTRL0_FSEL(_x)                    ((_x) << 16)
> >> +#define HOST_CTRL0_FSEL_CLKSEL_50M             (0x7)
> >> +#define HOST_CTRL0_FSEL_CLKSEL_24M             (0x5)
> >> +#define HOST_CTRL0_FSEL_CLKSEL_20M             (0x4)
> >> +#define HOST_CTRL0_FSEL_CLKSEL_19200K          (0x3)
> >> +#define HOST_CTRL0_FSEL_CLKSEL_12M             (0x2)
> >> +#define HOST_CTRL0_FSEL_CLKSEL_10M             (0x1)
> >> +#define HOST_CTRL0_FSEL_CLKSEL_9600K           (0x0)
> >
> > Add the shifts to the #defines and remove HOST_CTRL0_FSEL(_x).  That
> > makes it match the older phy more closely.
> >
> Wouldn't it hamper the readability when shifts are used ??
> I mean if we have something like this -
>=20
> phyhost |=3D HOST_CTRL0_FSEL(phyclk)

this one looks better to my eyes.

> >> +                       refclk_freq |=3D HOST_CTRL0_FSEL_CLKSEL_9600K;
> >
> > Why |=3D with 0?
> >
> kept this just to keep things look similar :-). will remove this line,

I would rather keep it. Compiler will optimize it out anyway and it
makes things logical, I mean, we can see that you're telling IP that
reference clock is 9600KHz.

--=20
balbi

--5/uDoXvLw7AC5HRs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ8AyBAAoJEIaOsuA1yqRENBIQALUmxMVwjCAvREZkeFyfMljJ
LCZPlZdCuCrcmQ956EpFNUzzfD6F6DclqvWeHvTaBLzCOEQGrqIXRBZtb2R/h3M5
bdyHiT1k42PRVFeqZO7MHIuZw/x3jsINZS7i5qWYA6Q3KQlDOBIP06bOLagnRsJq
FcYraSGKvebxKJSjzBS27X4fv7I8iT+vmdVQnS7gi1kn2E0t7hYUWuId/jG9MQkW
W3A4zXbQzB9glajZ8s+xxM8KyfFrBfYtOdbz+msXLflp4p9Yxzf8CiAtqubmj7M5
mgkTlU9brLrTnaPmI0zkO7Kjrr+XZQb78Zx2Ay8Zjsi7dAlyFddE0HNd4mg7EshW
2pmGEbTjrejwntCOg++L2cH7SKX9VTLdrDJpwSWEFiaVxd4F6Smliguekk6lSmeb
ECGvgbtjx6/SYYKQk33r+Y/+zZls4aQRzVFFoWyONVl1593BJHpnIWMW10vDHsA7
71wP8w72hIJR/P9fcPP9H0gVgYN2HHosxzIBqerDOa0CjCUAa1Jxy2H0D1mp2hEE
CBmwHEoV797Rh3E6frCrx6nKpTVDBhaGqxE7C7RS2hj67+4y6Dkjm4vz6fT538j+
6wIkqk7+mcKILOM4g6/EUEqYgT9ckPnQIzgvEP5+jFngc7DsMApMWDjcoE/eg530
RTD8ImstVHHYNZg36CN/
=B8UN
-----END PGP SIGNATURE-----

--5/uDoXvLw7AC5HRs--
