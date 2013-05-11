Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab3EKANd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:13:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11649 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab3EKANF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:05 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Q01Ji7nO_U0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=n6nKWzXh2cUA:10 a=VwQbUJbxAAAA:8 a=LMcSrfU8RRQBovQVaDYA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=JTMqrY5UvyEA:10 a=LI9Vle30uBYA:10 a=c3d4ZAKcgtrIh3wP5qgA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001303.237466370@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnd Bergmann <arnd@arndb.de>, Robert Richter <rric@kernel.org>
Subject: [PATCH 01/18] ring-buffer: Select IRQ_WORK
References: <20130511001206.477862307@goodmis.org>
Content-Disposition: inline; filename=0001-ring-buffer-Select-IRQ_WORK.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

As the wake up logic for waiters on the buffer has been moved
from the tracing code to the ring buffer, it requires also adding
IRQ_WORK as the wake up code is performed via irq_work.

This fixes compile breakage when a user of the ring buffer is selected
but tracing and irq_work are not.

Link http://lkml.kernel.org/r/20130503115332.GT8356@rric.localhost

Cc: Arnd Bergmann <arnd@arndb.de>
Reported-by: Robert Richter <rric@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 5e9efd4..015f85a 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -71,6 +71,7 @@ config TRACE_CLOCK
 config RING_BUFFER
 	bool
 	select TRACE_CLOCK
+	select IRQ_WORK
=20
 config FTRACE_NMI_ENTER
        bool
@@ -107,7 +108,6 @@ config TRACING
 	select BINARY_PRINTF
 	select EVENT_TRACING
 	select TRACE_CLOCK
-	select IRQ_WORK
=20
 config GENERIC_TRACER
 	bool
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRjY0PAAoJEOdOSU1xswtMAK4IALDc/YMupGTSZZmHYSMJpC2E
KEextlNZAP6LpEaXbRtff6MT3jwrzzy2Co8CoEKBWf1wW2yvBjAMwcgxAMOgqruU
B5+ErOajAHbUUuxwajDmgsJqefLgwgynG3rustjUMO8ChYLAKxOPLidgR5n3MZnX
OF+HXKlIimFRhbItBdiTH2RkKq38V+tItRs2GdKmM8I2Ak4e7HbJwj2W/osTkHCF
FscYoXyoqF2Sl9wLPLv5j5r7Xxzl9qDBQ2zasXRNmW92GvRS69xVHuc3rsNevAH6
COoLcijqo6Keru/ifqFmOQMsYllwPBvNs3s203AB51gziRzmaUqW9kT5Tm9RKKM=
=Fe6l
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
