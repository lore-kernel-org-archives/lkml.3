Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763247Ab3IEDCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 23:02:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57818 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762147Ab3IEDCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 23:02:13 -0400
Date: Thu, 5 Sep 2013 13:02:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: linux-next: manual merge of the vfs tree with the aio-direct tree
Message-Id: <20130905130209.39efbc35d4601cab4e981281@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Sep_2013_13_02_09_+1000_qPdG.uP/m7sZXzrX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Sep_2013_13_02_09_+1000_qPdG.uP/m7sZXzrX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in fs/direct-io.c
between commit 8f2a7fbb9b10 ("dio: add bio_vec support to
__blockdev_direct_IO()") from the aio-direct tree and commit 7b7a8665edd8
("direct-io: Implement generic deferred AIO completions") from the vfs
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/direct-io.c
index 75a3989,1782023..0000000
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@@ -127,7 -127,7 +127,8 @@@ struct dio=20
  	spinlock_t bio_lock;		/* protects BIO fields below */
  	int page_errors;		/* errno from get_user_pages() */
  	int is_async;			/* is IO async ? */
 +	int should_dirty;		/* should we mark read pages dirty? */
+ 	bool defer_completion;		/* defer AIO completion to workqueue? */
  	int io_error;			/* IO error in completion path */
  	unsigned long refcount;		/* direct_io_worker() and bios */
  	struct bio *bio_list;		/* singly linked via bi_private */

--Signature=_Thu__5_Sep_2013_13_02_09_+1000_qPdG.uP/m7sZXzrX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSJ/QxAAoJEECxmPOUX5FEIIgP/RyDQqP2rkvbY+bAOjzovMtf
XmH9WneYNZDwiSo1HEU3ZBp6PIMpOXwE5bSJQgRNZ860mF2BEGXNBlW7SL4i88Nq
K3j5hbeX9DE1DKpnEOrLVZDvnAf+SGG+SanxvEV4C7nyR4dmJxh6eRH5dEWfjEQz
zrVSgu6hEF7qp9Soib+A0h+QFGSeOR9QDcgvNmIwvILAqHHhDg3FY1K8EIkB4WDF
3tt8yNE5+5RqehigaUJ8dAmrYg/XaYlH0oI3dmgXLul8S3UDYcUT2hAQEDZwfe0i
jZWsl4Lx82v1bjUjNh2xD5P+BSQ+H7ZD0G0ntudyt1RhHB0jrjQMsDmGNPJfgczG
Dg0MYpiRgB1l6ACOtatAUTEZzs6DgXqUOpBjVujBjsy1gqE72pSuYQTt1Hph6gLU
ZQ7fdQiTqiYUTnHGPzUydRtBXzXRlnU9CIlaGS1PEtFGqtUTAUlAdn0AEP1Hx3Wi
coPLvCMpAMu5GJTTbWKOI5X8T4tqhXWbHBx2BHeRgz+5IB48+VcMBIehRnPElTcx
TO3grDWp+diRZZuzXT+gaT158JXlltpsmr6gsMmkFgIs0t1wtQmWDYJbzD3JUPgH
bIsorlfQALcIMrNyqZ0APNa8/WKQVLcFR7eIi0/2KAB1DZYpb5p3ysbNtIVKPoE/
atZcfOxTCqIjeSIALhWp
=fGwO
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Sep_2013_13_02_09_+1000_qPdG.uP/m7sZXzrX--
