Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaIZINJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:13:09 -0400
Received: from ozlabs.org ([103.22.144.67]:43240 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbaIZINB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:13:01 -0400
Date: Fri, 26 Sep 2014 18:12:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zefan Li <lizefan@huawei.com>, Dirk Gouders <dirk@gouders.net>
Subject: linux-next: manual merge of the cgroup tree with the kbuild tree
Message-ID: <20140926181252.3c7f48b1@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/oNyPL4t1HkyHH3mprh=IBRE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/oNyPL4t1HkyHH3mprh=IBRE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the cgroup tree got a conflict in
scripts/tags.sh between commit a60113d6a7fc ("scripts/tags.sh: remove
*PCGFLAGS regular expressions") from the kbuild tree and commit
e0e5070b20e0 ("sched: add macros to define bitops for task atomic
flags") from the cgroup tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc scripts/tags.sh
index fd651f90a838,293828bfd4ac..000000000000
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@@ -193,6 -193,13 +193,9 @@@ exuberant(
  	--regex-c++=3D'/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
  	--regex-c++=3D'/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/' \
  	--regex-c++=3D'/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'		\
 -	--regex-c++=3D'/TESTPCGFLAG\(([^,)]*).*/PageCgroup\1/'		\
 -	--regex-c++=3D'/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'		\
 -	--regex-c++=3D'/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
 -	--regex-c++=3D'/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
+ 	--regex-c++=3D'/TASK_PFA_TEST\([^,]*,\s*([^)]*)\)/task_\1/'	\
+ 	--regex-c++=3D'/TASK_PFA_SET\([^,]*,\s*([^)]*)\)/task_set_\1/'	\
+ 	--regex-c++=3D'/TASK_PFA_CLEAR\([^,]*,\s*([^)]*)\)/task_clear_\1/'\
  	--regex-c=3D'/PCI_OP_READ\((\w*).*[1-4]\)/pci_bus_read_config_\1/' \
  	--regex-c=3D'/PCI_OP_WRITE\((\w*).*[1-4]\)/pci_bus_write_config_\1/' \
  	--regex-c=3D'/DEFINE_(MUTEX|SEMAPHORE|SPINLOCK)\((\w*)/\2/v/'	\
@@@ -252,6 -259,13 +255,9 @@@ emacs(
  	--regex=3D'/__CLEARPAGEFLAG_NOOP(\([^,)]*\).*/__ClearPage\1/' \
  	--regex=3D'/TESTCLEARFLAG_FALSE(\([^,)]*\).*/TestClearPage\1/' \
  	--regex=3D'/__TESTCLEARFLAG_FALSE(\([^,)]*\).*/__TestClearPage\1/' \
 -	--regex=3D'/TESTPCGFLAG\(([^,)]*).*/PageCgroup\1/'	\
 -	--regex=3D'/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'	\
 -	--regex=3D'/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
 -	--regex=3D'/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
+ 	--regex=3D'/TASK_PFA_TEST\([^,]*,\s*([^)]*)\)/task_\1/'		\
+ 	--regex=3D'/TASK_PFA_SET\([^,]*,\s*([^)]*)\)/task_set_\1/'	\
+ 	--regex=3D'/TASK_PFA_CLEAR\([^,]*,\s*([^)]*)\)/task_clear_\1/'	\
  	--regex=3D'/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'		\
  	--regex=3D'/PCI_OP_READ(\([a-z]*[a-z]\).*[1-4])/pci_bus_read_config_\1/'=
 \
  	--regex=3D'/PCI_OP_WRITE(\([a-z]*[a-z]\).*[1-4])/pci_bus_write_config_\1=
/'\

--Sig_/oNyPL4t1HkyHH3mprh=IBRE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJSAJAAoJEMDTa8Ir7ZwV+hQP/j6E1SC9jfp/oq0DSdXq5MCN
xEn0RNXTv98CUCkC+d+uKTjiyfngIgj8p7UE8GyTFDFU+PQ9WZEFRjd2IXVij3ez
fFSwYlZZiR2q04wVrgIOCXbYQedh5Y5zjNB7DGMofaAwZjKHuNexNdAu2tC6lPT5
VdLKnCeSOmDemFP8GdV3sNqQwAUKaTPXXOzBEcvy+ksknMDxxvZT4w/Y44y0nR/S
dzOw7vwnou8lgHV7NG2q1yO/Ub1JHX7pn4cWMBRcLmWhg2X44uShoT790QXzUj4n
4fk9ic6D1P73p+VoWYIBZ+ifcD8Sm8Ye0Jf81CYr8fRibRKhu2mYxvb0V9JoC5VV
QFae/Ea40F9a4Rrn2JgiX/dRoDkFrrajJt8oYYR7OaFPCKuVnp+GfD+rBwjnNQEc
QQxlLW3dWYHiX1H84KgeX+K6iPZSQNMsGgAyEyUT4BCnQTWkhftby5qtd6dp9Iu1
FB6uEymcQ0ANRXb7auDW+rVEXU+c4OPN8WgN7GhrCW9RrW03witCBFd4FVPYcSjZ
NNZlpHy25/gTES/xXhGSq0ajvDTqHKBu2DUT43rstiVC5NvPpG6Ca7JX0/WuFhv7
0iNEgpCi7aoknhrzjJigC8HG354f4Vp7z5XSMgTRTlbiFu6bigdsDN89lx9wMxzN
0iRj74QYwl2Hr2WFFE31
=BIXw
-----END PGP SIGNATURE-----

--Sig_/oNyPL4t1HkyHH3mprh=IBRE--
