Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaKENeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 08:34:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41421 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbaKENen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 08:34:43 -0500
Date: Wed, 5 Nov 2014 13:34:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20141105133408.GU3729@sirena.org.uk>
References: <1414668415-597-1-git-send-email-mike.looijmans@topic.nl>
 <1415083845-27079-1-git-send-email-mike.looijmans@topic.nl>
 <20141104202638.GZ3815@sirena.org.uk>
 <545A0CEE.2050101@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AonAANj1daC6QcQu"
Content-Disposition: inline
In-Reply-To: <545A0CEE.2050101@topic.nl>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.197.121.157
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] Add ltc3562 voltage regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AonAANj1daC6QcQu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 05, 2014 at 12:41:34PM +0100, Mike Looijmans wrote:
> =EF=BB=BFOn 11/04/2014 09:26 PM, Mark Brown wrote:

> >So, I managed to find a datasheet[1] and this does actually seem to be a
> >standard register map.  It looks like this is a 4x12 register map with
> >the program bytes being essentially register addresses (called sub
> >addresses in the datasheet), two pad bits (normally we'd include these
> >in the data for convenience) and the rest of the bits data.  What am I
> >missing here?

> Things that makes me think it's NOT a register map:
> - You cannot read from the device

That's entirely normal for older devices, on larger process nodes the
extra digital to implement read was expensive enough for people to care
and I believe there were some IP issues with implementing read support.

> - You always have to send a complete command set (two bytes)
> - There is data (the regulator mode) in the address byte

Having to send both a register and a value is the standard thing, and
with older write only devices things frequently weren't full byte
multiples, 7x9 was extremely common.

> - The 'address' is not an index but a bitmask in bits 4..7

That's just a sparse register map, again very common (you'll also often
see holes in the register map due to undocumented registers or with
larger register addresses just to keep the map neat).

> I fail to see the use for regmap here, but if your view on this is "regmap
> or burst" then I'll implement it.

The biggest advantage is that it means that a large proportion of the
code in the driver can be removed and standard implementations in the
core used instead.  In general removing code is good and this means that
if we do things like impement support for enabling and disabling
multiple regulators with a single write then the driver will support
this for free.

--AonAANj1daC6QcQu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWidPAAoJECTWi3JdVIfQxsUH/3ztNU9CfoB4OUQ0MkHDi/cP
GcRRY7y51Ob/MpS58PXJh9Q8arpTR7LqZIEAubyyEBhv/iAvCBkDA93LjQR3K8dm
xk5qpkuYrrvPZFG0nKyT3Cu5jfnIWKcYaerxlU9pr7j6LC1zZKy/L8fPlT3LrZU5
BQfTM8/UgyV678Jm3II0ambE/rlw0sSbIg8Zdl8lmwFHSrPYuJd/b4R7AX1V3DR4
aiaaEccFU8tKyQXFyY2YOXQ5srqRXuD6f4zHfRK7fyopORT7NNGTdVwJnW+O21uq
w2/Q8JuJAq6a1ZE7n8MOFg/Q9L95LC7K8P818JzfodPEyCjYV4yvD4u+z9SjNag=
=xfC+
-----END PGP SIGNATURE-----

--AonAANj1daC6QcQu--
