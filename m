Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150AbaLPJfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:35:08 -0500
Received: from down.free-electrons.com ([37.187.137.238]:33920 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751008AbaLPJfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:35:04 -0500
Date: Tue, 16 Dec 2014 10:32:41 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: VishnuPatekar <vishnupatekar0510@gmail.com>
Cc: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        hdegoede@redhat.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, grant.likely@linaro.org,
        benh@kernel.crashing.org, msalter@redhat.com, ralf@linux-mips.org,
        jdelvare@suse.de
Subject: Re: [PATCHv3 3/5] ARM: sunxi: dts: Add PS2 nodes to dtsi for A10 and
 A20
Message-ID: <20141216093241.GN4337@lukather>
References: <1418408748-9797-1-git-send-email-vishnupatekar0510@gmail.com>
 <1418408748-9797-4-git-send-email-vishnupatekar0510@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wwtQuX191/I956S7"
Content-Disposition: inline
In-Reply-To: <1418408748-9797-4-git-send-email-vishnupatekar0510@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wwtQuX191/I956S7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vishnu,

On Fri, Dec 12, 2014 at 11:55:46PM +0530, VishnuPatekar wrote:
> 1) Fixup the sun4i ps/2 nodes interrupt property, sun4i interrupts take
> only 1 specifier
>=20
> 2) dt bindings should use the compat string for the earliest version of t=
he
> hardware which has the relevant hardware block, unless there are differen=
ces,
> the A10 and A20 ps2 controllers are identical, so for both sun4i-a10-ps2
> should be used as compat string, update the sun7i.dtsi ps2 entries to
> use the sun4i-a10-ps2 compat string.

This shouldn't be a changelog, but what this patch actually does.

> Signed-off-by: VishnuPatekar <vishnupatekar0510@gmail.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  arch/arm/boot/dts/sun4i-a10.dtsi |   17 +++++++++++++++++
>  arch/arm/boot/dts/sun7i-a20.dtsi |   18 ++++++++++++++++++
>  2 files changed, 35 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a=
10.dtsi
> index 7b4099f..ef9a01c 100644
> --- a/arch/arm/boot/dts/sun4i-a10.dtsi
> +++ b/arch/arm/boot/dts/sun4i-a10.dtsi
> @@ -629,6 +629,7 @@
>  				allwinner,drive =3D <0>;
>  				allwinner,pull =3D <0>;
>  			};
> +

This is an uneeded change

>  		};
> =20
>  		timer@01c20c00 {
> @@ -795,5 +796,21 @@
>  			#address-cells =3D <1>;
>  			#size-cells =3D <0>;
>  		};
> +
> +		ps20: ps2@01c2a000 {
> +			compatible =3D "allwinner,sun4i-a10-ps2";
> +			reg =3D <0x01c2a000 0x400>;
> +			interrupts =3D <62>;
> +			clocks =3D <&apb1_gates 6>;
> +			status =3D "disabled";
> +		};
> +
> +		ps21: ps2@01c2a400 {
> +			compatible =3D "allwinner,sun4i-a10-ps2";
> +			reg =3D <0x01c2a400 0x400>;
> +			interrupts =3D <63>;
> +			clocks =3D <&apb1_gates 7>;
> +			status =3D "disabled";
> +		};
>  	};
>  };
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a=
20.dtsi
> index e21ce59..6ab7714 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -866,6 +866,7 @@
>  				    allwinner,drive =3D <0>;
>  				    allwinner,pull =3D <0>;
>  			};
> +

Ditto.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--wwtQuX191/I956S7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUj/w5AAoJEBx+YmzsjxAgtJsQALNM69R96RZTqD95JMB18/uT
ghUxLLq2/rXKRztDrJVmAZZAhBX+WC/YNAYcJGD9RTP0R9emJyyEvQ0Kc9+abNic
0OwbUSzIqBulbAMmapo4JENPxJ7I+oNfKpYEXFCDJawUtWgoh8PVyO5VJuniYvw0
NCRZecZFPwleU61AOVV7OpuDUVOp5d+wDvu3P6ZMyWQf/s0tReu2hkaYIC1lR/Jj
yqPrRLFKyf0sv7ZyMjVHiUsQJYn0haz9hO+MiWoSP+PhUONENdKNIS4fTFVonYF9
0SkNfPAPDn137rv8hr2PquPz+ehsH5s6bPRqUFjKink89KdqvXU4vFWaJ0SAvSBa
8OvSb+f8q7s21yLakLh5LSRDPvLs+bR1aPrfjmlzdilzUQ5mqL3Fv0/f3eBWAMv4
5sCSdqS0A6mFOvNuzP5DHjlqVOuBC0/kDTYPPUid0FNW/iCWXpJXcknrJJVoxqpK
IyDXA+RAvsp1sD0o9brG1WbjwILq0ea2m/lYToHJptwlK/K8qWyX7jwAJ6ST0lLn
GCdDnHeLxU+gMl5kCfT/W6JiT3QDBuapsQorqoAZm94PE9CpZAHJCPb0ZTZqWkB5
DmrkwaAlZf+lbP3pKHkyKlgiwJtNUpeZ+nj6hJT11WoEQ62i1TicgpNEXij4ioQH
zctr44x/4XpAknUp2gnT
=f35W
-----END PGP SIGNATURE-----

--wwtQuX191/I956S7--
