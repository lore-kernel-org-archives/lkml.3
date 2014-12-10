Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbaLJOID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:08:03 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:47122 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbaLJOIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:08:00 -0500
Date: Wed, 10 Dec 2014 15:07:53 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Liu Ying <Ying.Liu@freescale.com>
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        p.zabel@pengutronix.de, shawn.guo@linaro.org, kernel@pengutronix.de,
        linux@arm.linux.org.uk, mturquette@linaro.org, airlied@linux.ie
Subject: Re: [PATCH RFC 12/15] ARM: dts: imx6qdl-sabresd: Add support for
 TRULY TFT480800-16-E MIPI DSI panel
Message-ID: <20141210140751.GF23558@ulmo.nvidia.com>
References: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
 <1418200648-32656-13-git-send-email-Ying.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B0nZA57HJSoPbsHY"
Content-Disposition: inline
In-Reply-To: <1418200648-32656-13-git-send-email-Ying.Liu@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B0nZA57HJSoPbsHY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 10, 2014 at 04:37:25PM +0800, Liu Ying wrote:
[...]
> diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
[...]
> +&mipi_dsi {
> +	status = "okay";
> +
> +	panel@0 {
> +		compatible = "himax,hx8369a-dsi";
> +		reg = <0>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_mipi_panel>;
> +		reset-gpios = <&gpio6 11 GPIO_ACTIVE_LOW>;
> +		reset-delay = <120>;
> +		bs2-gpios = <&gpio6 14 GPIO_ACTIVE_HIGH>;
> +		data-lanes = <2>;
> +		panel-width-mm = <45>;
> +		panel-height-mm = <76>;
> +		bs = <10>;
> +		status = "okay";
> +
> +		display-timings {
> +			native-mode = <&timing1>;
> +			timing1: truly-tft480800-16-e {

This is the only place where Truly is mentioned. The panel vendor is
either Truly or it is Himax, it can't be a mix. From this example and
your patch description it seems like Truly is the manufacturer of the
panel, hence the panel compatible should really be:

	compatible = "truly,tft480800-16-e";

That it uses an HX8369A chip internally is really secondary, at least
regarding the binding. If we ever get need to support multiple panels
with the same driver IC the proper solution would be to abstract that
code out into a helper library that is used from the various panel
drivers.

Thierry

--B0nZA57HJSoPbsHY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUiFO3AAoJEN0jrNd/PrOhNVMQAJ7nyeBGoPn6DqBNFXP48D0u
6WICYrBJ/ZufLiIHcYQsaHpZd2yMz3xuSp+FRdGZWMk8fbYflhgu79xAUIz+KAth
vP1ew3b7gcokFfHQMunHGrOPQUSsuVIGBHuqiC6dIxqppmSZWkJIhzNXIGJf66xV
pNqe7Cd3/8v/HhhQUeI3Z47HwTxHMNmO10OLvf5iBatx4GRZy1n5uxu9cE4Dm+RV
xjvuVciqfgqkHhd5Hrd8YXyOv3tJfGjMl5QEdDOCXx/3Afo+zcMwNp/VOHSoWDKp
Ewf6qZtkpnQjDkni5e2gCnhFDQ7k1+rLpkQHOMgtEfXLlppKALTlZDw3s6S00mX2
uJ6YI0a/b/uZiWacOji8YPQNLAaIM36Puf25m1ubng27It2aU3jH3qBxM2yNwqnx
HRpl6dRNx09FXCW2+UOmlrWslhRbm6gsogNwJKeESqG1BorFlih6v72qHiCD9t0Z
TScCCaCVBGs7339lT/eq8IGD/z9bdr6997Crepv7srs5/pKmGo15OhNM7Jkw9rWy
zbFFhDUg6IxbT4Da+OEErRgEvi/zgl24cgSF7iFeVakoOrJPLq6t7GlejP+u+jyM
ZfowlAith9Q6dib8X4o3TPCulvw4BnP8ovn8U9CIxbEfoY5HgoL0atOa0q9qLAvm
hHy1NDzgISH1Zxfn61S9
=Rml8
-----END PGP SIGNATURE-----

--B0nZA57HJSoPbsHY--
