Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3FELmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:42:01 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44875 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab3FELmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:42:00 -0400
Date: Wed, 5 Jun 2013 12:41:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20130605114140.GW31367@sirena.org.uk>
References: <1369753080-1929-1-git-send-email-srinivas.kandagatla@st.com>
 <20130604210137.GV31367@sirena.org.uk>
 <51AF0313.6000205@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrxji9MxLi9YGTOD"
Content-Disposition: inline
In-Reply-To: <51AF0313.6000205@st.com>
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


--yrxji9MxLi9YGTOD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 05, 2013 at 10:21:23AM +0100, Srinivas KANDAGATLA wrote:

> Is it ok if we rename the regmap_field_init function to
> regmap_field_alloc, as it will make it obvious that its allocating
> memory which should be freed?
> I also thought we could add devm version of it as well.

Yes, that's all sensible.

> With this change here is what the init/alloc function would look like:

> static void _regmap_field_init(struct regmap_field *field,
> 		struct regmap *regmap, unsigned int reg,
> 		unsigned int lsb, unsigned int msb)

> struct regmap_field *devm_regmap_field_alloc(struct device *dev,
> 		struct regmap *regmap, unsigned int reg,
> 		unsigned int lsb, unsigned int msb)

I think I'd prefer to see a struct passed in here for the field
definition - this would make it easier to initialise from static data,
otherwise people will end up writing a loop that reads from a locally
defined struct once they get more than a couple of fields.

Otherwise this makes sense.

--yrxji9MxLi9YGTOD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRryPsAAoJELSic+t+oim98AEP/20e3C64bT1qqffhwXw5J8LU
PO7JcCpYfxzVhfH4A0imx6MOb7QlxTyX83EcpydgFXEBOQXOjKZyxIUdDMPmKdq4
DuEbTgME+YCuj5C1GkHW9DHfLDWSVE7MMsC1/F6bBDm6O/ezhAbCTt0OxVxwpmnm
tvSIK38UXeLymnlzc2BzUz1FiKmajnz0KN8IdbGnJLWKrJFMtFbgTwepX8WGiV6e
ZGHw7pCroIYCGXoctzxsi5POFS4pVFfR+m5lCoZPXAvG+p7OzulW7yqrO5HGJmO5
TrJkqPqoXDJmn/YmSMVttgC/CS073ObmZAE0oJFOri26NBiEj1kNZG0uHtKogrDk
1UduCFTdFNCFoRvLu+Jm9YARaW9nyZg1W23uN4rVe8XO3n45o86XtLcgMNWMJloC
/y80ajCFQ2lTFXlNW+4QGNE8K9lgPVw9SwtxiL232AyTCqEEVMxT4f7TEzBaVWgg
CAr7RuuhCrXxa1Q52Wqcy7bSs5iXQFDNoX2IPajV0Mu0ycbLFNrv2nJGHfEvZVpF
7sWz8O3venXXFh9CjIYlDbyDmd1tClp668ssG7HBWLtR0Fa5voFgFMkx2SXOQfRj
VSibCgqE5/iaI452VybCnKdUaW59alPfZlA7WS3zFrV9S4+zOTk1P2HnaW794FwP
9dUvrH/FV6RliOWsk9HD
=HJfc
-----END PGP SIGNATURE-----

--yrxji9MxLi9YGTOD--
