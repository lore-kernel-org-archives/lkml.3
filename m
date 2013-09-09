Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab3IIUkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 16:40:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35517 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab3IIUkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 16:40:03 -0400
Date: Mon, 9 Sep 2013 21:39:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wei Ni <wni@nvidia.com>, khali@linux-fr.org, swarren@wwwdotorg.org,
        lm-sensors@lm-sensors.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130909203910.GV29403@sirena.org.uk>
References: <1378722552-10357-1-git-send-email-wni@nvidia.com>
 <1378722552-10357-2-git-send-email-wni@nvidia.com>
 <20130909111242.GW29403@sirena.org.uk>
 <522DB253.6000707@roeck-us.net>
 <20130909135022.GZ29403@sirena.org.uk>
 <20130909155043.GA18975@roeck-us.net>
 <20130909160237.GR29403@sirena.org.uk>
 <20130909161735.GC18975@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MXE3caftPhBF8dmD"
Content-Disposition: inline
In-Reply-To: <20130909161735.GC18975@roeck-us.net>
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


--MXE3caftPhBF8dmD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 09, 2013 at 09:17:35AM -0700, Guenter Roeck wrote:
> On Mon, Sep 09, 2013 at 05:02:37PM +0100, Mark Brown wrote:

> > It does, though it gets complicated trying to use it for a case like
> > this since you can't really tell if the regulator was powered on
> > immediately before the device got probed by another device on the bus.

> Why not ? Just keep a timestamp.

The support is a callback on state changes; we could keep a timestamp
but there's still going to be race conditions around bootloaders.  It's
doable though.

> > > On a higher level, I wonder if such functionality should be added in the i2c
> > > subsystem and not in i2c client drivers. Has anyone thought about this ?

> > I'm not sure what the subsystem would do for such delays?  It's fairly
> > common for things that need this to also want to do things like
> > manipulate GPIOs as part of the power on sequence so the applicability
> > is relatively limited, plus it's not even I2C specific, the same applies
> > to other buses so it ought to be a driver core thing.

> Possibly. I just thought about i2c since it also takes care of basic
> devicetree bindings. Something along the line of
> 	if devicetree bindings for this device declare one or more
> 	regulators, enable those regulators before calling the driver
> 	probe function.

That's definitely a driver core thing, not I2C - there's nothing
specific to I2C in there at all, needing power is pretty generic.  I
have considered this before, something along the lines of what we have
for pinctrl, but unfortunately the generic case isn't quite generic
enough to make it easy.  It'd need to be an explicit list of regulators
(partly just to make it opt in and avoid breaking things) and you'd want
to have a way of handling the different suspend/resume behaviour that
devices want.  There's a few patterns there.

It's definitely something I think about from time to time and it would
be useful to factor things out, the issue is getting a good enough model
of what's going on.

> > There was some work on a generic helper for power on sequences but it
> > stalled since it wasn't accepted for the original purpose (LCD panel
> > power ons IIRC).

> Too bad. I think it could be kept quite simple, though, by handling it
> through the regulator subsystem as suggested above. A generic binding
> for a per-regulator and per-device poweron delay should solve that
> and possibly even make it transparent to the actual driver code.

Lots of things have a GPIO for reset too, and some want clocks too.  For
maximum usefulness this should be cross subsystem.  I suspect the reset
controller API may be able to handle some of it.

The regulator power on delays are already handled transparently, by the
time regulator_enable() returns the ramp should be finished.

--MXE3caftPhBF8dmD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLjHrAAoJELSic+t+oim9k/MP/jTamsn6zl52va+mJqjasS6c
mREzOt84i+2eFFjJQGWM9LjKdcziRq/CuEAHLGwrWbFFbEhGim7NbpDVLkzJy+aS
oh0Iof/L4j8rB04GXnMUo42KGVQEDP8zqBpX6HBoX3uib95hA0eA8PgFVVM65z2i
KjBfRPp1TCisXQyJVuNgbZCECPFbuko7457cDYP93xlVQio5XnNcYdPKBPF5S1ms
JwSeTrjISBiTMBovb7KphwVXbt9T7hYJKr3NGLiRjR+Ypsxjj6ZaoCKbd6XF6bco
Bvbsm0LDoVG5foYTxOxQSprF4jMQsM1Ury5CDYrZh1Gn061Jgz/dlsS9jOfvHaJg
KSN+fYm0k8rrg8E+nS9TV22qxladk96QjWGbHB3D7H45EuUqWWGVv4EohHT7e+U5
hm6BJLNDNI7EV9eJJ4WS83OdYtd5PU3pGHc8hphA6nGt62WI38mzMEUicIiN0Pn0
RQACww8/ALgRUFm+TJFZy49YfL6COtwxMrjFWl7qiuESWDeGDNE9rP1njzHkzHyJ
yK5fpymSC3Ge61PxOKOKJIw2Li925uaR21uitduwulOPrOmt1Xg0eub5lZ5UA3g2
1Ba8RbEWBMGSVF7lG/ukUYG5ZMWAMJumjH9DxZuX2HXu4E7TpxiBRQan4hnOgCIK
rUE9ltokxIy2OnvJPPC0
=C1Zh
-----END PGP SIGNATURE-----

--MXE3caftPhBF8dmD--
