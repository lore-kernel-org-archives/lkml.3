Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbaCLAwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 20:52:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52030 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984AbaCLAwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 20:52:04 -0400
Date: Wed, 12 Mar 2014 00:51:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg KH <greg@kroah.com>, Stewart Smith <stewart@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__12_Mar_2014_00_51_52_+0000_d4BWeWPHZp.pHIYy"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: build failure after merge of the driver-core tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Mar_2014_00_51_52_+0000_d4BWeWPHZp.pHIYy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build ()
failed like this on a PowerPC defconfig:

HEAD is now at ceb98e684dec Merge remote-tracking branch 'driver-core/drive=
r-core-next'
  GEN     /home/broonie/next/powerpc_ppc64_defconfig/Makefile
#
# configuration written to .config
#
/home/broonie/next/next/arch/powerpc/platforms/powernv/opal-elog.c: In func=
tion 'elog_ack_store':
/home/broonie/next/next/arch/powerpc/platforms/powernv/opal-elog.c:84:2: er=
ror: implicit declaration of function 'sysfs_schedule_callback' [-Werror=3D=
implicit-function-declaration]
  sysfs_schedule_callback(&elog_obj->kobj, delay_release_kobj,
  ^
cc1: all warnings being treated as errors
make[3]: *** [arch/powerpc/platforms/powernv/opal-elog.o] Error 1
make[3]: *** Waiting for unfinished jobs....
/home/broonie/next/next/arch/powerpc/platforms/powernv/opal-dump.c: In func=
tion 'dump_ack_store':
/home/broonie/next/next/arch/powerpc/platforms/powernv/opal-dump.c:100:2: e=
rror: implicit declaration of function 'sysfs_schedule_callback' [-Werror=
=3Dimplicit-function-declaration]
  sysfs_schedule_callback(&dump_obj->kobj, delay_release_kobj,
  ^
cc1: all warnings being treated as errors

due to an interaction between d1ba277e7988908 (sysfs, driver-core: remove u=
nused {sysfs|device}_schedule_callback_owner()) and 774fea1a38c6a5a8 (power=
pc/powernv: Read OPAL error log and export it through sysfs) from the Power=
PC tree.

I reverted 774fea1a38c6a5a8 for today.

--Signature=_Wed__12_Mar_2014_00_51_52_+0000_d4BWeWPHZp.pHIYy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTH6+oAAoJELSic+t+oim9k44QAJwAVNHXmKC+BQ4CwzyM809r
cTiQNjh303o/KsNgRRouzPfK3B2yIDxpntja2uX5ML2v/+XRJ+bTxGdscLAlNqr4
3J2DLL4OIeCaSZ3sBl9gdRR5ZKARur4tkWjZInb7m7fmk8R9gbgBQPFu9bfPoLVx
nzdkVNtOVZ171fpvrlH5AVum/BX2PW/sasAhvlWmAQcgsM341wgdBIts0OE0uuK/
m89bfGflrDfIld5kYLx3Y93QB/izxYjSdtNqEMBAkvw39AdIN6lz66hfkkXsGgh6
70MuTY4qLca4ebs/Cu4iwJZ4ziT8/vj0OjrWlfhumD5/xMyMn3t20i0Gr9Gcmm8X
82cx1exTVtOCkEi9meIpr1Myyhvat1d6KqxC1tTmDgCYsXpEip3KXC2rhnr5Q570
A2qKZlySO17eYDh6sQ79ahtpocJ8xH3f54bBySuchb2/kK0qiMoYrVLP0L1NjsUG
mXI30QdM0PEckKuGTjwg9cCvzEYACHUIaD+mVPijmwh5HOOUQ2v7hIIhNCOsE520
Wfq7m3AjcJZ6bAonZ7NgA19UtU962vomyKWjqSdf0O33Gm5zbp/i8mtNHON3ramn
9B/gn8vxI0tgdJsLkWXIxWeNsNSsuHfpw7aU7hXNdbryB6melu/B6FMSHOUYPG1r
oH8NYZ4xgMyNskipmKDo
=wHEN
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Mar_2014_00_51_52_+0000_d4BWeWPHZp.pHIYy--
