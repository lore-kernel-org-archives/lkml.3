Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab3BFDbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 22:31:32 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58494 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab3BFDba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 22:31:30 -0500
Date: Wed, 6 Feb 2013 14:31:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: manual merge of the battery tree with the mfd tree
Message-Id: <20130206143120.73c66ac3eadced968f9dd2d5@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Feb_2013_14_31_20_+1100_GqgnwCrUi5DaqXOx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Feb_2013_14_31_20_+1100_GqgnwCrUi5DaqXOx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anton,

Today's linux-next merge of the battery tree got a conflict in
include/linux/mfd/abx500/ab8500.h between commit 1d843a6c8c20 ("mfd:
ab8500-core: Allow the possibility to dump all AB8500 registers") from
the mfd tree and commit 0ed5107fa860 ("ab8500-charger: Do not touch
VBUSOVV bits") from the battery tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/mfd/abx500/ab8500.h
index fa7173d,b9a6a84..0000000
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@@ -345,12 -346,23 +350,32 @@@ static inline int is_ab8500_2p0(struct=20
  	return (is_ab8500(ab) && (ab->chip_id =3D=3D AB8500_CUT2P0));
  }
 =20
+ static inline int is_ab8505_1p0_or_earlier(struct ab8500 *ab)
+ {
+ 	return (is_ab8505(ab) && (ab->chip_id <=3D AB8500_CUT1P0));
+ }
+=20
+ static inline int is_ab8505_2p0(struct ab8500 *ab)
+ {
+ 	return (is_ab8505(ab) && (ab->chip_id =3D=3D AB8500_CUT2P0));
+ }
+=20
+ static inline int is_ab9540_1p0_or_earlier(struct ab8500 *ab)
+ {
+ 	return (is_ab9540(ab) && (ab->chip_id <=3D AB8500_CUT1P0));
+ }
+=20
+ static inline int is_ab9540_2p0(struct ab8500 *ab)
+ {
+ 	return (is_ab9540(ab) && (ab->chip_id =3D=3D AB8500_CUT2P0));
+ }
++
 +#ifdef CONFIG_AB8500_DEBUG
 +void ab8500_dump_all_banks(struct device *dev);
 +void ab8500_debug_register_interrupt(int line);
 +#else
 +static inline void ab8500_dump_all_banks(struct device *dev) {}
 +static inline void ab8500_debug_register_interrupt(int line) {}
 +#endif
 +
  #endif /* MFD_AB8500_H */

--Signature=_Wed__6_Feb_2013_14_31_20_+1100_GqgnwCrUi5DaqXOx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJREc6IAAoJEECxmPOUX5FE0wQP/iUBeEhj1tLRPNA5Q7Wi31XG
E+YJHI5REQJaWnmX/LrMOXB1utbtwkG3HdKB+3tl3hf2kqvLjq6sDVormw4n2UUW
Q465Fatdh87SsUHGGLoo0fdSCxnLR/9FgV1gEWZi/Asp5845GxtrLkOUg3eXoGZO
lWLKNoKldgzAk0PxQjVPxK5Gy4fYBKB2wX0XSDxknoaUYl5yQwt4Jqm54JEWmycC
qBv16zJqNmIlQJagIPs8c+ETV2zPrwAsvE9mX764ywcBeuFMqqc3+sUCfBOqwRF2
ry1mU2GuddDn2lIalXS2qceq4hdLb7z5UixmQi757lR8kNtNGcHMetRrNfColfwn
qNRXzdJjqFY2LdmsA8FHqzz2uYoHVlnrSUwJm+//68Vqv10UVsI9CzKYhGk3xuRP
vsHkyr1ruWgC2vbu2gupYhRwPX4QPb42vdl0df8ri7wOzJp4bKOrjMoGByPh45l4
lf8D1QKtN/Z7EMf5Ur9HTx3inyVks/rbjcJ64QUXpRr4WfWJApeFI+Bex9LJ1Jke
uh4uGbW2bS8CFULLtubK+d5K0ygyEY0yWtqA71/8MZYcS5CVkDbWkfBIdePU2el2
LxA0Ij0V2RX9AhAyj5YmG0fqDIanXRYNnXtKeuVmaGXqvojM8zR647Q6sd5jWfgS
poCd48+9XdtpwJwTzhEZ
=Xtdn
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Feb_2013_14_31_20_+1100_GqgnwCrUi5DaqXOx--
