Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab3G2Gkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 02:40:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57393 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab3G2Gkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 02:40:51 -0400
Date: Mon, 29 Jul 2013 07:40:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130729064028.GR9858@sirena.org.uk>
References: <20130729134223.bbae9d9f2a9cd6ca1717c976@canb.auug.org.au>
 <20130729050011.GJ9858@sirena.org.uk>
 <20130729155609.bb9d635427d8eef1da954e3a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P+Tcv3rFao5ReJtX"
Content-Disposition: inline
In-Reply-To: <20130729155609.bb9d635427d8eef1da954e3a@canb.auug.org.au>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the spi tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P+Tcv3rFao5ReJtX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 29, 2013 at 03:56:09PM +1000, Stephen Rothwell wrote:

> Did the 0 day tester find these?  If so, then maybe you should wait a
> while longer before adding these things to your published trees.  If not,
> then I wonder why not.

No, it didn't.  The latency from the zero day tester seems to be quite
variable at the minute - sometimes it's just not reporting things at
all before they get found and fixed otherwise, sometimes it's as
astonishingly prompt as ever and sometimes it's reporting things other
than build issues but not the build issues.

> Even so as a developer, you should not really be submitting patches that
> have not been at least build tested.   You can find out which files are

Right, I don't submit stuff that's not been build tested at all except
in unusual situations - the issues have been coverage and dependency
ones.

> affected by these config changes and then really simply do:
> (assuming an x86 native platform - adjust for cross compiling)

> $ mkdir ../test.obj
> $ make O=../test.obj allmodconfig
> <make sure that the CONFIG options got turned on>
> $ make O=../test.obj <files affected s/.c/.o/>

When I change source files I do take steps to ensure that they've been
built including variations on the above, this specific issue is a fairly
unusual situation.

> You don't need to do full builds to find most of this stuff.  Of course,
> this will not find link time errors or missing module symbols.

Yeah, unfortunately those issues are a good proportion of what gets
caught by this sort of testing that wouldn't get caught in normal
development so it doesn't seem worth doing something that won't at least
give a linking kernel.

--P+Tcv3rFao5ReJtX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9g5YAAoJELSic+t+oim9gJkP/1HU6N1A4pgedndOleE1Vf8G
1lYL/GoxoP4NV7vT0iWHr9iSx1lgiymGI7Qo0/IzX26H3nGirvjhyQ199jrWVHi+
LMEj/O0vZOwFs9z+fR6mKHSGvEZWqw1C4nle90ujxavuJA6yVgsROTWjTD9bnE2O
EvdCxLqNRRFCFSRgIctSRvYWMOJY4fQjPiGu7lgpJXhVbv27nP4AwFH1BWqw29EA
xlkh1RPZTJdXSPBya7DN8glJKdwb63ZNh4ZkfL7eL7WjWPDzsyF4ND2UCuO8tR3q
v3ehcvF31xIzWNdGPgyNuAc39YlZvOOcN8OeqMzlU0HdQ6wBaanQPbjbMzrU0Ihj
yzXQsZafoYRvgI73XWn4vmBzcn46o2yctRWr0n4T+7J3i5tPkk4tRPUjbc770c2+
irKdy5YbEsO14mPQ9tKK+s1UUK89TnzvGh741wKGdvsDef++OzIDxsF3+JDPe8vJ
9sBC/qPdHRdhMTJYwl5xIhOdiVoij35/MM+UE5g9A5+A8jh5UsgXcxezKByDXxKS
bUQegEAReHSPBRXmaOtjiUmTlRuoPrzZT3ni6Nfrw4s+EQ7rrP0dG2253GzbOOH1
Skt8ByJebLG1ico1jSnvRacGFtpb/N8G8Zv32JsqG7nWgDJEWujrvXz2W7bIbMtS
EJX+Rj8dwH79MzsyMcCW
=91TY
-----END PGP SIGNATURE-----

--P+Tcv3rFao5ReJtX--
