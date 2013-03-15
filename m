Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab3COTwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:52:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27573 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab3COTv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:28 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=kiqpUSEY0E0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=t7cQmnt9RJUA:10 a=pGLkceISAAAA:8 a=7UP2ANuj3NrH8xkdtVAA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=MSl-tDqOz04A:10 a=yzF4G9T43oE4jbcrdJ0A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195125.735616225@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [for-next][PATCH 19/20] tracing: Add "perf" trace_clock
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0019-tracing-Add-perf-trace_clock.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The function trace_clock() calls "local_clock()" which is exactly
the same clock that perf uses. I'm not sure why perf doesn't call
trace_clock(), as trace_clock() doesn't have any users.

But now it does. As trace_clock() calls local_clock() like perf does,
I added the trace_clock "perf" option that uses trace_clock().

Now the ftrace buffers can use the same clock as perf uses. This
will be useful when perf starts reading the ftrace buffers, and will
be able to interleave them with the same clock data.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8eabfbb..7f0e7fa 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -648,6 +648,7 @@ static struct {
 	{ trace_clock_global,	"global",	1 },
 	{ trace_clock_counter,	"counter",	0 },
 	{ trace_clock_jiffies,	"uptime",	1 },
+	{ trace_clock,		"perf",		1 },
 	ARCH_TRACE_CLOCKS
 };
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ3u9AAoJEOdOSU1xswtMPZIH/jyXayneslzoTRFR2Zn+COBU
5ssYma49Kkrr0EFYdcue0dabYTjc7J2aCSNFNoogZ0dZfhht1r+GcGfIipLyupsl
oq2Ia7bmqIjF+yVrYUSKOn2SrFY+6VVjj+vQKRobobBC+XS7+DiHWLtZHsIjmRGd
qVT1nVSx18gdvQJcKwlnBTwjvJqUiRKoxFkzEHTUFf2C+FPPAndRRv/1yHer0aht
e6ADjxIDVFQiNKr0QoA06er+VdETC5relZOcs1vtlZUBrj5X7rC9fiLml0QdaFLZ
78NrnqYsVoYZeKCH0KORH945NdY0lF9v9fpfAdEqQ5EuHrH3KCRo7FxhmYzxfCA=
=m0TO
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
