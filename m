Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030651Ab3DSOIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:08:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030503Ab3DSOF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:05:58 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=qpaQnO7LyMkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=jm46q04Kc8UA:10 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=GIASEB_d3D8VeEgvLcsA:9 a=QEXdDO2ut3YA:10 a=lqfzikGvtTgA:10 a=TIV7c6GJmisA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=3DavHFx1VsVvHwyq6TIA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130419140556.988391624@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 19 Apr 2013 10:04:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 4/7] tracing: Get rid of unneeded key calculation in ftrace_hash_move()
References: <20130419140402.730041313@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Get-rid-of-unneeded-key-calculation-in-ftrac.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Namhyung Kim <namhyung.kim@lge.com>

It's not used anywhere in the function.

Link: http://lkml.kernel.org/r/1365553093-10180-1-git-send-email-namhyung@k=
ernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9e31987..3b84fc1 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1320,7 +1320,6 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	struct hlist_head *hhd;
 	struct ftrace_hash *old_hash;
 	struct ftrace_hash *new_hash;
-	unsigned long key;
 	int size =3D src->count;
 	int bits =3D 0;
 	int ret;
@@ -1363,10 +1362,6 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	for (i =3D 0; i < size; i++) {
 		hhd =3D &src->buckets[i];
 		hlist_for_each_entry_safe(entry, tp, tn, hhd, hlist) {
-			if (bits > 0)
-				key =3D hash_long(entry->ip, bits);
-			else
-				key =3D 0;
 			remove_hash_entry(src, entry);
 			__add_hash_entry(new_hash, entry);
 		}
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRcU9FAAoJEOdOSU1xswtMvAQH/A92xjLGqVOjxeooQ14Z0GaU
1O60nB1bmx7v6fWpQNYG3WMYwu7IKaMCnL4RhyiQkYsidS/1r+I+cWLvRDXbe6lq
Rp6fXuH+VmicvL3dAQOyfdspuykNQ+x4BXkfhTykj8YKs0BDNLRrfoX1kUTST3Qt
VbGCBLAwut+kfmAfauHa+wKQBa54RGr6kDpoCZv+KXo0SmYwgopTOYL4RsevHxAT
YazSfXG7/cHRwtH7D0jIdajl5rkzfwrW+jgFtBGs9rFzTxBFvGfKEL/SYJPgELzI
LQARGiKmRXM+jqWqIyBK9M+FSQAfNKrQpW5myG/tVtBwVPFB4s5+CL5PAPgUBJo=
=prLc
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
