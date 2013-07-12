Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab3GLDQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 23:16:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42360 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab3GLDP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 23:15:59 -0400
Date: Fri, 12 Jul 2013 13:15:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chandra Seetharaman <sekharan@us.ibm.com>, Ben Myers <bpm@sgi.com>,
        David Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
        Glauber Costa <glommer@openvz.org>
Subject: linux-next: manual merge of the akpm tree with the xfs tree
Message-Id: <20130712131546.61d05ef97d33d58a28c728db@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Jul_2013_13_15_46_+1000_+ZSBWRLm1HQHWOJT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Jul_2013_13_15_46_+1000_+ZSBWRLm1HQHWOJT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/xfs/xfs_qm.h between commit 92f8ff73f186 ("xfs: Add pquota fields
where gquota is used") from the xfs tree and commit  "xfs: convert dquot
cache lru to list_lru" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/xfs/xfs_qm.h
index 579d6a0,cf2ad1f..0000000
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@@ -44,14 -44,10 +44,12 @@@ extern struct kmem_zone	*xfs_qm_dqtrxzo
  typedef struct xfs_quotainfo {
  	struct radix_tree_root qi_uquota_tree;
  	struct radix_tree_root qi_gquota_tree;
 +	struct radix_tree_root qi_pquota_tree;
  	struct mutex qi_tree_lock;
 -	xfs_inode_t	*qi_uquotaip;	 /* user quota inode */
 -	xfs_inode_t	*qi_gquotaip;	 /* group quota inode */
 +	struct xfs_inode	*qi_uquotaip;	/* user quota inode */
 +	struct xfs_inode	*qi_gquotaip;	/* group quota inode */
 +	struct xfs_inode	*qi_pquotaip;	/* project quota inode */
- 	struct list_head qi_lru_list;
- 	struct mutex	 qi_lru_lock;
- 	int		 qi_lru_count;
+ 	struct list_lru	 qi_lru;
  	int		 qi_dquots;
  	time_t		 qi_btimelimit;	 /* limit for blks timer */
  	time_t		 qi_itimelimit;	 /* limit for inodes timer */

--Signature=_Fri__12_Jul_2013_13_15_46_+1000_+ZSBWRLm1HQHWOJT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR33TnAAoJEECxmPOUX5FEdj4P/3q79Hko10rAF8RPkZ310xDm
gH2yFo7ncjndKq0y74dqTQGSY08UpwAZPSCT7QaLrpTvHzEz/eKRytnQO7HrpePZ
EiqPc3JeHX+i+XN5+jXSFRtNGHLg2hI8QsHoRzWaMKsfYk0/C9wgHgQKWdAwAsdW
g65RVvePnAhDr8ZTC+YGVSWOhUuBlBoYdSODs9IX9qAzjGP5IBWvVuQOdekBq0QS
Ij6497vO87UtQLf0NXECHQ8oSXXDsR3asjQElv0Rk11I5mEvVgwAZ5JCovPBHT1g
XqXgQjh6TiVqQiKxdPVomUTxOHHw4gTJTxuiu9laul4a2zlzGy3EYhJU32ERvSqf
osXMQJMKCTIYyagHfvGTPtM1Xemy+9tLvgK1rv9osHy6JmWo6zz/apWvoST/EvIC
qJU6oS/CYEVUe94PhiFK5MOkvxnZX8qgOOnGTLqlFR4Y1MJwGQQueClSIZeH8b0N
5NtE6Vs4U8koBDAWwYawye6NFcRG6z+XzO2cFXmS2WQVTceQlauheKYUUvvZoNLz
4VaA/LB7WBmoSH5WBQ733xQJ2VrBVtq0RhhOkpr9IslmIvvSfQB5HA6pu7lAgbOF
XINRIbI2DO5xNvFnAnDrOIl59wnfvaR5pjEqTx3UtuWjnYHllqEMF7x/jSdWV6KO
cpqRxrHpyHgwplUpJ061
=yhcL
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Jul_2013_13_15_46_+1000_+ZSBWRLm1HQHWOJT--
