Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbaDKVrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:47:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50755 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbaDKVrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:47:16 -0400
Date: Fri, 11 Apr 2014 22:47:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-spi@vger.kernel.org
Message-ID: <20140411214704.GH28800@sirena.org.uk>
References: <20140411105604.GR6518@sirena.org.uk>
 <CA+55aFxCubywWSLdhAva9dvj26=o4WkaVnhYjgEKrEuMuaFo+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cfJ13FhsvNR/yOpm"
Content-Disposition: inline
In-Reply-To: <CA+55aFxCubywWSLdhAva9dvj26=o4WkaVnhYjgEKrEuMuaFo+g@mail.gmail.com>
X-Cookie: There is a fly on your nose.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [GIT PULL] spi fixes for v3.15
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cfJ13FhsvNR/yOpm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 11, 2014 at 01:41:56PM -0700, Linus Torvalds wrote:
> On Fri, Apr 11, 2014 at 3:56 AM, Mark Brown <broonie@kernel.org> wrote:

> > Same issue as on the regulator pull request with the entire diffstat for
> > the original pull request for this merge window has appeared - like I
> > say I will try to fix the scripts as it's annoying and unclear.

> Yeah, looking at this, the problem does seem to be that extraneous
> merge. I'm not sure why you did that "Merge tag 'spi-v3.15' into
> spi-linus" at all, but it basically acts as an indirect back-merge
> giving you two different merge bases.

Indeed.

> You seem to start your development by doing a merge of that tag that
> you sent me. Why? Why not just start *at* the tag you sent me, not at
> that extraneous merge of that tag and v3.14.

What the script is doing is starting from your latest tag, merging any
tags I've sent you in the meantime and then merging any additional topic
branches.  I'm not doing any actual development on the resulting branch,
only on topic branches.  The tags get merged first to suppress repeated
merges of the same topic branch if I've sent a prior pull request been
tagged yet and I use your latest tag to pick up fixes from other trees
and make sure I'm not tripping over things I sent you before.

Usually this works fine since most of the time either your latest tag
contains the last thing I sent you or my tag contains your most recent
tag and either way there's no back merge.  What's gone wrong this time
around is that I sent you my initial pull requests based off the last
-rc rather than off the release tag, the script didn't cope well with
that and picked the wrong thing to base the merge off.

If I'd respun the merge before I sent the pull requests it'd all be
working as expected, I need to either just do that or teach the script
to be more sensible about picking where it starts building the merge
=66rom.

--cfJ13FhsvNR/yOpm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTSGLVAAoJELSic+t+oim96BYP/3tRpXis5mdPLsTni6gqyTQ7
nclabFkENt78yifOOeudBMVHbEN407/5xibOKTUCx1KFqwRJm6v2xzxbYMF2Y9Oy
/OP3THJrYb5pmORLcbCo696ES8nRLBBkWGehk6WVUCFhbl3h8AQbR3YfWQ6cOKWF
w0p2hyBTxxdRS6AAX47zonBRTWGLkUr5VGmFlIv7FgWnSL3UkFCtBFz5tQXHrgUM
uESicvrFk0OxCXItXmrbTv2dPFbBfWVJU5BI/uFwv20NKDPON3kk/dtmgb/ig/tH
cvHoqf4wuPcZ2QVYuSVkypOHmL67bAw6640fpBTPC6/w7cnxGKZfeL8/O0H9fnqu
sO/9mauyXmdOUYQldFYCU5k0NUsey8Gvj9DXm3GHcbVqgZYbblALVba0Z3oavlpT
a06kth0PX4dXVOcvcnTIQmCU0HcpgBjipvPTmRoNf1V0UdSiQgLZXrRVZ9teLdRx
RhGvlw/DUcPj88vcBWHA38k8anKO+oSsPcqT5IA1+BXprQlARLYVrjTfyLhfWDvZ
8l5+Hhpe2DhALeaJd46/9wu47+PRM0kDk5SYCbGWY3rawmd0cQV5d4oBga03kdnd
7edMTv6x5qdt/An8NlpaUGGWZ5MQcHBplSOcN+4TESE9Agojf3NXrL+C7ScF8AgD
yGa0/m6ie2UAJPj8ODrf
=m7W3
-----END PGP SIGNATURE-----

--cfJ13FhsvNR/yOpm--
