Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbaKLO7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:59:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35071 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbaKLO7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:59:19 -0500
Date: Wed, 12 Nov 2014 14:58:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20141112145802.GK3815@sirena.org.uk>
References: <20141112111835.GA12635@opensource.wolfsonmicro.com>
 <20141112113541.GD3815@sirena.org.uk>
 <20141112130735.GA16426@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dOxoUI6yY1QuNMER"
Content-Disposition: inline
In-Reply-To: <20141112130735.GA16426@opensource.wolfsonmicro.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: export function to check if regulator
 always on
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dOxoUI6yY1QuNMER
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 12, 2014 at 01:07:35PM +0000, Richard Fitzgerald wrote:
> On Wed, Nov 12, 2014 at 11:35:41AM +0000, Mark Brown wrote:

> > I'd like to see a user here,

> The user will be the Arizona codec drivers but I wanted to upstream
> this patch first for discussion.

My point is that the code using the API is useful input to the
discussion.

> > and I'd also like to understand why this is
> > a better approach than using a callback to postpone these expensive
> > operations until the regulator is actually powered off like we already
> > do for some things like register cache resyncs.  That is normally better
> > since it also avoids the work in cases where the regulator isn't always
> > on like reenabling during a delayed powerdown or shared regulators.

> The runtime_suspend() for the Arizona drivers has to do a bunch of
> preparation before disabling the DCVDD regulator (and there's more
> preparation steps that need to be upstreamed). There's no point doing
> any of this if at the end the regulator isn't going to switch off.

I'm not sure that this addresses my concern about postponing the
expensive work until the regulator is actually powered off at all?

> > You're also missing a !CONFIG_REGULATOR stub.

> It's there at the end of the patch, returning 1.

Bah, so it is.

--dOxoUI6yY1QuNMER
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUY3V5AAoJECTWi3JdVIfQ5nMH/1qX8UMHTF4ktXoZyI9Qcnbe
yJVezWzAXh0rj6SXDn+fTfTvZdk1mRjYbXhuWX1rup4/k4CE45jrOpXg3kV0OhRQ
yzJcoBuaHTMyEvS2aeKu6TZOui9cbILK/H+heCWN6PsFX5OEFs7EuA3VHyn9kwcv
2ainLNEWFY6ZjU3sAsK/0k1icjNRZG/tNkyHX9dXnHyiJOmyYW+d7jwTKaZSXRjA
DzF8WglyylcQELWfa7F5ZsHwcnWhRD0BqEAJ0bPTydpQ+U4Y0J8GcYWb7ojqs//M
3kFhl6Zr1PDmCmfOZnK9KsH3/QhM+dinQLc01itAW65LlDPMiJHWnUNvL1PxmZw=
=kMD0
-----END PGP SIGNATURE-----

--dOxoUI6yY1QuNMER--
