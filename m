Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbaEYTmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 15:42:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33528 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751682AbaEYTmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 15:42:43 -0400
Date: Sun, 25 May 2014 20:51:01 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH 04/22] clk: sunxi: move "ahb_sdram" to protected clock
 list
Message-ID: <20140525185101.GQ10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-5-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QVgWX4+QEldMe/r9"
Content-Disposition: inline
In-Reply-To: <1400831485-28576-5-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QVgWX4+QEldMe/r9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 03:51:07PM +0800, Chen-Yu Tsai wrote:
> With sunxi_gates clocks registered with clkdev, we can use the
> protected clocks list to enable the "ahb_sdram" clock, instead
> of looking for it and adding CLK_IGNORE_UNUSED inline in the
> clock setup code.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  drivers/clk/sunxi/clk-sunxi.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index 3e33bc1..b2c6d12 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -870,7 +870,6 @@ static void __init sunxi_gates_clk_setup(struct devic=
e_node *node,
>  	int qty;
>  	int i =3D 0;
>  	int j =3D 0;
> -	int ignore;
> =20
>  	reg =3D of_iomap(node, 0);
> =20
> @@ -891,15 +890,12 @@ static void __init sunxi_gates_clk_setup(struct dev=
ice_node *node,
>  		of_property_read_string_index(node, "clock-output-names",
>  					      j, &clk_name);
> =20
> -		/* No driver claims this clock, but it should remain gated */
> -		ignore =3D !strcmp("ahb_sdram", clk_name) ? CLK_IGNORE_UNUSED : 0;
> -
>  		clk_data->clks[i] =3D clk_register_gate(NULL, clk_name,
> -						      clk_parent, ignore,
> +						      clk_parent, 0,
>  						      reg + 4 * (i/32), i % 32,
>  						      0, &clk_lock);
>  		WARN_ON(IS_ERR(clk_data->clks[i]));
> -		clk_register_clkdev(clks[i], clk_name, NULL);
> +		clk_register_clkdev(clk_data->clks[i], clk_name, NULL);

I'm fine with the change itself, but shouldn't this part of it be in
the patch that actually add this line?

Looks broken to me otherwise.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--QVgWX4+QEldMe/r9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTgjuVAAoJEBx+YmzsjxAgU2AQAJ23NSY+q1M+vKxZawJNTFc8
opSQQHHQieAr/U7cDqnxFdgpVmTZGVai/cWEsCWPuHn6d0d3xhmUABrzZ29kw+A5
4zk7Bvr7q85bS4gGcMF/JXzixyjS4ddzKrRNTHDUooXgMX///CMk01XxEu+jAdbV
8spCUMMq+N5UyGXKGWb6HjEBRLYSXSIqk26BBGYMBn0/wvCQhNxzC/MO8muTf8jw
roA2DC58MKR8JmnmyKkff3TOprRYSl3ZHy5W/bPyf3DHFqN8fLq1M+piyy+GtAXG
YysWY0oYEXOODbfPWCdNHd6n95dXFtsHI1Gt0kvEUswPiJd77o8W5LWVEIX6j+1r
Nfst79IKFGPq//EmCt0Z7H7PRe8JRwt3+KfGzPjw0qliCveoUUAEyMu0LNKMfbyo
q5fKflsYJrqhO6G83XaYaQ6R4OKSxVZm4uTcUrzE59NHInV+74FEiXBkqTQ/bWVk
he9lvPfRTnfpPhiyQkzW8QM3sTsx3qK07vjEdaiSkhJuJ44XX5Hg3ouU5sD1AGGd
2CqkucCN4eGOv/BONsVXk882o808ln+XHe0DlsY/8kFvJf+PQ9jqhUXCpP50Ni9O
iggTOUhxt+2cJMN3/Q6n4pSqxmaDUMSq6ia4g8zACOtZpbyxuUZlS+pllV8HccG6
O/nON6O8xnQugF72Jttp
=mKpx
-----END PGP SIGNATURE-----

--QVgWX4+QEldMe/r9--
