Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367Ab3LXDhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 22:37:36 -0500
Received: from ring0.de ([91.143.88.219]:54111 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758191Ab3LXDhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 22:37:34 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Tue, 24 Dec 2013 04:37:30 +0100
From: Sebastian Reichel <sre@debian.org>
To: Anton Vorontsov <anton@enomsg.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz
Subject: Re: [PATCH 1/3] power_supply: add power_supply_get_by_phandle
Message-ID: <20131224033729.GA6542@earth.universe>
Mail-Followup-To: Anton Vorontsov <anton@enomsg.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
	linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz
References: <1385311771-447-1-git-send-email-sre@debian.org>
 <1385311771-447-2-git-send-email-sre@debian.org>
 <20131224022035.GA25939@lizard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <20131224022035.GA25939@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 23, 2013 at 06:20:36PM -0800, Anton Vorontsov wrote:
> On Sun, Nov 24, 2013 at 05:49:29PM +0100, Sebastian Reichel wrote:
> > Add method to get power supply by device tree phandle.
> >=20
> > Signed-off-by: Sebastian Reichel <sre@debian.org>
> > ---
> >  drivers/power/power_supply_core.c | 24 ++++++++++++++++++++++++
> >  include/linux/power_supply.h      |  2 ++
> >  2 files changed, 26 insertions(+)
> >=20
> > diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_su=
pply_core.c
> > index 08bce22..99e4b41 100644
> > --- a/drivers/power/power_supply_core.c
> > +++ b/drivers/power/power_supply_core.c
> > @@ -340,6 +340,30 @@ struct power_supply *power_supply_get_by_name(cons=
t char *name)
> ...
> > +
> > +	dev =3D class_find_device(power_supply_class, NULL, power_supply_np,
> > +						power_supply_match_device_node);
> > +
> > +	of_node_put(power_supply_np);
> > +
> > +	return dev ? dev_get_drvdata(dev) : NULL;
> > +}
> > +EXPORT_SYMBOL_GPL(power_supply_get_by_phandle);
>=20
> The code had no !CONFIG_OF protection so I had to make the following
> changes to this patch:

Right. Thanks for queuing.

-- Sebastian

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSuQF5AAoJENju1/PIO/qaqEIP/1mx9Ouf+SlbTb+JU6qTNQhj
2xp1MODlz16YgAijWzPQUvlCa/+k60VCesd0UWUx2k/uMtk7dHgQb6TBN8t72iva
YsvgxKNznHIcTiUEUm/SvFxc8m9dXZ0wOQyO0t7a4pSCbaRTdH0w1a2gYJ7hgrpy
4bWI1HEc8Uxnbo/ZyAYvZGcibM60MO+7ZvrEYXnndsFsEoVVePTmQUTrKJgGK08L
veyjHAuO8vY8qqySc43U+PQi0SvKNgJsnruuh++Pkv6QS6777hx72aPyIU15OeUP
hK+q9jsUgQXTQlO598tRo67JhPXSXZ/MlbtW0PUJ4VrjBRKzVxhQB/O0w2my2t7L
7/XVQy3cKyxa5qLyNomQX3QCp4oPXxuAiQTQzE62rrHAZ6swQnvEncHp6KGgTWra
v6G1TLujXOpx22KHLGDPgKey6V0jZv/9PSAJV7Tv0/r9PI09EnhkPjUbAykwb7cQ
ALiFJfWvIDJn1ZMP2WaiT6l6EFBcYrgMLsaDseKp80uKPF4EyGI1T5Otovsx38is
SHqzcxBclC97/YsLvhARg32Dn9trDYWHC0AuuA7fffy04673MjR1FntD92wBotWr
2Ur7N8+GrZ2LXq2+44N94PkOXX1saxYAheFYV6F2aYj0hRwEQhRqNI6Cp1MsOKt0
U64yaHxCoW9xq6/8TGrj
=ACM0
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
