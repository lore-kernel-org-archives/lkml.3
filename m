Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3JHP2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:28:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59960 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414Ab3JHP2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:28:31 -0400
Date: Tue, 8 Oct 2013 10:27:44 -0500
From: Felipe Balbi <balbi@ti.com>
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, James Hogan <james.hogan@imgtec.com>,
        Luciano Coelho <luca@coelho.fi>
Subject: Re: [RFC] clk: add flags to distinguish xtal clocks
Message-ID: <20131008152743.GB13128@radagast>
Reply-To: <balbi@ti.com>
References: <1372971912-10877-1-git-send-email-coelho@ti.com>
 <20130704222538.10823.2559@quantum>
 <1372977465.21065.136.camel@cumari.coelho.fi>
 <20130704231953.10823.94331@quantum>
 <1373010853.21065.159.camel@cumari.coelho.fi>
 <1375105842.20048.18.camel@cumari.coelho.fi>
 <20131007074424.7445.52119@quantum>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <20131007074424.7445.52119@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Fixing Luca's address since he left TI

On Mon, Oct 07, 2013 at 12:44:24AM -0700, Mike Turquette wrote:
> Quoting Luciano Coelho (2013-07-29 06:50:42)
> > Hi Mike,
> >=20
> > On Fri, 2013-07-05 at 10:54 +0300, Luciano Coelho wrote:
> > > On Thu, 2013-07-04 at 16:19 -0700, Mike Turquette wrote:
> > > > Quoting Luciano Coelho (2013-07-04 15:37:45)
> > > > > On Thu, 2013-07-04 at 15:25 -0700, Mike Turquette wrote:
> > > > > > Or is it the same clock input and basically the problem is that=
 you need
> > > > > > to know what kind of waveform to expect (e.g. square versus sin=
e)?
> > > > >=20
> > > > > It's the same clock input in the chip's perspective.  One clock i=
nput
> > > > > that can be any of the combinations I mentioned above.  Again, I'=
m not
> > > > > familiar with clocks, so I guess the square vs. sine explanation =
is
> > > > > plausible.  What I could see in the firmware is that it handles t=
he
> > > > > clocks differently if they're xtal or not.
> > > >=20
> > > > OMAP has a similar thing where sys_clkin (the fast reference clock =
for
> > > > the chip) can be 19.2, 26, 38.4, etc. This is easy to handle since =
only
> > > > the rates matter.
> > >=20
> > > Right, this part is easy and I already have the code for that.  What =
I'm
> > > missing is a way to pass this XTAL flag to the chip.
> > >=20
> > >=20
> > > > In your case you need some extra metadata to know what to do. I'm r=
eally
> > > > not sure if CLK_IS_TYPE_XTAL is the most useful form this metadata =
can
> > > > take. It would be best to know if the waveform is what you really n=
eed
> > > > to know, or perhaps something else. For instance you might be affec=
ted
> > > > by some clock signal stabilization time. Can you talk to your hardw=
are
> > > > guys and figure it out? I'd rather model the actual needs instead of
> > > > just tossing a flag in there.
> > >=20
> > > I get your point.  I have tried to investigate how this flag is used =
by
> > > the firmware and I could see that it is used to set different "buffer
> > > gains" and "delays" when waking up (I guess this means when the clock=
 is
> > > starting, so probably related to stabilization time).  They specify t=
wo
> > > "modes", "boost" and "normal" and use different delay values for each.
> >=20
> > I tried but I couldn't find any more information on how exactly this
> > works.  But since this change is really simple and there seems to be
> > other people who need the same information, couldn't we add it as is and
> > try to figure out more specific information about the clocks later on?
> >=20
> > Even if XTAL is not that useful if we know the other details, at least
> > it wouldn't hurt to have the flag there anyway.
>=20
> Luca,
>=20
> By any chance did you come to a different solution for this problem? I
> can take the patch, but I do not feel like we're solving the right
> problem the right way.
>=20
> If not I will take it for 3.13.
>=20
> Regards,
> Mike
>=20
> >=20
> > --
> > Cheers,
> > Luca.

--=20
balbi

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSVCRvAAoJEIaOsuA1yqREKRcP/R/JrJFcKGQsDBJK2Rd3VIPg
pTjbKyGCoHJ+eUs1znFOHQ429Ct4Ci1Cox+Y4PvjRlE8qWlZAzxewUiByPpp+mr6
7KVVfdcH8dKlZmUvMAI0nminaKZCfjMyVnHYIwSV/Uui0AgBx9D7q+QF5R0q/PaG
UJ8Q9mR8eq1Gp3RXy3t/txtsLWsfIK8WmnPGw0rXl4w/Fyq1gus60VsTH0phq8i4
/cRPI0+VaRYHKxaOoJFsXB1GzZItfGyGcG9snVlR6HYABgzHMAk+4hIHFeTJLXtz
IZhx5Szvl5DzZOJMjih+8ac9ymRGEIEr3HJdWZevjQrA92NvT9UBXzQW5TwIv0tj
SBZznxssewmps5A7NCwi6NPPdYd7+wtvqlMMeHtRIEDLJGtJtRctzkLOiZwaUlIv
dRVR4j3Atmp5fS9j5rF/CjsuI+WtPmLFxL1U+mAMkRWK71gu8ndczsX4+TPMg/Lq
vYm6FQ529Fs9s2jeOWId0y8gNuUZ58TGIVTq+VcOQMPhAFmFD3N7wlo/6P0qhzfH
NiTUnlgVFJugONuT8aot5CC7MrXavOtK7eYsvHCGgUG46ci+0OBBP53DcFo5mctK
i4Qev1aqJV1VzVekwU0SuwugBhNX7KBkpeLc7aLC1o68Q56p88Pfyd+Kf8O46HfU
sXHI5aeKsWXM/juGyMNk
=kJqK
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
