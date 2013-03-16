Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab3CPDcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 23:32:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18453 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab3CPDbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 23:31:44 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=XLayDsVUU8wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=-SDnNTJOJOMA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=z3w93D6QnL9Qrsi9OHYA:9 a=QEXdDO2ut3YA:10 a=hPjdaMEvmhQA:10 a=jeBq3FmKZ4MA:10 a=ao5HghhwNXjUKT1NoB4A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130316033142.606511645@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 23:24:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [for-next][PATCH 3/9] tracing: Use TRACE_MAX_PRINT instead of constant
References: <20130316032412.416651612@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Use-TRACE_MAX_PRINT-instead-of-constant.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

TRACE_MAX_PRINT macro is defined, but is not used.

Link: http://lkml.kernel.org/r/513D8421.4070404@huawei.com

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bba1ba9..8486256 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5978,8 +5978,8 @@ void
 trace_printk_seq(struct trace_seq *s)
 {
 	/* Probably should print a warning here. */
-	if (s->len >=3D 1000)
-		s->len =3D 1000;
+	if (s->len >=3D TRACE_MAX_PRINT)
+		s->len =3D TRACE_MAX_PRINT;
=20
 	/* should be zero ended, but we are paranoid. */
 	s->buffer[s->len] =3D 0;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ+eeAAoJEOdOSU1xswtMWYsIAIiul5fbIL0kGTX8ad0kL74/
uNcU/JSedbNQWOmax8Tdi6mCdQfymVg9InY9ZY5bRhy1Snn00J6TyzmgeYCAsDc+
In7P63PrH2MiV8P/K9JmS6SSuH8C7Zs51lUnaKZNFtN2Z3NLnnh2+eM/aG85vRzc
1ldJy1PJbtKJgEG/Osuy3/gL1eMmQXYxwxyQLeJMzx6zTA80tJsXGXchCyILYxug
zH9FoadYaUKBmKAxisFcTMCmg+n7OQ/FibGUPN3tMioEhHzR2C+CKyQC/8vvHLEf
qW81tGdGw50HCtQuzLC6WLyAYaEHHRmIH+Ff4VqkbSFUkkr1e5Zw4VzpZsPrGqw=
=XKqJ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
