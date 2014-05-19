Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaESQQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:16:08 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33317 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaESQQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:16:06 -0400
Date: Mon, 19 May 2014 17:15:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Message-ID: <20140519161548.GZ12304@sirena.org.uk>
References: <1400483625-29312-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="en/7uzihPWgzh7Vo"
Content-Disposition: inline
In-Reply-To: <1400483625-29312-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: irq: Fix possible ZERO_SIZE_PTR pointer
 dereferencing error.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--en/7uzihPWgzh7Vo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2014 at 03:13:45PM +0800, Xiubo Li wrote:
> Since we cannot make sure the 'chip->num_regs' will always be none zero
> from the users, and then if 'chip->num_regs' equals to zero by mistake
> or other reasons, the kzalloc() will return ZERO_SIZE_PTR, which equals
> to ((void *)16).
>=20
> So this patch fix this with just checking the 'chip->num_regs' before
> calling kzalloc().

Where is the actual dereference that's being protected against here?

> This also sorts the header files in alphabetical order at the same time.

No, don't do things like this.  It just makes things harder to review.

--en/7uzihPWgzh7Vo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTei4xAAoJELSic+t+oim96xYP/0cc1qLl1df8JUABsq/KCEDF
OzV2KMP5PgvXb3RUKZSznvH+ilvjfv258Ee5yLtVnYokpgySbeqOzfLnJMUfUYrk
vz4M/9zQz8G9FwJ2RDh/21NqlIqbgDo+lJluLh4ncZJ7Hjq4Bw78wLTzlYw2AIfA
kD5UHDzjbSzA2ezVjdN+8Ildv/jDIO4xXxRnYzJreeJjI0vMp0YLsBP5KHKat0IK
k7IG5hVUUcFmhMX5+7F7rGSpLrRuBAf2ulc2zKLpVkpQl+nERaw6XRtNa05veglN
uJPi5ADm7Pwj2kkhCiQ3viNRAZNlCVQtQnXzK5dqdOchQ1mb1QlJCXEbtBkH1cTF
euY+4vuRQMLeNDn6QejdUALF1l+iYkTqv8Vw5OjHBqIDNNSp+HnP/LhU2vEGNjKE
p3QPBa3ILO2QHaAwucg96nx+KyCvsYOVCSPJMJ5yiFjloEzGCU7l9zSMCZwkuM9E
i0gG+5Sa2XwJYRv3mtjI5v6kOV746Bv4/O7iG0qhn7HZSPd3O7IWPLIAB2sqZGeQ
Lk5mXQXFKEu3MX+SRK6Pov5hB4uBKXMHwnwYE5l/qWH6EzW6u0hvCvAjoRGyGfaD
pqhCShtLZ1W6tC/SifKryYypUBelEITtATPnr2dWQ8vmaCb83CDlRmpK6L371RN9
dcvQOeOw49w8BJoEMw40
=E5qX
-----END PGP SIGNATURE-----

--en/7uzihPWgzh7Vo--
