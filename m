Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbaAZXvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 18:51:15 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59821 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaAZXvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 18:51:13 -0500
Date: Sun, 26 Jan 2014 23:51:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <khali@linux-fr.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Wei Ni <wni@nvidia.com>, linux-kernel@vger.kernel.org,
        LM Sensors <lm-sensors@lm-sensors.org>
Message-ID: <20140126235103.GP11727@sirena.org.uk>
References: <52E561D0.4040308@roeck-us.net>
 <20140126211357.6fa68909@endymion.delvare>
 <52E573B6.9040903@roeck-us.net>
 <20140126214936.7736f530@endymion.delvare>
 <52E58330.90602@roeck-us.net>
 <52E58656.7000903@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ian02MSQ7xDzAZO2"
Content-Disposition: inline
In-Reply-To: <52E58656.7000903@roeck-us.net>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [lm-sensors] lm90 driver no longer working on PCs in 3.13
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ian02MSQ7xDzAZO2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 26, 2014 at 02:04:06PM -0800, Guenter Roeck wrote:

> I think I have a better idea: Surround the regulator code, or at least
> its error handling, in the lm90 driver with

> 	if (IS_ENABLED(CONFIG_OF)) {
> 	}

> Would that be ok ? If yes I'll submit a patch. I'll do the same in
> another driver I am working on.

That's not going to have the desired effect in cases where DT is built
into the kernel but not in use on the current system (which is a
configuration that gets used) and will remove error handling for non-DT
systems that do have regulators set up.  There's not the relationship
between this and DT that you seem think there is...

Besides, if we're going to do a bodge like that we should do it in the
core and not in individual callers.

--Ian02MSQ7xDzAZO2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5Z9kAAoJELSic+t+oim95vYP/2rMw17Z87sKyLMYbcpWZqHf
AM2Z6vpAs+yGmfR+p+3SP8ImQmNGC8zutxMuIm744UCjm8rMSityQawDQx56lHwC
ycVplotrIeqcl5UwESKPss1fCOiLmYWR6R2++sb6vYj1MPHaQF5HP1h/uJJUXi+7
TLmgvAQQFzQ9XxXohb70hiwsMuM25dQ+zBFvqygqu2eYNEgWWbANeMIwqss6R6fp
v5TG2iUwfkHPS6YhKp6qOlRtpGu3ZYtK1kNtafNBbLWnbBKp/ek76vOLR4vR+8zt
oc9V+z9b0+JYAthenQb6oWgN5g+NUmYjY5LwBUGZFvcKLY19F/lDgdPSn8rIDOPq
Ug9z0EP70ao+B4DU7QZ3BVHcjhUbAA+MzWFDqzaeTj2lEAVqvwfa6gBUPpCIFJSI
Ne49QbuVY5pP3pBfuLHyPM4GQuryC8SE90lYMV7zoHBZDcTEOSlI7GqUWa9prs/s
RggDb8ZkP73Iwv+BiRmOEPvPAUU8h4i+9cXNj9UrCv8/LubjJPRcn/tKrQofBxA0
qDpdr2+ZyEcuPeT+0HFOFAOq5V9n5uU9GRESsEJGAj6kmEGSTLiSB/QmdgLLewA5
VfJizc8LgswRvX+NWqi4G4/sv2/QofMSK60bHYYZKOpVnCosmncvtxygrXlwORIU
e8eYVZvzPSDiuUbRWlVu
=lcWY
-----END PGP SIGNATURE-----

--Ian02MSQ7xDzAZO2--
