Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab3IIFQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 01:16:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40764 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab3IIFQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 01:16:32 -0400
Date: Mon, 9 Sep 2013 15:16:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <dchinner@redhat.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130909151619.ea53601d59e61545aa5aea71@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Sep_2013_15_16_19_+1000_jIAZBk/JMAGEajUc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Sep_2013_15_16_19_+1000_jIAZBk/JMAGEajUc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in fs/internal.h
between commit eed810076685 ("vfs: check unlinked ancestors before
mount") from Linus' tree and commit  "shrinker: convert superblock
shrinkers to new API" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/internal.h
index 62f05e9,c909014..0000000
--- a/fs/internal.h
+++ b/fs/internal.h
@@@ -126,7 -127,7 +127,8 @@@ extern int invalidate_inodes(struct sup
   * dcache.c
   */
  extern struct dentry *__d_alloc(struct super_block *, const struct qstr *=
);
 +extern int d_set_mounted(struct dentry *dentry);
+ extern long prune_dcache_sb(struct super_block *sb, unsigned long nr_to_s=
can);
 =20
  /*
   * read_write.c

--Signature=_Mon__9_Sep_2013_15_16_19_+1000_jIAZBk/JMAGEajUc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSLVmoAAoJEECxmPOUX5FELwwP/1XE0yv4JcZVrPCuthXOJybf
eB3pAwQOnytZPRlKQv1g+8wGCyK9ymBGiE/l9HUvMQBLmanZWVAWVz6oKfagvuT/
ysMD1Mp/9cZ9q3YEzspA8XdWk70zcgl3f2PpGgPkX+z5B+Godh6x3IIJnlUvRENt
otYYNcDYDF/uQsqKmMRcjV0Jwl9cPIm50EoPeOLtnQt1cCZ3sIOLSRsI6zN31t+Z
qIJxlmoOoTlLnLD8q4lsGrN4f9CvCTdXvtVr/6dhP6z83ffeTOtAKoTkfbsauIxR
e5MEWt0mm86yVHPreux7pZApD339ad1qxEpT1eiyzdfpHFs0oru3A1S7vsNhnt8z
oHATuD26cXyFZe5x+Dpz8Z82p7HIzWNBhesVP5kD20m5jL0OWqgEg+Wyobwn5xFL
5Lq5w59H8qJAZyiEtFkPBrYB4R0BBLVn5wZaNTCwjZqnvEoMa+Bc/HMOmwZN0T3V
o3aIp8SSB08KIiWQKkRfJHYGpNDGSidODnzDTDu4axr72bL6jPZYQL+fpAJbs4xn
NdAggGML4bqMSmNoKCSqfNh4ont6RPX2XSAHFrw03hWhD7u6BVIy7ZIu7xwYhrTD
oHDC9SW/5hj9ejDixWobSETPxE27By2PqRYmUrLR7LUYLQTpUD121QFNrLhiAXyI
gOnlCkqZBCwbL3L1HE5D
=aVdB
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Sep_2013_15_16_19_+1000_jIAZBk/JMAGEajUc--
