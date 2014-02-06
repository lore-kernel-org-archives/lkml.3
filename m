Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbaBFBAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 20:00:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56535 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754559AbaBFBAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 20:00:50 -0500
Message-ID: <1391648441.3003.101.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 3/3] perf trace: Decode architecture-specific signal numbers
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 06 Feb 2014 01:00:41 +0000
In-Reply-To: <1391648361.3003.97.camel@deadeye.wl.decadent.org.uk>
References: <1391648361.3003.97.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-EdzDIibAk0fwch6D7HJf"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.239
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EdzDIibAk0fwch6D7HJf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

SIGSTKFLT is not defined on alpha, mips or sparc.
SIGEMT and SIGSWI are defined on some architectures and should be
decoded here if so.

Fixes: 8bad5b0abfdb ('perf trace: Beautify signal number arg in several sys=
calls')
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: <stable@vger.kernel.org>
---
 tools/perf/builtin-trace.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 5c32dcf..25ea64c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -807,7 +807,6 @@ static size_t syscall_arg__scnprintf_signum(char *bf, s=
ize_t size, struct syscal
 	P_SIGNUM(PIPE);
 	P_SIGNUM(ALRM);
 	P_SIGNUM(TERM);
-	P_SIGNUM(STKFLT);
 	P_SIGNUM(CHLD);
 	P_SIGNUM(CONT);
 	P_SIGNUM(STOP);
@@ -823,6 +822,15 @@ static size_t syscall_arg__scnprintf_signum(char *bf, =
size_t size, struct syscal
 	P_SIGNUM(IO);
 	P_SIGNUM(PWR);
 	P_SIGNUM(SYS);
+#ifdef SIGEMT
+	P_SIGNUM(EMT);
+#endif
+#ifdef SIGSTKFLT
+	P_SIGNUM(STKFLT);
+#endif
+#ifdef SIGSWI
+	P_SIGNUM(SWI);
+#endif
 	default: break;
 	}
=20

--=20
Ben Hutchings
It is a miracle that curiosity survives formal education. - Albert Einstein

--=-EdzDIibAk0fwch6D7HJf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUvLeuue/yOyVhhEJAQrwexAA0iJ2M1Ha6ZeLxWaIeMfSYdXjzUqiCplV
ld6we/GkeXTrlXcz/3Qm+8F9izKOWrZpSpLYQTHZs16mZrQsdIqz82bz2pT4L+eo
OtWIkJdJSYh9j1KK0Myx4N3DP3FqOxRpXcY88PVrdOT8SfY61XkylXdqH1m5MheW
cpaPorNEPCnAtfG/7Ch/+f9nyh5elmLzfvwWBBKgx1JX+aXB+hIn8jxloUSYQMQH
X4MLkaIQTQCm4tb2cgYJNumpUhfC1zxpPyFJqtRWQDeqF+K5ieCviY40dVwbymDr
giRzsghy1HMOCvC6dqxBIamfp365tzUBWBm2S2qan3N95LidAaF3Ei/RGV7f+ExF
gzIGH2H+x8hwjxMgs+AADw9ePHzax2gqxLUBwVl7cm1ltq7E6Y/fqlfLHp866RgV
u+UVSn0qKgRHe1k1s2g3e22KppFOiytdFcC5hK6IcL4VitLYD+STRXVmoUlQ/lWK
W6t2YpdSLVj2XKRD2+mvW+GvDaW4CwmEhjcU1GmcTlHQkC2fhx+6jWHYn5dTR2yY
li9pH86dzH2aXxPpBn/q+kGcebpPq3GQ97ITIRQqbOYjJyGxKTFRNZr/3s2Gv7mW
Je+5sSs7tcQJpTYxy6VGaJwYM6N/NuCSCT3M7Ggsunm1E6vUpuM2aObMR1FlRAHe
uOFfxJ9d2wI=
=JwaL
-----END PGP SIGNATURE-----

--=-EdzDIibAk0fwch6D7HJf--
