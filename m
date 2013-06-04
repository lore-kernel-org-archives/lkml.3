Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab3FDVCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 17:02:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40093 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3FDVCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 17:02:03 -0400
Date: Tue, 4 Jun 2013 22:01:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20130604210137.GV31367@sirena.org.uk>
References: <1369753080-1929-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1xJJiECQTZ8+YlWm"
Content-Disposition: inline
In-Reply-To: <1369753080-1929-1-git-send-email-srinivas.kandagatla@st.com>
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


--1xJJiECQTZ8+YlWm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 28, 2013 at 03:58:00PM +0100, Srinivas KANDAGATLA wrote:

> +#define REGMAP_FIELD_INIT(regmap, reg, lsb, msb) { 	\
> +				.regmap = regmap, 	\
> +				.reg = reg, 		\
> +				.lsb = lsb, 		\
> +				.msb = msb, 		\
> +			}

Having a macro for this is really odd since macros are generally only
used at compile time but the regmap is only available at runtime and
this...

> +static inline void regmap_field_init(struct regmap_field *field,
> +	struct regmap *regmap,	unsigned int reg,
> +	unsigned int lsb, unsigned int msb)
> +{
> +	field->regmap = regmap;
> +	field->reg = reg;
> +	field->lsb = lsb;
> +	field->msb = msb;
> +}

...is a bit awkward since you can't use it with static data.  I think
either the read/write/modify APIs should be changed to take both the map
and the field as arguments (with the field only containing the bitfield
definitions) or the init function should be something that allocates a
new, runtime only structure from static data.

--1xJJiECQTZ8+YlWm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRrlWoAAoJELSic+t+oim9SDUP/AjLLTu5p8xbpfkzYNKqdHUJ
FgfASm9DFJrPcyCrdAUOpOGAqtFccmKlbqG1lnSM+XcGeP8q7rj9nFhengqhGaAm
uNmTQAaa31PnIs0PjjqLRu2d5rU4cDTSLj2cG4VsGQaElvaYw7Qyx22Zs7xY3Lbc
xctAHuKudy5osWJ10igA+1YZiJhKUw/IN2Pam2og8ql6v6mA5mBQwz+mBpXsJ4nB
lAeZu3H11QMXOzLFFl8VQ3ZSnAy3jb1sD1+JEjdwGmCeFdGEye98wCyBTzIzc/ph
hgRNes3w2TFFs2QInZQny2rmbqEL7JBM5XncBTAZl4KTQq/ih7KjLBDVLNJt8EOl
WmtEXBKvz1y/7VxhOK/PfjEk53inh60d6Tyy1k5pOPo9adZDWvgSpPXN9werTReY
XlQXx2/MoJh3ZvcHM+BSUeSMeA9fVzwHB7aIYzGEJITBzYKxgB3vX5437oOIpKlF
Fcr76FdKNH1PbpTakO24NyeVRwGGu6jpEGB6Dv7+dnTaF2NdCRXYepkVZwAd+Yhz
yzNK0yWOl8vHqj/rsWTmb8vc9AC6artOgqW52mgpB8XgRyX2VHebDT16u9ASrk3R
scocQXcpJdHi3XuN3ObLwuNMowlDNwxwP/UYObFBMIppqcZiy2J20uJW6pCZJSH4
SPYF+X2VhK1nUiNh6HBO
=TGmk
-----END PGP SIGNATURE-----

--1xJJiECQTZ8+YlWm--
