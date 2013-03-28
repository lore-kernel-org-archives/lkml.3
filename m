Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab3C1Mwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:52:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25852 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab3C1Mwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:52:35 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=wHWRjsBrAToA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=tm-Dbz-0zS0A:10 a=a_U1oVfrAAAA:8 a=VwQbUJbxAAAA:8 a=nnS9Z_ekIDrHSj9FyUoA:9 a=QEXdDO2ut3YA:10 a=k4qQewaewV0A:10 a=jeBq3FmKZ4MA:10 a=45nWZrmACNp8bfXQgn8A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130328125232.535380915@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 28 Mar 2013 08:52:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <stable@vger.kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 2/3] ftrace: Consistently restore trace function on sysctl enabling
References: <20130328125214.132479321@goodmis.org>
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

iQEcBAABAgAGBQJRVD0QAAoJEOdOSU1xswtMTwwH/2EFq/3AIIDBeXh/C6ses0Y4
N9g3a/hFPTRR7PPnu5LN4mnqJzf2rMBOEJg8CLJRg7QvR10tOB768+KkSFAir5Q5
bI4RjYI/VsAjjwVud7zdDoA0oVnPbRFEB5JyeC9VgzA4i5LPq/iVKf2G9AKhIn0a
Q/kdcSdhRXhxqQdcrUgpR++Oak7FLjKDBaCV1PFa/0E0us73sykokq6zmpez1kb6
yRXT5jjQeO/ZupisgKaQFyJ8mn8J5YlPX63/R82lVSJQznU4eQwuAX3d6tK/Onde
I/XT4uv24TWi9z9TWrCGh7fe3QnK7FhjPCxZkigW8vuRnMFoGIyqHoKgJYtQP1A=
=fH43
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
