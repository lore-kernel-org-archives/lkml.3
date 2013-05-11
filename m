Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab3EKAOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:14:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26184 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab3EKANG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:06 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=d0bJ0RYreG8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=SRBuSu8WieIA:10 a=3nbZYyFuAAAA:8 a=lmcEmdQg-uVwDH5O87gA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=EvKJbDF4Ut8A:10 a=uiYmaT7mAurxkoyR:21 a=Rwu8c-QgAMvsS3z7:21 a=eFJuNF4DFz1MedSrADcA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001303.794894915@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 04/18] ftrace: Have ftrace_regex_write() return either read or error
References: <20130511001206.477862307@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-Have-ftrace_regex_write-return-either-read-or.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

As ftrace_regex_write() reads the result of ftrace_process_regex()
which can sometimes return a positive number, only consider a
failure if the return is negative. Otherwise, it will skip possible
other registered probes and by returning a positive number that
wasn't read, it will confuse the user processes doing the writing.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8a5c017..d85a0ad 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3276,7 +3276,7 @@ ftrace_regex_write(struct file *file, const char __us=
er *ubuf,
 		ret =3D ftrace_process_regex(iter->hash, parser->buffer,
 					   parser->idx, enable);
 		trace_parser_clear(parser);
-		if (ret)
+		if (ret < 0)
 			goto out_unlock;
 	}
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRjY0PAAoJEOdOSU1xswtM9pIIALJa5whaJw93UWdO51KnFTBi
inDVQY6Pk3Vgv/XAQJaynP8xCBBIXxobMXggeC9unMCDqY6Bh6yarQGqddhHDgoC
M6/RIKVYPCU7NPIr5F2hOWgYLLK1IK72YCidxMndYe/3jdI1FyRHascSSlaB3fLd
f6EZkJwAeC4vllh1CgcJYHAj+yod1hSzjKyILp9wcebuOhpi/pAbscp7hkd/eLG8
P1A9QLTErDXMKtMmqe7T5VmtvKUi3nk3JN2Bp64E2a+bqAVEB7rmP4n+uVMsDcQ8
KDsv5OwVfBs24/OCccirXL3Mal/RCFVq9zA2ojUHpff6haigbdxxkNTsH660j7I=
=Hxjp
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
