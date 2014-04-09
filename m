Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933874AbaDIPKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:10:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33327 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933544AbaDIPKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:10:42 -0400
Date: Wed, 9 Apr 2014 17:08:46 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/15] ARM: sunxi: dt: define A31's APB0 clk gates node
Message-ID: <20140409150846.GG28585@lukather>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397051478-4113-8-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m0vRWufqUC70IDnR"
Content-Disposition: inline
In-Reply-To: <1397051478-4113-8-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m0vRWufqUC70IDnR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 09, 2014 at 03:51:10PM +0200, Boris BREZILLON wrote:
> Define the APB0 clk gates controlled by the PRCM (Power/Reset/Clock
> Management) block.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  arch/arm/boot/dts/sun6i-a31.dtsi | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a=
31.dtsi
> index 3858424..61e8b34 100644
> --- a/arch/arm/boot/dts/sun6i-a31.dtsi
> +++ b/arch/arm/boot/dts/sun6i-a31.dtsi
> @@ -141,6 +141,16 @@
>  					"ahb1_drc0", "ahb1_drc1";
>  		};
> =20
> +		apb0_gates: apb0_gates@01f01428 {

The node name should reflect the class of the device, so it should be
clk@<address>.

> +			#clock-cells =3D <1>;
> +			compatible =3D "allwinner,sun6i-a31-apb0-gates-clk";
> +			reg =3D <0x01f01428 0x4>;
> +			clock-output-names =3D "apb0_pio", "apb0_ir",
> +					"apb0_timer01", "apb0_p2wi",
> +					"apb0_uart", "apb0_1wire",
> +					"apb0_i2c";
> +		};
> +

Hmmm, I'm not really fond of this.

There's already a PRCM node in the DT, which is used for the SMP
bringup.

I really don't want any duplicate memory regions in the DT, so you'll
have to fix the SMP code.

That being said, I can understand that you did this to be consistent
with the scheme we have for the clock controller where we chose to
make every clock a single driver.

That worked well for the CCU precisely because we only had clocks. It
doesn't for the PRCM because it's not been very well documented, and
it does clocks, resets, that fits pretty well in the existing
frameworks we have, but the SMP related functions are actually not
fitting that well.

It's mostly a power clamp and a power gating bits, that could maybe
fit in the regulator framework.

I don't really have a solution for this. Maybe someone else will.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--m0vRWufqUC70IDnR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTRWJ9AAoJEBx+YmzsjxAg64gP/ioTdHhaimPXU5XYz4EYBfJw
wVcxjK+dkd1aJ8tcQT9V8BbBcCOe5ctFehFglCZme1ZWNcyYOFTaoqOUuSKAI884
bw+B9gFTglpymCXp0DmviiJCweJcZa+qWJ+0nduTbRaQUZO5N9/eg7hTcFG7ZWuR
vWUnQEnEzABPcbaKEaNvMu3nL5dbYYHRnifAv0P2QkaJmUVVho2mKX79T+DnZCnt
/5SQqcL4nRe7guqKCA046RgeBd2RpRswth8XxMViug9CG0cT0m0sfVX1Z1fwWq5r
/bz9LYHfNZ/I6W6PEwYNQeeLqmxB8ru2VFiXAUlUU7/ADa4GojSyOo8Mw8rBDGrj
h1M0QsgHer8gRT0to4P0IBbSAZg/8V3LndO/YLItNz5qRb/i2TTvFSMU+PmneKIb
tMcTSG2m6xbDA4B8Sl2ORYLCswusmVAjr0KpT95H5kwTsuHlpTtZlE1Ln9WNDYAy
aOfinPXkTgkrk494c54qBStNdN61uC0uApEI8hPxxy0Y1pRyOuuaaNVRI42Whg72
3kWS6YRBMQVdT92F7dSBFNQJVqwH3Xz3yBhJanYaacmPYQ01Q/PKj1eGCjQkz2v/
ud7BkEFOjteqrVdhzl2tBgyTsyAbhZa57eAu+UcuQCjlEwWEvh1up9/5EcRZe/bK
AyuETFEtk4J/ushM4131
=xBPG
-----END PGP SIGNATURE-----

--m0vRWufqUC70IDnR--
