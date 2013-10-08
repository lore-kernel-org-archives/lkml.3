Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3JHNSC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:18:02 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53714 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab3JHNSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:18:00 -0400
Message-ID: <52540604.9000100@ti.com>
Date: Tue, 8 Oct 2013 16:17:56 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: "Kristo, Tero" <t-kristo@ti.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Rounding issue in drivers/clk/clk-divider.c
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="akciE2l5uF1K6J1LGLfltsWehiSlClT3P"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--akciE2l5uF1K6J1LGLfltsWehiSlClT3P
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I'm seeing the following issue on omap3 with dpll4_m4 clock. dpll4_m4's
parent is a PLL set to 864000000 and dpll4_m4 is a divider, handled by
clk-divider.c.

Now, if I call clk_round_rate(dpll4_m4, 143999999), I get 123428571
which is correct. However, if I call clk_round_rate(dpll4_m4,
123428571), I would presume to get the same answer, 123428571, as that
was already "verified" by the previous clk_round_rate() call. However, I
get 108000000.

So, if I have the following code:

rate =3D clk_round_rate(dpll4_m4, 143999999);
/* rate is 123428571 */
clk_set_rate(dpll4_m4, rate);

the resulting rate is 108000000.

 Tomi


--akciE2l5uF1K6J1LGLfltsWehiSlClT3P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSVAYEAAoJEPo9qoy8lh715wYP/A18wh/i2LD69FTFBdQrmgUk
KPz/1U1bW40zBl3fNxHdMNom0f9VaUKx0k7KwUxgMtICMwd6lngVNx/r7rvAA4+2
acm4jwf1B4ZPCk23+/INfhiX12XDPJ9Nb5bmkKbcwQUj7mfMJNrfoIA0wBUPhFAQ
/4TZkHfs/oo/d5rDj+YzsSS6AwqXEqKVRAGzgJVxXGHcnsMiy+6HZyPiHwfVej2V
HoDcsnyps3+HJdSNqVwtA0PnMV/cqMW/l2u9HT81obdipNt7pY8WTBHP7b5mMick
P0LNRyilRWwcdzesrq9mve2RAOTcLlA6Us0evkcm6UPAhFft132zL7K4u1ewdPzh
VbV5x7Pe9ytrOwM3jOEURubKraVN69Dp2gNA1yX7PChyKvT39/Weu9GwxRfG3NYJ
Pf5jHkXyOA5VFnNLZbElLUfA1xbm3V3FyD94eQaNV0F8bRoSgE58/rRbrdb5vZqC
pQ2mhKSjAjpNhJiepDfakLx/agkAbNMnB4Q86jfNiyEqsEB36OG3vK7Ii4AMLGuQ
u87wDBjHJQ7XFVVXMc4cTideOO2d87SvuV+wAS+hFMKzF6V3+z9TjPRXAbYvveC6
ChQdAkMJ0X/+CC3Di2ir9J72w+l4sbzeCoXfjufcCJW2jE537ZjuvhTX3cuE8kG3
RJh6hBGlJE7u6k7DYf4J
=AGoK
-----END PGP SIGNATURE-----

--akciE2l5uF1K6J1LGLfltsWehiSlClT3P--
