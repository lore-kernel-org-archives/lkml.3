Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968003AbaLLORb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 09:17:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56849 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966399AbaLLORa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 09:17:30 -0500
Date: Fri, 12 Dec 2014 14:17:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141212141714.GN11764@sirena.org.uk>
References: <1418162021-32229-1-git-send-email-linux@rasmusvillemoes.dk>
 <20141212132109.GH11764@sirena.org.uk>
 <87h9x10yrk.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OL6cD/Uw4z31vgI6"
Content-Disposition: inline
In-Reply-To: <87h9x10yrk.fsf@rasmusvillemoes.dk>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: soc-dapm: Fix comparison of pointers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OL6cD/Uw4z31vgI6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 12, 2014 at 02:43:27PM +0100, Rasmus Villemoes wrote:
> On Fri, Dec 12 2014, Mark Brown <broonie@kernel.org> wrote:

> > If we're worrying about standards conformance type stuff here this is
> > also buggy since it's out of spec to compare pointers that are not part
> > of the same array like this.  Casting to uintptr_t is a better fix here.

> I'm not worrying about standards conformance. Casting pointers to and
> from [unsigned] long is done everywhere in the kernel, and that's
> fine. But subtracting ints or longs and using the sign of the result for
> comparison is simply wrong. See acbbe6fbb2 (kcmp: fix standard
> comparison bug) for the long story. In this case the narrowing (when
> BITS_PER_LONG==64) of the result from long to int just makes it even
> more wrong.

*sigh*  If that's what you meant you should've said so in your commit
log since that's distinctly non-obvious.  In any case, regardless of why
you originally wanted to do this the fact remains that your new version
is out of spec.

--OL6cD/Uw4z31vgI6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUivjpAAoJECTWi3JdVIfQ8YEH/3Bj06wf2U9O08OxFodtzSvG
gPYm/zfLVtqTaNtr++07kQCtMp70RKVW5a4JLa3I75r5cpoZnC9CHqhbjgUbcQKR
4NrxlRaoqlD1R4BVdPg20Nr0TkKFWuljuoFv07iwHBUnDSeZQs3mFTpTqB9l0KBT
ljjEV2dXRNMNxbdnYp6FODJlknWQC/LYO06qK2Fn5XAVA1r1nE+GoHcDQY1hWBC+
UCqVmGCimG4iCaCXJVWXYke7bLOd4DJEVdANal5c4dPm/U7CLcDVW+ajdVJCGXqm
h9VpacBKqH4aE/SJkEQFZwBDMkgvCHD9pcSZ6QV0rkSq6aQu4zuIAbNVXVskdEY=
=krAJ
-----END PGP SIGNATURE-----

--OL6cD/Uw4z31vgI6--
