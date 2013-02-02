Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851Ab3BBOU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:20:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15416 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723Ab3BBOT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:19:59 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=wBQ6kyXqWdQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=aRSc99bivSEA:10 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=qAaru0vXYkri28767zIA:9 a=QEXdDO2ut3YA:10 a=lqfzikGvtTgA:10 a=TIV7c6GJmisA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=PA-H8lXqmHqWmEGognYA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130202141955.909958480@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 02 Feb 2013 09:18:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 07/11] tracing: Use sched_clock_cpu for trace_clock_global
References: <20130202141842.189550803@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Use-sched_clock_cpu-for-trace_clock_global.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Namhyung Kim <namhyung.kim@lge.com>

For systems with an unstable sched_clock, all cpu_clock() does is enable/
disable local irq during the call to sched_clock_cpu().  And for stable
systems they are same.

trace_clock_global() already disables interrupts, so it can call
sched_clock_cpu() directly.

Link: http://lkml.kernel.org/r/1356576585-28782-2-git-send-email-namhyung@k=
ernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_clock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 22b638b..24bf48e 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -84,7 +84,7 @@ u64 notrace trace_clock_global(void)
 	local_irq_save(flags);
=20
 	this_cpu =3D raw_smp_processor_id();
-	now =3D cpu_clock(this_cpu);
+	now =3D sched_clock_cpu(this_cpu);
 	/*
 	 * If in an NMI context then dont risk lockups and return the
 	 * cpu_clock() time:
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRDSCMAAoJEOdOSU1xswtMrZAIAKZGoEKkdc/zEsjY51BnbOeo
cRL+8jGO+VkIhkzmPKrDRr2SlM+cAgf/ezz3ywemm8L7hZChpzOK7OEttJ0sVKwx
5O/iVDgHhecZ6XJeUX7F2kzslRgR7/2pXGydnevLXfJMCVzoLWfBvJKl/V6weWyA
aNtH/UCk/OUuW0JyTyZcWNkOEuEbncAJviKjb2UxYwjwfudadqwWxeJoFyXewLwp
L2rw1AGnBxLnWCNLBNMrnpMrhtm/aBUoN9iB5/XpBnvn1kmvT61MogwCrfx653DY
oo4O5VTRi2JxiJOTHL0EIHZKthibC5GIGfawORp/LuebxlmvrC7888MTbhQuJso=
=n/u5
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
