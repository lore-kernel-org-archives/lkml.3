Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab3IIQDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:03:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39659 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab3IIQDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:03:34 -0400
Date: Mon, 9 Sep 2013 17:02:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wei Ni <wni@nvidia.com>, khali@linux-fr.org, swarren@wwwdotorg.org,
        lm-sensors@lm-sensors.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130909160237.GR29403@sirena.org.uk>
References: <1378722552-10357-1-git-send-email-wni@nvidia.com>
 <1378722552-10357-2-git-send-email-wni@nvidia.com>
 <20130909111242.GW29403@sirena.org.uk>
 <522DB253.6000707@roeck-us.net>
 <20130909135022.GZ29403@sirena.org.uk>
 <20130909155043.GA18975@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tvVWxv2WwUczo9bQ"
Content-Disposition: inline
In-Reply-To: <20130909155043.GA18975@roeck-us.net>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/2] hwmon: (lm90) Add power control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tvVWxv2WwUczo9bQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 09, 2013 at 08:50:43AM -0700, Guenter Roeck wrote:
> On Mon, Sep 09, 2013 at 02:50:22PM +0100, Mark Brown wrote:

> > And indeed it does this (well, it does whatever the driver says in terms
> > of delay).  However it is possible that the lm90 needs this time for
> > itself - if it's doing some sort of initialisation or callibration
> > sequence then that'll happen after the supplies come up.  25ms did seem
> > rather long, especially for such simple devices, but it's not beyond the
> > bounds of possibility.

> Even then it would be unreasonable to enforce such a delay for every instance
> of this driver, even if the regulator is a dummy one and/or has been enabled
> already. Many if not almost all users of the driver work just fine as-is,
> without additional enforced delay (and, for that matter, without regulator ;).

> If there is a delay, it would have to be optional: Only wait if the regulator
> was really turned on by the call and not already active. I don't know if the
> regulator subsystem has this capability; if not, maybe it should.

It does, though it gets complicated trying to use it for a case like
this since you can't really tell if the regulator was powered on
immediately before the device got probed by another device on the bus.

> On a higher level, I wonder if such functionality should be added in the i2c
> subsystem and not in i2c client drivers. Has anyone thought about this ?

I'm not sure what the subsystem would do for such delays?  It's fairly
common for things that need this to also want to do things like
manipulate GPIOs as part of the power on sequence so the applicability
is relatively limited, plus it's not even I2C specific, the same applies
to other buses so it ought to be a driver core thing.

There was some work on a generic helper for power on sequences but it
stalled since it wasn't accepted for the original purpose (LCD panel
power ons IIRC).

--tvVWxv2WwUczo9bQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLfEZAAoJELSic+t+oim9YzcP/2Xsw4IXiihoOInzmZU56HSW
E1bc1Yn4Ix00V1PEJBXxNJ9WtGOBoUFjQS58vIYe3wXNuW4eGQV9ltCA7YffnSLL
YpW4S2OQlKNTrRl+XKixHA7x4FJPRgVBeokR0R7eIzfzPXuaUiyzPsbiQll956oa
NPKlo3P1iadahpzXhlxDfu7CNX3p6Jfkxe84XRQtafb2XT4EnSUyKWHDmgTLHHEg
BV/0f5EIHHlLo5QI1bwy3EJeX5soJmb5SU2Xq2Ocrf+ea+McOMCPE8xp/HThILTx
ZgBQC0i+vZLg029/Z6PayxZGdTpRnFqteyOQSnDD75NMKNGt8qEkg9dQMPKlG0OW
ZIXLzzIYiVzbHClyKm+RlnnAnIC3FbWVqmhf4XNd6xo1+4wSNeEOb2D5y12dEV0d
SSmtbnOWxEyHFW3jmSu1daRhr+eDscDKS48bgYFTOWQmxfs95dM5cGAGxq+pB0d5
Za4BMsVxf7rH4oMWqhK90bie+ae9mApTMaAatToQLZx4EyXPRXnd5bXQftVi4eiR
JMUsSDShk3LnKZHi1KfWj5eeqe2iKVElJnwX5lcoX2PIuf8ZLvzb+k1am0wj73Iw
6aLgz73fSYvtu0PxgCYdSXmwTB/IEedA4xVktrVVx4wtr8l927mhWmEvlT0mY8fR
rjArakslzbEmL6a4Qz/w
=H60y
-----END PGP SIGNATURE-----

--tvVWxv2WwUczo9bQ--
