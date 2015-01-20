Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbbATTDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:03:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48815 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbbATTDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:03:01 -0500
Date: Tue, 20 Jan 2015 13:02:09 -0600
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] ARM: dts: dra7-evm: Add extcon nodes for USB
Message-ID: <20150120190209.GE15169@saruman>
Reply-To: <balbi@ti.com>
References: <1421689942-10201-1-git-send-email-rogerq@ti.com>
 <1421689942-10201-4-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o0ZfoUVt4BxPQnbU"
Content-Disposition: inline
In-Reply-To: <1421689942-10201-4-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--o0ZfoUVt4BxPQnbU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2015 at 07:52:20PM +0200, Roger Quadros wrote:
> On this EVM, the USB cable state has to be determined via the
> ID pin tied to a GPIO line. We use the gpio-usb-extcon driver
> to read the ID pin and the extcon framework to forward
> the USB cable state information to the USB driver so the
> controller can be configured in the right mode (host/peripheral).
>=20
> Gets USB peripheral mode to work on this EVM.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/boot/dts/dra7-evm.dts | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.=
dts
> index 10b725c..47d9a06 100644
> --- a/arch/arm/boot/dts/dra7-evm.dts
> +++ b/arch/arm/boot/dts/dra7-evm.dts
> @@ -26,6 +26,16 @@
>  		regulator-max-microvolt =3D <3300000>;
>  	};
> =20
> +	extcon_usb1: extcon_usb1 {
> +		compatible =3D "linux,extcon-usb";
> +		id-gpio =3D <&pcf_gpio_21 1 GPIO_ACTIVE_HIGH>;
> +	};
> +
> +	extcon_usb2: extcon_usb2 {
> +		compatible =3D "linux,extcon-usb";
> +		id-gpio =3D <&pcf_gpio_21 2 GPIO_ACTIVE_HIGH>;
> +	};
> +
>  	vtt_fixed: fixedregulator-vtt {
>  		compatible =3D "regulator-fixed";
>  		regulator-name =3D "vtt_fixed";
> @@ -391,6 +401,19 @@
>  			};
>  		};
>  	};
> +
> +	pcf_gpio_21: gpio@21 {
> +		compatible =3D "ti,pcf8575";
> +		reg =3D <0x21>;
> +		lines-initial-states =3D <0x1408>;
> +		gpio-controller;
> +		#gpio-cells =3D <2>;
> +		interrupt-parent =3D <&gpio6>;
> +		interrupts =3D <11 IRQ_TYPE_EDGE_FALLING>;
> +		interrupt-controller;
> +		#interrupt-cells =3D <2>;
> +	};
> +
>  };
> =20
>  &i2c2 {
> @@ -520,6 +543,14 @@
>  	};
>  };
> =20
> +&omap_dwc3_1 {
> +	extcon =3D <&extcon_usb1>;
> +};
> +
> +&omap_dwc3_2 {
> +	extcon =3D <&extcon_usb2>;
> +};
> +
>  &usb1 {
>  	dr_mode =3D "peripheral";
>  	pinctrl-names =3D "default";
> --=20
> 2.1.0
>=20

--=20
balbi

--o0ZfoUVt4BxPQnbU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUvqYxAAoJEIaOsuA1yqREg0cP/jT4ZIEh7Bd9bdhH6nbuuyy+
MayE1BxSYfe8bvRZkmX7WjF4UPx7/CPhk+9YRbetowqjskeylpImZ+2kYL84I553
ReoVo9oDU/E63lklKWEQNcdhcbNnshF26ao4PGWf099ThGDDvUR4LrplfIr9WXxb
tcCImOplpqnJVQoIZzaTAtsRQ+p/x5LY0jhsvojGWEecaMUmyOdPOU+w8Jt+pPnT
sv9+5O6SR8SLGb1q7XXEUUXcyPHesj+TICDe6kqe+o7kJ6lTL8NNnDm63SQlGnRT
M351vXfljedqggB1UVJeclelbR3gCw6x73ui27wzj3TRQenk3XwM2/LRFvkZWYvH
uvQE6/hpItXWnW1Lt4sCAwktUhdoWk+ax+CNMTGw5//Yb8SClRMLTiHDGB6yzKk6
o/WCwrPLtNUTcLSGKIbcSqkYkBbPt76AxZBfPWXDk7S/KjUTql62ZhheU91bioBL
JlOTvD1ZbB0sVBaolVVuMUsNswhNy4GSEINGpy5QT4zO/xzu/7mhFsgO5lfs/O8H
MUqmQOv+T2TXGZDD73C9TF3MyeruWEenJK2UTQA8DDZYHuXc+6pPAHDNWbP4Gh/9
zWu8CvAsIc8n2JFNFL6D7A+xWYBky1XwmJRqek7WzDPpQN4LkQOquD6QRMBlH13k
wTxL3VvSJd4XgePiBGGI
=u4Ec
-----END PGP SIGNATURE-----

--o0ZfoUVt4BxPQnbU--
