Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab3GIKV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 06:21:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58368 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab3GIKVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 06:21:25 -0400
Date: Tue, 9 Jul 2013 13:20:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>, <afzal@ti.com>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>
Subject: Re: [PATCH v2] arm: dts: AM43x: Add usb_otg_hs node
Message-ID: <20130709102022.GH5552@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1373361446-30050-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QwZB9vYiNIzNXIj"
Content-Disposition: inline
In-Reply-To: <1373361446-30050-1-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+QwZB9vYiNIzNXIj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 09, 2013 at 02:47:26PM +0530, George Cherian wrote:
> Adds device node for HS USB Host module for AM437x
>=20
> changes from v1
>=20
> renamed synopsis to snps
> removed flag tx-fifo-resize

the patch revision changes don't need to go to the commit log,
they should be placed after the tearline (---) and before the diffstat.

> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  arch/arm/boot/dts/am4372.dtsi | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
> index ddc1df7..c9e0da8 100644
> --- a/arch/arm/boot/dts/am4372.dtsi
> +++ b/arch/arm/boot/dts/am4372.dtsi
> @@ -64,5 +64,23 @@
>  			compatible =3D "ti,am4372-counter32k","ti,omap-counter32k";
>  			reg =3D <0x44e86000 0x40>;
>  		};
> +
> +		usb_otg_hs1: am4372_dwc3@48380000 {

dtsi should always have status =3D "disabled"; no ?

> +			compatible =3D "ti,am437x-dwc3";
> +			reg =3D <0x48380000 0x1ff>;

weird size, shouldn't this be 0x200 ?

> +			interrupts =3D <GIC_SPI 172 IRQ_TYPE_LEVEL_HIGH>;
> +			#address-cells =3D <1>;
> +			#size-cells =3D <1>;
> +			utmi-mode =3D <1>;
> +			ranges;
> +
> +			dwc3@48390000 {

dtsi should always have status =3D "disabled"; no ?

> +				compatible =3D "snps,dwc3";
> +				reg =3D <0x48390000 0xcfff>;

weird size, shouldn't this be 0xd000 then the size would be exactly
52KiB

> +				interrupts =3D <GIC_SPI  168 IRQ_TYPE_LEVEL_HIGH>;
> +			};
> +
> +		};
> +	=09

there two trailing tabs on this line.

Another thing: am437x has 4 instances of this IP, why are you adding
only one ? And why aren't you pasing the PHY nodes here ? The device
won't work without its PHYs.

--=20
balbi

--+QwZB9vYiNIzNXIj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR2+PmAAoJEIaOsuA1yqRE9KQP/R/EN80a1vDZzkZRGmM4HLEd
AtsJnkkcb1q/mSyge3BhuXN03ue3iZ7SGGErEy07zb83zERwFeM+7KikA5g3KMWz
09bxKBarhdzNxO8d2b1HqeUXNAZEYMZNaSshIUb5LUMwfApIRH6OY2D38crzWfWQ
YEa5OURx6sWfs/iKNnL+p8LK0ldhoShMBhEKwXQDc321Mc3Cfs1oVF9SoxOQXVyC
L2mN4pPidlMeUt6E57/8SaQrQOK3rExdfjkcqOqWXTYefT6zdrnz1q5vhCmxdi/L
7b5RrMPw37H/XMoOYcltd8PRuyYFVzin62AAHC2YX2+LFv9l0nS5CoHWqUoN9Una
A7N2u53bWDpgXEH2e0qOYbpXnwJaJIS2q8qlAwVp1LeqPed/f2eMVZBfYQJeVv7H
kKUqdI3FLxf10/eR+k0KWPBIMFTB9AjnLYKy6q7NwSK8oPTSB0476xOoUJcuOKDW
5ZiF71GT+0W97rJbs3Q7Vrq+et4Xrc5z/ylDH101b5HscOlLxyxwc1H2x3kkOvy/
QiyZ0hqKdJ19lsEcDBKiH/H/lE4X7fjS6ySNyL59NUci9obPj9DEikEYPCIY2Fm6
3v2C6H3dMuG1nDnGk8ecClTCUV26zeBjpo91s3qmgNBwObPX406qii8lVdDJ81/y
0FHJeTl88TXuJ7s3m+Ke
=BA/h
-----END PGP SIGNATURE-----

--+QwZB9vYiNIzNXIj--
