Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632Ab3LJUKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:10:05 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44369 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750960Ab3LJUKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:10:03 -0500
Date: Tue, 10 Dec 2013 21:05:29 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev <netdev@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 01/10] net: stmmac: Enable stmmac main clock when probing
 hardware
Message-ID: <20131210200529.GD3651@lukather>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
 <1386350983-13281-2-git-send-email-wens@csie.org>
 <20131207103335.GL24519@lukather>
 <CAGb2v65YOSq_BMWSzSHX8w_hbo+0vwquBT2pnLuwNVZkWRfLvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qrgsu6vtpU/OV/zm"
Content-Disposition: inline
In-Reply-To: <CAGb2v65YOSq_BMWSzSHX8w_hbo+0vwquBT2pnLuwNVZkWRfLvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qrgsu6vtpU/OV/zm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 09, 2013 at 10:43:29AM +0800, Chen-Yu Tsai wrote:
> >> @@ -2759,15 +2760,18 @@ struct stmmac_priv *stmmac_dvr_probe(struct de=
vice *device,
> >>               }
> >>       }
> >>
> >> +     clk_disable_unprepare(priv->stmmac_clk);
> >> +
> >
> > Hu? Why do you disable the clock? don't you need it afterwards?
>=20
> The clock is enabled in *_open (when the network interface is used),
> and disabled in *_close.

Maybe it is the real issue then.

Why don't you move the clk_disable to _remove then?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Qrgsu6vtpU/OV/zm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSp3QJAAoJEBx+YmzsjxAgCBEQAKY/ZEZloHcDGaHYS0RqXDhM
GKZTcV9duag9I2sSRxbzDXeldJYIOOZ3g5lraAhhu0Qk9JEAUt4+Tw8WjHJcxNIV
shIxhRdGZW4hcoQDiYU3KIt88Bt5rvUrbz3vxWgaKKv9pjQ2b9Qz9AwnAJfosp8z
ufhZ6dqnSHzIhXUx2yyIEuaO1Rb0LKhfGUP8zzFFfKRLmED13ctCUaqc3mUo56+s
TlSQsiWwKZ19tHoGoq3T76TGGb0fiDrMvnlQM6OGmye9EufgEtQW2v6xUSMTmKWG
myOfPxRjRfH7c5nK7L5s0e7e/cZZaepISBjDABa2kXAiY7nlzlrzk4bNMM+NuS65
jugXp1UIPPXqkPUag551JsS0A6dJarplIjwLmOvq8GBK7wFpjDFuYgfivr3o7BSb
UggC9cMwoFv7YsYF4pLwkLkUTAhOsxFht6v6Tfm6Y51AjtxqYWMZr3Llve9F41l7
2hiLygT5y0JplrTmgrSvMcFpOBUDCXkk7+pw5c6/WhDUcLhaNOS+8ioOyzJmW7mX
RAp7GSpkmc+wykNso5z0ACXTXftyG9EKq4sTHnsKJdqu7r1PPEyTOM+4LWMkf+QY
BuElAYHcU2sQsra91+VuQO+Ug66sHmOgCI176p5VeAHClvdw7u2F89QVa+f54Eyr
AmEl1ZSm8vUj9/XcrSK1
=784y
-----END PGP SIGNATURE-----

--Qrgsu6vtpU/OV/zm--
