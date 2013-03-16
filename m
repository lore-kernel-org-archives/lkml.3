Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab3CPDcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 23:32:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3057 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3CPDbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 23:31:44 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=7U7jH6AurG0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=NZNHkhM1qTwA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=ZUgf_iq-7Fh9CYyPp5oA:9 a=QEXdDO2ut3YA:10 a=hPjdaMEvmhQA:10 a=jeBq3FmKZ4MA:10 a=N_BYMJslOPtVR1qEycAA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130316033143.186743139@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 23:24:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [for-next][PATCH 6/9] tracing: Fix comment about prefix in arch_syscall_match_sym_name()
References: <20130316032412.416651612@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Fix-comment-about-prefix-in-arch_syscall_mat.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

ppc64 has its own syscall prefix like ".SyS" or ".sys". Make the
comment in arch_syscall_match_sym_name() more understandable.

Link: http://lkml.kernel.org/r/513D842F.40205@huawei.com

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_syscalls.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 68f3f34..8f2ac73 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -37,7 +37,7 @@ static inline bool arch_syscall_match_sym_name(const char=
 *sym, const char *name
 	/*
 	 * Only compare after the "sys" prefix. Archs that use
 	 * syscall wrappers may have syscalls symbols aliases prefixed
-	 * with "SyS" instead of "sys", leading to an unwanted
+	 * with ".SyS" or ".sys" instead of "sys", leading to an unwanted
 	 * mismatch.
 	 */
 	return !strcmp(sym + 3, name + 3);
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ+efAAoJEOdOSU1xswtM/OgH+wZNutIfVPmpperFUfhRpGWu
DDqTIWDonz1u6ORwKFrbWi6BHPx+AVgfT/JwgbgKU1ht8ROSmmubuXOrwUkSdkOO
MN1mXaMy3upz75qFM7EjVOZ2qcoYqnIcZqHivpoqsV2scCchx5JMifWVX4jd7bgM
qwDkPNVDW+Xtd9SAN3nQVHcHbWC2A1D3yllxUSRmNvNdlsH1wcqG8nqu2i7jUGsy
1QwMnOZtTYEK++vzQWm3clWAY+MwZTFGW1iqLtXFh9dH20L0WNIkM/nKImWUHBqU
av3EqNyETh5buiVEs6q0Ag3PBsG0FUxS0M6ZbsuhNM7IYcLcS9V92oj24oVOozY=
=8oOU
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
