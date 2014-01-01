Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaAANAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 08:00:08 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52471 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbaAANAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 08:00:06 -0500
Date: Wed, 1 Jan 2014 12:59:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140101125947.GO31886@sirena.org.uk>
References: <20131212185917.7ed6b21f@armhf>
 <20131231165533.GK31886@sirena.org.uk>
 <20131231184430.3a4c9414@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m9EESf0ERqvzovaD"
Content-Disposition: inline
In-Reply-To: <20131231184430.3a4c9414@armhf>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: make snd_soc_dai_link more symmetrical
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m9EESf0ERqvzovaD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 31, 2013 at 06:44:30PM +0100, Jean-Francois Moine wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > It's possible there is a benefit I'm just not seeing but you'll need to
> > tell me.

> The first benefit I got was in the front-end definition: the codec side
> is the dummy codec, and this one has no phandle.

That's a sign that you're putting Linux implementation details into your
DT - remember, DT is supposed to be implementation neutral.

> Then, finding the CODEC DAI from phandle asks for more code
> (of_xlate_dai_name in the CODEC drivers) and finding it from the CODEC

They should be able to use a default there; I'd expect that just to be
making the IDs the same as the index into the array or the ID field.

> name asks for a double loop in soc_bind_dai_link. On the other way, a
> simple loop without any more change may be used when the DAI is simply
> specified by its name. I would say that the DAI name is more meaningful

Then as soon as anything else starts using the same name for some reason
the binding stops being useful.

> than a DAI index and that it is less subject to internal changes of the
> CODEC driver.

Obviously the numbers that get assigned become a part of the ABI and
can't be changed.  Now that we have preprocessor support for DT the
plain text can be done with that, though for a lot of devices that won't
be needed as the devices are just numbered anyway.

> Eventually, I don't think that, using only the name of the CODEC side
> DAI to identify it, is not more fragile than identifying the CPU side
> of the DAI link by its name.

This doesn't mean it's a good idea to do it - as you will remember I
said I expected things to want to go more towards using phandle plus ID=20
for everything. =20

--m9EESf0ERqvzovaD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSxBFAAAoJELSic+t+oim9l5QP/AmzGDqPf/V4zxev6avOOqmZ
l199Sm6lTBqJnHLBxJVzEtg9Y/3El247Kr+h6oCeHgmTcFdV6qWVYZFF1dR730Lt
vIT65lMZaNMEB1v1+G+zBiuYz1cbbTc12xssjglEDMe17gn42Uf+pBUiRZ/NIS7K
orykzeM2Wz11ALbtXTPVnloUEucZJayZx/B25HSLwhZO7IIlgz9680p7fIt+x9qm
2Qp9zBWUOwbVA5bwbghBdvYuonLoe8OVC6vLHBZOc/15/Pi4h78kCT/V3q0civSG
WVdj7AVPebouMue/w1JZhlW0MfxT0vtelRkX+1at1nM6TA/ZM8V5C+Fi2VfOEiPx
S98ACWVbFyQsBUqEs5+zm4wo58ZmvP6XoSIoJGGw2VpkQDSw9PkeifKOxjiAwOyV
OK0/fX8l1LsUtBzs9GQhcUAgBPw5rnjVVUCwyR0VfAOyXQuB2J4rdpgcM5U1Qddd
GqvUFojdTIApQcKIIricqRuSvDdiTB4Olkg41ZtUKdTqlM/4cYxRZhijXLvkEuTO
Ti+/W2GIEnLhIWodbmUB6HkUTOF4xuelphQyK4cAyqcY0M2eVjmhLOuQdTH4x/W2
5FWL0x0TOQiJxXctgbXWQvb3m0edUQsD/C5cXe2I06gQtITvLQvpbebC9vXF6awh
PF9miUG7pHcLTaPklZJd
=7Kuk
-----END PGP SIGNATURE-----

--m9EESf0ERqvzovaD--
