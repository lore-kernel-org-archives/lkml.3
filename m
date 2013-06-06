Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab3FFKEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:04:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46074 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab3FFKEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:04:08 -0400
Date: Thu, 6 Jun 2013 11:03:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Message-ID: <20130606100346.GC1883@sirena.org.uk>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
 <7380889.l4hHqCT0mm@dtor-d630.eng.vmware.com>
 <51AF8730.4010507@itdev.co.uk>
 <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com>
 <51AFA02B.3000604@itdev.co.uk>
 <20130605210715.GA16013@core.coreip.homeip.net>
 <51AFAF6D.7050204@itdev.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xo44VMWPx7vlQ2+2"
Content-Disposition: inline
In-Reply-To: <51AFAF6D.7050204@itdev.co.uk>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xo44VMWPx7vlQ2+2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 05, 2013 at 10:36:45PM +0100, Nick Dyer wrote:
> Dmitry Torokhov wrote:

> > What other purposes does it serve? I'd expect you need it during new
> > board bringup.

> Run-time examples would be adjusting noise suppression or touch suppression
> parameters based on something going on in the app layer (eg having
> different parameters during unlock screen), or tuning report rates based on
> application requirements, ot to inspect debug data if the touch sensor is
> faulty. You might say, well we should implement an kernel driver interface
> for these requirements, but they will vary hugely between different
> products. We are trying to keep the driver as generic as possible and push

If this interface varies dramatically between products then that sounds
like a badly designed interface.  Obviously the way the interface is
being used would be likely to vary between products but what you're
talking about sounds like parameter get/set stuff which sounds pretty
generic to me.  What userspace chooses to do with the parameters is of
course another story.

> product-specific complexity to user space. Hence exposing the register map
> and implementing user-space libraries to deal with this kind of customisation.

This sounds like a bad design decision for Linux, it's just asking for
fragility if userspace can go randomly poking round the entire register
map of the device with nothing coordinating with the driver code.

If you expose the paramters to userspace wouldn't that address the
issue?

--xo44VMWPx7vlQ2+2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRsF5+AAoJELSic+t+oim9pQ4P/j7Dlw9o7DNppHfAM0HAuMMl
kDsE7McPaFG3s5M4+EkaKh9BSyN78FSzFO+ALF8MRUrw87P6lTY9yK3nEg0leZBl
LVs8t+yM7X0+JekTugR2Gn7E22tLNiOn0JmxDrAXH5ltzLgSLwWviUDVb5Mi+cZW
yskJug2VgmoFpuVh2W0BGH69+iYTPqwrmwLe8xSbjGyDqI4y302J60iISzEolqiq
xt8BMQqnV8zY2uaQv/jpa3nTIdxCqM1Hq2x22wrWl5ncJVPmIeYAXDwMooMdDgu/
JH7l14Lc1X4CIzKnXnwYPJpVMw9vWtwdRumQnHkZ84ps0n7OHcpWke3fOnn/nEVF
m3thcNOrH8uC6tK9qmPLN+w8S+yXN75G1p4V+NXiO0CrHHqgDMxc0a+Tny225Gbi
0ry9TqMkHg5iyVEvqzORersgIbekag7+V/Z2cSjBOSeHHs9G6sqijtHjPfWYj9jk
kBYmxHFJiPriyEj4vC6INkA+3Y1L/SAU4GbBFcvmgI8Ki49tT8gtF+Y5MlDZYGiC
3ejz0/4dMFqNswh8iZuutQkUd4cA4kcr4F7sNEVdRQKw3ridlz7byPAPkjLE8OwQ
L7mf+4Tf/AsGgI4Rn1w6Sm9hVohgV/3zsjfmcDPmduCDt4N8OetEKtWMf3caLYcW
ITvlkWkCssiECxInyAYq
=/LLV
-----END PGP SIGNATURE-----

--xo44VMWPx7vlQ2+2--
