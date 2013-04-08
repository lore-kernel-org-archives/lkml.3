Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965057Ab3DHVFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:05:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20275 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964943Ab3DHVFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:05:20 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=wHWRjsBrAToA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=tm-Dbz-0zS0A:10 a=a_U1oVfrAAAA:8 a=VwQbUJbxAAAA:8 a=nnS9Z_ekIDrHSj9FyUoA:9 a=QEXdDO2ut3YA:10 a=k4qQewaewV0A:10 a=jeBq3FmKZ4MA:10 a=ed3n-MWihzIJX_CE8p4A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130408210518.345599192@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 08 Apr 2013 16:49:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <stable@vger.kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 2/3] ftrace: Consistently restore trace function on sysctl enabling
References: <20130408204937.649895945@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Consistently-restore-trace-function-on-sysctl.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jan Kiszka <jan.kiszka@siemens.com>

If we reenable ftrace via syctl, we currently set ftrace_trace_function
based on the previous simplistic algorithm. This is inconsistent with
what update_ftrace_function does. So better call that helper instead.

Link: http://lkml.kernel.org/r/5151D26F.1070702@siemens.com

Cc: stable@vger.kernel.org
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6893d5a..cc4943c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4555,12 +4555,8 @@ ftrace_enable_sysctl(struct ctl_table *table, int wr=
ite,
 		ftrace_startup_sysctl();
=20
 		/* we are starting ftrace again */
-		if (ftrace_ops_list !=3D &ftrace_list_end) {
-			if (ftrace_ops_list->next =3D=3D &ftrace_list_end)
-				ftrace_trace_function =3D ftrace_ops_list->func;
-			else
-				ftrace_trace_function =3D ftrace_ops_list_func;
-		}
+		if (ftrace_ops_list !=3D &ftrace_list_end)
+			update_ftrace_function();
=20
 	} else {
 		/* stopping ftrace calls (just send to ftrace_stub) */
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRYzEOAAoJEOdOSU1xswtMR98H/igitBBUz/sOGWSW29Mr5V8P
oDy8bpRdal7YehAPE1CHaaJX/EZTuan8rFr7biO4QhW3kAhIh/qavPaq3FeBVhfr
VtONW7LXxwfrVhWKb4EeP2UGPqyf3EsiICkbABRhHb7Ezt/ay/IEumovDO0tOtTN
hj7IJRtRPIgW0KnYbGgKKJKi0M7OvZlYgg3azf07wkUhqgufvjIrPzI7vJCKZ3q4
78rsWX86pCTtCUYIe/xhrEXk4zqH+2dhNeUM4sjOnPnh3sf1Te/7CNTiyMyE18eo
T6/uq4eAbqlw9eKDyG/wHs3+5XrpGv1e9vc/mFiJrOqqFMYUH82ehfPwFWCMfH4=
=3Di8
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
