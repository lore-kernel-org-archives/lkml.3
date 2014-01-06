Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbaAFDO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 22:14:29 -0500
Received: from ozlabs.org ([203.10.76.45]:59880 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaAFDO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 22:14:28 -0500
Date: Mon, 6 Jan 2014 14:14:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: linux-next: manual merge of the thermal tree with the pm tree
Message-Id: <20140106141419.308086b992aae2e1ee729f6e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Jan_2014_14_14_19_+1100_FSssg9Z_+jnm+CQ+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Jan_2014_14_14_19_+1100_FSssg9Z_+jnm+CQ+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Zhang,

Today's linux-next merge of the thermal tree got a conflict in
drivers/cpufreq/Kconfig between commit 109df086e002 ("cpufreq: Select
PM_OPP rather than depending on it") from the pm tree and commit
77cff5926a14 ("cpufreq: cpufreq-cpu0: add dt node parsing for cooling
device properties") from the thermal tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/cpufreq/Kconfig
index 386dbc9ccdfd,6b8cde5f98af..000000000000
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@@ -181,8 -181,7 +181,8 @@@ config CPU_FREQ_GOV_CONSERVATIV
 =20
  config GENERIC_CPUFREQ_CPU0
  	tristate "Generic CPU0 cpufreq driver"
- 	depends on HAVE_CLK && REGULATOR && OF
 -	depends on HAVE_CLK && REGULATOR && PM_OPP && OF && THERMAL && CPU_THERM=
AL
++	depends on HAVE_CLK && REGULATOR && OF && THERMAL && CPU_THERMAL
 +	select PM_OPP
  	help
  	  This adds a generic cpufreq driver for CPU0 frequency management.
  	  It supports both uniprocessor (UP) and symmetric multiprocessor (SMP)

--Signature=_Mon__6_Jan_2014_14_14_19_+1100_FSssg9Z_+jnm+CQ+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSyh+PAAoJEMDTa8Ir7ZwV8igP/0QwbpYRb7dlbcOB8kgR7MVQ
qmftoCseg4lWLbneJMY2/RbrTq0Vcs+nhs1mCOQSyIhJfxMjDNyPLxY2nTFiWUUI
Dh+ehL/xE8rsw2l0H7X2Z+JpLaUGt7PWfSostqNbHAt/plbIj1STK7lM1T0kTNrA
s31U6eHFw/6ts0gqgyKamewabw2Tbas1iw5pRY+TU3RTAHK0SNvEM9fqpiu7dGSu
wi3jfTsxPytPD9mPqB1624IbCYvYJPU9T4tnNSBHC5wJMZ9J70bmo4S3fYbnaMa4
M1IQbTrIv4BDNXlWG9sPkPXTaNR0M6k+9LHTwU7OApYYTzvGP6DYQYyPi02DsoV4
plSXdaOES5Qmn687dTJjX5uE8Xpqll6rEuG234nCF4L95iqmSnpFi1MLgI8Loo7z
ceXH44tggiQPwbH7J79vERS4tMiy/SlJVz3it6yhKel5opo+XFIx8S81LnxnoHAX
AN4SW+M+3iecaCNAqz7/zuu2sxZlfz4BlMlOqJ7n+V+tK2ntovDNScxqN1E2eYdJ
0EogCYccOYM3pBr4+31QyvG45OEH5+39PF7EobhI7xpJsTN0gNDwTBUI69yh6GjR
wzbKz4htCwEKckPrzj5Ei+Yt0xEeCAhQBoIyTlFOOA05oO2HFoxF3ngo8m4lB4GM
I2Iv6u2PDA1PO6gAACA4
=uVRF
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Jan_2014_14_14_19_+1100_FSssg9Z_+jnm+CQ+--
