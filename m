Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3FJJPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:15:46 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57585 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3FJJPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:15:44 -0400
Date: Mon, 10 Jun 2013 10:15:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20130610091539.GG31367@sirena.org.uk>
References: <1369753080-1929-1-git-send-email-srinivas.kandagatla@st.com>
 <51B4A693.4080503@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n5yZ2e1mC2Fd8Xdv"
Content-Disposition: inline
In-Reply-To: <51B4A693.4080503@metafoo.de>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC] regmap: Add regmap_field APIs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n5yZ2e1mC2Fd8Xdv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 09, 2013 at 06:00:19PM +0200, Lars-Peter Clausen wrote:

> > +int regmap_field_write(struct regmap_field *field, unsigned int val)
> > +{
> > +	int field_bits;
> > +	unsigned int reg_mask;
> > +	field_bits = field->msb - field->lsb + 1;
> > +	reg_mask = ((BIT(field_bits) - 1) << field->lsb);
> > +	return regmap_update_bits(field->regmap, field->reg,
> > +				reg_mask, val << field->lsb);

> Considering that you'd do the same calculations over and over again it would
> probably make more sense store the mask rather than the msb in the struct

However as an interface for registering either is OK - the current
MSB/LSB approach is probably better as that's what datasheets tend to
include (which is why I didn't say anything).

--n5yZ2e1mC2Fd8Xdv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRtZk4AAoJELSic+t+oim9XcQP/2ztbs1BmU+Ck6KKizsISkyf
mGUwLS6NNGthpLEITI7wFcQtDUtF1zh19AY16i5SKOhXE9xnmI3/h9jBR7UPQX0E
FhUNAPydXN00r//GbDbQayIyTCCVHLQiQ6E3JWkA96R26UWwuLd3pdteaPYaJlWl
5YN31lcBndO13slxo8HlHErt8qi3FQyPteZhy7/ip///I5Tj9CQ2AGKDA2YQDcRY
qT5JKbPbGlIZCU5H+Wk2pLZQCToWQF46p0FTnBVk/iBP0sPNzBV8Kux+dN5Cxqef
TXdHYsB/rjFyE2wV7Xswf4QPf08QqM4m8bhPyZtObO4gm5535rmoq02ygPA1u7KT
StJUzqUQzab06Ta798YrdaCWn2QYlL0YI6tsK11+dRlRSGtLTr73hwSCPailQhm0
4Y5YMV5+jWLONv/dX9KEi6VbQTtIAaWS8OmWJ7r33kYcRysSuGMXKKagNoDDuuEE
S9PlMu0hzyP2eUDuM+1N8CJ9EKR7nXGiDDS2vRwhXExGVrMVM022Fxrwo3i/MsBD
WCGpeTJ5jH2WLxZT8GJ1h5yF5m4mRdMp5qAHacThkR7Vr1ZGbTPm2mG4h5t3Ycy3
tb5NBURZ9LLCK+3rynFwyLJoNVQnuKhIIMuyjcjKo9sP5XA2PPJCDRbtXvyMNipM
MKDt6fW/NCumAmPkJhnu
=xmcV
-----END PGP SIGNATURE-----

--n5yZ2e1mC2Fd8Xdv--
