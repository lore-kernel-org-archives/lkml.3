Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab3DWQIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:08:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51063 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932220Ab3DWQId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:08:33 -0400
Date: Tue, 23 Apr 2013 19:07:59 +0300
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: phy: phy core cannot yet be a module
Message-ID: <20130423160759.GF15177@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1366732475-479886-1-git-send-email-arnd@arndb.de>
 <1366732475-479886-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Gs9iBZf6UKWgztis"
Content-Disposition: inline
In-Reply-To: <1366732475-479886-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Gs9iBZf6UKWgztis
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 23, 2013 at 05:54:32PM +0200, Arnd Bergmann wrote:
> A lot of platform code calls into the usb phy core at the moment, which
> does not work if it is built as a loadable module. This will hopefully
> change when those platforms are all converted to DT based probing,
> but for now, the easiest solution is to change it from "tristate"
> to "bool".
>=20
> This solves at least these ARM allmodconfig build errors:
>=20
> arch/arm/mach-imx/built-in.o: In function `imx_otg_ulpi_create':
> arch/arm/mach-imx/ulpi.c:117: undefined reference to `otg_ulpi_create'
> arch/arm/mach-omap2/built-in.o: In function `usbhs_init_phys':
> arch/arm/mach-omap2/usb-host.c:652: undefined reference to `usb_bind_phy'
> arch/arm/mach-omap2/built-in.o: In function `omap_2430sdp_init':
> arch/arm/mach-omap2/board-2430sdp.c:236: undefined reference to `usb_bind=
_phy'
> arch/arm/mach-omap2/built-in.o: In function `omap3_beagle_init':
> arch/arm/mach-omap2/board-omap3beagle.c:554: undefined reference to `usb_=
bind_phy'
> arch/arm/mach-omap2/built-in.o: In function `devkit8000_init':
> arch/arm/mach-omap2/board-devkit8000.c:596: undefined reference to `usb_b=
ind_phy'
> arch/arm/mach-omap2/built-in.o: In function `omap_ldp_init':
> arch/arm/mach-omap2/board-ldp.c:379: undefined reference to `usb_bind_phy'
> drivers/built-in.o: In function `ab8500_charger_probe':
> drivers/power/ab8500_charger.c:3629: undefined reference to `usb_get_phy'
> drivers/power/ab8500_charger.c:3706: undefined reference to `usb_put_phy'
> drivers/built-in.o: In function `ab8500_charger_remove':
> drivers/power/ab8500_charger.c:3411: undefined reference to `usb_put_phy'
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> ---
>  drivers/usb/phy/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index 21153d1..371d0e7 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -2,7 +2,7 @@
>  # Physical Layer USB driver configuration
>  #
>  menuconfig USB_PHY
> -	tristate "USB Physical Layer drivers"
> +	bool "USB Physical Layer drivers"

looks like this is the only way, indeed. Do you need on the merge window
on can this wait until -rc1 ? I just sent a pull request to Greg with
urgent fixes for the merge window.

Greg, if you want to take this one as a patch, go for it:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--Gs9iBZf6UKWgztis
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdrHfAAoJEIaOsuA1yqREXUoP/2h8lJGKS9NsGDjtah3FC8lL
7AhDisTWdM+0NUmt63xUv+RVuNx3/kcJy7yh5xO25Ioq39et1X2pLPQBs3LFiESJ
yjrgaIR9SqfjkF7/kE9RMyoDEg/6VoudInZgJfrVv7boIxgVI8ImH6ML8tbmQ/4y
mPfQGfhFQ/30hVEHGlz9ifZzZrC5arcdONfdNWYmhD+APiOiJgmUN1OVIczu/j96
oUN84kT8WkyPbrsfhzeITFgdahIGRuYbjk/tBkEv4iW5UPMeD0ly16SZ+KLSog+j
DD7WBRitQq5eV9WHTapPeRESIhVD9TuhK6Xht2xd6m6AwuHMf924TIth4pbPImqZ
Uo1nttGsHUhHQyPk6JfQpVgFv6auONXJYJHmRU7ZiY/v5Ns2jvDSkzA+v0O5wTy4
CmIlDBIWM8PyPDJXI7h1ec/oFPq/q4LNJBpNJwBdCrGWYuJZyb5o2TfDtLL1yCWt
at2RKIDYiPQ0TNlOKhUDqyLnB6XqnJlFLZfcmU8zT7Z3po5y91mBxjtXLCMwVSEG
umJU9ZUhS0dAKIEroZgp5VwHyjxOKFvNEDVvTg/ftY7nkqEcEYxsp56ctwPM072S
4zGPb+nyTnowJzb2DnLFSczwfm6woit49ea5IPWpivcpeXJ2QT8rekFxACK6k7SP
TS/HhFgRORAdzmeiac6R
=Sa8f
-----END PGP SIGNATURE-----

--Gs9iBZf6UKWgztis--
