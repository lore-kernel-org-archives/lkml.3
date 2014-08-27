Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935649AbaH0Shu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:37:50 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36420 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933759AbaH0Shr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:37:47 -0400
Date: Wed, 27 Aug 2014 19:37:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140827183733.GN17528@sirena.org.uk>
References: <1409053061-22568-1-git-send-email-javier.martinez@collabora.co.uk>
 <53FE2446.3040402@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HzcKk1hPirlxv8+t"
Content-Disposition: inline
In-Reply-To: <53FE2446.3040402@gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: max77802: set opmode to normal if off is
 read from hw
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HzcKk1hPirlxv8+t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 27, 2014 at 08:32:38PM +0200, Tomasz Figa wrote:
> On 26.08.2014 13:37, Javier Martinez Canillas wrote:

> > +		/*
> > +		 * If the regulator is disabled and the system warm rebooted,
> > +		 * the hardware reports OFF as the regulator operating mode.
> > +		 * Default to operating mode NORMAL in that case.
> > +		 */
> > +		if (val == MAX77802_OPMODE_OFF)
> > +			max77802->opmode[id] = MAX77802_OPMODE_NORMAL;
> > +		else
> > +			max77802->opmode[id] = val;

> I might be missing something, but I believe I see a flaw here. If after
> a cold boot opmode is something else than OFF or NORMAL, the kernel
> starts, turns the regulator off and does warm reboot, the setting is
> lost and the regulator is switched to NORMAL mode.

That's essentially the situation the patch is trying to fix - if we boot
and the regulator is off there's no way to figure out what the operating
mode would have been so we have to pick something.  If you've got an
idea for something better to do...

--HzcKk1hPirlxv8+t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/iVpAAoJELSic+t+oim9KBYP/2IQ8dbBPUG8lqmP8e5pdUPQ
Eh+jE0FF2w394Cp5zHISnJ+V/Kqng+xt54ki/8AHU6T3REhF3KqgCWo4fJMlos0r
Xo7EfDzaLjOztLjfTcGg+k3SOdjXIVNCr1i+gbOXvxWE0zBhBFK5hgp5JoFuVnk0
kneCtw5ZKBba8FidLLJobOFX4GY1brvHP7PfsYKvaNeTMkjM+vUO0cJPlc7Pvys9
6Q29/ZQLTeiLohhBO6Og3oEOmnoc14lDrbpYbTmj0gKUs5di0I2bABWMdAZxLORa
uEJ229+Zi/JFmNujDbZ50V+XGLm7OPHsDrBhNkPINXAquUDoKSw21d/Ry6P94jd8
z2Ca/xjxw92VTCaPcIUZnKEgojek36Fs7/dvxDN0b6TqQ/biHHUONn+orL5sivQ/
21n8G3Q2+io4h0AiMcivsS8E1xRWkIonZZqnZyE6XTyWfL5XHyJOLnenD5vLWHWt
XsVzIUySkfp6MQRnLhvFOBoQFixFTwQFuYOfSD7aEjidJmh0F37YncIUackhzzim
0QUVRdyx0RILKhjWddDdTAGCNDCz4j9KL1HZCyf2VHbkgpy4dzEXW8a7ebtMhOuq
hdiK5zUbDye2A5XISuMVb+q4kPrjw0/YXawkJq9aHhXoIfVRbj847frSpE913mEF
AtGaH0tobomL9rAYnY8H
=uOlI
-----END PGP SIGNATURE-----

--HzcKk1hPirlxv8+t--
