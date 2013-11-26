Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab3KZPzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 10:55:22 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36651 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab3KZPzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 10:55:21 -0500
Date: Tue, 26 Nov 2013 09:54:25 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <linux@arm.linux.org.uk>, <santosh.shilimkar@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] phy: kconfig: add depends on "USB_SUPPORT" to OMAP_USB2
 and TWL4030_USB
Message-ID: <20131126155425.GC24310@saruman.home>
Reply-To: <balbi@ti.com>
References: <1385460115-31194-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iFRdW5/EC4oqxDHL"
Content-Disposition: inline
In-Reply-To: <1385460115-31194-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iFRdW5/EC4oqxDHL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2013 at 03:31:55PM +0530, Kishon Vijay Abraham I wrote:
> Fixes
> warning: (OMAP_USB2 && TWL4030_USB) selects USB_PHY which has unmet
> direct dependencies (USB_SUPPORT)
> that shows up while disabling USB_SUPPORT from menuconfig.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/phy/Kconfig |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index a344f3d..0c87e4c 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -24,6 +24,7 @@ config PHY_EXYNOS_MIPI_VIDEO
>  config OMAP_USB2
>  	tristate "OMAP USB2 PHY Driver"
>  	depends on ARCH_OMAP2PLUS
> +	depends on USB_SUPPORT
>  	select GENERIC_PHY
>  	select USB_PHY
>  	select OMAP_CONTROL_USB
> @@ -36,6 +37,7 @@ config OMAP_USB2
>  config TWL4030_USB
>  	tristate "TWL4030 USB Transceiver Driver"
>  	depends on TWL4030_CORE && REGULATOR_TWL4030 && USB_MUSB_OMAP2PLUS
> +	depends on USB_SUPPORT

The problem is actually the select below. Make this driver depend on
GENERIC_PHY instead. Note that we have to remove that dependency soonish
as this same IP is used as a SATA PHY.

--=20
balbi

--iFRdW5/EC4oqxDHL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlMQxAAoJEIaOsuA1yqRERRUP/iAYFgvcfTc0hOJkn2jY689k
s6Xa/Sryt/s2aa321qhzKjSqwLNLkOlhPI6+SIQ0DQNPCB43jo+ZwZBkKGhpBHaa
skGa0hbnGQp0TvtTOTfiP10anWJZuJDq1NWniUeM1WLCmAhYfu0NqqLtEF/7K4uj
x4XgVnrDcvEy5ZU2f6MO8l0lUdRKnYwVpdWjEPq8spZMjKEDAeVYq3z4dDlS97hj
pcBT/r3Pv8QJHLbS1jQmqkan0M1tWRK0QBibc9EH55pRBQesidqpnlwuGEp+iYnx
HT8lnbzBjgpiwA3Km+pULCwWZHuhCYHGNU4wgOAOkMpXrqP+E8IDUqbtULvGVQtl
VtJLeaZ+lBwmxvP5RkgOZPkbm5p1l/lXEGyWrfo6ZORQElhUjjr77FvTg8RAnth7
c0fu9jg6m+A2y4FE88BvVjXuC3qfcejTYkZsB+QV4tvoSJnrik0Egbwn9gvt1FTR
bE9DSq4OcBGyOIfr5B+JaaLVVAr1BPcnjLGJvu3+NHL8ioaRjyfii4/zy5xcqmG/
JEvK095OIdYQprT2anspIZvSzy2AhwwrwqK6J8vtbpr/4293HxBxakhezXqhzMw0
94rmtJZTRcTYaFRSYXQVzRdcbzjpyUyH1pKjqTF161gV2LCSVT7cV7ato0COvFKl
tdUM8MQKfiX3eBea/CeP
=plLj
-----END PGP SIGNATURE-----

--iFRdW5/EC4oqxDHL--
