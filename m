Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935321Ab3FSWie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:38:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45019 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935291Ab3FSWic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:38:32 -0400
Date: Wed, 19 Jun 2013 23:38:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Message-ID: <20130619223828.GK1403@sirena.org.uk>
References: <1371669474-24473-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9HwyI31Aj78PLmNd"
Content-Disposition: inline
In-Reply-To: <1371669474-24473-1-git-send-email-nm@ti.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] regulator: core: allow consumers to request to
 closes step voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9HwyI31Aj78PLmNd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 19, 2013 at 02:17:54PM -0500, Nishanth Menon wrote:

> Account for step size accuracy when exact voltage requests are send for
> step based regulators.

If the consumer can tolerate a different voltage why not just request
the range that can be tolerated?  Your problem here is specifying an
exact voltage.

> The specific example I faced was using cpufreq-cpu0 driver with voltages
> for OPPs for MPU rail and attempting the common definitions against voltages
> that are non-exact multiples of stepsize of PMIC.

> The alternative would be implement custom set_voltage (as againsta simpler
> set_voltage_sel and using linear map/list functions) for the regulator which
> will account for the same.

> Yet another alternative might be to introduce yet another custom function similar
> to regulator_set_voltage_tol which accounts for this. something like:
> regulator_set_voltage_floor(regulator, voltage, tol) or something to that effect.

Or as I keep telling you guys the consumer can just do that directly
using the existing API; the whole point in specifying the voltage as a
range is to allow the consumer to cope with arbatrary regulators by
giving a range of voltages that it can accept.

The API is deliberately very conservative in these matters since there
is a danger of physical damage if things really go wrong in some
applications, it makes sure that both the drivers and the system
integration are involved.

--9HwyI31Aj78PLmNd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwjLhAAoJELSic+t+oim90ikP/iLmiKIUnbr9W8hpvhNDeD1B
TvFPj/D/eL8Q24RZ+EqDCBmGdSwD65ASZRtkUTZCi+eXyO9NKqrNRDbNh9PktVZc
Q5dMW7Kdbq8IXAYp50wZnDyV74I5O8JFknlW4tYS35x/ZfI+8uv96QIpRX+X+MbM
KoZy6PUkpYqQ6NxVcNEVZAdi4xOV+cCbjEtyECroCowrtUGj1Do8P706F+h9jG1/
4ICnS5Q6Ui9O14tYMv4gaZE6IqWhqRRskeOtyLTib3oiLwS0cmj2sVeL9CDQR36y
GxlzmNJvH75yPg80+L4nxOuQk8hpjPW0qKwzSNOTXuQJxYmUaJBt2SYPjDS4UCTw
d5/LPihoY/OaXs7LaJU10pSYZU6WET4fhsmoZyvSLyJCG4OS2O5c7WjpqT12e6kM
wmYYJAhokX98lfJZMJa/rX4xYblmDJIlJtkr+PclqOr299N8FgeUraLpljtf4Eus
HYqIXaGWnDFXtGYOI0ApACCI+SLaw8hmcKiKWrLVW/LThIVJnhrs7sHjZQwEp5sG
5nYx2k/IcnCDb7VEEZbvWbFd2PTOtSsh/e0TicUzOBWWpCVNJATpQCCsvQ+CAzWn
G8tnTFRm4Zf8CCzwhE2bCPKj5Z2x45SplNDbJpdVj8StHiW/Vpks17RWDQuEeu0f
RbT3gyS1DbhOJdvrTODz
=2wBT
-----END PGP SIGNATURE-----

--9HwyI31Aj78PLmNd--
