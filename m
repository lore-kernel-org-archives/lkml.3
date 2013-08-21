Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab3HUOIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:08:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50496 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3HUOIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:08:40 -0400
Date: Wed, 21 Aug 2013 15:08:16 +0100
From: Mark Brown <broonie@kernel.org>
To: David Jander <david.jander@protonic.nl>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130821140816.GC26118@sirena.org.uk>
References: <1377090155-3443-1-git-send-email-david@protonic.nl>
 <20130821151423.70c38fb3@archvile>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jousvV0MzM2p6OtC"
Content-Disposition: inline
In-Reply-To: <20130821151423.70c38fb3@archvile>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] drivers: regmap: bugfix in regcache-rbtree.c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jousvV0MzM2p6OtC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 21, 2013 at 03:14:23PM +0200, David Jander wrote:

> Here's the explanation:

> 1. If a driver initializes a regmap with a RB-tree cache, and starts writing to
> registers in some arbitrary order, you might get overlapping rbnodes:
> Suppose I have this rb-tree (a real case I happen to have):

> # cat /sys/kernel/debug/regmap/1-000a/rbtree
> 2-19 (24)
> 4-1b (24)

Like I say this isn't supposed to be the case in the first place, those
two nodes should be being merged - what we need to understand is where
the overlapping nodes came from.

--jousvV0MzM2p6OtC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSFMnNAAoJELSic+t+oim9zGkP/RHZlSq5HqOTH121uheTgiXs
uKZKNyLzwB5B7uGtTcIV6cUc4iGXMFmxSrE4gs8qpQtpva8Q6b1btI/w2ohUgojc
Bx92wA3Cmu3DxwSyBdOg7MM3/0g/LsqC5tbZtAjFyDRnYAcVdrgjZ5PLw7JG+uHj
1Pp/5OOqN09aGKBHd8YwZQuQHQnOi6IUJn3vxhq1d5PNdtGb706/WHNgyh0Qfog+
Gy4UXbdihXuI2Tkdqml2vSUIvIkb9e1xVDpw9LWZit8vPfbKG3Qu08ZxYvfn16Re
USk3OPWwYWwDKwWTIK9P5IlTgfvQ+djN5q+by6lRJCc7xmfokYEVHiIMqQZdnphh
FbLxqqPlIWks5xq4k6brhbEEL4rPIEYBNDdTCqUe+6zR4+37bQpZv65xErBL1Cku
D84Q4RdHBX7SwFjMteJZiI5Q03KYiBpTIp4s4+XLZyjneLIxsXF+VYBIg9Fh3YeK
U/4N9Ey17Q9ZXR3WDHFZh90bwwm8okJsO5PmKlLzjPw9nf/6OCzWFaW6SXxI6xx8
FbLE90L84Mlr8k81G8zM7spptSE+UOffosQ0cxFq1BaSbEHGwFyct3BEfHZ4Ps5F
gB8XMb0SHpMYbUHFWVa3mC7ScR+vz7p6/A+oEDVaTuObZbQXbx2r4Bqyzjrwc+Ab
DBuMGIero/Kg9ACewzHa
=Icka
-----END PGP SIGNATURE-----

--jousvV0MzM2p6OtC--
