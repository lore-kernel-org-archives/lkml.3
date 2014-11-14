Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaKNIkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:40:05 -0500
Received: from down.free-electrons.com ([37.187.137.238]:60866 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754622AbaKNIkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:40:04 -0500
Date: Fri, 14 Nov 2014 09:39:17 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 1/6] clk: sunxi: Add support for sun9i a80 usb clocks and
 resets
Message-ID: <20141114083917.GT20972@lukather>
References: <1415074039-16590-1-git-send-email-wens@csie.org>
 <1415074039-16590-2-git-send-email-wens@csie.org>
 <20141104165733.GI26729@lukather>
 <CAGb2v65VojZVEijdjXYGkMud7dMFzMzagfN=_4S3msZygu3YPQ@mail.gmail.com>
 <20141105100912.GD27686@lukather>
 <CAGb2v64RT4PKTji2KfDTFfc8b_kiTk0Vh49nEE9ZJukum7h2_Q@mail.gmail.com>
 <20141106085424.GF2989@lukather>
 <CAGb2v66Riu43PEzR2vLbg9r_WvZDLvxWtwAc3z43FkF57O2ksg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cUjMc5fB5G+GsIM6"
Content-Disposition: inline
In-Reply-To: <CAGb2v66Riu43PEzR2vLbg9r_WvZDLvxWtwAc3z43FkF57O2ksg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cUjMc5fB5G+GsIM6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Sorry for the belated answer.

On Thu, Nov 06, 2014 at 05:19:24PM +0800, Chen-Yu Tsai wrote:
> On Thu, Nov 6, 2014 at 4:54 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Thu, Nov 06, 2014 at 10:09:27AM +0800, Chen-Yu Tsai wrote:
> >> >> >> +static void __init sun9i_a80_usb_mod_setup(struct device_node *=
node)
> >> >> >> +{
> >> >> >> +     /* AHB1 gate must be enabled to access registers */
> >> >> >> +     struct clk *ahb =3D of_clk_get(node, 0);
> >> >> >> +
> >> >> >> +     WARN_ON(IS_ERR(ahb));
> >> >> >> +     clk_prepare_enable(ahb);
> >> >> >
> >> >> > Hmmmm. That look off.
> >> >> >
> >> >> > Why do you need the clock to be enabled all the time? Isn't the C=
CF
> >> >> > already taking care of enabling the parent clock whenever it need=
s to
> >> >> > access any register?
> >> >>
> >> >> There are also resets in the same block. That and I couldn't get it
> >> >> working without enabling the clock beforehand.
> >> >
> >> > Ah, right.
> >> >
> >> > What happens if you just enable and disable the clocks in the
> >> > reset_assert and reset_deassert right before and after accessing the
> >> > registers?
> >>
> >> That doesn't work either. I forgot to mention that most of the clock
> >> gates have the peripheral pll as their parent, not the ahb clock gate.
> >
> > Why it doesn't work? The clock needs more time to stabilize? The reset
> > line is set back in reset if the clocks are disabled?
>=20
> Let me clarify, what you proposed will work for the resets.
>=20
> However the clock gates won't work if we use the generic clk-gate driver.
> The problem is most of the gates don't have the ahb gate as their parent,
> but pll4 (peripheral pll). When we enable the clock, the ahb gate isn't
> its parent, and doesn't get enabled as a result. This is especially true
> for the usb phy clocks: all of them use pll4 as their parent.

I'm not sure I get this right. You mean that this USB clock needs
*both* pll4 and its AHB gates to be enabled in order to run properly?

Or that the PHY needs its AHB gate to be enabled?

Both ways, I still don't think it's the right thing to do.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--cUjMc5fB5G+GsIM6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUZb+1AAoJEBx+YmzsjxAgkmcQALrS+eHQUxXB3ILNiTDRYoSl
86As1lvTai80v0vfGK9BLJywguFTUTnqoaUSVEz3x8lW8QOFvTPyDEcHb+6ThJ5j
1T4UB36atpbrw978GpdnaXVDt/xkANXmFUhCKwOIylU5da5EULfHpv6TT3X8BYN/
hJLycEIG+Oe1RirAWSJSi4qX704XOVtFaD6H0GEJeXDyIxeobAdia3BpMAM9Eqc0
OEPpKztXYXTwaPl8jU1MxllJWNI4gdr7neAuNIhsoCTtjzRO9kPkmuEk4jiHUdkr
UJ4+WurOn0Uk2Srfw/9qMLW6QaiXToLneie9ap3voEqESDjm1QpBsvsomoqOV6f1
8tVy59XU1MG5MKVvZyWtjTNIb6EzumTmr/oKRbJL+orv0Dkm8k7q2373PEJXznnw
1GMT4vPMaV8Z3h63j+bGEUefbO2/U+dW1Q3HTgegJ74fXiEhfZcDQB6wNhv/nOJ+
9BskV8UD0THZjJbEnIuCGyghydEJELLkpuBkqQyw0cM6gpQ06Ou8TdGPUOhbO01+
+0X+EVmbbWFu8s6UrPRLeBlnNkMeOnUkl1hDVKZvRVeCAtWcE84u7xBejSZPwf8L
4yie1DVYKEcG+EQ/pzUzKWy+Roq8DQjEX50lxbtQK5biT+H5iR8oPEA5JTFplN4n
ZZr2WFgi98FSofjC9Fze
=g/Le
-----END PGP SIGNATURE-----

--cUjMc5fB5G+GsIM6--
