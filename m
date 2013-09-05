Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283Ab3IEI5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 04:57:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33324 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757817Ab3IEI5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:57:00 -0400
Date: Thu, 5 Sep 2013 18:56:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: linux-next: manual merge of the akpm tree with the vfs tree
Message-Id: <20130905185649.0dce2b5824f7a3fb355234c2@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Sep_2013_18_56_49_+1000__Fo3rdpsT4mp5c_j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Sep_2013_18_56_49_+1000__Fo3rdpsT4mp5c_j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
include/linux/fs.h between commit 7b7a8665edd8 ("direct-io: Implement
generic deferred AIO completions") from the vfs tree and commit "dcache:
convert to use new lru list infrastructure" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/fs.h
index ee1a9b2,b778968..0000000
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@@ -1421,8 -1413,12 +1413,15 @@@ struct super_block=20
  	/* Being remounted read-only */
  	int s_readonly_remount;
 =20
 +	/* AIO completions deferred from interrupt context */
 +	struct workqueue_struct *s_dio_done_wq;
++
+ 	/*
+ 	 * Keep the lru lists last in the structure so they always sit on their
+ 	 * own individual cachelines.
+ 	 */
+ 	struct list_lru		s_dentry_lru ____cacheline_aligned_in_smp;
+ 	struct list_lru		s_inode_lru ____cacheline_aligned_in_smp;
  };
 =20
  extern struct timespec current_fs_time(struct super_block *sb);

--Signature=_Thu__5_Sep_2013_18_56_49_+1000__Fo3rdpsT4mp5c_j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSKEdVAAoJEECxmPOUX5FE/GEP/3oB1q147cBdpwvTAGrpbvT7
L9Hs5Zz+GJ6u8e58/b/LBdaCXcUsXUQLTM0kOEIPFS3cAymzNhT4JacXvpFi0Q1u
rwgvORjefePdEkq8X+cYjl8qUPIZRdpCRzUplva+tUdDoO1pdKWCrUazgiN7Bhpp
5wzpLS/o7KP9/ww0dtuPQ5FXX+hMMDNKBWqPuiMjL7mRtbAJXQnyBGyMc4mJO5wK
7bg9PTMOiN0EdK9T5w6q4r/irPOMios5bSkcNNYKEIvkiPxILet39fX5vusNgrkU
sLNIeiw039Q+KzA3ezA3RovA4Brc8ESVpOyla/xuGc4gZt+nr8ZEnS44s06djsVP
IEXiEyBvq4GcNuML6/9iSg2OOe9Fq8vb7V9++/00dV7EGK7Ttqb26YNkYlVXTOh/
pVCRQBjVtSsB6V1o2fI/62QeOf5VmVTp7yY18ccuz2rSSk8LqZyUwQnMSg5AUQgC
gM9JAvLUw/kXPDIIzuQfl4lDRpb8b4sxCQeQsQVEvafndxTi56cUvmCurCcX78nP
OusH+5gC9pF9nshQjLu/JMXEVh379Js+pG0XB+WSaE1+p3f4JLoudggGrvWuOHJW
Gk/kkWakvTaRwcY7DXNC4lJMcLGScqnYwlVCXMzL4M46FYtaDKFibcphvYgV9tyN
cg4y3WVEYsU/0Nxf2QoF
=fj0B
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Sep_2013_18_56_49_+1000__Fo3rdpsT4mp5c_j--
