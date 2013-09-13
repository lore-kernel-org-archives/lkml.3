Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab3IMTPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 15:15:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49682 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3IMTPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 15:15:35 -0400
Date: Fri, 13 Sep 2013 20:15:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130913191530.GV29403@sirena.org.uk>
References: <1378065659-18135-1-git-send-email-linus.walleij@linaro.org>
 <20130901201321.GB23687@sirena.org.uk>
 <CACRpkdapBc6pRTTpnM3VWErMyzz1So_50H9_efsxXaEO_JLV7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zBWMTysW9x6NrB/p"
Content-Disposition: inline
In-Reply-To: <CACRpkdapBc6pRTTpnM3VWErMyzz1So_50H9_efsxXaEO_JLV7A@mail.gmail.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] regulator: add STw481x VMMC driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zBWMTysW9x6NrB/p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 13, 2013 at 09:00:08PM +0200, Linus Walleij wrote:
> On Sun, Sep 1, 2013 at 10:13 PM, Mark Brown <broonie@kernel.org> wrote:

> > I can put it on a branch so it can be pulled into arm-soc - it makes
> > life easier for framework refactorings to have the driver in the
> > regulator tree as well.  Would that be OK?

> Sure but then you need patch 1/4 in there as well. I don't know if that

It shouldn't do, the Kconfig dependencies should stop it actually
getting built until the MFD is merged into the same tree I'd expect?
But if it is required then I'm fine with it going via arm-soc only, it's
just easier to avoid mistakes if there's no new drivers in other trees.

> comment pertained to the situation prior to the v3.12 merge window
> though, can I take this in now maybe or is there still a stir in the
> regulator tree?

There's still stuff going on - devm_regulator_register() is the main one
I'm thinking of immediately.

> They are mutally exclusive. You cannot have both at the same
> time. The datasheet says:
>=20
> 0 Internal LDO VMMC is used
> 1 External VMMC is used
>=20
> If it is set to 1, the internal VMMC is disconnected. So it's
> like some internal mux. All designs I've seen use the internal
> regulator though.
>=20
> I move this to probe() and used regulator_enable_regmap()
> instead.

Great, that seems more idiomatic.

--zBWMTysW9x6NrB/p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSM2RPAAoJELSic+t+oim9FPMP/3N6LDq1iCnJowDARf2ZmwR3
5O9FCvH4N/UvhLpqvJXI8YQ6fLlVshkDLibuiptj1DhMqmwuH0tnV7XpTZwRNQXh
4ZRXRKXDZuzPgjplb5F+IhUkcQVeNiw6p242z7mhme//sAXFMF1PmBUM7onXBpDh
JK7i0YUZV9E0k2TljdaZdpah18J/QpKnYHiCqFrUPFzcrUZVbBRV0P2jxictgZrN
DBy082obKPoH28oVMa+9AS9JBPqW9S31KFM13YADVwyOHj5yANYv2VSH518vCpnR
2h38jApo9sDbJGNn5lbE9PU6RFLiKHiWAW7UvFhcFXT33LbzoKVNvpQmJ3OcS+TN
vjygXR6NT6VO1njIeamy03nT/CXdzqO8RJHTNjNKEPZXd+jKBIg2r1+Y7ZyYo/cO
1xQ+ksa1k/5HOxxHRv0oHgi2vzEqoOmWhrG5xAPP+186WLQ0ZYdacn8VP489ZAh4
1jdb/0byppXdAxx5THnDmSPDzUmLgYZqdN60HfJKuDqbU0ueLLC3EhW75dGhhr0E
a6dSJHzoIMa1wzruMd89Enr783bHq/GeLgB7h5lAw2rwqK5V41quLzRjpxYw/xbC
fSaS8X2oPjX2RadhO1hc0R6Epr52YocNiNjZBIuz5eFdVbnYKwhAa26rgZ2M0zUw
fPgAumP1sfW/MpXMGDqQ
=M1bH
-----END PGP SIGNATURE-----

--zBWMTysW9x6NrB/p--
