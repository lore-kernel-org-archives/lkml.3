Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab3JNXAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 19:00:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43062 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766Ab3JNXAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 19:00:20 -0400
Date: Mon, 14 Oct 2013 17:59:33 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <davidb@codeaurora.org>, <dwalker@fifo99.com>, <bryanh@codeaurora.org>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <grant.likely@linaro.org>, <jackp@codeaurora.org>,
        <mgautam@codeaurora.org>, <dsegal@codeaurora.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 12/13] usb: phy: msm: Properly check core interrupt
 number
Message-ID: <20131014225933.GF7446@radagast>
Reply-To: <balbi@ti.com>
References: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
 <1381764280-28420-13-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JSkcQAAxhB1h8DcT"
Content-Disposition: inline
In-Reply-To: <1381764280-28420-13-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JSkcQAAxhB1h8DcT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2013 at 06:24:39PM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> IRQ with number 0 is valid case, so check for negative

not entirelly correct... IRQ 0 isn't supposed to be used as a linux IRQ
number IIRC.

> numbers instead.
>=20
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  drivers/usb/phy/phy-msm-usb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> index ca2abe6..f34c8a9 100644
> --- a/drivers/usb/phy/phy-msm-usb.c
> +++ b/drivers/usb/phy/phy-msm-usb.c
> @@ -1415,7 +1415,7 @@ static int __init msm_otg_probe(struct platform_dev=
ice *pdev)
>  	dev_info(&pdev->dev, "OTG regs =3D %p\n", motg->regs);
> =20
>  	motg->irq =3D platform_get_irq(pdev, 0);
> -	if (!motg->irq) {
> +	if (motg->irq < 0) {

this check is correct though, since platform_get_irq() will return
-ENXIO if it doesn't find IRQ resource.

--=20
balbi

--JSkcQAAxhB1h8DcT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSXHdVAAoJEIaOsuA1yqRE3HkQAJ2z44WF0KL5m/u2VGTL1Xgp
7SIrdyETHe+py5kdp5cdxqbupTHhWzLiB65uevqGlBd67qMKxSkEgmDo++RC8guh
FYmAojyIWpRr7e8OMBXl8qIIJQYNOWBzZjNrrMcatYKlsHPMUTzBz1yJRUB4bDCZ
ZVB/txj11VT5zPjI4UyP6y1JAayIkyHDMiCElUk0JxBBdOx1YpdQhKsB/HcfUHkk
bp6NHpWCikaleM9U+I85T5PrTQp0AGJ3KOiq01QMHCwrAXnXz+MvSQPyInvyQ50m
H6yOKEl1kPfq15QWuK0v9R6kSpXMBwcr9nCRPz1GYLPcoTmSrs00f/iv836TgiNA
lmlSMWts2oILHvxZ48T+Tc/fRwTSoGLz5ejVvZEE21UKXEvi8CrBR84HSAxqZ7M0
1y8VIsq+8Juwn9hVVBwnUwZIQIKGh3o5/oIuuHLI6NCEdptoJu+VSOjA6m87MtRW
XeVpaPIUqwqb7XSr9bqaY+c5Q0pOzF3pFsgqhf2e12BR/0TQekMZ8taqzSfwjL9K
r99O4yLaSlUFhDljRmhbPQMt5/0uIbp3zBRcJy2ZDIaPvXlfNhnCz+kPw2Cd9ILX
sGngx7gSEXUVj4voVRndZJ6h3qg1+tEhRTVH9P203Iw7y1dzJQcOHXpOUhgl/NRG
4ubw1i2UA8qb8t5vgdcD
=pbRz
-----END PGP SIGNATURE-----

--JSkcQAAxhB1h8DcT--
