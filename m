Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbaBFBAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 20:00:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56523 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935AbaBFBAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 20:00:32 -0500
Message-ID: <1391648425.3003.99.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 1/3] Revert "perf trace: Initial beautifier for ioctl's
 'cmd' arg"
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 06 Feb 2014 01:00:25 +0000
In-Reply-To: <1391648361.3003.97.camel@deadeye.wl.decadent.org.uk>
References: <1391648361.3003.97.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-IASBRa3mOCOAP3iaZiGH"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.239
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IASBRa3mOCOAP3iaZiGH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This reverts commit 78645cf3ed32860a3e83b8e35aa469f5b844a4ba,
which is incorrect for many architectures and has broken
compilation on at least powerpc and sparc.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: <stable@vger.kernel.org>
---
 tools/perf/builtin-trace.c | 34 +---------------------------------
 1 file changed, 1 insertion(+), 33 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 8be17fc..c9671bd 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -275,14 +275,6 @@ static size_t syscall_arg__scnprintf_strarray(char *bf=
, size_t size,
=20
 #define SCA_STRARRAY syscall_arg__scnprintf_strarray
=20
-static size_t syscall_arg__scnprintf_strhexarray(char *bf, size_t size,
-						 struct syscall_arg *arg)
-{
-	return __syscall_arg__scnprintf_strarray(bf, size, "%#x", arg);
-}
-
-#define SCA_STRHEXARRAY syscall_arg__scnprintf_strhexarray
-
 static size_t syscall_arg__scnprintf_fd(char *bf, size_t size,
 					struct syscall_arg *arg);
=20
@@ -835,28 +827,6 @@ static size_t syscall_arg__scnprintf_signum(char *bf, =
size_t size, struct syscal
=20
 #define SCA_SIGNUM syscall_arg__scnprintf_signum
=20
-#define TCGETS		0x5401
-
-static const char *tioctls[] =3D {
-	"TCGETS", "TCSETS", "TCSETSW", "TCSETSF", "TCGETA", "TCSETA", "TCSETAW",
-	"TCSETAF", "TCSBRK", "TCXONC", "TCFLSH", "TIOCEXCL", "TIOCNXCL",
-	"TIOCSCTTY", "TIOCGPGRP", "TIOCSPGRP", "TIOCOUTQ", "TIOCSTI",
-	"TIOCGWINSZ", "TIOCSWINSZ", "TIOCMGET", "TIOCMBIS", "TIOCMBIC",
-	"TIOCMSET", "TIOCGSOFTCAR", "TIOCSSOFTCAR", "FIONREAD", "TIOCLINUX",
-	"TIOCCONS", "TIOCGSERIAL", "TIOCSSERIAL", "TIOCPKT", "FIONBIO",
-	"TIOCNOTTY", "TIOCSETD", "TIOCGETD", "TCSBRKP", [0x27] =3D "TIOCSBRK",
-	"TIOCCBRK", "TIOCGSID", "TCGETS2", "TCSETS2", "TCSETSW2", "TCSETSF2",
-	"TIOCGRS485", "TIOCSRS485", "TIOCGPTN", "TIOCSPTLCK",
-	"TIOCGDEV||TCGETX", "TCSETX", "TCSETXF", "TCSETXW", "TIOCSIG",
-	"TIOCVHANGUP", "TIOCGPKT", "TIOCGPTLCK", "TIOCGEXCL",
-	[0x50] =3D "FIONCLEX", "FIOCLEX", "FIOASYNC", "TIOCSERCONFIG",
-	"TIOCSERGWILD", "TIOCSERSWILD", "TIOCGLCKTRMIOS", "TIOCSLCKTRMIOS",
-	"TIOCSERGSTRUCT", "TIOCSERGETLSR", "TIOCSERGETMULTI", "TIOCSERSETMULTI",
-	"TIOCMIWAIT", "TIOCGICOUNT", [0x60] =3D "FIOQSIZE",
-};
-
-static DEFINE_STRARRAY_OFFSET(tioctls, 0x5401);
-
 #define STRARRAY(arg, name, array) \
 	  .arg_scnprintf =3D { [arg] =3D SCA_STRARRAY, }, \
 	  .arg_parm	 =3D { [arg] =3D &strarray__##array, }
@@ -937,9 +907,7 @@ static struct syscall_fmt {
 	{ .name	    =3D "getrlimit",  .errmsg =3D true, STRARRAY(0, resource, rli=
mit_resources), },
 	{ .name	    =3D "ioctl",	    .errmsg =3D true,
 	  .arg_scnprintf =3D { [0] =3D SCA_FD, /* fd */=20
-			     [1] =3D SCA_STRHEXARRAY, /* cmd */
-			     [2] =3D SCA_HEX, /* arg */ },
-	  .arg_parm	 =3D { [1] =3D &strarray__tioctls, /* cmd */ }, },
+			     [2] =3D SCA_HEX, /* arg */ }, },
 	{ .name	    =3D "kill",	    .errmsg =3D true,
 	  .arg_scnprintf =3D { [1] =3D SCA_SIGNUM, /* sig */ }, },
 	{ .name	    =3D "linkat",	    .errmsg =3D true,


--=20
Ben Hutchings
It is a miracle that curiosity survives formal education. - Albert Einstein

--=-IASBRa3mOCOAP3iaZiGH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUvLeqee/yOyVhhEJAQql9hAAm3ilYgMmrNZVh1ciOHVHNLNaOtPnvTHT
BmMcdrhhipkQ0IwG/SKNW5Nf/ivD85xzmfLzMj02u1ni8NZGizJbAYXVyhLNTWGa
EvJlgxertfeGgsAm+/OT5yK8F25fSHxyA3Lzzj3KCy6bqga2YMI14oc1roYA3B1i
+44YYQfi5iYKk807JLoPrbB3HJ27nsyqichENFwKpOnVOP78y+NJhTWUcUyFPpnO
lgiIRV+uSpjMNjwDhtWhuD/2d+7ORRCBXRe3E5SY3ZQjWTBVvTwONnXLZnbgmUgD
pb61WqsztMInqrnXtZbcrhnpZ82Ur6MgCjZITbpWXPix0rduEfMj+S7OFCzjBJFX
5bErs1jjkCM1QtmFLy8g6Gb/4ZvuKxEmhXvYffuY3r6Lzx1WcdqP5uLSdc1jIQlP
PuXvvzk3owftx6g3+AE2yOGj8zyYd5hAnBTwzVzFlbPlnXPDLiylFUvZqn5BsDo8
VNfGs4AZ2Ht3kuC4k7hzKfyD/ZJCtpPXlwuWe4coolhIZiC5olHzhQus/doc+wFS
1A5WLPfF9N8mIITEortyz8rxZDqL4mkVsFd6xmNLTL+8wPaxKlfe6f778I0P1H7k
SPvb2Iuk4ON6vTMYGNiftFHPrXo/D8ZAl2713RI+kVm2cN77dbq9kj2xw73E1/u3
56ryY/+iyM8=
=dcUb
-----END PGP SIGNATURE-----

--=-IASBRa3mOCOAP3iaZiGH--
