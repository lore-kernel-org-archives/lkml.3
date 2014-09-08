Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaIHGl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 02:41:26 -0400
Received: from ozlabs.org ([103.22.144.67]:51629 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbaIHGlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 02:41:24 -0400
Date: Mon, 8 Sep 2014 16:41:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheng Liu <wenqing.lz@taobao.com>
Subject: linux-next: manual merge of the percpu tree with the ext4 tree
Message-ID: <20140908164114.262bb178@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/+kQfF.xFU4/IgZ2W1GuD4Q9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+kQfF.xFU4/IgZ2W1GuD4Q9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the percpu tree got a conflict in
fs/ext4/super.c between commit eb68d0e2fc5a ("ext4: track extent status
tree shrinker delay statictics") from the ext4 tree and commit
908c7f1949cb ("percpu_counter: add @gfp to percpu_counter_init()") from
the percpu tree.

I fixed it up (the former removed a reference to percpu_counter_init)
and can carry the fix as necessary (no action is required).

That commit also added two references in fs/ext4/extents_status.c (thus
proving that modifying a little used API causes it to be used
more :-)), so I added the following merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 8 Sep 2014 16:25:46 +1000
Subject: [PATCH] percpu_counter: fix for ext4 updates

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/ext4/extents_status.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 09fd57667262..3777f7eda5cf 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -13,6 +13,7 @@
 #include <linux/list_sort.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/gfp.h>
 #include "ext4.h"
 #include "extents_status.h"
=20
@@ -1189,10 +1190,10 @@ int ext4_es_register_shrinker(struct ext4_sb_info *=
sbi)
 	sbi->s_es_stats.es_stats_cache_misses =3D 0;
 	sbi->s_es_stats.es_stats_scan_time =3D 0;
 	sbi->s_es_stats.es_stats_max_scan_time =3D 0;
-	err =3D percpu_counter_init(&sbi->s_es_stats.es_stats_all_cnt, 0);
+	err =3D percpu_counter_init(&sbi->s_es_stats.es_stats_all_cnt, 0, GFP_KER=
NEL);
 	if (err)
 		return err;
-	err =3D percpu_counter_init(&sbi->s_es_stats.es_stats_lru_cnt, 0);
+	err =3D percpu_counter_init(&sbi->s_es_stats.es_stats_lru_cnt, 0, GFP_KER=
NEL);
 	if (err)
 		goto err1;
=20
--=20
2.1.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/+kQfF.xFU4/IgZ2W1GuD4Q9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDU+QAAoJEMDTa8Ir7ZwVbCIP/1djJ3itqnb7r2qtLkGlgHNf
33rcaeRReP+8InsiSILxZTtO1AL8yPQs+vxdNfnf4z2ho7T4tpFsJCFwV/ieiTfx
3j8acFliN/h6QdaHtnH+1uaDFO0Te1FHBjiSBGrGEoILhrWdGxvXRa2mXRjRoQJE
MJATjsEAJYbeEo49udL8q5sK3u6cUCNajfG3iRjEHUC53Lp8JvwU8GOHGFOLOjqJ
0NELqGukiKUXqTG9oh/Fw9rf7t+o6tY2RXUySWBBe/bpR8ZbIzZLPFtIwQKeyj58
ApMiKXluj4ukipsTIg1q4ONEl/rEy4I0xrPMHumS0kBmZAKvPQT7Tmgm3C2zqzuS
Ycn4Aan6hAboLyUNOnVw3TshdSvGzA2l9Fl3qLoXEptCKU4jxiSldyu1MhtG3R+n
Kv9FMrUxYuxcoT2vKXpAMHJKCrJvFsAXoyRo8jUAkNxmMp6QG/oBLAv9gFsUu194
f/XfdHTuN8qCNndIaxHqaMpvg0Ln/MCiK+cywxQ7wkk1qR62l3hSDG/Qp6zkRzAc
nCa3AZKl/IWn6LKRV8hZuxH01r1ZtUO5/7IBCmzPgvb9+p28Xz0dQ8n4HtNMMn9W
Y6+7osQj50o3ayfMPu+8O+tJi9Isjvbid0OIrQ+jQD1Oitu6oAfn58qLq62YLW++
zIqArsLtRjhgfDHyPQLP
=dkVS
-----END PGP SIGNATURE-----

--Sig_/+kQfF.xFU4/IgZ2W1GuD4Q9--
