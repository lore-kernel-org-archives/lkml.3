Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3A3LOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:14:32 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35059 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab3A3LO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:14:29 -0500
Date: Wed, 30 Jan 2013 22:13:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Johan Bjornstedt <johan.bjornstedt@stericsson.com>,
        Henrik Solver <henrik.solver@stericsson.com>
Subject: linux-next: manual merge of the battery tree with Linus' tree
Message-Id: <20130130221357.bf022183e79305f38613b524@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__30_Jan_2013_22_13_57_+1100_qdzJ.Ow/K7fAq2E8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Jan_2013_22_13_57_+1100_qdzJ.Ow/K7fAq2E8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anton,

Today's linux-next merge of the battery tree got a conflict in
include/linux/mfd/abx500/ab8500-bm.h between commit 00441b5e6b98 ("mfd:
Fix compile errors and warnings when !CONFIG_AB8500_BM") from Linus' tree
and commit 3988a4df3499 ("ab8500_bm: Skip first CCEOC irq for instant
current") from the battery tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/mfd/abx500/ab8500-bm.h
index 9bd037d,e2a1e6d..0000000
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@@ -437,8 -438,38 +441,13 @@@ int ab8500_fg_inst_curr_started(struct=20
  int ab8500_fg_inst_curr_done(struct ab8500_fg *di);
 =20
  #else
 -int ab8500_fg_inst_curr_started(struct ab8500_fg *di)
 -{
 -	return 0;
 -}
 +static struct abx500_bm_data ab8500_bm_data;
 =20
 -int ab8500_fg_inst_curr_done(struct ab8500_fg *di)
 -{
 -	return 0;
 -}
 -static void ab8500_fg_reinit(void)
 -{
 -}
 -static void ab8500_charger_usb_state_changed(u8 bm_usb_state, u16 mA)
 -{
 -}
 -static struct ab8500_btemp *ab8500_btemp_get(void)
 -{
 -	return NULL;
 -}
 -static int ab8500_btemp_get_batctrl_temp(struct ab8500_btemp *btemp)
++int ab8500_fg_inst_curr_started(struct ab8500_fg *di)
+ {
+ 	return 0;
+ }
 -struct ab8500_fg *ab8500_fg_get(void)
 -{
 -	return NULL;
 -}
 -static int ab8500_fg_inst_curr_blocking(struct ab8500_fg *dev)
 -{
 -	return -ENODEV;
 -}
+=20
  static inline int ab8500_fg_inst_curr_start(struct ab8500_fg *di)
  {
  	return -ENODEV;

--Signature=_Wed__30_Jan_2013_22_13_57_+1100_qdzJ.Ow/K7fAq2E8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRCQB1AAoJEECxmPOUX5FEZJoQAIyTmMg/H/N87PB99tJqYlD2
2h5G2dIHPAMc2XW7yOwitOJNy3EfgwK9UZjcPY9hC0b1ePvQEDBMI1Ol323zmKny
V3IgiNaSpgbVTNvkU2INGdBYj0m7QbC15oRXSd9aHPx+vDOrhHD8uZgYu0BEWs7V
woFPdaS4fYL4Q4h8tZ62vMz5eciZDnK+Xg8sf2l2a0ayQEQosutilRSrjHN1W8UR
v3GtnY+uHQWEhcgnx0CI/p1HzeMxS9nd16JKxKWa64c4Tz96L3f3+HkTT8J7KEup
gcFN0hsGggtqzwjrDSYcahWd0RlJd5H67xsdLDSdEw9zejCUeHfQzxbaAaLmzep/
1DxLP3tLO7dZKZM+h2rjedJYS9Ax9sWMT6JconZ0/B0V1oj0wUYNkVzwF3mLV+cu
qcHUNVY1OGTPjZwZreuk2df+BgYIEeSgltmVnoXaS37vVMnA0au+X5rXLUlwRITh
kIbsMNU2fyi+xalVtFRjWUEKyWOsbyBuw++4UHA/h0ky6qabX6oBngR+SWRfL8sa
2EvTjuBAFXNqbQsueBxO5qWaxrCRvssRoP2C0UNYIAZ0eSuRa0uvsEE7EgCD6amV
EYKJLs3PPkqfytcPProq6Lp5uCd7oAtbROJZ1BcHXl83ji6DJy/ktmwIzlWZvwg1
ESbVReZ7Ya0/D+389FP+
=gIYP
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Jan_2013_22_13_57_+1100_qdzJ.Ow/K7fAq2E8--
