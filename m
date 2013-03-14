Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3CNVk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 17:40:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10468 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab3CNVkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 17:40:31 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=hEd2sb_-xJMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=xhDSq04P4-QA:10 a=VwQbUJbxAAAA:8 a=Wh8kfBTXKzvaumMlS68A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=NiJdMdCb41TC4Mb_qysA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130314214029.108015297@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 14 Mar 2013 17:33:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH 2/3] tracing: Keep overwrite in sync between regular and snapshot buffers
References: <20130314213303.302538352@goodmis.org>
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
 kernel/trace/trace.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 00daf5f..eaaccd8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2895,8 +2895,10 @@ static void set_tracer_flags(unsigned int mask, int =
enabled)
 	if (mask =3D=3D TRACE_ITER_RECORD_CMD)
 		trace_event_enable_cmd_record(enabled);
=20
-	if (mask =3D=3D TRACE_ITER_OVERWRITE)
+	if (mask =3D=3D TRACE_ITER_OVERWRITE) {
 		ring_buffer_change_overwrite(global_trace.buffer, enabled);
+		ring_buffer_change_overwrite(max_tr.buffer, enabled);
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

iQEcBAABAgAGBQJRQkPNAAoJEOdOSU1xswtMjVsH/A+NJ0i6z3Mp9B57vQeLMuk1
T4EbiMXlMwgMJkuYS1qwjpLV6v2780X8rT43gko2Ts49e9XdFl1FMN2LdCfMCpUP
HDVg3wQ2KoQI0vSboSCkSlZjwgUACafe4h6jzldL7iO34At6yKatF7WzZWT19sAT
hloBnO3H2ETJCarsP/MMXD7786vyHDy1oyyK/Vy26UxLSgSUk2+zvT5MzBERjW3h
rW/u14eJFT7ZIDoyTqPTHv/neP97wMZrp3g6GoGpXRLLLKtVUR2ThSYOlFJq9UIJ
oGplKU1XgI769OD89kO+BPEkXIiUtlZtZ5APMwUK50ra+6hYL1e6yeEUcrWJagw=
=sOyH
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
