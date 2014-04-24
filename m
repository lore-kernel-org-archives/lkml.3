Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaDXDBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 23:01:35 -0400
Received: from ozlabs.org ([103.22.144.67]:47177 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbaDXDBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 23:01:33 -0400
Date: Thu, 24 Apr 2014 13:01:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stratos Karafotis <stratosk@semaphore.gr>
Subject: linux-next: build failure after merge of the mfd-lj tree
Message-Id: <20140424130125.ab69302dfcfe73dc51a89809@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_Apr_2014_13_01_25_+1000_WqIGc2=I5SieD4tf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Apr_2014_13_01_25_+1000_WqIGc2=I5SieD4tf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lee,

After merging the mfd-lj tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

drivers/mfd/db8500-prcmu.c: In function 'round_armss_rate':
drivers/mfd/db8500-prcmu.c:1744:2: error: implicit declaration of function =
'cpufreq_for_each_entry' [-Werror=3Dimplicit-function-declaration]
drivers/mfd/db8500-prcmu.c:1744:52: error: expected ';' before '{' token
drivers/mfd/db8500-prcmu.c:1738:7: warning: unused variable 'freq' [-Wunuse=
d-variable]
drivers/mfd/db8500-prcmu.c:1752:1: warning: no return statement in function=
 returning non-void [-Wreturn-type]
drivers/mfd/db8500-prcmu.c: In function 'set_armss_rate':
drivers/mfd/db8500-prcmu.c:1895:3: error: expected ';' before 'if'

Caused by commit 2eb3cfd03d60 ("mfd: db8500-prcmu: Use
cpufreq_for_each_entry macro for iteration").

I have used the mfd-lj tree from next-20140423 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__24_Apr_2014_13_01_25_+1000_WqIGc2=I5SieD4tf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTWH6KAAoJEMDTa8Ir7ZwV7OIP/3rO6ouSbAjgQuJpJksB/8zP
QtN2qVipJVVJ4OUD0arpU8WFdOFh1CDVv1Sz9+GedfdnzDPPgf6t8ywWCYZvEsBV
xP5XicW4WlJKS6Tjd4P0Unx/LIQUKyQ6gNUR/TLh+LxeLCCS1sV/HX2Pc2Whlxcy
EuBEr3HjFLlc8Pk2nftQAV/NpdcqUT4Nvsc2Lb8qUHMeV0hOCRQB/InUWDg+Ah4t
0EThPmgRtLcpmdNuh6GRnx40Awj2ikhMZvf9OMUYDRLb6Slw8k8mv9xFHonjhTle
j1eLcEzhltKR3/vbkHLqZwqTlXpdidMZNrGcVUU6Iu+NxmYgL0APAhgEi00cTMO1
nLc+Q6gYsdONv+2nAcuhLEgmbZvoKWgfnMEyeiGBRfwv33crb/XUUG7swDcA/yAH
+lI7euN0u+5l0ez1417RoJQykIwcG5PckWv1PAXtxMXKZmEK+gtLSs//rsnGZpf3
qoqt/F8dY5fBTlq4jD2mENjxf52J6ix5gJ4BwviJnk6rkuLjb1IQV3rjVChowKGL
wFaY653QcdCeVeNULI12mtKVO5drzIP0BlXGFD/L2ikbPljED5y5wgUA2/0hKX5O
aO+BepwOXEfGrH3gQ9jZTQmfYPBQAd5cOuHO0xNqIJHubjYHMZLp+jnHA2JmIlIl
dYAPTN6QIek/kVIq2hgK
=tws5
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Apr_2014_13_01_25_+1000_WqIGc2=I5SieD4tf--
