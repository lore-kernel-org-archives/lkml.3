Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab3COFUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:20:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11106 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab3COFUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:20:34 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=z8HE06u5_jwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1b9JNiqLLoIA:10 a=VwQbUJbxAAAA:8 a=Wh8kfBTXKzvaumMlS68A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=lfXM9rlN-IP2ATZUPpEA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315052033.013031044@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 01:06:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH 2/3 v2] tracing: Keep overwrite in sync between regular and snapshot buffers
References: <20130315050616.512983245@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Keep-overwrite-in-sync-between-regular-and-s.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Changing the overwrite mode for the ring buffer via the trace
option only sets the normal buffer. But the snapshot buffer could
swap with it, and then the snapshot would be in non overwrite mode
and the normal buffer would be in overwrite mode, even though the
option flag states otherwise.

Keep the two buffers overwrite modes in sync.

Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 00daf5f..02debab 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2895,8 +2895,12 @@ static void set_tracer_flags(unsigned int mask, int =
enabled)
 	if (mask =3D=3D TRACE_ITER_RECORD_CMD)
 		trace_event_enable_cmd_record(enabled);
=20
-	if (mask =3D=3D TRACE_ITER_OVERWRITE)
+	if (mask =3D=3D TRACE_ITER_OVERWRITE) {
 		ring_buffer_change_overwrite(global_trace.buffer, enabled);
+#ifdef CONFIG_TRACER_MAX_TRACE
+		ring_buffer_change_overwrite(max_tr.buffer, enabled);
+#endif
+	}
=20
 	if (mask =3D=3D TRACE_ITER_PRINTK)
 		trace_printk_start_stop_comm(enabled);
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQq+hAAoJEOdOSU1xswtMUdsIAM9Jsfr4m0kvAavrOTuEomI1
XAAdVM8Sd8Jicn35xooVl3/J5ewJl1BCy/6LSqKm1cgcil83+2JDxEuedFCpK8Nj
fVNm3BJt5pMI9RI53EVokKTWd5VgoFJVunBsP/8yK9U8au1Tp8ztMoz2GpFrSuY9
n5Pe6oHV9S1kcA0QfHRi4o5dRaT7JC5ZGivML9zB36kpLRElulToHry72pmCq27s
K2qnx1zbiSPXIW2ybWXnPXfZkLYk6zU+7ni0m8m+4JFPEzfRPuvkyOIhjJqYonJ/
aoHi2ka9X085ZsJN/lPcgs5nvyLRKjB0/qyu9xKyRO/kkj5q4ssD9ydQePfkNP8=
=u0+q
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
