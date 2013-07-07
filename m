Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab3GGIgp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 04:36:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41314 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab3GGIgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 04:36:44 -0400
Date: Sun, 7 Jul 2013 11:35:58 +0300
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <a-kishore@ti.com>, <afzal@ti.com>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: Re: [PATCH] arm: dts: AM43x: Add usb_otg_hs node
Message-ID: <20130707083558.GA12992@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372401887-19422-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <1372401887-19422-1-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 28, 2013 at 12:14:47PM +0530, George Cherian wrote:
> diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
> index ddc1df7..e4f5eb8 100644
> --- a/arch/arm/boot/dts/am4372.dtsi
> +++ b/arch/arm/boot/dts/am4372.dtsi
> @@ -64,5 +64,24 @@
>  			compatible =3D "ti,am4372-counter32k","ti,omap-counter32k";
>  			reg =3D <0x44e86000 0x40>;
>  		};
> +
> +		usb_otg_hs1: am4372_dwc3@48380000 {
> +			compatible =3D "ti,am437x-dwc3";
> +			reg =3D <0x48380000 0x1ff>;
> +			interrupts =3D <GIC_SPI 172 IRQ_TYPE_LEVEL_HIGH>;
> +			#address-cells =3D <1>;
> +			#size-cells =3D <1>;
> +			utmi-mode =3D <1>;
> +			ranges;
> +
> +			dwc3@48390000 {
> +				compatible =3D "synopsys,dwc3";

let's us snps,dwc3. I recently posted a patch converting synopsys to
snps like all other DesignWare drivers. Support for synopsys,dwc3 is
still there, but shouldn't be used.

> +				reg =3D <0x48390000 0xcfff>;
> +				interrupts =3D <GIC_SPI  168 IRQ_TYPE_LEVEL_HIGH>;
> +				tx-fifo-resize;

is this flag *really* necessary, I asked you and didn't get an answer.

--=20
balbi

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR2ShuAAoJEIaOsuA1yqREZ+UQAJRKQneE7PVa/XniQyQVGDfW
zoF7Dx+KCBYijI5h9HDhSFKbs0OffUFwyfx3TOyJfhHrcRzSPy1PNHxdJ1i2XwRf
LqZG7+HQgz2+ruRRp6WunU7JXFpfDukhQ0JA6zcmW3H1HqTrJNWPVWRGBbNmfj1o
fJuYDQ9KijlRZ62n3Sw/oXIP0Tl0lMSc4Ap7egEc7AIXLFJwn4DLS1yr3wPF3e+c
i2V5rUv0iRiA3Gj7c/klXxEjQDSIHUCprNQ9rDuO6W0GCe0Z49kvdYoq/WFH+eYf
txGi8yfyLQM7Sz+iin8rlVJjDkerVqRB1OmBsxcHnCOdO+StC5coNNS2W6tWUNVO
CX/obXNKm4WuO4KFS3loptlvSN96yPyhrbgwAjQnIR+Zqfgk8aSasDR19B1md0e6
rJxIiM/n9FO7C5thnVUWplrOr+Zp7MDPCqFYOUO8B7k/MvEL7uGviLEorF9MnvnS
jC4G2POETbWjaXIGEgBBZisXm3Qhm+GIIyAkDGHjGmDFJRp9/KlTTXSFOphu28ih
3iPelDS3d0DnhyTdyQFyWCODHAS/PDpHqM1xxItzYBrRfUmbR/YhiC3T6BsAkF6G
ZvmLwtFuqHya2RCoFVypOvfGyDF1aMv7BntlcrUfes6dAkuD/xqyapu9igQ48Btc
UAZx397b9Plp3BshcBa6
=m44g
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
