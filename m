Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbaA1QOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 11:14:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60655 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaA1QOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 11:14:45 -0500
Date: Tue, 28 Jan 2014 16:14:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jon Medhurst <tixy@linaro.org>, Alexandre Courbot <acourbot@nvidia.com>,
        stable@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140128161428.GO11841@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K4JQQuyuIggLcvtH"
Content-Disposition: inline
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Possible stable fix for decompressor speed
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K4JQQuyuIggLcvtH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The changes in patch 1431574a1c4c (lib/decompressors: fix "no limit"
output buffer length) avoid doing decompression a byte at a time when
decompressing into high physical addresses using a small, well isolated
change.  The patch can give a very noticable improvement in kernel boot
times on affected systems, for example with one ARM system this reduces
the total time to boot the kernel by more than a third.

Would you consider this patch for stable?  It doesn't quite fit within
the criteria but you've indicated in the past that such isolated and
well supported changs can be acceptable anyway.  If it's not OK for
stable it seems like it should be a good candidate for LTSI.

--K4JQQuyuIggLcvtH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS59dhAAoJELSic+t+oim9hVAP/31TXXsoTb6DN6Syv5cJiT49
YKwiuPAuImuPkp8rI9otH3scCDjx2oesJBl6f+WHVqkyRgZqL6cswBC81qqd6Sgm
CCBlTw6G0nWfMLDP76MlobaZVavs83vKX/dMviUwnvpqeKX2rJl6ApKpQs8hfWxd
gbr2+Ru6wQ2YHdp3Wiy6E/OiQhRiEwGOhWGyLRFltPb+10vjcIiFBA73CG484sFX
7oCKq0iLHTN2y1RJZO/ZWwAgVLZQSdpqqHGCI/haHZ988TTIlY0b5m/yBn2FAWWy
S3/GrbjibJTs3E/U8kI/hDHpSuI9xqSDVQD/uZhY3nUdAk+IpNb4rK+YicHGfgsc
tkEJiYPmjQNKWZ/r85Vg0sxXw4mI4+6KzCqTH8YTrk3ewh4CxQ21yuYC9MFTZmNY
Gzy5yV+DOl4Ffk5ANrIYxzOVgrJvanaeXUQLmklgJqcg2HK63/Ae7jg0o7lc0d0f
zTn0YHWE0nHW3RqLZvkafaEWHjYbRT736+8BjPU4r8srem+840UuIXvzy5hQnK7+
r2kWIPHzBSbyUdluvpAoWLMa5B2sUudzOPgnRam4ybVh+sqf8CKdDcYfdFfcyuG2
qBh3xVNthl257+wcRmini+giDfcFJt38S4iGL6mik6x1TTXzXKlVTYXlyOnM5zwH
/m9IzhI8RPxwaJ8FS+3L
=mx9F
-----END PGP SIGNATURE-----

--K4JQQuyuIggLcvtH--
