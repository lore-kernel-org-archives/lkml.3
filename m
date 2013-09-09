Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3IINuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:50:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46363 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab3IINug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:50:36 -0400
Date: Mon, 9 Sep 2013 14:50:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wei Ni <wni@nvidia.com>, khali@linux-fr.org, swarren@wwwdotorg.org,
        lm-sensors@lm-sensors.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130909135022.GZ29403@sirena.org.uk>
References: <1378722552-10357-1-git-send-email-wni@nvidia.com>
 <1378722552-10357-2-git-send-email-wni@nvidia.com>
 <20130909111242.GW29403@sirena.org.uk>
 <522DB253.6000707@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MziYxCZO8WOaTd4I"
Content-Disposition: inline
In-Reply-To: <522DB253.6000707@roeck-us.net>
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


--MziYxCZO8WOaTd4I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 09, 2013 at 04:34:43AM -0700, Guenter Roeck wrote:
> On 09/09/2013 04:12 AM, Mark Brown wrote:
> >On Mon, Sep 09, 2013 at 06:29:11PM +0800, Wei Ni wrote:

> >This doesn't look good, it is going to ignore actual errors - I *really*
> >doubt that vcc is optional, it looks like it's the main power supply for
> >the device.  You should use normal regulator_get(), _optional() is for
> >supplies which could physically not be provided in a system (eg, if the
> >device can generate them internally if required).

> Then he'll have to make sure that all devicetree files in the system
> contain references to this regulator.

Or get the patches applied on top of the code that'll be going in this
cycle implementing get_optional() properly - when that's done the
default will be to provide a dummy supply for regulator_get().  If you
ack the patch I'd be happy to carry it.

> >Also do you really need 25ms after power on?

> I had not noticed, but I recommend to reject the patch because of it.
> If we add 25ms delay to each driver, booting the system will take as
> long as booting windows. If enabling the regulator needs time, the
> regulator subsystem should do it.

And indeed it does this (well, it does whatever the driver says in terms
of delay).  However it is possible that the lm90 needs this time for
itself - if it's doing some sort of initialisation or callibration
sequence then that'll happen after the supplies come up.  25ms did seem
rather long, especially for such simple devices, but it's not beyond the
bounds of possibility.

--MziYxCZO8WOaTd4I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLdIbAAoJELSic+t+oim9tFMP/2YyINivybEYWNCGYXmEplJr
K5DPV1cFNxezp3U5iVMoy3fg8mr6+BCB3WWxzSFlSMvBin+/J0KDlXUr5/sEnPHd
KARF0VeDY+n+pS8r1eS3Mo2+dgPeQNB2VaOwo90X3YOsgptdu/mICORVQuIZ18YD
s8rBF+OngFOxfGKRPanbfpg/niVPvorjsDZCxnxLjvAw5bsV/14KGZ1C3+Qr42go
DT0UIRG2uz6EFH/GbucY1hLzPlrf02qr/YH63eVruCTs+p1xCHViHv8phuYn0avD
loXaixks5/JGcjbsybpUqvefnhwrQiWzDz2d6fYfjc+/S08WPXuOut2PLcyIS7a2
PQ7iPcFoSbSDPEFUAJWruyYaq46rARa2beFXx/7uKyJjJ6VB9i/h2PVjMc2cQZho
01bdIjs5iGShRdSgDpELbqcwoIx0H84gezw6OBA74GZqd/768QL528dU0fxvKcB/
L/KcA196VyRBM/qaLW0Oqy63UDt3iA5JuvdV4wwP1AR4+5XU9Pr4xRTyhTtiSW02
pgB0l9s+Bu7mmS9Lm5mxd9dVv+ChmOEprV9Pru9Y95fkJeU0AuVjH5+v5gMgL/IM
KSYhN/sERO52DYbMsKi1Xa6BsePdkLzFP0PoxiIYZ/R/tmT8ZqHZ+mgllGZa3LEw
7ZWCAfTtn9Vgwi2nPu7w
=35jw
-----END PGP SIGNATURE-----

--MziYxCZO8WOaTd4I--
