Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaBJLti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:49:38 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39906 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbaBJLth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:49:37 -0500
Date: Mon, 10 Feb 2014 11:49:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20140210114927.GR1757@sirena.org.uk>
References: <73e82a7cf77a1a68c5303def3071418b7d0ea382.1392029156.git.michal.simek@xilinx.com>
 <52F8AFB2.4000307@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JKGvNdIvrY8Ovf7Z"
Content-Disposition: inline
In-Reply-To: <52F8AFB2.4000307@metafoo.de>
X-Cookie: Colors may fade.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Check readable regs in _regmap_read
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JKGvNdIvrY8Ovf7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 10, 2014 at 11:53:38AM +0100, Lars-Peter Clausen wrote:
> On 02/10/2014 11:46 AM, Michal Simek wrote:
> >Check if regs are readable.

> >+	if (!regmap_readable(map, reg))
> >+		return -EIO;

> This will cause issues with devices where registers are writable,
> but not readable, but we keep the register value in the cache.

Yes, exactly - this is deliberately not done so we can fake up
readability using the cache.  All the 7x9 devices are like this for
example, there's just no read support in the hardware (or if there is
it's not related to the register map).  If we were going to check it
should be at the point where we are about to interact with the hardware.

--JKGvNdIvrY8Ovf7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+LzDAAoJELSic+t+oim9tOgP/i8MTuBZcsnla7Tc5HDo5kHM
cVMYcA8gH0Fi5+/0hjbMuJso7FVweyp0hBwGEruZVwBig9eNMIy4BpfrWhWv2WEx
eOPbzo8JfV+0CTkkqkiSAzcXIfXNPftzwM9bvUcEtGBv9wCqK5ucYCzfe4qMNMp1
MCmShP12KQKCzhKZAWbEipBG6mTLhTn5QcpHFNeiS9cmd1zXau25bwk02VyybVMg
9xzkJq0A3PI+K/ewOzhyoLZJJlVsJ/8eiVRJyZGQ0NyJmUSQFrIvVQjTS2zN+hcL
WVinaJ+Nf9FUxIbaylMz2A7wSXZewdKu7VDCkiICsR6f7rUkgNgwH1sEZQfRD1Lh
MFq0uJp9HX5mJamyo14SpxjeUTdE5b6KJD2y8QkINP8DR/67WrA4hFVgJw7hEIZA
rHD6ljB/ouDTCdmbLAQGxmxedkZf4+pdIwzTmwO+AkKg0u3y9eLzmmXqxu0nh2aR
LRNShKR7F80JTuAwQZKugkQghjRGpsh37fuw47hgu4j+Q28hX0p5MFTIXYrpKJCD
teAm91TLIZltuJGG/krIqfXDi9xMu/dDslGuFE0XCx4jKFjnPtUZV8cDVvRyA0nT
OP1464NSfTY8RMJF3+bOfVPLEuMRxGYwy5h/Z/S2gFNATkmgufSXFwCVGqEV9BwQ
mc1h9NwuXcJDD9iibh4G
=aIXG
-----END PGP SIGNATURE-----

--JKGvNdIvrY8Ovf7Z--
