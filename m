Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3GJFZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 01:25:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50125 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab3GJFZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 01:25:57 -0400
Date: Wed, 10 Jul 2013 08:25:34 +0300
From: Felipe Balbi <balbi@ti.com>
To: Julius Werner <jwerner@chromium.org>
CC: <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-samsung-soc@vger.kernel.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Praveen Paneri <p.paneri@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH] usb: phy: samsung-usb2: Toggle HSIC GPIO from device tree
Message-ID: <20130710052534.GB15674@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1373416455-30358-1-git-send-email-jwerner@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <1373416455-30358-1-git-send-email-jwerner@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 09, 2013 at 05:34:15PM -0700, Julius Werner wrote:
> This patch adds support for a new 'samsung,hsic-reset-gpio' in the
> device tree, which will be interpreted as an active-low reset pin during
> PHY initialization when it exists. Useful for intergrated HSIC devices
> like an SMSC 3503 hub. It is necessary to add this directly to the PHY
> initialization to get the timing right, since resetting a HSIC device
> after it has already been enumerated can confuse the USB stack.
>=20
> Also fixes PHY semaphore code to make sure we always go through the
> setup at least once, even if it was already turned on (e.g. by
> firmware), and changes a spinlock to a mutex to allow sleeping in the
> critical section.
>=20
> Change-Id: Ieecac52c27daa7a17a7ed3b2863ddba3aeb8d16f
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  .../devicetree/bindings/usb/samsung-usbphy.txt     | 10 ++++++
>  drivers/usb/phy/phy-samsung-usb.c                  | 17 ++++++++++
>  drivers/usb/phy/phy-samsung-usb.h                  |  7 ++--
>  drivers/usb/phy/phy-samsung-usb2.c                 | 38 ++++++++++------=
------
>  drivers/usb/phy/phy-samsung-usb3.c                 | 12 +++----
>  5 files changed, 55 insertions(+), 29 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt b/D=
ocumentation/devicetree/bindings/usb/samsung-usbphy.txt
> index 33fd354..82e2e16 100644
> --- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> +++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> @@ -31,6 +31,12 @@ Optional properties:
>  - ranges: allows valid translation between child's address space and par=
ent's
>  	  address space.
> =20
> +- samsung,hsic-reset-gpio: an active low GPIO pin that resets a device
> +			connected to the HSIC port. Useful for things like
> +			an on-board SMSC3503 hub.
> +- pinctrl-0: Pin control group containing the HSIC reset GPIO pin.
> +- pinctrl-names: Should contain only one value - "default".
> +
>  - The child node 'usbphy-sys' to the node 'usbphy' is for the system con=
troller
>    interface for usb-phy. It should provide the following information req=
uired by
>    usb-phy controller to control phy.
> @@ -56,6 +62,10 @@ Example:
>  		clocks =3D <&clock 2>, <&clock 305>;
>  		clock-names =3D "xusbxti", "otg";
> =20
> +		samsung,hsic-reset-gpio =3D <&gpx2 4 1>;

looks like this should be modeled as a fixed-regulator ?

--=20
balbi

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR3PBNAAoJEIaOsuA1yqREVrcP/3+ZoNfaRCHuCz4obAY3ncGl
+FgaY3fuvJ1KJSXv/HzrnusggFfZ4btfeOrDRZCgDz26SAbjlQXZlgRU5Gy73G0I
ygCZIiCrI6oYxqbDYakRT+j9sB44hRd3cFaRcKCdqdRWVmun2low4J2JjYmow9OU
N8mYpvME4vm4AHxoOcCExgZBsdRyOUDD3k4IMHPRHITvN4sxAzDz/Dw8ykPZKCzw
B4iItvKW4qdeLuV+y2Gyih7hD4bDiBcdln8GLXzuqgRA6zI0i1HI+nMNxJYZeRf2
SjgzG68hNmnjxAlddwyQjbzDUgAIjFVMZyH/rP6tdzgSmJgP9reF/5UP+nilqt9t
BWWgVSmcnMy08pxvExBRYEFLkq87G0coJpoYxrzLWuPMtOxnEubSlwt2GpH/92mx
XLQl74NbIK9Zz1N/lyNZ3l5brV+Nc94eYc7kYr9LeWY0L/8zDXagk5n16PXCODVB
trb0lnAQVkglBiuaLHvWcxuPNzLShTt01MgAAuQG3SR0SxWIw7xM9uFVgbL9brEV
WRFm1xCyqg7gtoVkxhD4WJyCDJ6kuCdHfvvz72roF+lfbslgYE3rwaOLBiYaf8Io
oAR9OB8BGweAZ3N7WibjqAuYt8ajGjC4HcUmmnyZMDMiHi/ugWy0HcQIus3zT5Wi
Syy3jnFtel+UrFtOT4r3
=kMEY
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
