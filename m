Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967269Ab3HIK5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:57:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39849 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966745Ab3HIK5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:57:12 -0400
Date: Fri, 9 Aug 2013 11:56:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Ni <wni@nvidia.com>
Cc: "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130809105644.GW6427@sirena.org.uk>
References: <1375944991-29182-1-git-send-email-wni@nvidia.com>
 <1375944991-29182-2-git-send-email-wni@nvidia.com>
 <20130808110136.GA6427@sirena.org.uk>
 <520498F3.8030101@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hjiPcpt6rcFNGbLy"
Content-Disposition: inline
In-Reply-To: <520498F3.8030101@nvidia.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/3] hwmon: (lm90) Add power control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hjiPcpt6rcFNGbLy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 09, 2013 at 03:23:31PM +0800, Wei Ni wrote:
> On 08/08/2013 07:01 PM, Mark Brown wrote:

> > You shouldn't just be ignoring errors here, though there are deployment
> > difficulties with making sure a stub regulator is provided.  These
> > should be getting easier after the next merge window, the stubs will be
> > being tweaked slightly to have an "assume it's there" option even when

> Oh, really, could you show me the patch, I wish to take a look :)

No patch quite yet - the basic idea is that for plain regulator_get()
you'll only ever get -EPROBE_DEFER as an error, not -ENODEV.  If the
regulator is missing in the DT we assume it's there and provide a dummy
if the DT doesn't hook it up.  If the consumer genuinely wants to see if
a supply might not be wired up it should use regulator_get_optional()
which is in -next at the minute.

--hjiPcpt6rcFNGbLy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSBMrpAAoJELSic+t+oim92agP/j5azvH/+9+pcUjPegcAHB1d
XX79RjQpQnEbtskZxH8tOM10KgWcQqCEzMu+D4L+jCGH592DA398AJl4miVmOAHt
f3BmcJrmIYH+1HUN6dQGzT2yCZqvJqHuvn3qoTff1j+Lfoo2Izr91befX66UoLG2
5+zZkK2iCo8RjOl5koMfNTH5yPt4RNff9iZNCnG1YFTO0U6Z9Kel3orLRBlAvBW1
dffaatc3qKyy8ZZ3O/dpd/nIu5UXo2rASoEaar5atL0mK6iQQ7VqhAnI8HsHphbV
WzmB3K+AoRxGblewawUVz/GZeHEUpxcgxOeFIXnbsOhs/fZrct0NIKre7LEhmUmm
6UJOK7TriFNtKTK3dF6hM68SAUJbiENpQo35vYaOZoiARcE06PIRg69v0wQj83zg
POMZOidZgp9fzI1FisYnTWB+dCFQnSlCJWLQMqrOqFoUjUTUGcSp7vRR8tMUhtL7
50f2dHPnhNKAEWHRRjCAr8c6wnYh4V2H/dFA5k72xHgbKxIMSgScZSTzaAMbsgJ1
77o0cT69HMh3H8scRKrfKhBXCn4UzNKZJwR3uoQHzqQIa4FLXrNAooL62PoTgxgq
U+WjToAlslBAFjQ/QQs83y3bpo27rYfXXEDFgEkv2LHzh6W2ANa5agsXvT5WVtSe
vypsdOjWv8lEByE1RrQ5
=lQYp
-----END PGP SIGNATURE-----

--hjiPcpt6rcFNGbLy--
