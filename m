Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030681Ab3DSOIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:08:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31727 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030541Ab3DSOF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:05:59 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=lBjhgWWBtPQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=oe-uKPTZ45AA:10 a=40MIqcmNAAAA:8 a=VwQbUJbxAAAA:8 a=uIN9_ZNfxcFh06y98-cA:9 a=QEXdDO2ut3YA:10 a=-tENaG0q7zQA:10 a=jeBq3FmKZ4MA:10 a=hPkc7QZ9I6kySGOkvb8A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130419140556.341332849@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 19 Apr 2013 10:04:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chen Gang <gang.chen@asianux.com>
Subject: [for-next][PATCH 1/7] kernel: tracing: Use strlcpy instead of strncpy
References: <20130419140402.730041313@goodmis.org>
Content-Disposition: inline; filename=0001-kernel-tracing-Use-strlcpy-instead-of-strncpy.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Chen Gang <gang.chen@asianux.com>

Use strlcpy() instead of strncpy() as it will always add a '\0'
to the end of the string even if the buffer is smaller than what
is being copied.

Link: http://lkml.kernel.org/r/51624254.30301@asianux.com

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    4 ++--
 kernel/trace/trace.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2577082..548a1f7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3496,14 +3496,14 @@ static char ftrace_filter_buf[FTRACE_FILTER_SIZE] _=
_initdata;
=20
 static int __init set_ftrace_notrace(char *str)
 {
-	strncpy(ftrace_notrace_buf, str, FTRACE_FILTER_SIZE);
+	strlcpy(ftrace_notrace_buf, str, FTRACE_FILTER_SIZE);
 	return 1;
 }
 __setup("ftrace_notrace=3D", set_ftrace_notrace);
=20
 static int __init set_ftrace_filter(char *str)
 {
-	strncpy(ftrace_filter_buf, str, FTRACE_FILTER_SIZE);
+	strlcpy(ftrace_filter_buf, str, FTRACE_FILTER_SIZE);
 	return 1;
 }
 __setup("ftrace_filter=3D", set_ftrace_filter);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 829b2be..07860b9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -125,7 +125,7 @@ static bool allocate_snapshot;
=20
 static int __init set_cmdline_ftrace(char *str)
 {
-	strncpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
+	strlcpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
 	default_bootup_tracer =3D bootup_tracer_buf;
 	/* We are using ftrace early, expand it */
 	ring_buffer_expanded =3D true;
@@ -164,7 +164,7 @@ static char *trace_boot_options __initdata;
=20
 static int __init set_trace_boot_options(char *str)
 {
-	strncpy(trace_boot_options_buf, str, MAX_TRACER_SIZE);
+	strlcpy(trace_boot_options_buf, str, MAX_TRACER_SIZE);
 	trace_boot_options =3D trace_boot_options_buf;
 	return 0;
 }
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRcU9EAAoJEOdOSU1xswtMnB0IANAyjjRYluPQc8RJ9gwtZDMj
Mw10I5RFMsoa68oK7dzVCniuncoWP/ITQGgMtOFNRWsI4+fD/3CPH4LYUQJCFA38
1MKsMPxthqRCj87OQobAJkwmWc3BdkmbaIJN8fbZhbIhl3NdE3UNxOSI77gj9xx+
MyOasQDDsxsO5iX5m80TdIRQW9W+akRfAM+jHK4eX/dNbUrgImkRbKIXkIOlTbxF
9GGDsks9UmX4Aty7eDiqSwxP7Hyu3SAFTpRiAQ3mHU2OC0w7xlCrPxbCKQupaCMH
VaUUfW55+AAU5Uu2WtvdeQuOWYuTK0iaA41l00IZYyXvwt0OCcTWtFpYLFPcKBo=
=EbQE
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
