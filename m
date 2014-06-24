Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbaFXXPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 19:15:46 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56368 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaFXXPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 19:15:45 -0400
Date: Wed, 25 Jun 2014 00:15:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140624231528.GV23300@sirena.org.uk>
References: <1402757665-15102-1-git-send-email-robert.jarzmik@free.fr>
 <20140617144323.GU5099@sirena.org.uk>
 <87oaxrs5wb.fsf@free.fr>
 <20140624153812.GT23300@sirena.org.uk>
 <877g46tc7p.fsf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zd8I2GZVcdxtyaG/"
Content-Disposition: inline
In-Reply-To: <877g46tc7p.fsf@free.fr>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: max1586 add device-tree support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zd8I2GZVcdxtyaG/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 24, 2014 at 08:05:30PM +0200, Robert Jarzmik wrote:
> Mark Brown <broonie@kernel.org> writes:

> >> As for the "state report", this max1586 doesn't report anything, it cannot even
> >> be queried about the current voltage, sic ...

> > It can't?  That's unfortunate, though I was able to turn up a datasheet
> > which appears to support that.

> Oh really ? Well, tell me where you read it.

I said I *was* able to turn up a datasheet which appeared to support
that.

> >> If you want me to modify this bit I need a bit more of an explanation to
> >> understand.

> > Where the driver is doing unusual things if they are actually sensible
> > then the change needs to be clearer about why.

> So would a comment like this address your comment ?

> 	/* Either matched < 0 and return the error. Or matched is 0 which means
> 	 * no init data was found, ie. no regulator is configured, and return 0
> 	 * to caller, stating neither error nor any matched regulator.
> 	 */
> 	if (matched <= 0)
> 		return matched;

Can you include something like "...and we have no readback support in
the device so can't report status" or something please?  That's the key
bit - the point is that even unconfigured regulators should normally be
registered.

--Zd8I2GZVcdxtyaG/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTqgaNAAoJELSic+t+oim9fLwP/0JTT64mVDazJpLup0JPRaMK
WVpI0q4VpnKyi58EVpsaU3VyFf6HnY8r4PKOP5tK7XMol7AYPnLyN5YbHHTPjRmU
vfssB+TeewaDSfGsr8HV+mPICtAqZqRGpqRWvAEunsm9RjO+tf05YKZlZUJhCNMS
GepbyBvZrsmupyqPZiQ2zSnZvbc7Lh5gKpYWrxJ4/gKOdvvk09zKECf8T0l2as0A
nZFO8Gr0iygkXtHLmmHCigOjsipsDevAHHurjHdQZ9djh/k5Ec0ZziUjUpQwhFxP
TD3PlssZ7hK4kbWvVwCOEcaTvrC0Y/b7LbknjEb7J/mwGwQVL2tyjzNHxuA35Ejy
kfuku2X8DZd+GeNtnidd9pRW4nOsfIMnA3HJ69VxIrqYpSy1ECoxVdi1YtGh+9Nd
X9+N2VsXtBP6DMAUKzUbNmgpzI/E4lb+Ibi84qusQzwFXcKyiw2Q5HnIkS4H5/L1
uQWNzJ1ZXd2geSODQ3Hp6kw9ySHewYjS8XN/KKjjLiSXssnhthJLGX19qCix64k4
CCSRVvcWQ16hQDc+3o20nABi/LYTBcwf0MFS9tHfgZ3a7AB1ECPcOaLBUJ0Kr65L
pzTcJbo82gfuvMCROnlvM4q1JKqAc6pmxiASI3BnSTKf7IHXbf46bxn75uTYioVv
ZmoXj0/LENbZfMEr8eBB
=nEK4
-----END PGP SIGNATURE-----

--Zd8I2GZVcdxtyaG/--
