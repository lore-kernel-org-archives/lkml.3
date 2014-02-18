Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbaBRPpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:45:07 -0500
Received: from top.free-electrons.com ([176.31.233.9]:46345 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755478AbaBRPpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:45:04 -0500
Date: Tue, 18 Feb 2014 16:42:12 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: David =?iso-8859-1?Q?Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>
Cc: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 8/8] ARM: sunxi: Add documentation for driver for
 SD/MMC hosts found on Allwinner sunxi SoCs
Message-ID: <20140218154212.GL3142@lukather>
References: <20140217095907.15040.81893.stgit@pagira.o2s.ch>
 <20140217100302.15040.56273.stgit@pagira.o2s.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DN8g+DOX2TxGxleI"
Content-Disposition: inline
In-Reply-To: <20140217100302.15040.56273.stgit@pagira.o2s.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DN8g+DOX2TxGxleI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 17, 2014 at 11:03:02AM +0100, David Lanzend=F6rfer wrote:
> Signed-off-by: David Lanzend=F6rfer <david.lanzendoerfer@o2s.ch>
> ---
>  .../devicetree/bindings/mmc/sunxi-mmc.txt          |   32 ++++++++++++++=
++++++
>  1 file changed, 32 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mmc/sunxi-mmc.txt
>=20
> diff --git a/Documentation/devicetree/bindings/mmc/sunxi-mmc.txt b/Docume=
ntation/devicetree/bindings/mmc/sunxi-mmc.txt
> new file mode 100644
> index 0000000..5ce8c5e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mmc/sunxi-mmc.txt
> @@ -0,0 +1,32 @@
> +* Allwinner sunxi MMC controller
> +
> +The highspeed MMC host controller on Allwinner SoCs provides an interface
> +for MMC, SD and SDIO types of memory cards.
> +
> +Supported maximum speeds are the ones of the eMMC standard 4.5 as well
> +as the speed of SD standard 3.0.
> +Absolute maximum transfer rate is 200MB/s
> +
> +Required properties:
> +- compatible: Should be "allwinner,<revision>-<chip>-mmc".
> +  The supported chips include a10, a10s, 13, a20 and a31.

Please use the real compatibles here. It's much easier to search
for. Plus, your driver doesn't support all the SoCs you're mentionning here.

> +- base registers are 0x1000 appart, so the base of mmc1
> +  would be 0x01c0f000+0x1000=3D0x01c10000(see example)
> +  and so on.

Please provide the real property name to use. No need for an example
here, you have a full-fledged one in a few lines.

> +- clocks requires the reference at the ahb clock gate
> +  with the correct index (mmc0 -> 8, mmc1 -> 9, and so on)
> +  as well as the reference to the correct mod0 clock.

Ditto. Plus, this is not a mod0 clock.

> +- interrupts requires the correct IRQ line
> +  (mmc0 -> 32, mmc1 -> 33, and so on)

Ditto.

> +
> +Examples:
> +
> +mmc0: mmc@01c0f000 {
> +	compatible =3D "allwinner,sun5i-a13-mmc";
> +	reg =3D <0x01c0f000 0x1000>;
> +	clocks =3D <&ahb_gates 8>, <&mmc0_clk>;
> +	clock-names =3D "ahb", "mod";

You never talked about the clock-names property, and which clocks were
supposed to be provided.

> +	interrupts =3D <0 32 4>;
> +	bus-width =3D <4>;

And you never talked about bus-width either.

> +	status =3D "disabled";
> +};
>=20

Isn't the cd-gpios property requested too?

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--DN8g+DOX2TxGxleI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTA39UAAoJEBx+YmzsjxAgrQoP/1HzFSTgYBFAw1bVtXhU/jtZ
GljPpZDpY/1ME7jQb38kGhD5FB3t392ECFtEryOhvzoif91WQzB5Rd8SHKn58zLZ
vD4zmfAIGiT8x5ifXBVGYAP5TNj9hsG0eKUFQM0tNV+WuUC7L713FkclAR7FlZHX
4GTHvFKIBmdlpUbFBkAzBfcjDkczA/hjOyoxYX6zFV6i1AEy1xpkd9y5C+LqwA7l
rffSqhp1I95S7V1md0UReZmMUVqT4jpgYVLpDWiJ0rf1nBanT0axpF8HNsDYb/zl
PCEj7PteTdgic8q2g2aXnEDshYMhMavf8hrEFIfO0U6hu+Vmj3ei729kM9wl//DO
FrakQUlJq1le838wk0VIiwRicfP4ooWht6a9VtlTSDEZbOHTNfrewhsqMw/bS+wu
8PrNIiwRGgFTmfX220PLDoiQRDf9Cq5tk6NEiOkzE4IPMfWb/FzB6Gvfa/JJneyy
mq/WYY2ucyLXokmUh2hTOqe9Sxt3hgcZgsVCde4T7KleMPfGD1YLvAbXUwlE6Mg0
OuVw+3u2HgR1hTSC44TBXQlCxFKFvBJmKiMmFfNI5pJq7tSFvWWQEtXhfe24lgN+
WsUtpy0GMT6RE1SCNOHVs7PuhcTUvtzAe3pgf6XVLvtRrE4cqHyVVXrFp1PVPydC
cPA2PLr4hDTwfP0O65uO
=l3Jv
-----END PGP SIGNATURE-----

--DN8g+DOX2TxGxleI--
