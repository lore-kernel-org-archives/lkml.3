Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbaD1QKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 12:10:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49910 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751663AbaD1QKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 12:10:47 -0400
Date: Sat, 26 Apr 2014 18:03:51 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>, devicetree@vger.kernel.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        linux-kernel@vger.kernel.org, Jisheng Zhang <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [RFC 2/5] clk: berlin: add berlin clock groups DT bindings
 documentation
Message-ID: <20140426160351.GE24905@lukather>
References: <1398456024-27876-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1398456024-27876-4-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H7BnLk9CMipoMykF"
Content-Disposition: inline
In-Reply-To: <1398456024-27876-4-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H7BnLk9CMipoMykF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2014 at 10:00:21PM +0200, Alexandre Belloni wrote:
> Document the device tree for the clocks sharing a common set of registers
>=20
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
> Cc: devicetree@vger.kernel.org
>  .../devicetree/bindings/clock/berlin-clock.txt     | 29 ++++++++++++++++=
++++++
>  1 file changed, 29 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/clock/berlin-clock.txt b/D=
ocumentation/devicetree/bindings/clock/berlin-clock.txt
> index 49bc229827a0..6d374066d6b9 100644
> --- a/Documentation/devicetree/bindings/clock/berlin-clock.txt
> +++ b/Documentation/devicetree/bindings/clock/berlin-clock.txt
> @@ -11,10 +11,18 @@ Required properties:
>  		CPU PLL and System PLL
>  	"marvell,berlin2-clk":
>  		simple clocks
> +	"marvell,berlin2-clkgrp":
> +		clocks sharing a common set of registers
>  - reg: Address and length of the clock register set.

Judging from your code, you expect two arrays in reg. You should
document it and in which order you expect them.

Also, you'd probably want to use reg-names, which is much more
flexible from a DT point of view.

>  - #clock-cells: from common clock binding; shall be set to 0.
>  - clocks: from common clock binding
> =20
> +For the clock groups:
> +- marvell,clk-switch-offset: offset in bits to the first bit related to =
the
> +  clock in the switch registers
> +- marvell,clk-select-offset: offset in bits to the first bit related to =
the
> +  clock in the selection registers.

Encoding bit offsets and/or register addresses in the DT is usually a
bad idea. You should more likely use different compatibles here.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--H7BnLk9CMipoMykF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTW9jnAAoJEBx+YmzsjxAglUEQAIH2QZBbqyPjhjuFNOgm7gmy
aeIelJqKXmr8lKUhtys5DCzjjthno4qOzF6T+0mqRZm61f1Sr7bVc3watTCgQ4bJ
jlMaPK0//SQxFR+4R3Wy8a63tT2vVBv2ldwQaixeBoFjzoc3PcQymjfNQ/K2uw1l
oh+tsX4w2u3PZ3PRNXf/babtUTnsjm1t/Lt5ywGgzS8IKk6L8I1A5Ue+RngBCmWQ
MuRASO9JfoQqr9aMdvoCiMTZ9OJD5hfPfW2w/QJfPzxTsxOsdKszPezbuvKF+keQ
2HjcmPV6W+Pp60EhmAjKzaoCoEIZmBL6yRllH3pZt+5iVkfygP92RyHl8B9xL/NG
FeelNeyYyi852K2H46V+frnW8+JNM8IzAR9GGFWZwSaSqQ3+5f1ZRShLyvV3XWZ1
cXekUosXJU5LagNqTrGI4lp5GswQ4HVKxd+pVNRAHED7WH3CewqwFBrZDw2zW/Qh
huQUG19W9WUrvXfA+cPzjju3k4qU4hBg6mptBQsMdz5+4tRtGV0l5Odw3aov7Lfh
fwdjd8+NQOC0RVk/jhAcIKF+rSB+FhpxUa7ZxDYy/cI2ExR0k7Gm8sXKyXARWWdI
81w2BDcukECCu/uuq22RF5Fr+wHaHVIr6nnfS2haTIv+5g0m69ghkr/cO43Wy1l2
TyfDNSxR+S1ynufOFNaG
=MGCX
-----END PGP SIGNATURE-----

--H7BnLk9CMipoMykF--
