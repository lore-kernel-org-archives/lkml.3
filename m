Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbaBDUKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:10:01 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35499 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaBDUJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:09:56 -0500
Date: Tue, 4 Feb 2014 20:09:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140204200951.GA22609@sirena.org.uk>
References: <52ED901F.3010002@roeck-us.net>
 <20140203182152.GG22609@sirena.org.uk>
 <20140203222726.GA5053@roeck-us.net>
 <20140204111045.GS22609@sirena.org.uk>
 <52F0F7A6.4070700@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="et24xtwJyFaWkh8+"
Content-Disposition: inline
In-Reply-To: <52F0F7A6.4070700@roeck-us.net>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Would devm_regulator_enable be useful ?
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--et24xtwJyFaWkh8+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 06:22:30AM -0800, Guenter Roeck wrote:
> On 02/04/2014 03:10 AM, Mark Brown wrote:

> >Sort of.  They're there but that doesn't mean that they should be used
> >in normal operation - they should be special cases, not normal things.
> >Managed resources are supposed to for things that are more fire and
> >forget.

> Isn't that a bit philosophical ? The drivers I had in mind commonly
> call regulator_enable() in probe and regulator_disable() in remove.
> Having device managed functions would simplify that code a lot.
> If those same drivers implement pm functions, I don't see a problem
> using devm_ functions in those. Sure, execution complexity is a bit
> higher, but it is not as if pm functions are high volume calls.
> And, after all, the existence of devm_ functions doesn't mean
> that they _have_ to be used.

It's partly about what we're encouraging people to do - if the
frameworks are encouraging people to do things we don't want them to do
that's not great, and if there are things that are normally warning
signs that are getting used normally that's a bit worrying.

For what you're talking about it'd seem better to have the core
automatically drop the reference counts on enabled regulators when the
consumer is destroyed all the time rather than having an explicit devm_
function for it.

--et24xtwJyFaWkh8+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8UkMAAoJELSic+t+oim9jNwP/jfWBiIw5r8hc8Tr3On6cUuz
ut57WJk+KlPgOKFHpYXdQnBuPa9URZzg5KXdJoNmdQm6lb9Q4AHUnK0KE1f1dxcM
P9UH2WVBOcw1+NQZSlWvw/MBstuVdOOs1W68tvK9tmx9S0jUSsOIMpC6m4pRfMCm
DtqpqHrIvNFD7P6wlUt4YuqSv75lFVjzSqpapjqP1tiSSKaExDA7HjyDF3WrWp3X
+vMonSXBUFQYt+9W8koOetNDqTVgWLPw/+NCgN6l5WU8Ctzi9vnD+zEvCI8Xj9nm
BT0s+KuUkaT95l4egNKLp1R4d+IxA1ipQJ97kuRpyFZHYeTFBX5SWdUJUqnPRjdP
H9juDfLmO4iLLNXI9I/ab67uRv21w6c+2lT5HW6xj72t4RYAzt/M/CK7oMHfufr4
j4MaGLktPLLjJgTZ3Do8u489WOuOS5HNkDa12Qz3NuZlZVfmsgrfY5x+ZQcvlmi2
YNMEYoDqCvxynk6naM7i/VJSkGiThocxIvzQTDU8BZ5EIgW4I0iwBmuEbzSXcSOp
PLfGuS0pvjaM62VMBEXSvStzyhZKGdj1vnK3Nwl7m6hvlJvVIziz92TRnsZwtXCZ
JdDKmN6xO+W06/9XRwm8RsfA+oW2kvqE4UIvy8FGotKzxOZ1V+BFWFoHX4yIlzr8
j7VI8HNscFS8wsZ6NI/C
=N9FB
-----END PGP SIGNATURE-----

--et24xtwJyFaWkh8+--
