Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaEGHE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 03:04:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34629 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaEGHE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 03:04:57 -0400
Message-ID: <5369DAC6.6050608@ti.com>
Date: Wed, 7 May 2014 10:03:34 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marek Belisko <marek@goldelico.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <plagnioj@jcrosoft.com>,
        <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-fbdev@vger.kernel.org>,
        <hns@goldelico.com>
Subject: Re: [PATCH v2 2/3] ARM: dts: oma3-gta04: Add display support
References: <1398284120-4986-1-git-send-email-marek@goldelico.com> <1398284120-4986-3-git-send-email-marek@goldelico.com>
In-Reply-To: <1398284120-4986-3-git-send-email-marek@goldelico.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="TA9jFC3xdJ9vTBgTJIH9luDgDtdnihQ8l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TA9jFC3xdJ9vTBgTJIH9luDgDtdnihQ8l
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 23/04/14 23:15, Marek Belisko wrote:
> This patch add support for lcd display on gta04 board. Display control
> is connected on spi (used spi bitbang driver).
>=20
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
>  arch/arm/boot/dts/omap3-gta04.dts | 86 +++++++++++++++++++++++++++++++=
++++++++
>  1 file changed, 86 insertions(+)

<snip>

> +&dss {
> +	pinctrl-names =3D "default";
> +	pinctrl-0 =3D < &dss_dpi_pins >;
> +
> +	status =3D "okay";
> +
> +	vdds_dsi-supply =3D <&vpll2>;
> +
> +	dpi_out: endpoint {
> +               remote-endpoint =3D <&lcd_in>;
> +               data-lines =3D <24>;
> +       };
> +
> +};
>=20

Did you try this on 3.15-rc? The above is not right, and I don't think
it works. You need 'port' node for the dpi_out endpoint.

 Tomi



--TA9jFC3xdJ9vTBgTJIH9luDgDtdnihQ8l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTadrGAAoJEPo9qoy8lh71v68QAI+/7OX3iR/NW7MTleTezIFX
6XTvjUJR3c0afx1CrqpdEBM59E75PwSCtwvwU78kCQswVSwEBRGfTd8g8l9GoUlD
+kLOnVskRen+o1ghoKLF0ICLReSSzGY3bplfLBGTF5zidvDiwHrCeJuCsvzE4vMQ
2Zg1kESfJWoQEAOTS6CmgqFJv6e5d22pyyDrzC9NrJRJITgWRlYDS2Q2K0VI+oV2
GbjhllR1+VQR+3e3YswsHw9kRk2pYvDeyC+ZMWAyfyfJntY8McFXZPP1IUi5oCVU
K4IkP+M7hvKeSSfecyxh9S4GHk8GBztrKWHnvGj94rXpulLwxSzIdSBnXDFYitAJ
F3i05Nq4AohD6oqZ6LJyA8kyzGG+YcjTdNvwHkh5kxttlNGEb2lbYpGTm7OnjBkp
5OVcTOCJUnqNDhV3RsyXSz2QhkeZZP2H7f6Qvc3w3RFwcOUFbWlQIYGcx4mKkRzh
BHbBxa8iywIPVK1rOu03XwMHanqWcaT4XpBt0cAgrbyfAbO6hMxo1+8bPLoCo6bP
uT8WOTWif1i7BMIk8XIbA8lWJZJuw8h9GBmrTHeW56NSTHdkLFGdqzqgiWRyG/UM
jIIBkPmnUDZbgEkjFhvzh4aNTitIrbWudD4Dd5AnXqdN556MlMZQMh4hFPB/bsTM
77e36kPMiAm8dIk7FJ/K
=OElA
-----END PGP SIGNATURE-----

--TA9jFC3xdJ9vTBgTJIH9luDgDtdnihQ8l--
