Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab3G3W66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 18:58:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43482 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180Ab3G3W64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 18:58:56 -0400
Date: Tue, 30 Jul 2013 23:58:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Richard Genoud <richard.genoud@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Bo Shen <voice.shen@atmel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20130730225845.GB9858@sirena.org.uk>
References: <1375180329-4860-1-git-send-email-richard.genoud@gmail.com>
 <1375180329-4860-3-git-send-email-richard.genoud@gmail.com>
 <51F7FBA8.6080400@wwwdotorg.org>
 <20130730204511.GX9858@sirena.org.uk>
 <51F8302D.406@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sOljI8osNSgTwq0k"
Content-Disposition: inline
In-Reply-To: <51F8302D.406@wwwdotorg.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6 2/8] ASoC: atmel: machine driver for at91sam9x5-wm8731
 boards
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sOljI8osNSgTwq0k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30, 2013 at 03:29:17PM -0600, Stephen Warren wrote:
> On 07/30/2013 02:45 PM, Mark Brown wrote:

> > You really shouldn't do this, it's not accomplishing much.

> What it accomplishes is not polluting the CODEC's binding with a set
> of strings that must always be supported since DT is an ABI. The
> strings are isolated into the specific audio complex binding, which
> might possibly become deprecated and replaced with something better
> and more generic.

You seem to be assuming that the strings are a bad thing.  I'm not sure
that this is the case modulo the tooling issues...

Besides the reality is that we're using strings right now and they're
being baked into bindings right now, I can't see anything being saved by
listing them in the board binding rather than in the CODEC binding since
both are ABIs especially once you get to the second board binding.  The
ship has sailed on that one. =20

All the CODEC binding does is say "there are pins called this", it's up
to some other binding to define how they're used and the CODEC binding
can always add extra information to that list, including a mapping to
integers.

> > The above is going to be legibility challenged without defines at
> > which point the strings end up appearing in the binding document
> > anyway.

> Yes, you'd certainly have to use defines not raw integers. The strings
> wouldn't appear in the binding doc so much as the numbers.

The strings would be there in the text explaining what the numbers mean
- whatever happens the pin names are going to be physically present in
the document, it's just a formatting difference.  The CODEC document
has to list all the pins, we're not going to avoid that by defining a
mapping to integers since adding the integers will in some way end up
defining the names even if just as part of the name of a constant.

We could start adding the integers right now - something like:

	The X CODEC has the following numbered input and output pins:

		1. HPOUTL
		2. HPOUTR
		...

	(see datasheet for details), a header file is provided with
	constants X_PIN_foo for convenience.

would work with either approach to identifying the pins or if we're
being less verbose and just reference the header file for the
definitions that becomes something like:

	The X CODEC has input and output pins listed with numerical
	identifiers in the form the X_PIN_foo defined in the X.h header
	file where foo is the name of the pin.

(that's not good boilerplate wording but you get my drift) which still
ends up defining a set of known strings for pins.

In fact now that I think about this why don't we just go ahead and do
all this, starting by putting the numbers into the bindings for the
CODECs since that's the simplest thing and doesn't involve writing code?
I even have several boards on my desk that run DT ASoC...

--sOljI8osNSgTwq0k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+EUiAAoJELSic+t+oim9S4sP/2eRljQXNmjQrcold3ve3zZI
t5RVJZnOItspiO9EH8rU+QpQGBZ4Ef3GX5uack8mYm956mTX9YdDRIzcMMoOhciZ
RXcttTDHRHexgFHiTgzn/9ManagPYtFi++FzPc5IErqGNF00yVWlWQVZndNiyLfh
I4SAnAPdSK2HJfLy46unSmDenGINCdJDhDo2NJvFDxPZKrOYUKiJ2fVFCohwVhbp
GrS+PQPmFV5yoj6PKL2+XA/WFNU7JiN0sdDkErjCyz2iCjava3W+8D/AFzJj5c84
k4kiz9fLTOL9Ay6ttspmHBxMW4TNZ5yjZ10pP8xG4ZRYELVc3zPi+EQM7TI78UFX
umfFMw89OMXG2Gsa8mKzAclwYCiCATw4TFBXyGpYIShfCr1VVuq0K1UQh7jIJPeF
XJFdNjIcT/TjwCrYFjgwFyrqHfJ2k3utdT/GGpntzYS8SQy6JfbQbHFTCR0aXGTC
IEfUDh7e4KrLKkGjScG893cae/EShmvhxN8XgQ+cwClpvPZ3+qJlxZZrR/2SX/r1
L4WrUEMx/FFCQQC2fy1X7wE73E2WGqtMibN6awPjGACuk5rD8d/rqITtgxpp7JaS
zgQp/MvBRivSEz0w26hPw3AFLZY9UilpGlDOihWzRHQM1DHPIB17sQ2LF+tGrXKT
H6iEKJU3WGbHicJ4Vdm2
=Tqfg
-----END PGP SIGNATURE-----

--sOljI8osNSgTwq0k--
