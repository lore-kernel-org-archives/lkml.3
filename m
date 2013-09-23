Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab3IWNkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:40:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37052 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab3IWNkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:40:40 -0400
Date: Mon, 23 Sep 2013 14:40:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org
Message-ID: <20130923134028.GF21013@sirena.org.uk>
References: <1379926127-8935-1-git-send-email-jhovold@gmail.com>
 <20130923110140.GB21013@sirena.org.uk>
 <20130923122806.GA1454@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g4y/k9+5pukpRNAq"
Content-Disposition: inline
In-Reply-To: <20130923122806.GA1454@localhost>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] driver core: prevent deferred probe with
 platform_driver_probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--g4y/k9+5pukpRNAq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 23, 2013 at 02:28:06PM +0200, Johan Hovold wrote:
> On Mon, Sep 23, 2013 at 12:01:40PM +0100, Mark Brown wrote:

> > This doesn't seem like the right end to address the problem from, it
> > seems like it would be better to move these drivers over to being normal
> > plaform drivers.  Using module_platform_driver() means relying on init
> > ordering which is the sort of thing we're trying to get away from.

> I actually started out doing that, but it's getting a bit hard to audit
> which drivers could actually request probe deferral since gpio and later
> other subsystems started returning -EPROBE_DEFER. I found six by just
> grepping for gpio_request, but some of these calls can be made in helper
> functions (e.g. mmc_gpio_request_cd even though that one was easy to
> find).

I think it's just the case that all drivers ought to be being converted
to module_platform_driver(), platform_driver_probe() is probably going
to be more trouble than it's worth to use going forwards as it's not
great for single zImage and other distro style usage.

> Having a warning printed by platform_drv_probe if a platform driver
> inadvertently requests probe deferral could be useful to catch any
> mistakes even if we start moving probe functions out of __init.

Haing a warning is useful, yes.

--g4y/k9+5pukpRNAq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQETJAAoJELSic+t+oim9gWQQAI3K2Wjdd4Jsc6N7O/8r0RT+
bGYvQCgwLX5oRfiCItjIfLj6TeMVy0YAIUZQS457zc1zpXRBPJj5gCrBCWW1m7lQ
mSUvnbnFASNxAHt60lLuxxdo91mZ3DQi4dum4fDcmVTlAMK66SygXqRh4eNWaHEC
q2eKOViQs6SMUkofz5tA2rNSnLzc/B5OXVaStmzn4hz5zRaJ/BeWWCEkiJTWY+xM
KPo/sh3BwCrsLbO1xZz0tnfnek7/hxulzzUUz0rh4Tqa4reD7xUo0WfpygfFH3De
O3uCIFEi9IkgpNwbJDLDOSnMzjzg3CGHlA3941Zq01/siUGftssgadopxd1PJZEr
+OcYjXYvyY/97dI3odoV6XN/hRo7UxMR2rvhGPkWQp7jV5ojRxlf8iVcwQl74ppN
qsp+dUyp7/68wKaR4ClcHfBjUG1wDemZti3A45iyn0Mnejarx8uFlt2tBSX62tXm
Mu1KBdANGkLC0kWpymz+bHBmSUzyi7q5zOXjK9E83DRFDqZMPKWadeYSeGBryrrX
HYT0IDgON4fA5o88tRunaGJBFiz1wyn8YGBCL73SJEAgRJv4QNi0rAk0osqVgIjl
TFitYKOuxF9y/7UkQZJzcUYx0ghz6nld9FcmAq/YXBW5OsS3ARo02O8LOx5APhLO
ZaBMCc96iZwIgqtRIjEw
=vpYZ
-----END PGP SIGNATURE-----

--g4y/k9+5pukpRNAq--
