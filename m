Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964947AbaEMO5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:57:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51752 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933006AbaEMO5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:57:03 -0400
Date: Tue, 13 May 2014 09:56:48 -0500
From: Felipe Balbi <balbi@ti.com>
To: Jim Davis <jim.epost@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: Re: randconfig build error with next-20140513, in
 drivers/usb/phy/phy-msm-usb.c
Message-ID: <20140513145648.GD1151@saruman.home>
Reply-To: <balbi@ti.com>
References: <CA+r1ZhhpZtMV6qt=E__UT+6jgbsAnhso58+wmrrwrU5FRNZp=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fOHHtNG4YXGJ0yqR"
Content-Disposition: inline
In-Reply-To: <CA+r1ZhhpZtMV6qt=E__UT+6jgbsAnhso58+wmrrwrU5FRNZp=Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fOHHtNG4YXGJ0yqR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 06:46:05AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
>=20
> drivers/usb/phy/phy-msm-usb.c: In function =E2=80=98msm_otg_read_dt=E2=80=
=99:
> drivers/usb/phy/phy-msm-usb.c:1461:2: error: implicit declaration of
> function =E2=80=98devm_reset_control_get=E2=80=99
> [-Werror=3Dimplicit-function-declaration]
>   motg->link_rst =3D devm_reset_control_get(&pdev->dev, "link");
>   ^
> drivers/usb/phy/phy-msm-usb.c:1461:17: warning: assignment makes
> pointer from integer without a cast [enabled by default]
>   motg->link_rst =3D devm_reset_control_get(&pdev->dev, "link");
>                  ^
> drivers/usb/phy/phy-msm-usb.c:1465:16: warning: assignment makes
> pointer from integer without a cast [enabled by default]
>   motg->phy_rst =3D devm_reset_control_get(&pdev->dev, "phy");
>                 ^
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/usb/phy/phy-msm-usb.o] Error 1

Here's a patch:


diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index fbbced8..ec531a4 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -173,6 +173,7 @@ config USB_ISP1301
 config USB_MSM_OTG
 	tristate "Qualcomm on-chip USB OTG controller support"
 	depends on (USB || USB_GADGET) && (ARCH_MSM || ARCH_QCOM || COMPILE_TEST)
+	depends on RESET_CONTROLLER
 	select USB_PHY
 	help
 	  Enable this to support the USB OTG transceiver on Qualcomm chips. It

will send it shortly

--=20
balbi

--fOHHtNG4YXGJ0yqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTcjKwAAoJEIaOsuA1yqREGS4P/A6LfcxhxUNWn6emvF2oD55o
r3jy46gw4osD/6eiopJrnPMLjz7Izy+atHOmojPNZ9aBPPnVudRuRjIVLFNIwfWm
t59+lrh0q8qFbZqZwZHwMVjpavt/ojexU3WVgUKCOGbrIQh8HGOhmsa15SaQiemU
t72dOPecfGdPAoJQXh/JwFLgJyd37471HA7dhwFAObBXzEPPpuYCNmr8YpElPVpw
J5KOI7gvIzCgJo7jpfm/5sT7I2ZSoX4CVDanvPvAuUumhf4uJNI5LzmnjBJdY+6p
lXlvaJLKCRuBUobfMNONT73GMg9A2ojbhiCMq3ikG94oDN/Z+loNwf5JOMaAHMze
Rs6nke7o2OTY/3E0jUWzvwBW0dmFihdLNQpgE/1j+l+N9/L5Tpbm3Z8Kmzfs0LKi
43aq8EWFb9kYMu7w17ioJ0LIwUFqT++aSXHgenqgcTIbTULLZ1iDP1DnUMYTLQqA
kcslQYU/qlEE+G1Py1ZLXTiKLTQDqeDk2IH6mf+zeGA36CkIluyrJ4hPub7/1vEm
435zNsuWtIRmGvT65NsQJdjZbdqURHkxAWUXCWmdxEknC/Ne/7npoNrtQblNiavU
CGOxuZq0EMqG4caRA7lOSsRo/M5EsNCrluXd6qMZgxKcRg4EzrArPvOxpeNbmN/E
db8JjhIWqSaM5V2wzhTJ
=K5TX
-----END PGP SIGNATURE-----

--fOHHtNG4YXGJ0yqR--
