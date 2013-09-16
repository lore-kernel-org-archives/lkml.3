Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab3IPXbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:31:51 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55164 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab3IPXbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:31:48 -0400
Date: Tue, 17 Sep 2013 00:31:11 +0100
From: Mark Brown <broonie@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kevin Hilman <khilman@linaro.org>, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20130916233111.GB21013@sirena.org.uk>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <5235BA9C.1090509@gmail.com>
 <20130916084708.GN7393@intel.com>
 <1861747.RtS0ZLgUUN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="St7VIuEGZ6dlpu13"
Content-Disposition: inline
In-Reply-To: <1861747.RtS0ZLgUUN@vostro.rjw.lan>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/9] i2c: prepare runtime PM support for I2C client
 devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 16, 2013 at 09:07:07PM +0200, Rafael J. Wysocki wrote:

> That may be left to the client driver altogether.  I mean, if the client wants
> the controller to be powered up, it should just call
> pm_runtime_get_sync(controller device) at a suitable place (and then do the
> corresponding _put when the controller is not necessary anu more) from its
> ->probe() callback.

It shouldn't even need to do that, it should just be able to rely on the
controller to power itself up when asked to do work.   This is how the
existing implementations are done - the controller power management is
totally transparent to the slave.

--St7VIuEGZ6dlpu13
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSN5S8AAoJELSic+t+oim94uwP/jx69z1Q6v47hnnPe96VbjT3
EnKgxbDsp7+Kf746Wk/4N2NJFH8BjlmoURBIKCAEaBkvbjNpU1MMYj3R/hyr8KNY
Noc5qU1N0C+a+of3hrAN1mEPy8GF+fsRbcdVTKwvljaVW+dzDld9KJBoBhaQABms
LJK9cAmv+usvMHTRnqjbd66CR7pV1uu7yXOb+iMOAaypAIE7ws5vGlCf6risl5fW
1aaWEBLJCuoVNG6dY4tOMlWf0C/PWyqqFzwUWtRyHAnG99ZOoBqupMXtDe+OpU8Z
PK+qLKJfk+9vqIw3TnG3lIrDUmTCdKBE0TupAQETSxU6aHT9u6rnLvcaLqMEICRF
qpjG0gRe/XY28K1MwlZH+AWXYdh16OdkgDfEL72mJaznx06Z4oi4OR4Am0vFZSwt
jtSf8G9PnFbbjpFY5wMaSpXUQLHZShUkB2Hnjq25rvAAPeUr02Iv9WybbFyrHnJ3
XKFU7w5IsUlwIWvSEaMeTlqIwoG0zJqkcnVBGHaVQwqVTlHreq9GlF9dwRTpZcZl
J8btH2M1/nyezwPOoTDmQeJpiY/tvK4S++0Z9Xfg/Yxy8a/Km76PEQWf2FqhmcxB
PhAQz5iPvW0r8zVr/05R/Bwd4Zl0PwpBtzH9WxaSo/gbMpRsUiOPEZZm1w0y2q+G
aHTR4zk6jgEdn60R8zZQ
=CLGD
-----END PGP SIGNATURE-----

--St7VIuEGZ6dlpu13--
