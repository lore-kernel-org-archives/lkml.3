Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbbA2BZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:25:43 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38394 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859AbbA2BZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:32 -0500
Date: Wed, 28 Jan 2015 15:24:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Steve Capper <steve.capper@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20150128152412.GX21293@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="TVvFCdSJ1YJh/5iY"
Content-Disposition: inline
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Hangs in libhugetlbfs tests in -next
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TVvFCdSJ1YJh/5iY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

For at least the past couple of days tests of libhugetlbfs have been
hanging on mustang in the mlock test running ARMv8 defconfig with both
32 bit and 64 bit userspace - after the mprotect test (the one before
it) we get no console output for several hours so it appears that the
test has deadlocked.  The tail of the log is:

| find_path (2M: 64):	PASS
| unlinked_fd (2M: 64):	PASS
| readback (2M: 64):	PASS
| truncate (2M: 64):	PASS
| shared (2M: 64):	PASS
| mprotect (2M: 64):	PASS

and then a timeout.

This may be a generic bug but my ability to run these tests on other
platforms with huge page support using the infrastructure I'm using is
limited so I've not been able to test elsewhere and confirm.

--TVvFCdSJ1YJh/5iY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyP8cAAoJECTWi3JdVIfQxvcH/3eS6/TEKm3fn5zqMhoxZvPy
TuLAm96/ve1oWtxpS/JMDvTJGxTKpDlKfAyZ5aALoJ4J/ayn4gBPGkLDucpn73PD
H8M6GOj3XyfVS9N/I1EVQ8W1InTnA1WzGNIqppA47QR2P9PrwAWCOCbAUyQ0cXA7
SBRHf8HtX91KUPReHa06puXVjnoFHqojd1ibrjBDarHhZrKRbF4+wm+WHIB3ncMI
N6NPa632/tcbCnJCF0oSe9gPskW48Aqq89ofw9MdD4qyvp1LdEd8gAJJcNyItRJB
GTtX2M+XiKe43nrboUalrvJXQe9bygjSgS6yumOa9qakWviMp/53/27ubQLCWjw=
=4qPx
-----END PGP SIGNATURE-----

--TVvFCdSJ1YJh/5iY--
