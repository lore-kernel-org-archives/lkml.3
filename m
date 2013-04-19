Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030673Ab3DSOH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:07:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31727 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030563Ab3DSOGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:06:00 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=X7Yw52b5g04A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=_9YwlVeAePoA:10 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=IiuyvBDGNC2QyYxQFS4A:9 a=QEXdDO2ut3YA:10 a=lqfzikGvtTgA:10 a=TIV7c6GJmisA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=TK4odPUnvjOhrlapYQ4A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130419140557.434905640@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 19 Apr 2013 10:04:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 6/7] ftrace: Get rid of ftrace_profile_bits
References: <20130419140402.730041313@goodmis.org>
Content-Disposition: inline; filename=0006-ftrace-Get-rid-of-ftrace_profile_bits.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Namhyung Kim <namhyung.kim@lge.com>

It seems that function profiler's hash size is fixed at 1024.  Add and
use FTRACE_PROFILE_HASH_BITS instead and update hash size macro.

Link: http://lkml.kernel.org/r/1365551750-4504-1-git-send-email-namhyung@ke=
rnel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3b84fc1..9b44abb 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -486,7 +486,6 @@ struct ftrace_profile_stat {
 #define PROFILES_PER_PAGE					\
 	(PROFILE_RECORDS_SIZE / sizeof(struct ftrace_profile))
=20
-static int ftrace_profile_bits __read_mostly;
 static int ftrace_profile_enabled __read_mostly;
=20
 /* ftrace_profile_lock - synchronize the enable and disable of the profile=
r */
@@ -494,7 +493,8 @@ static DEFINE_MUTEX(ftrace_profile_lock);
=20
 static DEFINE_PER_CPU(struct ftrace_profile_stat, ftrace_profile_stats);
=20
-#define FTRACE_PROFILE_HASH_SIZE 1024 /* must be power of 2 */
+#define FTRACE_PROFILE_HASH_BITS 10
+#define FTRACE_PROFILE_HASH_SIZE (1 << FTRACE_PROFILE_HASH_BITS)
=20
 static void *
 function_stat_next(void *v, int idx)
@@ -725,13 +725,6 @@ static int ftrace_profile_init_cpu(int cpu)
 	if (!stat->hash)
 		return -ENOMEM;
=20
-	if (!ftrace_profile_bits) {
-		size--;
-
-		for (; size; size >>=3D 1)
-			ftrace_profile_bits++;
-	}
-
 	/* Preallocate the function profiling pages */
 	if (ftrace_profile_pages_init(stat) < 0) {
 		kfree(stat->hash);
@@ -765,7 +758,7 @@ ftrace_find_profiled_func(struct ftrace_profile_stat *s=
tat, unsigned long ip)
 	struct hlist_node *n;
 	unsigned long key;
=20
-	key =3D hash_long(ip, ftrace_profile_bits);
+	key =3D hash_long(ip, FTRACE_PROFILE_HASH_BITS);
 	hhd =3D &stat->hash[key];
=20
 	if (hlist_empty(hhd))
@@ -784,7 +777,7 @@ static void ftrace_add_profile(struct ftrace_profile_st=
at *stat,
 {
 	unsigned long key;
=20
-	key =3D hash_long(rec->ip, ftrace_profile_bits);
+	key =3D hash_long(rec->ip, FTRACE_PROFILE_HASH_BITS);
 	hlist_add_head_rcu(&rec->node, &stat->hash[key]);
 }
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRcU9FAAoJEOdOSU1xswtMFJYH/0OYk0S0aFhRak3hUtDUoCSg
qtQrDEfT0w1RyciSfUiOw++pRkNKSCxZZt6YUIvTzOgKR38Cw5t5qqCd2r/7Z2jO
TIBaX9qeZYfLkDZUmRbAeMHy8M7ASH3WDyDcuKAk94QudR0eTzCtA5K4xTemiaHn
nYpR2HBptTEoonPv/8evPm0MLzac88suk2OKN8MToZqaSnLJRhS/AaiNa73oCRdn
V66ac/8CGw5PdLcqJj0U5hxlsfjlA2OsJctfzpOuQhsvQqdABnv2TWUc+zoCMWM5
AbhHY5zZG9m28w0eyWXQPiYHn9vTkm1steR7gvZnTJWA2GBE5bRe2ywaBb8CJgc=
=aVHP
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
