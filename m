Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3A1Kyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:54:51 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52420 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3A1Kyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:54:49 -0500
Date: Mon, 28 Jan 2013 21:54:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: manual merge of the char-misc tree with the sound-asoc
 tree
Message-Id: <20130128215444.98524bf94e5fcd2035833055@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Jan_2013_21_54_44_+1100_nRVQZEZBL__E3VMD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Jan_2013_21_54_44_+1100_nRVQZEZBL__E3VMD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the char-misc tree got a conflict in
include/linux/mfd/arizona/pdata.h between commit c94aa30edac4 ("ASoC:
arizona: Allow number of channels clocked to be restricted") from the
sound-asoc tree and commit 92a49871b378 ("extcon: arizona: Support use of
GPIO5 as an input to jack detection") from the char-misc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/mfd/arizona/pdata.h
index ec3e2a2,bcbe4fd..0000000
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@@ -98,13 -96,15 +98,22 @@@ struct arizona_pdata=20
  	/** Pin state for GPIO pins */
  	int gpio_defaults[ARIZONA_MAX_GPIO];
 =20
 +	/**
 +	 * Maximum number of channels clocks will be generated for,
 +	 * useful for systems where and I2S bus with multiple data
 +	 * lines is mastered.
 +	 */
 +	int max_channels_clocked[ARIZONA_MAX_AIF];
 +
+ 	/** GPIO5 is used for jack detection */
+ 	bool jd_gpio5;
+=20
+ 	/** Use the headphone detect circuit to identify the accessory */
+ 	bool hpdet_acc_id;
+=20
+ 	/** GPIO used for mic isolation with HPDET */
+ 	int hpdet_id_gpio;
+=20
  	/** GPIO for mic detection polarity */
  	int micd_pol_gpio;
 =20

--Signature=_Mon__28_Jan_2013_21_54_44_+1100_nRVQZEZBL__E3VMD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRBlj0AAoJEECxmPOUX5FEbvYP/Axcj+/0gscaNZyFdBopzjVL
vW48YudJ4f4bTIBnA3b3nl8X4Q9TPLXOfn6W2YBMZtTEY7vWFqJ7ig+zT9aXGOTJ
uPrbbZ9jD/xMg6DfmnQpLMuy85Vs1nkkt3dU79V7JPJUIjeTuitPDFECj/ieLIQt
1a2dnylc6h7dXxpvUJquHsHAqZhdxfBNhVab/FtTjjMlclvZmAUxE8uE25SexuHT
fQhc1O4UMb+/IOnuLpeS1aeMn68BPv/lM8SX2qJ9IDmzfd1JvyV/lcpBziNM477L
2gMqCkw18aF66rJ7muhQIBtbwHCgEnxL6l7efDW5r2PPEtaGsEdoAHEZ4fTboMd0
hhJsQ05K75KFvg4M7pV0HsARnD5WRPPjFGg8EDyzwtQhyucNubpbJpAi6hQLMm2t
QhkgE0mB90c1KsiQgIcbWMYrao4H95iOkUxApgFqlzhPQ818IQWN7kKPgqCUyeal
XVYGnnmiGd4F5xEF4D9y0mw14sFO+BOXMEAYManbfXZ3yqjhtfeEN5CgenxA3aSp
K2e2v/O9Bz2SfK1OXIS1wJqW7dc4+4bSqSFIJLTo8/EDKTV2GCOTap/PJCFFlInQ
D2uba4esqHKOcwMXAeGlDPqt+Ov+5JWvV3OinoOrm/c6SMK2WPFuqoAe3UjqUrMT
IMAckWh9ie/9ZmPKe1Mz
=S4rE
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Jan_2013_21_54_44_+1100_nRVQZEZBL__E3VMD--
