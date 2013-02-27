Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab3B0Tv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:51:26 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56903 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436Ab3B0TvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:51:22 -0500
Date: Wed, 27 Feb 2013 21:51:12 +0200
From: Felipe Balbi <balbi@ti.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] usb: limit OMAP related USB options to OMAP2PLUS
 platforms
Message-ID: <20130227195046.GA2300@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1361992119-2465-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Content-Disposition: inline
In-Reply-To: <1361992119-2465-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI,

On Wed, Feb 27, 2013 at 02:08:39PM -0500, Paul Gortmaker wrote:
> commit 57f6ce072e35770a63be0c5d5e82f90d8da7d665 ("usb: phy:
> add a new driver for usb3 phy") added the new Kconfig option
> OMAP_USB3, but it had no dependencies whatsoever, and hence
> became available across all arch/platforms.
>=20
> Which presumably caused this to show up in x86 randconfig:
>=20
>     warning: (USB_MUSB_HDRC && OMAP_USB3) selects \
>         OMAP_CONTROL_USB which has unmet direct \
>         dependencies (USB_SUPPORT && ARCH_OMAP2PLUS)
>=20
> Then commit 6992819feb39cb9adac72170555d957d07f869f2 ("usb: phy:
> fix Kconfig warning") was added.  However, this just deleted the
> ARCH_OMAP2PLUS dependency from OMAP_CONTROL_USB, further
> compounding the problem by opening up OMAP_CONTROL_USB to
> all arch/platforms as well.
>=20
> Here we revert the change of 6992819feb to restore the dependency,
> and add the same ARCH_OMAP2PLUS dependency to the new OMAP_USB3.
>=20
> Perhaps a more platform specific dependency could be chosen for
> OMAP_USB3, but at least this keeps it from bleeding out to other
> architectures and non-OMAP ARM platforms as it is currently doing.
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Moiz Sonasath <m-sonasath@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  drivers/usb/phy/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index 65217a5..40b8463 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -17,6 +17,7 @@ config OMAP_USB2
> =20
>  config OMAP_USB3
>  	tristate "OMAP USB3 PHY Driver"
> +	depends on ARCH_OMAP2PLUS
>  	select USB_OTG_UTILS
>  	select OMAP_CONTROL_USB
>  	help
> @@ -27,6 +28,7 @@ config OMAP_USB3
> =20
>  config OMAP_CONTROL_USB
>  	tristate "OMAP CONTROL USB Driver"
> +	depends on ARCH_OMAP2PLUS

I rather not add dependencies here and fix the selections of
OMAP_CONTROL_USB.

--=20
balbi

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRLmOvAAoJEIaOsuA1yqREHKEP/jOM+BtpaLTQFxqD95PNGr3E
rlhE2YtVyRsUYVTyD1i2yYMzaBgu+YuHN0MuE2P8PFCLq5e1hb1kuUghTcOTHOZ7
fZRHL7zRkdrb9znVTHdtZF4oaqKuBK9nkXJctDVIeKYOT+ZAvbBk4ivrEUvx3QTH
9gikUz++R09DS3njDPwIHgDWqS16lTskRJJKizNlVLT8Xv7q3DtYYMyGdqiA7YK/
S8Je72ggOby9R3lwzUi/C7+34+NLzNxuerTzy6mFqtvnxyC3qoTfBdB/XNOMBaK9
5eDyGAWgOKJ9TBnatphMh6C4XEm+ys3FitiuBX+0K7KH4H65TU9MXDdNT33zhXvP
pe3r1AsqpzfODch1m6QxgdV6Vp17jIYACGWbaSqh3tr45eDZ5a0XqVLjXI4he71P
nnQI76fe64pl8ZfQ7iLPYUTETqEhKgnXMsN+zZL+Kx2AUjbclzR3aQExvxhoLmnX
hVOj9PRKqR6YOtaQEiqmnChf++LZuzkw26BVDyaB8hpqGCJ5oyxnepeyGgRxBMbq
rMcoFzSL4igYTD+1kwJ+oA3JfInXltwCzavTfctVNizc9dEt3kyasEgshOWj0w7I
WCxgAmRto8MTPGzB7WLKJUlDBG0BERwdnmWw7kTyjrdOKGE/x0MWH34aHeWifGha
Qy9Q5hHLBx4lmYW2XtYp
=ht65
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--
