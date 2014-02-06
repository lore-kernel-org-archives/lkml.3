Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaBFA7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 19:59:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56511 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753529AbaBFA7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 19:59:39 -0500
Message-ID: <1391648361.3003.97.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 0/3] Fix perf build breakages in 3.13
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 06 Feb 2014 00:59:21 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-+fBz8e2dwyHGXbhWH/GA"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.239
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+fBz8e2dwyHGXbhWH/GA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

perf no longer compiles on powerpc and sparc due to changes in the trace
sub-command.  This series fixes those compile errors; I compile-tested
in Debian sid on armhf, i386, powerpc and sparc.

I would much prefer not to revert the tty ioctl decoding but I think
it's going to take a much more sophisticated approach to do it right
across all supported architectures.

Ben.

Ben Hutchings (3):
  Revert "perf trace: Initial beautifier for ioctl's 'cmd' arg"
  perf trace: Add fallback definition of EFD_SEMAPHORE
  perf trace: Decode architecture-specific signal numbers

 tools/perf/builtin-trace.c | 48 ++++++++++++++----------------------------=
----
 1 file changed, 14 insertions(+), 34 deletions(-)


--=20
Ben Hutchings
It is a miracle that curiosity survives formal education. - Albert Einstein

--=-+fBz8e2dwyHGXbhWH/GA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUvLeaee/yOyVhhEJAQpAgBAAustemqnLFnGrq/81XD5Q6qpAV1ibPrcK
VDXF2ek90bO9aGdq0qs71YUuWaRkpEcZnLq7MIZBg6nG45akksUBUN3tX30cLaVQ
48iNb7QckI4YDHL8oIeBfn66qDmEIOKF9QPSTgZ25pUUcqY1f72m/hKXJOYQiAdN
qehXOgJL0mHOwSzy9QE7d8u9nHLhetoKF9wqEsQw5viFro0BwHSbHbT1XJwxgmfh
yHQmUrvqhl4XKkNGbXQ3poBV7lRKB15fAe7S5k5IZ/T7LKqf2dezBz832EVsLFzq
G4mugPHNcW0ULUoktJtMZdwtMRGxY6HTwb/cSZ6su6N2L2ou0UD3pIeq3CzwcYxl
lF0PIifmiM/GAGhzfLc5p6jvXvW3/yuHILplOx+0vB+D6Uypl3xglUr5gWeb9t8H
XacWHsGI6MYh8PPjmnPVYYLkyYdgGnfaiNuDRROQZWLqymbBLXu7PVpo+rmikLLq
C3qG2g9H3r5j2ljhyZ79M3SBigtoDottqAByHApqgDwInKDckuRWXEBjLSmx5Mvc
ZIlF+9WWWU6fdKRy8y+J541R1bMsgSPPwuc7cW122j42wCFnk6AFojOL+GIMmWHy
eGEX7WzaaDG/PaYSEuwcP1sPNmHjjy20DiP3HuE02zhZkLvHCtq4/RUyNbDISGZ4
p8JXvJttRrI=
=dQ2r
-----END PGP SIGNATURE-----

--=-+fBz8e2dwyHGXbhWH/GA--
