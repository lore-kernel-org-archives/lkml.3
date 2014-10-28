Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbaJ1VzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:55:05 -0400
Received: from down.free-electrons.com ([37.187.137.238]:37838 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751602AbaJ1VzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:55:03 -0400
Date: Tue, 28 Oct 2014 22:51:37 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Roman Byshko <rbyshko@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 2/5] ARM: dtsi: sunxi: add common VBUS regulator
Message-ID: <20141028215137.GG9255@lukather>
References: <cover.1414444953.git.rbyshko@gmail.com>
 <210cc2a03d43e3d65b08f302b3b32663044ad94f.1414444953.git.rbyshko@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="reI/iBAAp9kzkmX4"
Content-Disposition: inline
In-Reply-To: <210cc2a03d43e3d65b08f302b3b32663044ad94f.1414444953.git.rbyshko@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--reI/iBAAp9kzkmX4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 10:43:02PM +0100, Roman Byshko wrote:
> Until now the regulator nodes for powering USB VBUS
> existed only for the two host controllers. Now the regulator
> is added for USB OTG too.
> ---
>  arch/arm/boot/dts/sunxi-common-regulators.dtsi | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sunxi-common-regulators.dtsi b/arch/arm/bo=
ot/dts/sunxi-common-regulators.dtsi
> index c9c5b10..f521672 100644
> --- a/arch/arm/boot/dts/sunxi-common-regulators.dtsi
> +++ b/arch/arm/boot/dts/sunxi-common-regulators.dtsi
> @@ -21,6 +21,13 @@
>  				allwinner,pull =3D <0>;
>  			};
> =20
> +			usb0_vbus_pin_a: usb0_vbus_pin@0 {
> +				allwinner,pins =3D "PB9";
> +				allwinner,function =3D "gpio_out";
> +				allwinner,drive =3D <0>;
> +				allwinner,pull =3D <0>;
> +			};
> +
>  			usb1_vbus_pin_a: usb1_vbus_pin@0 {
>  				allwinner,pins =3D "PH6";
>  				allwinner,function =3D "gpio_out";
> @@ -49,6 +56,18 @@
>  		status =3D "disabled";
>  	};
> =20
> +	reg_usb0_vbus: usb0-vbus {
> +		compatible =3D "regulator-fixed";
> +		pinctrl-names =3D "default";
> +		pinctrl-0 =3D <&usb0_vbus_pin_a>;
> +		regulator-name =3D "usb0-vbus";
> +		regulator-min-microvolt =3D <5000000>;
> +		regulator-max-microvolt =3D <5000000>;
> +		enable-active-high;
> +		gpio =3D <&pio 1 9 0>;
> +		status =3D "disabled";
> +	};

We're using these regulators because a huuuge majority of the boards
out there, regardless of their SoC, are using the same GPIO to drive
the same regulator. Is this the case here? What board have you looked
at?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--reI/iBAAp9kzkmX4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUA/pAAoJEBx+YmzsjxAgBFQP/R0/geH9Ku9G/DQlOQ0a8wFN
MwRDpmp49F5QSQuTJv+/4XQJwwvLvAdB9JWAGZ54TLiE7O6i3PepWlqS+BpvFznp
IkPVWe2egZ1dN2tSvhbmIvFeenkJMb99aK4HwmjGOBlpuzOoUxuDng58ZufS49Or
tghCYnVrJ81WhZw3KRQ7/eLHc7Nvl5wt3iKxHljEsiE2wDtnBLwDBIdDeVKsE222
it/cMWHXhC6hTwBEHp0q5ZgAB5/RHnW98xM0REANEUJFesthFEDlZA9fYEPAnLjY
GZsnuW4+YLAA8C4yMWzT+OdHndJtIabb9rOy/1cTi+OUTicMxM+zuxRnVaRlNt8+
n5+Ft/QYcn8FDJG9/2dBqrkfrz9RdscRgMAkai5F/NMg+fEcTKSygFYQiQJNv45c
JBRzt9mnp9bVxwTGk8aIBonS2qE/xWWs2rbprtGCKjv08jJQ1uCsneD+iqQZlDyv
kW8+X9e4z3gQjejHa/FLrBy4wtcAMf0tqoR5Iuq1SZX0ryZWR3BsGmqo405HPXYS
tqpMZ1eB6K7rb2ACd/2CT+Bfy6epyx2Q+31uFrWLFGm+1OazAKSZ8XgBh+ttVh5X
nq8s8gRu66+/OMZwFF9XA63nM3e5pC6RmKz/sx6WObDY0wLjsH3PnGG5SFsM68JZ
Um1RmLCQU1UCxfYjEU17
=dBpE
-----END PGP SIGNATURE-----

--reI/iBAAp9kzkmX4--
