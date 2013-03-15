Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab3COTv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:51:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab3COTvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:24 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=r3PqfY-RzMEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=pnMHTUkj5g8A:10 a=Uut2Z0_hVRInUPtnOAUA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rzmPpaZA1KNtYzkDr4kA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195123.285355451@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH 07/20] tracing: Fix comments for ftrace_event_file/call flags
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Fix-comments-for-ftrace_event_file-call-flag.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Most of the flags for the struct ftrace_event_file were moved over
to the flags of the struct ftrace_event_call, but the comments were
never updated.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index d84c4a5..4cb6cd8 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -230,6 +230,13 @@ struct ftrace_event_call {
 	struct list_head	*files;
 	void			*mod;
 	void			*data;
+	/*
+	 *   bit 0:		filter_active
+	 *   bit 1:		allow trace by non root (cap any)
+	 *   bit 2:		failed to apply filter
+	 *   bit 3:		ftrace internal event (do not enable)
+	 *   bit 4:		Event was enabled by module
+	 */
 	int			flags; /* static flags of different events */
=20
 #ifdef CONFIG_PERF_EVENTS
@@ -248,7 +255,7 @@ enum {
=20
 /*
  * Ftrace event file flags:
- *  ENABELD	  - The event is enabled
+ *  ENABLED	  - The event is enabled
  *  RECORDED_CMD  - The comms should be recorded at sched_switch
  */
 enum {
@@ -265,12 +272,8 @@ struct ftrace_event_file {
=20
 	/*
 	 * 32 bit flags:
-	 *   bit 1:		enabled
-	 *   bit 2:		filter_active
-	 *   bit 3:		enabled cmd record
-	 *   bit 4:		allow trace by non root (cap any)
-	 *   bit 5:		failed to apply filter
-	 *   bit 6:		ftrace internal event (do not enable)
+	 *   bit 0:		enabled
+	 *   bit 1:		enabled cmd record
 	 *
 	 * Changes to flags must hold the event_mutex.
 	 *
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ3u7AAoJEOdOSU1xswtMxsMH/1yS8N0k8f2Oxc3A+JTPGSdS
f+r+0U7pzjNB0Qv7NmpGqobTTID/Vzs5UTo/S/9T/5k3atnk7+n3/oKlPAxzyYZC
8//2TibizBsUAmG5xm5x1pSfQulOl/uBpBSdnY8hqPxjC5UCK1oFNSWnc7q6v8r9
YMdLa8H0gbu7nWdS3+a+uUH/inEZuLEBjaolPsC+RqI2L4ekh3kFEV9BltK8EG+T
y5PM0RnsKdUWm0DJg92ZDHY3Md4iUoJ0TP8RMxNhzbaIHe+o1Wv6E0Boj2wlORDx
fyPLgQnuuYaBvnoKKJQy+tm+wecd6Y+iRb7V7JWtAl2FAlRJo8eDgFSvMV3T5YM=
=nq0m
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
