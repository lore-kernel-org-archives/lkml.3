Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbaLPL3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 06:29:48 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33163 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLPL3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 06:29:46 -0500
Date: Tue, 16 Dec 2014 11:29:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20141216112928.GN11764@sirena.org.uk>
References: <1418130764-22440-1-git-send-email-mike.looijmans@topic.nl>
 <20141209161420.GJ1934@sirena.org.uk>
 <54873B8E.1060106@topic.nl>
 <20141209184817.GH11764@sirena.org.uk>
 <549008F7.9060206@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P4FumoV6cQve47oF"
Content-Disposition: inline
In-Reply-To: <549008F7.9060206@topic.nl>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] drivers/regulator/core.c: Don't print error on
 EPROBE_DEFER
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P4FumoV6cQve47oF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2014 at 11:27:03AM +0100, Mike Looijmans wrote:
> =EF=BB=BFOn 12/09/2014 07:48 PM, Mark Brown wrote:
> >On Tue, Dec 09, 2014 at 07:12:30PM +0100, Mike Looijmans wrote:

> >>Can we instead at least reduce it to WARN or INFO level then?

> >You appear to have deleted my reply here...  one problem with your
> >suggestion is that it means we have to special case all error handling
> >on probe for deferral which isn't wonderful.

> special casing deferral may not be "wonderful", but it is what currently
> happens in many places, and it's just "the best we can do for now". A
> similar patch for MMC got approval:
> https://lkml.org/lkml/2014/10/27/477

That's just one call site, were all the other places that might see a
probe deferral updated too?

That also looks like a case of the core passing through other errors
rather than a case of primary error reporting - I guess there's a
reasonable case for the core not logging at all here since the drivers
ought to be doing it.

> >>I have to explain over and over again that there's no problem when that
> >>message comes along ten times in a row. And it causes people to overloo=
k the
> >>messages that really are errors.

> >Can we do something with the log message that triggers on probe
> >deferral?  There tends to be a learning curve with probe deferral but
> >the fact that it's generally extremely noisy tends to be useful - I
> >usually point people at that (not just in the context at regulators) and
> >tell them not to worry unless debugging.

> Using "dev_err" is not really "tell them not to worry unless debugging", I
> think that is what "dev_dbg" was meant to do.

Well, then the core probe deferral stuff ought to be less chatty then...

> The only real solution I could come up with here is to replace "return
> -EPROBE_DEFER" with something that stores the current stack, registers the
> resource it requires and jumps back to where the driver probe originated.
> Once the resource is available, the stored stack is resumed and then the
> probe code path can continue as if nothing bad happened. This would also
> deliver excellent diagnostic data in case the resource remains absent. I'=
ve
> built something like this in Python which has a "yield" statement one can
> use for this purpose. It's a bit tougher to do in C I guess. So until the=
n,
> we're stuck with sprinkling "if (ret =3D=3D -EPROBE_DEFER)" code snippets=
 all
> over the place.

There was a proposal the other day for a restrack framework (name might
change in future) which drivers would call in their probe and get a
callback when everything appears.

--P4FumoV6cQve47oF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUkBeYAAoJECTWi3JdVIfQPEkH/2djQAXWup10+Gk9aDJnA7ej
F9WziOje5veP2ON7DTUKrwkYBc6GoXZyT8kGw3CF49KcjK3ezqPF3pK42CsicSXi
Op6SVZbkbMeO4l2t3qpv8GhLjejYnFRZqG6j0PC64q3QNwzMjYjEMVqDyj/RLbH0
s43/GnpVO0qI60UrKymuhm2EMZD4YVbfrIDSdvTB/aJ3AZgzDo8V6YgnWzQT3fwZ
xCAjntJVz4E2x/rEo8bobYn2+ZYqOyGocsdn9j0AZNERsnkN1pUhoffH5skACj+j
OqhJYCTUuT1LInlqjWoodRCLx3EsI6HWiGFEqqBCKSiI0dlchg70qfkaR9J5Bj4=
=2UyL
-----END PGP SIGNATURE-----

--P4FumoV6cQve47oF--
