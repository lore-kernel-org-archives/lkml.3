Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaDOOpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:45:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41116 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750924AbaDOOpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:45:04 -0400
Date: Tue, 15 Apr 2014 16:42:15 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-gpio@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 7/7] ARM: sun7i: cubietruck: enable bluetooth module
Message-ID: <20140415144215.GG3207@lukather>
References: <1397544101-18135-1-git-send-email-wens@csie.org>
 <1397544101-18135-8-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wtrm9ATX0sn6fFKv"
Content-Disposition: inline
In-Reply-To: <1397544101-18135-8-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Wtrm9ATX0sn6fFKv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 15, 2014 at 02:41:41PM +0800, Chen-Yu Tsai wrote:
> The CubieTruck has an AMPAK AP6210 WiFi+Bluetooth module. The Bluetooth
> part is a BCM20710 device connected to UART2 in the A20 SoC.
>=20
> The IC requires a 32.768 KHz low power clock input for proper
> auto-detection of the main clock, and an enable signal via GPIO.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/boot/dts/sun7i-a20-cubietruck.dts | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/d=
ts/sun7i-a20-cubietruck.dts
> index cb25d3c..767c8e1 100644
> --- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
> +++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
> @@ -61,6 +61,13 @@
>  				allwinner,drive =3D <0>;
>  				allwinner,pull =3D <0>;
>  			};
> +
> +			bt_pwr_pin_cubietruck: bt_pwr_pin@0 {
> +				allwinner,pins =3D "PH18";
> +				allwinner,function =3D "gpio_out";
> +				allwinner,drive =3D <0>;
> +				allwinner,pull =3D <0>;
> +			};
>  		};
> =20
>  		uart0: serial@01c28000 {
> @@ -69,6 +76,12 @@
>  			status =3D "okay";
>  		};
> =20
> +		uart2: serial@01c28800 {
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&uart2_pins_a>;
> +			status =3D "okay";
> +		};
> +

Please make this a separate patch.

>  		i2c0: i2c@01c2ac00 {
>  			pinctrl-names =3D "default";
>  			pinctrl-0 =3D <&i2c0_pins_a>;
> @@ -139,4 +152,16 @@
>  	reg_usb2_vbus: usb2-vbus {
>  		status =3D "okay";
>  	};
> +
> +	rfkill_bt {
> +		compatible =3D "rfkill-gpio";
> +		pinctrl-names =3D "default";
> +		pinctrl-0 =3D <&bt_pwr_pin_cubietruck>, <&clk_out_a_pins_a>;
> +		clocks =3D <&clk_out_a>;
> +		clock-frequency =3D <32768>;
> +		gpios =3D <&pio 7 18 0>; /* PH18 */
> +		gpio-names =3D "reset";
> +		rfkill-name =3D "bt";
> +		rfkill-type =3D <2>;
> +	};

Hmmm, I don't think that's actually right.

If you have such a device, then I'd expect it to be represented as a
full device in the DT, probably with one part for the WiFi, one part
for the Bluetooth, and here the definition of the rfkill device that
controls it.

But tying parts of the device to the rfkill that controls it, such as
the clocks, or the frequency it runs at seems just wrong.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Wtrm9ATX0sn6fFKv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTTUVHAAoJEBx+YmzsjxAg6TMP/0G0r2/dNXOxOM8l6eWhk4VH
gQq6tk1gX+Bkb9YfFFWl4GtPcRVD7lTeX6NoVhQtTLGGSctuVaojsOJ6UvIPg3K/
JYTNf2QBk4b0pmzpST+l2pDzbGr+SzByKjL85eKZdZvmbm9LJJit8SxEGVKHFhAz
ztDfUlmotR7nZtculXRkxAow7uNsoRmVWVGWpifVJGtIqqYD+TAaSc+2W7xaLFF8
bRh7Ri0jdtBQeaegVVTm/COEdAGmBH32exW4d0v2edvdDdnKTI/PLzkvk5YI1vhm
6S5Vm/sL644ZeGCH6/9A84zrRoqsceJuGVIxc5BkG2mm88UPh0Nx1mAheO5jvh3A
VjaKT0hNAvDEF7FKRUDbhK+cLPyWpfkc+vDaKJgJtZ6fBlj3nrB4pxHwYbIGGfPv
VCAJSQBhplGYTbERO4S4UHQwMZ74N1RRVDs4mM+2hGrv8wryYkE/FlTX75bd64Py
+HMdcJIOo2xsvF4DmHk0NvKWgkJUT1yAmaCnoWzrbykza/Kwisn4Goj6QQfQJCFT
9New/zkrYOXTy7jTnSRfNFb7ItkaD19MFDR4vLzd416PdJkRX8U5H6OLCqVrUdtj
S67EIjvS/kPOV4QYcyrrpGwGm4Sy+hBEgn82mZmZ6SjVz/ou5aW9uD1PXh2DBoSi
6wvwNOvHBcutEks+WwlF
=071c
-----END PGP SIGNATURE-----

--Wtrm9ATX0sn6fFKv--
