Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaIKHKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 03:10:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaIKHKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 03:10:36 -0400
Date: Thu, 11 Sep 2014 17:10:19 +1000
From: NeilBrown <neilb@suse.de>
To: Thomas Graf <tgraf@suug.ch>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] rhashtable: remove duplicate comment.
Message-ID: <20140911171019.223c287f@notabene.brown>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/uz69dv/reeff2HaIMqg_6Bq"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/uz69dv/reeff2HaIMqg_6Bq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



The second comment is identical to the earlier comment, just indented
a bit. This is confusing, so remove it.

Also expand that first comment to mention the splicing that happens.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index a2c78810ebc1..8fd2f21d022a 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -309,15 +309,12 @@ int rhashtable_shrink(struct rhashtable *ht, gfp_t fl=
ags)
=20
 	/* Link each bucket in the new table to the =EF=AC=81rst bucket
 	 * in the old table that contains entries which will hash
-	 * to the new bucket.
+	 * to the new bucket, and then splice in the second
+	 * bucket from the old table.
 	 */
 	for (i =3D 0; i < ntbl->size; i++) {
 		ntbl->buckets[i] =3D tbl->buckets[i];
=20
-		/* Link each bucket in the new table to the =EF=AC=81rst bucket
-		 * in the old table that contains entries which will hash
-		 * to the new bucket.
-		 */
 		for (pprev =3D &ntbl->buckets[i]; *pprev !=3D NULL;
 		     pprev =3D &rht_dereference(*pprev, ht)->next)
 			;

--Sig_/uz69dv/reeff2HaIMqg_6Bq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBFK2znsnt1WYoG5AQL4HRAAulKtQ+FXFUXMHLiyskEpjljXZIbd/qNn
Wnz+Uk44yZoQ8RUSyYZbSZZU14YM6M6bcuR5w6/4U3XoXGyUZmBQOV82sU9HllUT
lyQMfRJhFSpkfscmkRPvTIZHobARUDDoV76k+sKRwYG63yoZ19IAKg/NV8zOqo6X
Bw042Yue8mi8mqdFsUdBYiM/Nd3g0WWYNe1RSpDv+GSomh0Wudjswegaq3oZsqGj
7W1yoCkHdqXlzWWMcV8RtFT0421vUPzZB6CL494N36/BrVVAsSPZkAURDBRGd4KY
i0Ua0bw9efjZrg4xpqx4iyPzFNI5JP/s0F0fbQCgbi2HkPXPQQ2pyTY0t/MXO9p1
zKzUBLKjZaboR3GX0PLXX8eOTKdyAovmrrKB+74LLeEFFgP4A6SQ4xYCkUqbXau3
CajS4mNMYJnvSIz4B52XvJHrbFNAFRBEivavL0oes0TCfFWILdfIz1hQD30PhtG/
aBuLZ+SsvnAe4lWuc+uAHTdT9/hS/09xsydkBtfDdQjZLXDq1r7oORTMSbupetjN
uMAjwnw1XMsvr2K7NuMs4aZtD4+/X5e/aWB+DCh5/2TvsUqraJEkAPp1AI7fVLdo
0hOaRbnQJqWCPMri1I+YNw9PA05v9tWUyMhwCpToFwOEz4hevui5sxGa5Yr/0DpO
saeTai3btsA=
=pM7x
-----END PGP SIGNATURE-----

--Sig_/uz69dv/reeff2HaIMqg_6Bq--
