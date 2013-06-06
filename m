Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3FFWTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 18:19:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15173 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab3FFWTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 18:19:11 -0400
X-Authority-Analysis: v=2.0 cv=BcJaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=5aMjM8uUleYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=4MUG0HObBwsA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=rp8sQ_PGhaDcVZ7OaiUA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=dGJ0OcVc7YAA:10 a=qoukI1nBB0HGh60lbgwA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130606221909.795671349@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 06 Jun 2013 18:16:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH 3/4] tracing: Fix bad parameter passed in branch selftest
References: <20130606221654.698742573@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Fix-bad-parameter-passed-in-branch-selftest.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="===============7605742884412225407=="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============7605742884412225407==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The branch selftest calls trace_test_buffer(), but with the new code
it expects the first parameter to be a pointer to a struct trace_buffer.
All self tests were changed but the branch selftest was missed.

This caused either a crash or failed test when the branch selftest was
enabled.

Link: http://lkml.kernel.org/r/20130529141333.GA24064@localhost

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_selftest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 55e2cf6..2901e3b 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -1159,7 +1159,7 @@ trace_selftest_startup_branch(struct tracer *trace, s=
truct trace_array *tr)
 	/* stop the tracing. */
 	tracing_stop();
 	/* check the trace buffer */
-	ret =3D trace_test_buffer(tr, &count);
+	ret =3D trace_test_buffer(&tr->trace_buffer, &count);
 	trace->reset(tr);
 	tracing_start();
=20
--=20
1.7.10.4



--===============7605742884412225407==
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRsQrdAAoJEOdOSU1xswtMLJMH/jTQiRvhtUxFAAYsWGWzg4Sh
ZzM4DQbCfHlg+iSl28WysxlXMOGiWBogHwCNVTBa5or3PVcDWyARGAP7vDUqDoEW
KqJttM59yhXwcKxNpDGtN4QQFafhQ9VfKQVQjUwHqM1eMLjcX65qZcacV/58SHyb
BFWPE88bL15xUE+QsyRn4+NujZE16YbFpgfDOu/AztU2ST1FA5d/dj16vyZwEJQa
ZWcvFHKJV21WiFDG8ZpXl3Ova3THusYxZLAMac+s6gFaIuSTcLKTTM09JIz9MQpg
bocrQtz5iAC8wN4IUcpPsKIK11AzuWYe/+sRRb8NbEQ7+SZAEcZxOzkfmH6x8co=
=hagt
-----END PGP SIGNATURE-----

--===============7605742884412225407==--
