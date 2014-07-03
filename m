Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbaGCOQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:16:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57483 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757960AbaGCOPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:15:51 -0400
Date: Thu, 3 Jul 2014 09:15:29 -0500
From: Felipe Balbi <balbi@ti.com>
To: Keerthy <j-keerthy@ti.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <mark.rutland@arm.com>,
        <galak@codeaurora.org>, <robh+dt@kernel.org>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>
Subject: Re: [PATCH 1/5] mfd: Add DT bindings for tps65218 PMIC
Message-ID: <20140703141529.GG5814@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404395102-21469-1-git-send-email-j-keerthy@ti.com>
 <1404395102-21469-2-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ndw/alBWmZEhfcZ"
Content-Disposition: inline
In-Reply-To: <1404395102-21469-2-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4ndw/alBWmZEhfcZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 03, 2014 at 07:14:58PM +0530, Keerthy wrote:
> Add DT bindings for tps65218 PMIC
>=20
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>  Documentation/devicetree/bindings/mfd/tps65218.txt |   57 ++++++++++++++=
++++++
>  1 file changed, 57 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/tps65218.txt
>=20
> diff --git a/Documentation/devicetree/bindings/mfd/tps65218.txt b/Documen=
tation/devicetree/bindings/mfd/tps65218.txt
> new file mode 100644
> index 0000000..38f48ef
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/tps65218.txt
> @@ -0,0 +1,57 @@
> +Texas Instruments TPS65218 family
> +
> +The TPS65218 are Integrated Power Management Chips.
> +
> +Required properties:
> +- compatible : Must be "ti,tps65218";
> +  For Integrated power-management used in AM437x based boards
> +- interrupts : This i2c device has an IRQ line connected to the main SoC
> +- interrupt-controller : Since the tps65218 supports several interrupts
> +  internally, it is considered as an interrupt controller cascaded to the
> +  SoC one.
> +- #interrupt-cells =3D <2>;
> +- interrupt-parent : The parent interrupt controller which is gic.
> +
> +Optional node:
> +- TPS65218 PMIC has a number of child nodes. Mainly the regularors and S=
MPSs.
> +
> +Example:
> +/*
> + * Integrated Power Management Chip
> + */
> +tps65218: tps65218@24 {
> +	reg =3D <0x24>;
> +	compatible =3D "ti,tps65218";
> +	interrupts =3D <GIC_SPI 7 IRQ_TYPE_NONE>; /* NMIn */
> +	interrupt-parent =3D <&gic>;
> +	interrupt-controller;
> +	#interrupt-cells =3D <2>;
> +
> +	dcdc1: regulator-dcdc1 {
> +		compatible =3D "ti,tps65218-dcdc1";
> +		/* VDD_CORE voltage limits min of OPP50 and max of OPP100 */

wonder if this comment really makes sense here as boards might have
another regulator assignment. Likewise fro the other two regulators.
Also, this device provides 7 regulated outputs according to [1], why
only provide three here ?

[1] http://www.ti.com/product/tps65218

--=20
balbi

--4ndw/alBWmZEhfcZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtWWBAAoJEIaOsuA1yqREEbkQALHEmVoOSdIUH92puCjqBh5M
iGdYVi4HMQtyBn8R3wJcrpINrSbBUoSAoTx+wJZ2DL40LX3XLzIiDqLtrCdLOd7/
aV0TlXN4Xa6xaX6h1fvLbjeb+yvsMV1187/MB0xHAns5bHQFGX7G/b1yl5xrL2ma
eITtCtV4792i1cfXD68hxYROuplCb4dF+rJ9xf2L9NSxUlZpMZXqP+aL17kjG34g
AAhAL0xlqfaEipWB2CLPWMO5Umwx80vN23C87VFudoJWa+k/arFIDv+1Zfhc1CPT
GQd6vkWLArAzhu8p/0a4+jsg5oT4wbQzZT6vkmADV47sKoO7neQMdhctwRnuEbDm
2bbIVvVmVggiyfWJnD2p/qpcJbZFK6IFMYbL0j+269eBF1orc0KUW2rTihJTGGBi
k3Ir54BUgQ8NVX7Gd7eGXmmGf+Yi6waLQ1RKbfbRzkGCMvg7Nj5AgZeXUaAP0+LF
wOMb+DbZ30/G6H2LZzn+TW2Wmua0WKHuA29qvSdRviEBTyRSFjpVeOA5B5rfsq7v
87xwyEBJYNi0PfUiIVR/ct3AfukQVQoB0gv/WTYfO8JHROO0vanJSwKDaEllQgCp
KefXjFw697RIIopa0+y1vWvTJoW+PtruwSwdd0VCYssQxlhngocIXN2HZ80hlpdf
cd4f1I6tcxqJntgu4jwD
=vhW/
-----END PGP SIGNATURE-----

--4ndw/alBWmZEhfcZ--
