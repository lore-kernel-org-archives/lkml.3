Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab3FASp2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 14:45:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38090 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab3FASpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 14:45:20 -0400
Date: Sat, 1 Jun 2013 19:45:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "balbi@ti.com" <balbi@ti.com>
Message-ID: <20130601184511.GC16790@sirena.org.uk>
References: <1369911393-25747-1-git-send-email-kishon@ti.com>
 <20130530113247.GI5180@sirena.org.uk>
 <51A74D70.5060303@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Uq4LBwYP4y1W6pO"
Content-Disposition: inline
In-Reply-To: <51A74D70.5060303@nvidia.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 30, 2013 at 06:30:32PM +0530, Laxman Dewangan wrote:

> Palma have SMPS10 regulator which can generate two voltage level
> 3.75 and 5V.
> This SMPS10 has the two outputs OUT1 and OUT2 and having one input IN1.

> SMPS10-OUT2 is always connected to SMPS10-IN1 via following logic:
> - Through parasitic diode (no sw control)
> - In bypass mode (bit  configuration is there to enable/disable Bypass)
> - In Boost mode (bit configuration is there to enable/disable Boost mode)

> SMPS10-OUT1 is connected to the SMPS10-OUT2 pin through Switch (SW
> control for enabling/disabling this switch).

> So I think:
> regualtor enable/disable, we should toggle the bit for SWITCH.
> In STANDBY mode, it should be BYPASS disable and Boost disable.
> In Idle/Normal mode, BYPASS enable and Boost disable.
> In Fast mode, it should be bypass disable and Boost enable.

No, that makes no sense at all to me.  Why do you think this maps onto
the set mode API?  Modes are all about accuracy of regulation.

--/Uq4LBwYP4y1W6pO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRqkE0AAoJELSic+t+oim9n7wQAJDj2Bdk9zGWQgCW835i/nqg
yzzdc0pP4fUarbBdr47/C/4ReJNPRo4nYPetg5Jz0wEpFhbn5ssZP6Ltv0nuBCTT
gziz8gzwJmQFPqdEbTzbu+Yo2uAT1rCP5pE3eKdNgnWne/Ga3mfT2BXSWdEShsyB
3ltyrv1WJnmKg/IYNBNdo3R85qqjFUqpmZegY7ou15PKnUBdLT++iFesQgCIzrS8
MCaeGhPjo3ny8CmxNIAh1JzX3+JpsbD+UbPl4fdcNEcameQU827jZfx4i110rGpB
hCFFTxujmVvJH/pao7IwSbfk15JPoKYvzDtcy1l+zS3oRlBosJ3AZORTv48GR99n
ILTDC8+iXv6lvOm7+s3IZ3ReX4OsFMlyqAqalQMfECADsoEUAYn+a9X2ajeYZOZC
He4O+mRj0g2QIshXs14J3P7MylgI0u0Mxclo6risREsNGT3/gkCPXb930L2/PH25
IVyCo0zPL6G8DFDsxLpbfIhsTgqIcZrClnjZDcNlfYrwTizUbDdSjGFoo2+LV+X1
zd7ZKtu/t5IgjBZyKp9OJ5fcBMwTGXZvUD8OJRFLcepsG4OVrB4MNnNA3rMixw9d
m/VMlJz3D/HwQVEd6wkArRmk/OP7VLwzDpJDCAXWe7dNnD00dy0bwxjkAeeiz0vt
fdqo/xP0trVZsNP+Hvcp
=FXL7
-----END PGP SIGNATURE-----

--/Uq4LBwYP4y1W6pO--
