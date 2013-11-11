Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3KKVAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:00:20 -0500
Received: from top.free-electrons.com ([176.31.233.9]:38306 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751256Ab3KKVAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:00:13 -0500
Date: Mon, 11 Nov 2013 21:59:10 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Luca Coelho <luca@coelho.fi>
Cc: balbi@ti.com, mturquette@linaro.org, james.hogan@imgtec.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: add flags to distinguish xtal clocks
Message-ID: <20131111205910.GA26440@lukather>
References: <1382528150.21526.25.camel@porter.coelho.fi>
 <1383933648-28595-1-git-send-email-balbi@ti.com>
 <20131110113716.GN26440@lukather>
 <20131111194247.GB19212@saruman.home>
 <1384199456.12583.27.camel@porter.coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bMDD5T6Tp9Yu3dvb"
Content-Disposition: inline
In-Reply-To: <1384199456.12583.27.camel@porter.coelho.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bMDD5T6Tp9Yu3dvb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Luca,

On Mon, Nov 11, 2013 at 09:50:56PM +0200, Luca Coelho wrote:
> On Mon, 2013-11-11 at 13:42 -0600, Felipe Balbi wrote:
> > > > +	if (of_property_read_bool(node, "clock-xtal"))
> > > > +		flags |=3D CLK_IS_TYPE_XTAL;
> > > > +
> > >=20
> > > Introducing a new compatible instead of a property would make more
> > > sense here I think.
> > >=20
> > > Do you have a reason not to do so?
> >=20
> > As you can see, this is original work from Luca but I disagree that
> > adding a new compatible makes more sense. This still related to a fixed
> > rate clock, we're just giving it one extra metadata which willAnd t
> > differentiate between crystal and oscilator fixed rate clocks.
>=20
> I agree with Felipe.  This was discussed before [1].  While still at TI,
> I tried to figure out the exact need for the firmware to know whether it
> was an oscillator or not.  It was mostly because the stabilization time
> and such things differ with oscillators, but I wasn't able to find out
> how exactly this affected things.
>=20
> In any case, as I concluded earlier (but it's not really my call), being
> a crystal or an oscillator *is* a characteristic of the hardware,
> regardless of whether that information is useful or not.  In the WiLink
> case it is, at least it can differentiate the clocks that are used in
> the HW modules it uses.
>=20
> So IMHO it doesn't really hurt and it's not really against the DT
> principles.

Just to be clear, I'm not against your patch. If you need this to make
your driver work, then it's fine for me. Mike will probably know
better if we actually need some extra metadata.

What I'm not really convinced about is *how* you carry that metadata
in the DT, that's all, nothing more.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--bMDD5T6Tp9Yu3dvb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSgUUeAAoJEBx+YmzsjxAg+CYP/3c99NW8DUaTbwbzgA9BSnua
xKoNIIU40+llr/eZC+yuf5wGzNPkn6qtjGdA8v3EJblUutA6AsUt0ZxnzgJJciLK
wmG0Owl4zR8Red8lAyxeJEbdL/QEU/eJPfDxMH5nmOb9Hc4UYMrp53juA1cYAhkq
MoPLoAdyGr5FW9sPSwgx3AdwyDjBp79P59z62k4jzO9Ez9XgRYYDTOZT90gWzI2z
VYa3W8hrncpoJ+QKv9apB4+o4qH5xJ4VdnOVZ7cY26svrNAsTgnJCAE5YX5Ruhqg
SIipJ20elMZ1I6yZC5nbCZknl/9jDeXpc2PZTgC0I3dkDG8zHpgPQFnPyCHbmGqo
1Oz+uzB1lmWeqQ65A74diC7/ZiORwwWv1bC6CrUW7kKGrbAjvNNX6yB6F7snoBvX
6KvDx/irFSH4fNzUbE+ZmZxXOrxV36PZaFkkwzHOrcEBKa7tI32DvnqrBscdFlIH
+dskaGtwyuAUDR5GDDdpm0yDer01X2kJHnSrgzn+pEoY4r6UgqRRyGdbSSy62Mc/
k2aD6hjxrXIAtIbXMXzjCWufkN8N1Vujh73rVi0d7lMOz64JDvYNJNUwNkMsi0BS
sgIz9+YRdKxf5EGeZoW14fsYH1w9RyBzf8cZAnimalY8hEa9Bw2Zw6C4c+Fr+9AV
qltzl1Oa45BhsAf3xLcS
=z+GS
-----END PGP SIGNATURE-----

--bMDD5T6Tp9Yu3dvb--
