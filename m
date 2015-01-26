Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbbAZX5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:57:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbbAZX5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:57:06 -0500
Message-ID: <54C6D44C.4060106@suse.de>
Date: Tue, 27 Jan 2015 00:57:00 +0100
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Heiko Stuebner <heiko@sntech.de>, linux-sh@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Beniamino Galvani <b.galvani@gmail.com>,
        linux-rockchip@lists.infradead.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH v4 6/7] ARM: zynq: DT: Add pinctrl information
References: <1420818231-13451-1-git-send-email-soren.brinkmann@xilinx.com> <1420818231-13451-7-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1420818231-13451-7-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="GsJqPrllPDqFf9KBORojVe0UiwjkGA44H"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GsJqPrllPDqFf9KBORojVe0UiwjkGA44H
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 09.01.2015 um 16:43 schrieb Soren Brinkmann:
> Add pinctrl descriptions to the zc702 and zc706 device trees.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Tested-by: Andreas F=C3=A4rber <afaerber@suse.de>
> ---
> Changes since v1:
>  - remove 'pinctrl-' prefix for pinctrl sub-nodes
>  - separate config and mux nodes
>=20
> Changes since RFC v2:
>  - add pinconf properties to zc702 mdio node
>  - remove arguments from bias-related props
>=20
> Changes since RFC v1:
>  - separate DT changes into their own patch
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi |   8 +-
>  arch/arm/boot/dts/zynq-zc702.dts | 181 +++++++++++++++++++++++++++++++=
++++++++
>  arch/arm/boot/dts/zynq-zc706.dts | 152 +++++++++++++++++++++++++++++++=
+
>  3 files changed, 340 insertions(+), 1 deletion(-)
[...]
> diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-=
zc702.dts
> index 280f02dd4ddc..4995412f116f 100644
> --- a/arch/arm/boot/dts/zynq-zc702.dts
> +++ b/arch/arm/boot/dts/zynq-zc702.dts
[...]
> @@ -50,15 +52,24 @@
>  	status =3D "okay";
>  	phy-mode =3D "rgmii-id";
>  	phy-handle =3D <&ethernet_phy>;
> +	pinctrl-names =3D "default";
> +	pinctrl-0 =3D <&pinctrl_gem0_default>;
> =20
>  	ethernet_phy: ethernet-phy@7 {
>  		reg =3D <7>;
>  	};
>  };
> =20
> +&gpio0 {
> +	pinctrl-names =3D "default";
> +	pinctrl-0 =3D <&pinctrl_gpio0_default>;

On linux-next the equivalent no longer works for the Parallella, with
gpio failing to probe.

If I move these two properties to the leds node (for which I am
configuring gpio 7) then I get a heartbeat as before.

Regards,
Andreas

> +};
> +
>  &i2c0 {
>  	status =3D "okay";
>  	clock-frequency =3D <400000>;
> +	pinctrl-names =3D "default";
> +	pinctrl-0 =3D <&pinctrl_i2c0_default>;
> =20
>  	i2cswitch@74 {
>  		compatible =3D "nxp,pca9548";
> @@ -132,10 +143,180 @@
>  	};
>  };
> =20
> +&pinctrl0 {
[...]
> +	pinctrl_gpio0_default: gpio0-default {
> +		mux {
> +			function =3D "gpio0";
> +			groups =3D "gpio0_7_grp", "gpio0_8_grp", "gpio0_9_grp",
> +				 "gpio0_10_grp", "gpio0_11_grp", "gpio0_12_grp",
> +				 "gpio0_13_grp", "gpio0_14_grp";
> +		};
> +
> +		conf {
> +			groups =3D "gpio0_7_grp", "gpio0_8_grp", "gpio0_9_grp",
> +				 "gpio0_10_grp", "gpio0_11_grp", "gpio0_12_grp",
> +				 "gpio0_13_grp", "gpio0_14_grp";
> +			slew-rate =3D <0>;
> +			io-standard =3D <1>;
> +		};
> +
> +		conf-pull-up {
> +			pins =3D "MIO9", "MIO10", "MIO11", "MIO12", "MIO13", "MIO14";
> +			bias-pull-up;
> +		};
> +
> +		conf-pull-none {
> +			pins =3D "MIO7", "MIO8";
> +			bias-disable;
> +		};
> +	};
[...]
> +};
> +
>  &sdhci0 {
>  	status =3D "okay";
> +	pinctrl-names =3D "default";
> +	pinctrl-0 =3D <&pinctrl_sdhci0_default>;
>  };
> =20
>  &uart1 {
>  	status =3D "okay";
> +	pinctrl-names =3D "default";
> +	pinctrl-0 =3D <&pinctrl_uart1_default>;
>  };
[dito for zc706]

--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Jennifer Guild, Dilip Upmanyu,=

Graham Norton; HRB 21284 (AG N=C3=BCrnberg)


--GsJqPrllPDqFf9KBORojVe0UiwjkGA44H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUxtRMAAoJEPou0S0+fgE/OzoQAK+nrGpRFOJLfGu8CPjK6rtX
MhiL8uZtasyRC8XJM9kS1r91Dwyqn9TqpdyKItedA+WEzGHiEiSuqZHtJ+2ghycX
TqdUE8kDMMD6Dnpwm8wfS0hc/2tsUM1w6zuA/vva92eMGIFc5kxAb59TjUOTWQJ9
luyBI261QTFcKJ458Co7ZzOJ3MTZx3/vKDHL1E+pws9S9rtUVDrfplIB0rhH5gLr
dUL03FpLB5UKvu8Cc0d7A1IBShqWRiKVBbo/8hjA5AwG/TwhRe6ZrybUaj2DYyMK
k40+41Na0hNMYJBMJ6qJZC3jkB4UxD9EDN2rhn2c+juq3gDSQgotyAQi9Mj0ORoA
jUA7guMsxV2dCFI47Bism0Zn1PMIqLcUwJoLWPxkTHgQDl0evjR9V+j5Ou6cpnep
EhmXX3iWYhfM2iHSLnBjC91Tx1HPih16MKyD+F5kL253fuG1kIh1PARw2G8agoR5
XvwfI/fsMYRckP9o/Tgphvv/wfxs91BZA7TSPxA30Vshn7hLu3h44P/eXQVgJCaa
cJDf8V1PyRhKYc5zAGcPC+JOSqHX+UF4EXU3eNIO5guhvLjTcCUT79dXby+sFuDU
gv9Fm2eP0pYSL7vd8i9yRFqfxtlyrEHptPGvAoSHIZ5jPGT7UTmn+MolcoFr0YbC
3j2Le73Pd5IroMo/lZ/a
=dj7v
-----END PGP SIGNATURE-----

--GsJqPrllPDqFf9KBORojVe0UiwjkGA44H--
