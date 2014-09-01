Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaIAMG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:06:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44562 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaIAMGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:06:25 -0400
Date: Mon, 1 Sep 2014 13:06:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
Cc: Dirk Behme <dirk.behme@de.bosch.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Gokulkrishnan Nagarajan <Gokulkrishnan.Nagarajan@in.bosch.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Message-ID: <20140901120602.GT29327@sirena.org.uk>
References: <1409336356-27682-1-git-send-email-dmitry_eremin@mentor.com>
 <20140829190129.GZ29327@sirena.org.uk>
 <5404246E.4090908@de.bosch.com>
 <20140901101512.GK29327@sirena.org.uk>
 <54045FA6.70602@mentor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wKbYzd8t8rt1PVqr"
Content-Disposition: inline
In-Reply-To: <54045FA6.70602@mentor.com>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: GPIO #0 is a valid GPIO
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wKbYzd8t8rt1PVqr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 01, 2014 at 03:59:34PM +0400, Dmitry Eremin-Solenikov wrote:
> On 09/01/2014 02:15 PM, Mark Brown wrote:

> >There's no practical way to deploy that without breaking users - as soon
> >as you treat 0 as a valid GPIO you make all existing users relying on
> >the natural behaviour of treating 0 as default instantly buggy which is
> >not practical.  Really the GPIO API is badly specified here.

> Back in the time before DTS conversion started, the 0 was a correct GPIO
> number. If somebody wanted to specify that no gpio is provided, he provided
> -1 as an invalid number. I have the feeling that allowing users to use 0 as
> 'no gpio' is a mistake. Or the API should be changed
> to disallow GPIO 0 to exist at all.

Please consider my point about making users instantly buggy - it's not
practical to introduce a new field into existing platform data which
needs initialization.  Disallowing the use of 0 as a GPIO seems more
practical here (in that it's something the platform can control with
more reliable coordination).

--wKbYzd8t8rt1PVqr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBGEnAAoJELSic+t+oim9O18P/RyfbP6ZNwFMZfDLz319s9a3
mkvygsjPKJawDBWYLAZrnhYzM1n9wAUJ95fdf8/RkCM3Sd0XiJEorJu2sgCJXb1y
4RnPBGixpmaRVZlzNZaGUhE5bqYeUzheYTY6ii8YeBPApm+qa8YTYpbgWjcOjgBL
iniADKzuWBQ89jvMmpxWhu0OAWKijJXpbvKEPxpJXDTF+DnhUNBjWcx8Y++v/De9
PH2JI5WnB+JlqNFMdxf0Ee39xXiBRepDvFdqIfWqeuBSw0k7cz0pecaKupUSoTiv
Afc9lLE6Bp232u3EvLTJpwQKKdSleTlDiczsC6ZmDqsrbkNcMl5QIXdFpFYHCW/w
BzBj8v+DFvtnTHze9qxmTJG+WqZ0FSGAEAvhPcmyEo+w5s5JZwAfQVwyU4qj348v
Rrm5qLf3tLa7kKO+Bysg1XZNAIESYDoyROb5dWtYm9tIElnhKDuDOp0kEgopIo3I
H50e14CRDAfxhxcSodU5RTSTR0EIYVc1khXQPeLQF/wSWCZQM7pf35oi+nPnIDnp
7GmtBLR9mUBSjKw/ieRs1+GXYGmZgWfDomCAEtAoQF8q4oLEmoP1iyniu7L5bIgQ
viS7SriAmPC1YH/3FmhxIm944HR2u4KEV8xt45bF3g/7jaXT1/+mI0dEFg58Lruh
j/llOqev25bJRmN5odbR
=Crtp
-----END PGP SIGNATURE-----

--wKbYzd8t8rt1PVqr--
