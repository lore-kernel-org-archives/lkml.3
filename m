Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaEMP2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:28:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41001 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbaEMP2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:28:11 -0400
Date: Tue, 13 May 2014 10:27:35 -0500
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH 5/8] usb: phy: msm: reset controller is mandatory now
Message-ID: <20140513152735.GJ1151@saruman.home>
Reply-To: <balbi@ti.com>
References: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
 <1399557141-1346645-6-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZG+WKzXzVby2T9Ro"
Content-Disposition: inline
In-Reply-To: <1399557141-1346645-6-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ZG+WKzXzVby2T9Ro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 03:52:18PM +0200, Arnd Bergmann wrote:
> Commit a27345434134 "usb: phy: msm: Use reset framework for LINK
> and PHY resets" introduced a mandatory call to reset_control_get
> into the msm usb phy driver, which means we have to add a Kconfig
> dependency on the API to avoid this build error:
>=20
> phy/phy-msm-usb.c: In function 'msm_otg_read_dt':
> phy/phy-msm-usb.c:1461:2: error: implicit declaration of function 'devm_r=
eset_control_get' [-Werror=3Dimplicit-function-declaration]
>   motg->link_rst =3D devm_reset_control_get(&pdev->dev, "link");
>   ^
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> ---
>  drivers/usb/host/Kconfig | 2 +-
>  drivers/usb/phy/Kconfig  | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 3d9e540..890fc8c 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -168,7 +168,7 @@ config USB_EHCI_HCD_AT91
> =20
>  config USB_EHCI_MSM
>  	tristate "Support for Qualcomm QSD/MSM on-chip EHCI USB controller"
> -	depends on ARCH_MSM
> +	depends on ARCH_MSM && RESET_CONTROLLER
>  	select USB_EHCI_ROOT_HUB_TT
>  	select USB_MSM_OTG
>  	---help---
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index 359a6c1..65bec8f 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -165,6 +165,7 @@ config USB_ISP1301
>  config USB_MSM_OTG
>  	tristate "Qualcomm on-chip USB OTG controller support"
>  	depends on (USB || USB_GADGET) && (ARCH_MSM || ARCH_QCOM)
> +	depends on RESET_CONTROLLER
>  	select USB_PHY
>  	help
>  	  Enable this to support the USB OTG transceiver on Qualcomm chips. It

yeah, only this second hunk is necessary. I'll swap my patch with yours
once I see a second version.

--=20
balbi

--ZG+WKzXzVby2T9Ro
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTcjnnAAoJEIaOsuA1yqRE1zkP/i1uEAUgZGvc28aw5MBAjhhC
CYTseLwuxoD5jNUcCezrLgJd+EgJnT37CN7T+23bAZ7R2Dohpn8oRKgh/R/pQ6m0
wPBBuK5torGGnuxYjIXQz4MtkkkJK+3WkRKh4db6URXgEf87IpPgNukis0ApGZGX
k81SkF/Jwu7HIqngJgDmgRDB2s1mOic55u4HkvPZ1MnUitHcCpwrcFnAB1cmF9/e
xTMJxyuQE0UmzGSpFutv+JHyvwhP7e3iDjXg8BwtJXe3TDNfcEC2DFmLYIQG9yNo
WTYkHaei44CjwXN+n0t3Vu6IV8X0r20GXMD28f8kI4BaS5NTECTJze8cm8yjW4tK
enaUrjDVzKuNahV9YCL3lKdgqLd4fBEovPqoFAOYYEY5VvIXoEp9R4R7Wr0vRlan
XufwaVJC+hhzV84THY1F71xT2HC7BjyMmmxLVY/l7NdDCSPIYQ3PR7DcvThb7PMy
1G4JJ1h0QBwJ1/fInp4s9zbNGYmqqxfIYCJDKQS2M+9KI4ntrIj7Ob3tc7I9aAfw
/xGFNknLvtKPng7b5N6plyeLoJlEgyVPtvaBuG6CY+rHb2uzUPot450euaCBNoAz
rL9em725PYEFx5chZlICozaJAA7uOsbpLejyhXwdtTLfJjsccrE0e8cOFbnskZZ6
p5vL5JSJkCfBHYBLCBOt
=pA0f
-----END PGP SIGNATURE-----

--ZG+WKzXzVby2T9Ro--
