Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab3HGFTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 01:19:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34297 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab3HGFTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 01:19:05 -0400
Date: Wed, 7 Aug 2013 15:19:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <dchinner@redhat.com>
Subject: linux-next: manual merge of the akpm tree with the ext4 tree
Message-Id: <20130807151903.6281b33735f4e3f79231bf5e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__7_Aug_2013_15_19_03_+1000_zk5Du8fLECIDSwLz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Aug_2013_15_19_03_+1000_zk5Du8fLECIDSwLz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/ext4/extents_status.c between commit 49c6efc7b80e ("ext4: add new
ioctl EXT4_IOC_PRECACHE_EXTENTS") from the ext4 tree and commit
"fs-convert-fs-shrinkers-to-new-scan-count-api-fix" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext4/extents_status.c
index 28e2627,0361206..0000000
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@@ -947,13 -909,23 +947,15 @@@ static int __ext4_es_shrink(struct ext4
  	struct ext4_inode_info *ei;
  	struct list_head *cur, *tmp;
  	LIST_HEAD(skiped);
- 	int ret, nr_shrunk =3D 0;
+ 	unsigned long nr_shrunk =3D 0;
 +	int retried =3D 0, skip_precached =3D 1, nr_skipped =3D 0;
 =20
  	spin_lock(&sbi->s_es_lru_lock);
 =20
 -	/*
 -	 * If the inode that is at the head of LRU list is newer than
 -	 * last_sorted time, that means that we need to sort this list.
 -	 */
 -	ei =3D list_first_entry(&sbi->s_es_lru, struct ext4_inode_info, i_es_lru=
);
 -	if (sbi->s_es_last_sorted < ei->i_touch_when) {
 -		list_sort(NULL, &sbi->s_es_lru, ext4_inode_touch_time_cmp);
 -		sbi->s_es_last_sorted =3D jiffies;
 -	}
 -
 +retry:
  	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {
+ 		int ret;
+=20
  		/*
  		 * If we have already reclaimed all extents from extent
  		 * status tree, just stop the loop immediately.

--Signature=_Wed__7_Aug_2013_15_19_03_+1000_zk5Du8fLECIDSwLz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSAdjHAAoJEECxmPOUX5FEQjoP/jVOmwSIVBew+ABBkAze6Rp+
An5grAv+3hegvDRPsAMIMfyNWEBB1cutNlLttEOPB4mWdA0nCQi1JnP0X2MfJh6R
aA7lx3j+uNzRWc3NP+yCYp8Dc4fNJ3f86khq1o6WrX6no5WV4bfxJyCBHNKnSBo1
QCcoNnvOAjR6W4MMI3FZW67qXABKUq9Y3+5bALo+OzX2NDe901RmQnEx58u8/QJF
6w8/4f52gQ6sELXsNvHkyOarBD78vSBF//19rsewPHO/8vVFi75OR7vRCjDmMIva
JFocYHq3WTLsiRIP4ekysMdKRV3CPhaZ35h2fkTB/JEb0lmz8CINEWVtOGpZSPUU
7x+yOUA44eauoQqZso5WqkrM6BVdTqsGSzsCPkXlEPpi/FCf55Hbxj2ZfC0d7Blu
iQT8x29jDq1CnGZrg4X7usZE0Pp2hXyN/gQ09MwdG4dpDYjwAhbP21uqDC+xHmyv
GqsQF7c5zdUiP2HcT3Le7yS8kWSSwvAEzBOlRpWl74IfzqUtpH95vkUviPDm2gQN
nklYSqeq+lKfnv0TqWhwWiu5IB+wgRNLPqmHJY1Pa9M5+GkPVBUmohUH+unT8iyy
nszrByZEUp30la72s9mdy5yu4Tpoh78i89kwE1Ek0RigS0rpodCYD6y/cCr345Mk
pv/KAACjIAsj2OUokJGL
=oqeO
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Aug_2013_15_19_03_+1000_zk5Du8fLECIDSwLz--
