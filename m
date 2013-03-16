Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab3CPDcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 23:32:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22226 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab3CPDbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 23:31:44 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=1PkvgSSza48A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Ut1h0XlF8csA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=Liy2tW5R75nVpxZVywsA:9 a=QEXdDO2ut3YA:10 a=hPjdaMEvmhQA:10 a=jeBq3FmKZ4MA:10 a=GBcaZGZy0t2I4jhkGIUA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130316033142.416540502@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 23:24:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [for-next][PATCH 2/9] tracing: Use pr_warn_once instead of open coded implementation
References: <20130316032412.416651612@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Use-pr_warn_once-instead-of-open-coded-imple.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

Use pr_warn_once, instead of making an open coded implementation.

Link: http://lkml.kernel.org/r/513D8419.20400@huawei.com

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7f0e7fa..bba1ba9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5205,8 +5205,6 @@ static inline int register_snapshot_cmd(void) { retur=
n 0; }
=20
 struct dentry *tracing_init_dentry_tr(struct trace_array *tr)
 {
-	static int once;
-
 	if (tr->dir)
 		return tr->dir;
=20
@@ -5216,11 +5214,8 @@ struct dentry *tracing_init_dentry_tr(struct trace_a=
rray *tr)
 	if (tr->flags & TRACE_ARRAY_FL_GLOBAL)
 		tr->dir =3D debugfs_create_dir("tracing", NULL);
=20
-	if (!tr->dir && !once) {
-		once =3D 1;
-		pr_warning("Could not create debugfs directory 'tracing'\n");
-		return NULL;
-	}
+	if (!tr->dir)
+		pr_warn_once("Could not create debugfs directory 'tracing'\n");
=20
 	return tr->dir;
 }
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ+eeAAoJEOdOSU1xswtMvYwIALCJm91r0oLHcRd1iKaord3N
bfYZmwb64KCgcQ3jVfP6TPpWV+AaouO/kT4dl5lIDT9S8cjJwF8fqjvghU7FOhhk
nFN9gVbd7xrplRfE4FYpJGK2PM2hLQC4+7feXs33QnJ52AH0BQBGJqE6+A0aW8tm
/iICJdRXLd39m2WELWOWtWgwMUaCIQj+jjse/yTa+JIAtjvu8DkUzcS7P8+VLks0
twvjNEpVLFSMJwzX8VIwaW0ZFkQ3MxsoeR0ssTtqrivFNc7MJJB8KDAJ0NWQoCFL
QPHstUV97gq4Jc1T0vvA5N1NizlV4S3HB/XYCnSyclrZg7NxNu5qVghqYVk127s=
=u9Hx
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
