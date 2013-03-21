Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab3CURop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:44:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59555 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103Ab3CURoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:44:44 -0400
Date: Thu, 21 Mar 2013 18:44:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound: max98090: Remove executable bit
Message-ID: <20130321174440.GG15926@opensource.wolfsonmicro.com>
References: <1363730323.16270.11.camel@joe-AO722>
 <20130320095758.GD28775@opensource.wolfsonmicro.com>
 <1363792936.16270.30.camel@joe-AO722>
 <20130320163627.GS28775@opensource.wolfsonmicro.com>
 <1363820072.16270.43.camel@joe-AO722>
 <20130321162503.GC14768@opensource.wolfsonmicro.com>
 <1363886175.30275.10.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3VRmKSg17yJg2MZg"
Content-Disposition: inline
In-Reply-To: <1363886175.30275.10.camel@joe-AO722>
X-Cookie: You will be run over by a bus.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3VRmKSg17yJg2MZg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 21, 2013 at 10:16:15AM -0700, Joe Perches wrote:
> On Thu, 2013-03-21 at 17:25 +0100, Mark Brown wrote:

> > I don't think you're quite understanding the issues with automation
> > here.  Or indeed the desired end result.

> What issue is that?

That one needs a bit more taste and thought to work out what's
appropraite than can be guaranteed easily with a script, things like
working out drive level prefixes for example.

> Maybe this would work for you...

> $ cat .git/hooks/applypatch-msg
> #!/bin/sh

> . git-sh-setup

> perl -p -i -e 's/^(?:ASoC:\s*)?(.*)$/ASoC: $1/g if 1 .. 1' {$1+"$@"}

> test -x "$GIT_DIR/hooks/commit-msg" &&
> 	exec "$GIT_DIR/hooks/commit-msg" ${1+"$@"}
> :
> $

No, that's going to leave essentially every commit that needs fixing up
still needing manual fixup.

--3VRmKSg17yJg2MZg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRS0cAAAoJELSic+t+oim9fDkP/2nzeZTbxPgI0H8GZWNMOQwy
+wTQ+YXramvCTizU6lBbV16L1+OVi9CufxkCizcrued7z/gxUdcbYcX/e83JAHHf
K2KtigiOncTCKdryuN0uwJMSQBxFKKyM/zj5i4WnVm/Hrpfd31A1IDq2p9ChoAsZ
0L8GtJHp//6G1ddBiUH2hYQYMstcYJ9Xbr1MMRFullAILbOI3vlba7/9N260QNz3
HTeAFymzrKEarZJj5d7grJyxiI5K1dyAvNZYesPx79JZkuVb7OdA9KA4hrmstHRd
xvQVHHQCQaVEOnD6tXICnBpCzgpIqAqBd1JGXFzc5EcUPzxhZdvUidAS+2UrCf59
r4sWLdlxIw3xTO+I/6KwiKggaIJWl0OsnelvkloqVqSoRJUpTrLm4NIcTJ47pGl1
PGPN4TMoRfQmaeaPXi8MAFE5jcd9YLQZ3DJpiVV7lfMpl830aPC/doFFDFk8dkGR
IU3RNHgQocIl+Wm8aq+EU9OwKRH/O1bqMOgy4zHJRvlmxSOTyLhiwHFA1xAEJunJ
LKlYg+fRRL1Xz1c7Cn1NoDWUgYvyivgSD8jpPnHLnqZDeNvPv9h8F5Q1H0ajp1Yg
W7/OjeIh4tT1ACUv/L6mj7Goq8a1ng1SACTuLpt1WPanU5mL21PRTZU0vgQtN4Tu
a11zCGlntjfPAbD7s0Kd
=HHzM
-----END PGP SIGNATURE-----

--3VRmKSg17yJg2MZg--
