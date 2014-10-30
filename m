Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbaJ3Qfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:35:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53056 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758867AbaJ3Qfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:35:43 -0400
Date: Thu, 30 Oct 2014 11:35:13 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Antoine Tenart <antoine.tenart@free-electrons.com>,
        <gregkh@linuxfoundation.org>, <Peter.Chen@freescale.com>,
        <kishon@ti.com>, <stern@rowland.harvard.edu>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/7] usb: move the OTG state from the USB PHY to the
 OTG structure
Message-ID: <20141030163513.GI10130@saruman>
Reply-To: <balbi@ti.com>
References: <1414514141-31767-1-git-send-email-antoine.tenart@free-electrons.com>
 <1414514141-31767-2-git-send-email-antoine.tenart@free-electrons.com>
 <20141030163148.GF10130@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BEa57a89OpeoUzGD"
Content-Disposition: inline
In-Reply-To: <20141030163148.GF10130@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BEa57a89OpeoUzGD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 11:31:48AM -0500, Felipe Balbi wrote:
> On Tue, Oct 28, 2014 at 05:35:35PM +0100, Antoine Tenart wrote:
> > Before using the PHY framework instead of the USB PHY one, we need to
> > move the OTG state into another place, since it won't be available when
> > USB PHY isn't used. This patch moves the OTG state into the OTG
> > structure, and makes all the needed modifications in the drivers
> > using the OTG state.
> >=20
> > Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> > Acked-by: Peter Chen <peter.chen@freescale.com>
>=20
> Acked-by: Felipe Balbi <balbi@ti.com>

fails to apply:

$ patch -p1 --dry-run < patch.diff=20
checking file drivers/phy/phy-omap-usb2.c
checking file drivers/usb/chipidea/debug.c
checking file drivers/usb/chipidea/otg_fsm.c
checking file drivers/usb/common/usb-otg-fsm.c
checking file drivers/usb/host/ohci-omap.c
checking file drivers/usb/musb/am35x.c
checking file drivers/usb/musb/blackfin.c
checking file drivers/usb/musb/da8xx.c
checking file drivers/usb/musb/davinci.c
checking file drivers/usb/musb/musb_core.c
checking file drivers/usb/musb/musb_dsps.c
checking file drivers/usb/musb/musb_gadget.c
Hunk #3 succeeded at 1791 (offset -1 lines).
Hunk #4 succeeded at 1857 (offset -3 lines).
Hunk #5 FAILED at 1945.
Hunk #6 succeeded at 1968 (offset -7 lines).
Hunk #7 succeeded at 1982 (offset -7 lines).
Hunk #8 succeeded at 1994 (offset -7 lines).
Hunk #9 succeeded at 2012 (offset -7 lines).
Hunk #10 succeeded at 2043 (offset -7 lines).
Hunk #11 succeeded at 2118 (offset -7 lines).
1 out of 11 hunks FAILED
checking file drivers/usb/musb/musb_host.c
checking file drivers/usb/musb/musb_virthub.c
checking file drivers/usb/musb/omap2430.c
Hunk #6 succeeded at 180 (offset 1 line).
Hunk #7 succeeded at 192 (offset 1 line).
Hunk #8 succeeded at 201 (offset 1 line).
Hunk #9 succeeded at 266 (offset 1 line).
Hunk #10 succeeded at 280 (offset 1 line).
checking file drivers/usb/musb/tusb6010.c
checking file drivers/usb/musb/ux500.c
checking file drivers/usb/phy/phy-ab8500-usb.c
checking file drivers/usb/phy/phy-fsl-usb.c
checking file drivers/usb/phy/phy-generic.c
checking file drivers/usb/phy/phy-gpio-vbus-usb.c
checking file drivers/usb/phy/phy-msm-usb.c
Hunk #13 succeeded at 1769 (offset -6 lines).
checking file drivers/usb/phy/phy-mv-usb.c
Hunk #5 succeeded at 715 (offset -2 lines).
checking file include/linux/usb/otg.h
checking file include/linux/usb/phy.h

Please rebase on my testing/next and I'll take the series. When
rebasing, then add Peter's Tested-by/Acked-by where they're missing.

cheers

--=20
balbi

--BEa57a89OpeoUzGD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUmjAAAoJEIaOsuA1yqREsvAQAK0TshZu1340X3dk8z6yikgo
iJu8Nl9um+vkLteP5qfdqbcQPVYkrf1Y4oI5sw5Ar0riLMGa7i5TC4Sn7KHqQ5An
F0iuZd76uaV3K9ZeQLSYfM/36ptBTe5YZ3CECbW2s7E9Awzd30NKIVBaRaIDkw+b
XdyrgxF/tiVs/GezOskJMa9DneTK/BIHCjNTBUI5KM+AgoNuNO8YZ0Tk47WNavZt
1TT/yu3P4AR/dXc4oLr1qRlNxRVwgs1YK7OyxwjkLpz0uwJ6jnIpRCnDR1F6H0ef
/4wTI8a4XkXq8oLaOTW0NA6nVCjVuel4P96Bbg+2fDu4wSFZuHhEcc56o3JchVI7
nFnuhwxfmx+UJpsif8c3RG8mDLfad2TNP4xAIqYAg7t+0mlkK0m4B91UnRpDLjHF
FGPDj2Enu/RzN5+cKUbCHC6LEy8DRNz5ewS49uFWr9hou2V3UoetpkJwtaaBZhnZ
uIyXAq6b1LX02kNZocA86+FuaLukPNjfyCnidswlCZlP8QmH5CL33j+SUfP7cgyD
TFHxAj+5s4rywLDrhkAlEw6AThcgAQ7SiJbSrCoN3zjEfYLFvdygCd2OtjmrAr72
d6VXECOZpQsVLvkrYt8/wCpzLuTmoT2boR+T8G5uwoPYblw9hh/4djkVXO8dPzsx
ROvGXkqZrYknpDyZYNdf
=WBLU
-----END PGP SIGNATURE-----

--BEa57a89OpeoUzGD--
