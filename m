Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaBFBAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 20:00:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56529 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935AbaBFBAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 20:00:43 -0500
Message-ID: <1391648435.3003.100.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 2/3] perf trace: Add fallback definition of EFD_SEMAPHORE
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 06 Feb 2014 01:00:35 +0000
In-Reply-To: <1391648361.3003.97.camel@deadeye.wl.decadent.org.uk>
References: <1391648361.3003.97.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-coWg8row8lR+GqCYdWTu"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.239
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-coWg8row8lR+GqCYdWTu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

glibc 2.17 is missing this on sparc, despite the fact that it's
not architecture-specific.

Fixes: 49af9e93adfa ('perf trace: Beautify eventfd2 'flags' arg')
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: <stable@vger.kernel.org>
---
 tools/perf/builtin-trace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c9671bd..5c32dcf 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -35,6 +35,10 @@
 # define MADV_UNMERGEABLE	13
 #endif
=20
+#ifndef EFD_SEMAPHORE
+# define EFD_SEMAPHORE		1
+#endif
+
 struct tp_field {
 	int offset;
 	union {


--=20
Ben Hutchings
It is a miracle that curiosity survives formal education. - Albert Einstein

--=-coWg8row8lR+GqCYdWTu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUvLes+e/yOyVhhEJAQqPcA//RSK2pnS2gK8QzTXWihcvpyrVLJij7WxI
+kb1MTGYccd8ZnPIJZp/wusx6atSs5xBpLcByl7YwzcAaaN/Cg6lujLXg8hEdWVA
cqdRFOefR8ISno5HQVY6QractZ8zlHAJFawuy3CVosrEdo5ZewwZhzSM2q5CgJvh
Rlarzp95r0mc1ZZzkNXwlMTioZ8B0AtnNKSQTRJ5JxrA9K4KPht1njqAawDE7R5D
isZgxJ+b4q4ekV0VAUVa4ul2RcGzugnFfNEoKvtnH0aHabURmrjdM+a2wbqVx1rW
WuwRlQio4JVUqgvEed40zpd0QLizY/jiTy1m72vUIIizObUNMaixkYPZi53Rqowr
lMfD+46e2GUKo+CmrqnsH8diTio9/vRVAZYUoP7JYQc9WGP059Ml2hVc7BJ0VuW5
1ZdanNgtRcLwh4vW/UmyF07P4eygvRvRRbcWx+3v+qyQe9AYC5HEsC6+TCIeyvsj
pl/BCGL2k8n2NrNTOezj5VFZpsO19aIEOiK0INczyVpgVqhddckozAaFNbYIa2b7
WVUw6bQ4/z7im17Nsw81XYQ4sa0hhHwftII6CUPzrs2WC+IOCBMWoHTBDRZ+SQPJ
rImjai40srHyf/AMk/rl9GMzuoPlPJ3BDIJ7TTc2Ms1JGjwZc4mz54VnisBCvQeO
nr1eyIKfNXs=
=t1Cd
-----END PGP SIGNATURE-----

--=-coWg8row8lR+GqCYdWTu--
