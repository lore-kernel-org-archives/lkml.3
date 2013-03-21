Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab3CUCN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 22:13:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36473 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab3CUCN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 22:13:57 -0400
Date: Thu, 21 Mar 2013 13:13:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20130321131347.68a5a8d7d46c8baf28fe5353@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Mar_2013_13_13_47_+1100_SIANF5WdYIupyo2g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Mar_2013_13_13_47_+1100_SIANF5WdYIupyo2g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/mfd/wm5102-tables.c: In function 'wm5102_readable_register':
drivers/mfd/wm5102-tables.c:1172:7: error: 'ARIZONA_SPK_CTRL_2' undeclared =
(first use in this function)
drivers/mfd/wm5102-tables.c:1172:7: note: each undeclared identifier is rep=
orted only once for each function it appears in
drivers/mfd/wm5102-tables.c:1173:7: error: 'ARIZONA_SPK_CTRL_3' undeclared =
(first use in this function)

Caused by commit 7b00b5ecd312 ("mfd: wm5102: Add additional speaker
control registers").  Missing change to an include file?

sound/soc/codecs/arizona.c: In function 'arizona_init_spk':
sound/soc/codecs/arizona.c:205:28: error: 'arizona' undeclared (first use i=
n this function)
sound/soc/codecs/arizona.c:205:28: note: each undeclared identifier is repo=
rted only once for each function it appears in

Caused by commit 6f384ccffdf0 ("ASoC: arizona: Log thermal events").

I have used the sound-asoc tree from next-20130320 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Mar_2013_13_13_47_+1100_SIANF5WdYIupyo2g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRSmzbAAoJEECxmPOUX5FEU9UP/Reg9Eu23tVahVjRVEHJseFS
w+oL2GCA557a+xyT2MFRf4AQ8IMQSM6IEfy6dEa2L1DpQPNN4BMQcEautT3WH7sG
0CXRAfLIgswoFunI3or0JQeIK0a1xCNWKbtOWsO9AhUOhtrEfs/I+BUyqmJJhEjg
Bru/Vs3rmVsBPOlwMA3F+mArabDf+J2b77Zw+JrTOH9Rfzp+eBkju2Tp+yBacaqW
JPpq42tMZrQnajoQxs9dnbZL1+nTIMtkPeUk3KBO90s8RV9iphvsp393OqU80+7Y
kR9GUDiTU6Sg+lQPpltmHD8DPOlxDO3fgTaOjnadzd7GSTs3H6qQTFxWuZU8wsCS
ZOw/n9DuypwM9W8KtNhRqKE2nKN7kmyhfAd1j/sMla74CBCI8JB4DYXtmq9FTgmP
lwUqB8YvHHtjB9lVSQuXSAWc7tJdrSY4v6mEjScZ0PKD6+BHo7fpbFwotXIabyt/
FuXvRMriFPn2dbnDqpP4F4HmLM4q5BrQZ/3asan/572LOmeRNBLZBy/2yye7hwGi
O8rH1JHr4al/VSBJRK2TiQ//P00Fq467bhESIB4RTxqWOCkCP6K2UHVK+y4mObYO
uz04cSwxge+02/29EGuBDDumNvhz6bbziVuCXItd+nQxfoLdcNJkGTRHZYjr4DQr
tq55euSaGTjxRYaYmPr7
=bYnC
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Mar_2013_13_13_47_+1100_SIANF5WdYIupyo2g--
