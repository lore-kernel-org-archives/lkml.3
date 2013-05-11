Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab3EKANq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:13:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26184 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab3EKANI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:08 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=RLKoo40W0fYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=x6Hd-1goRbkA:10 a=v-9Tpi4omvYqg6QLtcEA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=sWFldwy9pU_93O82478A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001305.508530826@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 12/18] ftrace: Fix the output of enabled_functions debug file
References: <20130511001206.477862307@goodmis.org>
Content-Disposition: inline; filename=0012-ftrace-Fix-the-output-of-enabled_functions-debug-fil.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The enabled_functions debugfs file was created to be able to see
what functions have been modified from nops to calling a tracer.

The current method uses the counter in the function record.
As when a ftrace_ops is registered to a function, its count
increases. But that doesn't mean that the function is actively
being traced. /proc/sys/kernel/ftrace_enabled can be set to zero
which would disable it, as well as something can go wrong and
we can think its enabled when only the counter is set.

The record's FTRACE_FL_ENABLED flag is set or cleared when its
function is modified. That is a much more accurate way of knowing
what function is enabled or not.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f104c45..dcca9fa 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2459,7 +2459,7 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		     !ftrace_lookup_ip(ops->notrace_hash, rec->ip)) ||
=20
 		    ((iter->flags & FTRACE_ITER_ENABLED) &&
-		     !(rec->flags & ~FTRACE_FL_MASK))) {
+		     !(rec->flags & FTRACE_FL_ENABLED))) {
=20
 			rec =3D NULL;
 			goto retry;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRjY0RAAoJEOdOSU1xswtMDWQH/1Usv8Bkc2qupanP/BmgoyE4
nDKB1KsbwMBuCtbB0LkMos20rLcRmI/yyKdsk6L2Z09UA9mjpMU3LX8KYPy+FM4I
rnv8egNuAzWhfH81umjwJahrlj2saHQEw3Dyo54eCj/A8f1RawQJJmIlM+C0p4fD
r7kCKw2bosxXe1HLJVKHIUuJL0oM+vLCCdVF+CeqlkhZn3rqd/3nbgYrEv5T/3pQ
nbSn+pMDlIfim59VlQRF7P2LzUh89w816J2gRTGCV9yPJm9BxgNKQR7eD+lgiEBA
ddjyJ0viiZP+LFGeiM/faernREqtkXy4u38IkIN+QBadv2UYCoNCIihZLsq/X7E=
=uVhV
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
