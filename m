Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227Ab3EWPOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:14:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39200 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758788Ab3EWPOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:14:52 -0400
Date: Thu, 23 May 2013 10:14:20 -0500
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Davide Ciminaghi <ciminaghi@gnudd.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Message-ID: <20130523151420.GA6406@sirena.org.uk>
References: <1369314377-22873-1-git-send-email-lars@metafoo.de>
 <1369314377-22873-2-git-send-email-lars@metafoo.de>
 <20130523140503.GD2412@sirena.org.uk>
 <519E25AB.4060406@metafoo.de>
 <20130523143137.GH2412@sirena.org.uk>
 <519E2985.8000704@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <519E2985.8000704@metafoo.de>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regmap: Make regmap-mmio usable from different
 contexts
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 23, 2013 at 04:36:53PM +0200, Lars-Peter Clausen wrote:
> On 05/23/2013 04:31 PM, Mark Brown wrote:

> > So you'd have to allocate a struct on the stack with a pointer and the
> > flags in it and initialise the pointer.  Not awesome but not the end of
> > the world.

> I'm not sure I understand what you mean. This needs to be done for each
> caller of a lock()/unlock() pair. We can't allocate the flags on the stack
> inside the lock() function since the stack will be gone once the function exits.

Allocate the struct on the stack - if you can allocate flags on the
stack you can allocate the struct on the stack too.  Though I suppose
you still need to change all the callers for this which is just nasty
and makes it seem pointless to bother with abstraction here.

This is all stuff you should've been going through in the changelog when
you're jumping off into something that involves changing every single
user...

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRnjJJAAoJELSic+t+oim9pLMP+wT/7xkcgBBfFzHpatVN2/4i
hr4AIWHw7tagjt/hi39pA+YOtujx1vqvEUpwHh570EiIghVLTaWLpEik7E4CDxJ3
r1SaNQ0qa14/rvHcAUNfVD2vhR7U9p1p5IO7qo8Q/5TEjdsCPJS0kMnZ9nwHUMv5
EcOY2Lg2Mp7YAiZEVOVIT6/F+QuMinnAtm1vxqxUyyMMWY5Y9kEOgSK70ygWfury
ZOIz+hxwyNKwChMQvQgHaR8pTw/YpOBTQpkDC8J0/yHOtIVnk/XWm0eSQT2vyNsY
q9+eGQM6WclZmWShXS6b9GJAuBe8olaD5er43FNfPXOCS6+nJDLiAKW9jJ1DCY2H
R8s2uARoaDmOi+DFDrL4EEyjljFQfM1dneIfJ82hzIXhZyH+1BoXnkbhAg/IKSDR
xoZz+dSUm6HtriL89kLufUo950rsaOgiFoHjwaobpNA+AKf+69aujQpBn6e+Zhdk
MpmLbkGfNkdsuJND6rWoYa7yRe7KNq574Bp+vuVW1jpmbsv1HzvOpPqBJVnN+kCG
8PfGeat5idNpI1UJsQB5kYxetLLaWvo8Ozw1eWp1jSo9KcF9DLK1AfCUPHASuW9U
S8vh3aE/X4MfHIMbAPXL5ST1g+Dg05RV9M1z/h/OIGaz7Mb/t2mPQs1HuBo5oik3
e4j4dm4+vE8EY10lfsv6
=shla
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
