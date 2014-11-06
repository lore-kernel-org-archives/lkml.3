Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232AbaKFDY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:24:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57016 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbaKFDYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:24:54 -0500
Message-ID: <1415244281.3398.46.camel@decadent.org.uk>
Subject: [PATCH 0/3] i2o: I2OPASSTHRU fix and cleanup
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 06 Nov 2014 03:24:41 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-5DPUFhwPNiTkxP1rnFhb"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5DPUFhwPNiTkxP1rnFhb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

i2o_cfg_passthru() provokes compiler warnings in 64-bit configurations.
A very similar function in the same file, i2o_cfg_passthru32(), does
not.

Comparing the two, I found a DMA mapping leak in i2o_cfg_passthru32(),
missing casts in i2o_cfg_passthru() and some other apparently arbitrary
differences.

This series fixes the leak and then largely merges the two functions.

Ben.

Ben Hutchings (3):
  i2o: Fix DMA mapping leak in failure path of i2o_cfg_passthru32()
  i2o: Define i2o_cfg_passthru() and i2o_cfg_passthru32() consistently
  i2o: Delete the '64bit fix' comments from __i2o_cfg_passthru()

 drivers/message/i2o/i2o_config.c | 286 ++++++-----------------------------=
----
 1 file changed, 45 insertions(+), 241 deletions(-)


--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-5DPUFhwPNiTkxP1rnFhb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVFrp/ue/yOyVhhEJAQrtvA//Wb0qohYiZhxc5eqdDqsYC/snUADnSh9R
mnRBu82EWLajBMnJD98niytr9gluaCm5pO7JLOZhsFqP2IQroeb5OGNVOHRPKo9P
BbAqhlKTTE5RbAEX6YNZ0arN8X2MhaHGOyr6Gg/aQ4S4ZKlzESfdu8V9N4l6T7WL
ahDlWe/t4kHg9cncXXoJ2iiZScafoKP5jDHiSciZoPcOekti+PNOCSIXujLSuWoj
rGQiDdIUh7wJn5HVb3DMtLUvGLiuzAH+DgH8jczSv/pGghOUIaV2ZczqmDbTJxm4
xhUJRcb6+rYqoQJA1GPpe90RJXMTU3q7iPRoScnE7uswX4GRHzs9SiqyuYohSoUc
v5l3Zd4l0TSAUeb+89AwyECv7BH3xiVjO0Rr4e9MvqmqTpdTy+4+uLSFoYusgDVj
oxQ6Ke1aZNN87sa+N4dx7WmyEiT1n2qv4b09vPqYP71Xs3Poqf6+iW6S3wLjwXGB
kzI+qdtuDrCpmZJGiM1kJ48o8dqckF0FNkMLs0MCbddrs737+zsXG9YWDazU5n/V
HL0hSw2I7VFw3noLeIzO1BqITWc/SK0w4IoTAxmAiheUyiB3tDYbVnCmNl7XWm+D
yD1mJjDicOEHE+bn1fWPxH8EziEeAy6aJlXEeY7h1IpE9Z2mjwVoGNGeo3AvvXlD
oo0zAweBLck=
=FsW6
-----END PGP SIGNATURE-----

--=-5DPUFhwPNiTkxP1rnFhb--
