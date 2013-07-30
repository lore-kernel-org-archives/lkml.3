Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab3G3GCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 02:02:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55973 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab3G3GCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 02:02:12 -0400
Date: Tue, 30 Jul 2013 09:01:34 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm: omap: remove *.auto* from device names given in
 usb_bind_phy
Message-ID: <20130730060134.GD9155@radagast>
Reply-To: <balbi@ti.com>
References: <1374829418-27503-1-git-send-email-kishon@ti.com>
 <1374829418-27503-3-git-send-email-kishon@ti.com>
 <20130729150638.GD3063@radagast>
 <51F68A56.8060805@ti.com>
 <20130729175413.GC4964@radagast>
 <51F74BC8.7020903@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hoZxPH4CaxYzWscb"
Content-Disposition: inline
In-Reply-To: <51F74BC8.7020903@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hoZxPH4CaxYzWscb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 30, 2013 at 10:44:48AM +0530, Kishon Vijay Abraham I wrote:
> > On Mon, Jul 29, 2013 at 08:59:26PM +0530, Kishon Vijay Abraham I wrote:
> >>>> Previously MUSB wrapper (OMAP) device used PLATFORM_DEVID_AUTO while=
 creating
> >>>> MUSB core device. So in usb_bind_phy (binds the controller with the =
PHY), the
> >>>> device name of the controller had *.auto* in it. Since with using
> >>>> PLATFORM_DEVID_AUTO, there is no way to know the exact device name i=
n advance,
> >>>> the data given in usb_bind_phy became obsolete and usb_get_phy was f=
ailing.
> >>>> So MUSB wrapper was modified not to use PLATFORM_DEVID_AUTO. Corresp=
onding
> >>>> change is done in board file here.
> >>>>
> >>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >>>> ---
> >>>>  arch/arm/mach-omap2/board-2430sdp.c          |    2 +-
> >>>>  arch/arm/mach-omap2/board-3430sdp.c          |    2 +-
> >>>>  arch/arm/mach-omap2/board-cm-t35.c           |    2 +-
> >>>>  arch/arm/mach-omap2/board-devkit8000.c       |    2 +-
> >>>>  arch/arm/mach-omap2/board-igep0020.c         |    2 +-
> >>>>  arch/arm/mach-omap2/board-ldp.c              |    2 +-
> >>>>  arch/arm/mach-omap2/board-omap3beagle.c      |    2 +-
> >>>>  arch/arm/mach-omap2/board-omap3evm.c         |    2 +-
> >>>>  arch/arm/mach-omap2/board-omap3logic.c       |    2 +-
> >>>>  arch/arm/mach-omap2/board-omap3pandora.c     |    2 +-
> >>>>  arch/arm/mach-omap2/board-omap3stalker.c     |    2 +-
> >>>>  arch/arm/mach-omap2/board-omap3touchbook.c   |    2 +-
> >>>>  arch/arm/mach-omap2/board-overo.c            |    2 +-
> >>>>  arch/arm/mach-omap2/board-rm680.c            |    2 +-
> >>>>  arch/arm/mach-omap2/board-rx51.c             |    2 +-
> >>>>  arch/arm/mach-omap2/board-zoom-peripherals.c |    2 +-
> >>>>  16 files changed, 16 insertions(+), 16 deletions(-)
> >>>>
> >>>> diff --git a/arch/arm/mach-omap2/board-2430sdp.c b/arch/arm/mach-oma=
p2/board-2430sdp.c
> >>>> index 244d8a5..17bb076 100644
> >>>> --- a/arch/arm/mach-omap2/board-2430sdp.c
> >>>> +++ b/arch/arm/mach-omap2/board-2430sdp.c
> >>>> @@ -233,7 +233,7 @@ static void __init omap_2430sdp_init(void)
> >>>>  	omap_hsmmc_init(mmc);
> >>>> =20
> >>>>  	omap_mux_init_signal("usb0hs_stp", OMAP_PULL_ENA | OMAP_PULL_UP);
> >>>> -	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
> >>>> +	usb_bind_phy("musb-hdrc.0", 0, "twl4030_usb");
> >>>
> >>> how about moving usb_bind_phy() calls to omap2430.c ?
> >>>
> >>> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> >>> index f44e8b5..b6abc1a 100644
> >>> --- a/drivers/usb/musb/omap2430.c
> >>> +++ b/drivers/usb/musb/omap2430.c
> >>> @@ -544,6 +544,9 @@ static int omap2430_probe(struct platform_device =
*pdev)
> >>> =20
> >>>  		pdata->board_data	=3D data;
> >>>  		pdata->config		=3D config;
> >>> +	} else {
> >>> +		/* bind the PHY */
> >>> +		usb_bind_phy(dev_name(&musb->dev), 0, "twl4030_usb");
> >>
> >> This looks like a hack IMHO to workaround the usb phy library. otherwi=
se it is
> >> similar to get_phy_by_name.
> >=20
> > actually, this is a workaround to the fact that we're not creating all
> > platform_devices in arch/arm/mach-omap2/ :-)
> >=20
> > If we had the musb allocation there, we could easily handle
> > usb_bind_phy()
> >=20
> >>> so that's temporary. It might be better than to reintroduce the IDR in
> >>> musb_core.c.
> >>
> >> that=E2=80=99s needed for generic phy framework anyway :-s
> >=20
> > right, but generic phy framework can handle everything just fine, the
> > only problem is that names are changing.
>=20
> right. But if the names change, PHY framework wouldn't be able to return =
the
> reference to the PHY.

with my suggestion they can change whenever they want since we're using
dev_name() of the just-created musb platform_device. Right ?

--=20
balbi

--hoZxPH4CaxYzWscb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR91a+AAoJEIaOsuA1yqREInAP/24uFqeFDQGuhDAdaELJDW3O
9adi2mRhLHud86tyodt76WHryaRgCA8EUzoWaWGTjk+Mj07fWMNAR0wBIhRyBfYF
rPLENuvMqsFcSszLXf0RBKJkob+fyqIW57ANeDR8oU/mmfRh6Cg3stwKYsoKB9am
yUGmTlaMg+REuqLklBrOrKCqoXraIWNDNYd63sSDH8TgWrRx9UXQSn6m48oIVmm4
6y1Ev+BIoJCEeLKkfS1sQakoF/5Cf6IWXjDXO1nyQ3GXtrt9JUWrDhft37QtBrgT
+PP28VQXgCkBfY9r45r4eD8JQpj5YGguDJEBFYs06XLNK3VthrRXTTW9ygTpg02J
ZDWJCbLG63Z2BPZ9F1Wr7iFcNo8J9Ip/WD3V4y3RLwvJYejYoV3BSARZ+L53rbBi
X7U4xKtbIg+0q95Vkfi3PgIZUhJHmCnpxdbPyWEqQa2nz9M99O/SOd1FJ+K0tgLc
AMoRPOEaQiYHZM6rrWV4Yy/TfZ5KGsqdfa6yzecTc0dsk2Rls/pR5jOZJZ8OJ3i2
0cYtVvLZyf+3260tMYRBVl6ouJGnpXOXe+5F377fT1uKDaZ1xUAvSgjJGx/B1B5C
1JuDU7dGNuI5YCKUFJe4iE/Kupfdi8n9qn/wfsucdjFqLy9H6kX/UrpR80TbVh/P
wlVClv8sctN5614HrwaF
=5dWQ
-----END PGP SIGNATURE-----

--hoZxPH4CaxYzWscb--
