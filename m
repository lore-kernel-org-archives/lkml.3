Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab3FZP6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:58:50 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:49480 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab3FZP6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:58:49 -0400
Date: Wed, 26 Jun 2013 17:58:46 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        jimwall@q.com, brian@crystalfontz.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 3/3] ARM: mxs: dt: Add Crystalfontz CFA-10058 device
 tree
Message-ID: <20130626155846.GH5803@lukather>
References: <1372261232-21051-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1372261232-21051-4-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHbokkKX1kTiQeDC"
Content-Disposition: inline
In-Reply-To: <1372261232-21051-4-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHbokkKX1kTiQeDC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexandre,

On Wed, Jun 26, 2013 at 05:40:32PM +0200, Alexandre Belloni wrote:
> From: Brian Lilly <brian@crystalfontz.com>
>=20
> The CFA-10057 is a breakout board for the CFA-10036 that has Ethernet, US=
B and a
> 5" LCD screen on it.
>=20
> Signed-off-by: Brian Lilly <brian@crystalfontz.com>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/boot/dts/Makefile           |   1 +
>  arch/arm/boot/dts/imx28-cfa10058.dts | 158 +++++++++++++++++++++++++++++=
++++++
>  2 files changed, 159 insertions(+)
>  create mode 100644 arch/arm/boot/dts/imx28-cfa10058.dts
>=20
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index d494f37..ddd6f32 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -133,6 +133,7 @@ dtb-$(CONFIG_ARCH_MXS) +=3D imx23-evk.dtb \
>  	imx28-cfa10055.dtb \
>  	imx28-cfa10056.dtb \
>  	imx28-cfa10057.dtb \
> +	imx28-cfa10058.dtb \
>  	imx28-evk.dtb \
>  	imx28-m28evk.dtb \
>  	imx28-sps1.dtb \
> diff --git a/arch/arm/boot/dts/imx28-cfa10058.dts b/arch/arm/boot/dts/imx=
28-cfa10058.dts
> new file mode 100644
> index 0000000..99a21ac
> --- /dev/null
> +++ b/arch/arm/boot/dts/imx28-cfa10058.dts
> @@ -0,0 +1,158 @@
> +/*
> + * Copyright 2013 Crystalfontz America, Inc.
> + * Copyright 2013 Free Electrons
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +/*
> + * The CFA-10058 is an expansion board for the CFA-10036 module, thus we
> + * need to include the CFA-10036 DTS.
> + */
> +/include/ "imx28-cfa10036.dts"
> +
> +/ {
> +	model =3D "Crystalfontz CFA-10058 Board";
> +	compatible =3D "crystalfontz,cfa10058", "crystalfontz,cfa10036", "fsl,i=
mx28";
> +
> +	apb@80000000 {
> +		apbh@80000000 {
> +			pinctrl@80018000 {
> +				pinctrl-names =3D "default", "default";
> +				pinctrl-1 =3D <&hog_pins_cfa10058
> +					&hog_pins_cfa10058_pullup>;

It doesn't compile, this node doesn't exist anymore.

> +				hog_pins_cfa10058: hog-10058@0 {
> +					reg =3D <0>;
> +					fsl,pinmux-ids =3D <
> +						0x0073 /* MX28_PAD_GPMI_D7__GPIO_0_7 */
> +						0x3053 /* MX28_PAD_AUART1_TX__GPIO_3_5 */

Again, we should probably split out these two pins into two different
nodes that would be grabed by their respective drivers.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--xHbokkKX1kTiQeDC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyw+2AAoJEBx+YmzsjxAgEQYQAI64FtotuIUX3qehstr+pBHC
W4UPqBEl99mJ44horo+uR83w1hPeZ1cY7FQuooKm/nJGm8P35KHt/qMHHRtGiC2K
Ohhmz6lLCFMusRRfc0XRofcTPe45vGJ0TdeNP2rCfVrsj/MMiP+SQfJKfctUVD39
BEHY342VYfUzLuAAsHNHQ8wwMHBVyp712Z1bWtD1u/c3pBz3B+0COtDnLoqARTjK
5gdiuDr4J2mNOBLx/aCc0mmvkIr6v+gT2WYokS5aBIK3VJ1vV3kA2T7aCVFYFqUu
BK3sYU4NPRcOVWoj4+HFqAGe7SiWqvECHyjGhEpntQrRJksokfpXWobPesOtf+2D
arx6/gTacLfC0gpS7Qx1SONkrtqrUHqwOy1t6ac++0YGIfOEi1sx//Rx3/GRiDlq
+IyGaVmt8ERsNZk+blJvLyXNNzoMrqFFS4J/URc2EtOLku8m+XSSGrn+D6MDdMam
WF6a2YZqpY3tNaB3l+AEB+sxbR2m7Qf0US56mIP7bZLu7ICTzOHfIe6ZhQP80IGF
t7HIF1mYlSU9mESLdAh/2a4oLOCtC8+wXcNuOA2ABSVvqr6HOvTayN5+zXgxx3zZ
jYwpmfJVs3EpNKvh2E9GVXcNVPWZXthN7RxCGBvsPOczZCZStRQmMxpj55kIadll
Oj81rFuPC+7sFhZj26pE
=muaB
-----END PGP SIGNATURE-----

--xHbokkKX1kTiQeDC--
