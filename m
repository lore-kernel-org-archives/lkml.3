Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab3GIMDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 08:03:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34430 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab3GIMDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 08:03:19 -0400
Date: Tue, 9 Jul 2013 15:02:58 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <arnd@arndb.de>, <adrienverge@gmail.com>, <kishon@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>,
        Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v3 1/2] USB: PHY: Make PHY driver selection possible by
 controller drivers
Message-ID: <20130709120258.GO5552@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371203502-29624-1-git-send-email-rogerq@ti.com>
 <1371203502-29624-2-git-send-email-rogerq@ti.com>
 <20130709112948.GJ5552@arwen.pp.htv.fi>
 <51DBFB8A.6000908@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uX2tiToO0oGq+LKk"
Content-Disposition: inline
In-Reply-To: <51DBFB8A.6000908@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uX2tiToO0oGq+LKk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 09, 2013 at 03:01:14PM +0300, Roger Quadros wrote:
> On 07/09/2013 02:29 PM, Felipe Balbi wrote:
> > On Fri, Jun 14, 2013 at 12:51:41PM +0300, Roger Quadros wrote:
> >> Convert PHY Drivers from menuconfig to menu so that the PHY drivers
> >> can be explicitely selected by the controller drivers.
> >>
> >> USB_PHY is no longer a user visible option. It is upto to the PHY
> >> drivers to select it if needed. This patch does so for the existing
> >> PHY drivers that use the USB_PHY library.
> >>
> >> Doing so moves the USB_PHY and PHY driver selection problem from the
> >> end user to the PHY and controller driver developer.
> >>
> >> e.g.
> >>
> >> Earlier, a controller driver (e.g. EHCI_OMAP) that needs to select
> >> a PHY driver (e.g. NOP_PHY) couldn't do so because the PHY driver
> >> depended on USB_PHY. Making the controller driver depend on USB_PHY
> >> has a negative effect i.e. it becomes invisible to the user till
> >> USB_PHY is enabled. Most end users will not familiar with this.
> >>
> >> With this patch, the end user just needs to select the controller driv=
er
> >> needed for his/her platform without worrying about which PHY driver to
> >> select.
> >>
> >> Also update USB_EHCI_MSM, USB_LPC32XX and USB_OMAP to not depend
> >> on USB_PHY any more. They can safely select the necessary PHY drivers.
> >>
> >> CC: Pavankumar Kondeti <pkondeti@codeaurora.org>
> >> CC: Roland Stigge <stigge@antcom.de>
> >> Signed-off-by: Roger Quadros <rogerq@ti.com>
> >> [USB_LPC32XX part] Acked-by: Roland Stigge <stigge@antcom.de>
> >>
> >> Signed-off-by: Roger Quadros <rogerq@ti.com>
> >=20
> > There is one problem (?) with this: phy-core.ko will never be a module.
> > If that's not a problem for anyone, I guess this is safe to apply. I'll
> > wait a little longer until merge window closes to give people some extra
> > time to shout.
> >=20
>=20
> Is phy-core already meant to be loaded as a module already?
>=20
> At least with the old phy.c I was getting the following build errors if i=
t was built as
> a module
>=20
> arch/arm/mach-omap2/built-in.o: In function `usbhs_init_phys':
> /work/linux-2.6/arch/arm/mach-omap2/usb-host.c:652: undefined reference t=
o `usb_bind_phy'
> arch/arm/mach-omap2/built-in.o: In function `omap_2430sdp_init':
> /work/linux-2.6/arch/arm/mach-omap2/board-2430sdp.c:236: undefined refere=
nce to `usb_bind_phy'
> arch/arm/mach-omap2/built-in.o: In function `omap3_beagle_init':
> /work/linux-2.6/arch/arm/mach-omap2/board-omap3beagle.c:554: undefined re=
ference to `usb_bind_phy'
> arch/arm/mach-omap2/built-in.o: In function `devkit8000_init':
> /work/linux-2.6/arch/arm/mach-omap2/board-devkit8000.c:596: undefined ref=
erence to `usb_bind_phy'
> arch/arm/mach-omap2/built-in.o: In function `omap_ldp_init':
> /work/linux-2.6/arch/arm/mach-omap2/board-ldp.c:379: undefined reference =
to `usb_bind_phy'
>=20
> If we are sure it can be built as a module then we could just change "con=
fig USB_PHY" to tristate
> instead of bool.

good point, board-files are using some of our symbols. Then we can apply
your patches. I'll wait a bit longer, though.

--=20
balbi

--uX2tiToO0oGq+LKk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR2/vyAAoJEIaOsuA1yqREzzQP/1vMyS2ytm9umrh+OUtL6TFP
QBCD2SYHUs1SuQUr2y5gVVYFSN+QGAggS5IjDLOsr0YUPpPOcZN9AvUGwxZVYjyS
Z5z0snNeovVLgO8wUqlpU1VMQDKfB1ZHYgf1LoeVataN6BkdnHY3e9B4hb8hvzQs
AiOl3msq2Y5mLyZe/hN4eXRvlKo23yr3RslVevC8GMynR68iCkTI4VciVXIzP9EI
Iv01OZHcH9TCfHPBScvhjbBkJS40XIUK4dCK/ZERZAtIKWO78GBuaItX0DeBskLJ
4OsRlYOCnUIaVBby4eRRhqstSoFhF7HCPoyIJ63lRMDfE6WjKWHh8IAH2eGY/Dqp
0gCj/hVAqIyFP3vzFwBETIe09C94XGPJc8JDLhF/cwyE3QgyEzqSqN80/LtDpKyY
vcqKrCDjjck89r4AnIAHSzCJxAvBXvCQW+HeTneqgkAmu8dDoHBf6uNcc89auEPT
bnlBg/9fLwlpHryRmw1goG7QSkxIeQUkoQxQk/PaAdt4QeamxbeXK1+wU4pAND7V
DColf/FBSirieTS46z/SkRuPMAPHjwk8YIPSZN8+yO6c+PbuuBc1xBzgbhyGVukd
taTXAX+bJO4+gcW06Im2BA7YBpT+pdRTAjsTp1tLJExsnHi7Vgn+kJHOUHAay8jK
wMnW+5LT29xLa9MqpOSN
=IIgS
-----END PGP SIGNATURE-----

--uX2tiToO0oGq+LKk--
