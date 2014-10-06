Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaJFLBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 07:01:23 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34694 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaJFLBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 07:01:19 -0400
Date: Mon, 6 Oct 2014 13:01:16 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-pwm@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v7 10/11] ARM: at91/dt: add LCD panel description to
 sama5d3xdm.dtsi
Message-ID: <20141006110115.GH25202@ulmo>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
 <1412175188-28278-11-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dx9iWuMxHO1cCoFc"
Content-Disposition: inline
In-Reply-To: <1412175188-28278-11-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dx9iWuMxHO1cCoFc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 01, 2014 at 04:53:07PM +0200, Boris Brezillon wrote:
[...]
> diff --git a/arch/arm/boot/dts/sama5d3xdm.dtsi b/arch/arm/boot/dts/sama5d3xdm.dtsi
[...]
> +	bl_reg: backlight_regulator {
> +		compatible = "regulator-fixed";
> +		regulator-name = "backlight-power-supply";
> +		regulator-min-microvolt = <5000000>;
> +		regulator-max-microvolt = <5000000>;
> +		status = "disabled";
> +	};
> +
> +	panel_reg: panel_regulator {
> +		compatible = "regulator-fixed";
> +		regulator-name = "panel-power-supply";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		status = "disabled";
> +	};
> +
> +	backlight: backlight {
> +		compatible = "pwm-backlight";
> +		pwms = <&hlcdc_pwm 0 50000 0>;
> +		brightness-levels = <0 4 8 16 32 64 128 255>;
> +		default-brightness-level = <6>;
> +		power-supply = <&bl_reg>;
> +		status = "disabled";
> +	};

Why are these all disabled? Patch 11/11 now needs to enable all of them
explicitly for each board that uses this display module.

> +	panel: panel {
> +		compatible = "foxlink,fl500wvr00-a0t", "simple-panel";

"simple-panel" shouldn't be in this list. There's nothing useful a
driver can do by matching on it.

> +		backlight = <&backlight>;
> +		power-supply = <&panel_reg>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		status = "disabled";
> +
> +		port@0 {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			panel_input: endpoint@0 {
> +				reg = <0>;
> +				remote-endpoint = <&hlcdc_panel_output>;
> +			};
>  		};

There's no support for OF graphs in simple-panel, so this is unused,
isn't it?

Thierry

--Dx9iWuMxHO1cCoFc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUMnZ7AAoJEN0jrNd/PrOh7dQQALTxam4ysRj94M0DSSCpPK8u
xAzUFOMBRrJscYVHkyeSUY4RVsvSGnmjR/IY4QcBY1LX2+UnByOWCeMCw2hrhXi9
1OeJMuuGOnubNxN6KOwv1rIZyLeoNZPLuKsUGcL6E/+N4ZYFGuNpklvLdRkCvakn
XMR/TV/+8kVw+/s06IqxAZkYsWU0uKo+N+aonOMzRkiGd0+CaBlQAhzeMJqnnUWX
eOt+W9Ao3g6zbiYTY8mI4oR/HjFYS9JBH0c9SKMVcXVqysEVjQDFqR+JjAorY6BK
r6iTJEf6sNvCFr2QyhRFWCQrtS/RJytkyry5h0+spZw61Q4smzsTIcNl8fP14eo0
6v92i3/oLqwWFa5oFb3JHjGHYcyF4uESZVBcQbn2+M3DipwaoHOdpTK74Xbep/vC
Tv+U1f8GOuey0TwZh/BEWcuz3jqR9VzAIDqRdGPK18n3TrdOkFHXb2A2ZHXGwNvC
pUOBAZaLcJw2ulbF82KiKBxALED5ozZ6wj63fLLKYDvcb30lSpnSylqIZX4iW9jL
qoK8SLiMPvTIx0IVAB/yz4+2/m9byatTqwGjnU1hI5+baxOvQ6/K9gfYYdFV6NYb
UQSvcxRWdCsE3xWHlXYWn+CrQNjI2+lvfA+2WsazCvdAbUSlvx0KQyifIdu4YjfT
YA8CyY24JMyy2f7R0LXh
=7CgZ
-----END PGP SIGNATURE-----

--Dx9iWuMxHO1cCoFc--
