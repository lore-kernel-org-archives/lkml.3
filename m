Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3DVPVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 11:21:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13446 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab3DVPV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 11:21:28 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=568tTqlxv9MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=5qBJZXopSywA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=1XWaLZrsAAAA:8 a=VnNF1IyMAAAA:8 a=o2WwMXiXxKMk1GZNxUYA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=UTB_XpHje0EA:10 a=o9pwrgduIDOShOAtjuoA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130422152127.001086345@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 22 Apr 2013 11:20:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Gary Hade <garyhade@us.ibm.com>
Subject: [for-next][PATCH 1/2] tracing: Compare to 1 instead of zero for is_signed_type()
References: <20130422152026.207981701@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Compare-to-1-instead-of-zero-for-is_signed_t.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The formats of the trace events show if the type of a event field
is signed or not via a macro called is_signed_type(). This does
a trick with the type and compares a -1 to zero after typecasting
to the tested type. If it returns true, it's signed, otherwise
its not. But this unfortunately triggers a warning by gcc:

  warning: comparison of unsigned expression < 0 is always false

As we know it is always false (that's why we do it), this is a
false warning. Luckily for us, the comparison works with a 1 as
well, without giving the warning.

Convert the check to compare (type)-1 < (type)0 to (type)-1 < (type)1
to determine if the type is signed or not.

Link: http://lkml.kernel.org/r/CAErSpo4YXcY9fuOKWYGDkddJwk68kmZTohsmVB6Qvrh=
jboOh1Q@mail.gmail.com

Reported-by: Bjorn Helgaas <bhelgaas@google.com>
Reported-by: Gary Hade <garyhade@us.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4e28b01..34e00fb 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -333,7 +333,7 @@ extern int trace_define_field(struct ftrace_event_call =
*call, const char *type,
 extern int trace_add_event_call(struct ftrace_event_call *call);
 extern void trace_remove_event_call(struct ftrace_event_call *call);
=20
-#define is_signed_type(type)	(((type)(-1)) < (type)0)
+#define is_signed_type(type)	(((type)(-1)) < (type)1)
=20
 int trace_set_clr_event(const char *system, const char *event, int set);
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRdVV3AAoJEOdOSU1xswtMbHEIAJfGUEAEGZLFuM3MTSkkBTHF
YLA6i4ke4ks5MO7kb+7qEuc45OD1r8HF9mCBc7QLlku5XsXTkb7/hCZKVNeGsOj7
ajSX194+eizzW1SlRg4ONHDrQAEgMQIIYuujrCFaZsb1Hrs/pTpgLBlhS/qtxdeS
b8Ce0HkZ4I2xn/SZJcqRBRRXadtv0ppvWC98YyE76KIgNfOjL2Hwe8sxGjpKOeDT
rXslgLghvU+YjmfQNYDGYSePil3tMvTw2qAIhBGdssBYBTL3wKRW13Z5L7PNIG3m
Q3Y7JvT9Q7uGQ0e05CctD1stl3VCzjOHfK/HNO5y9wxP9psAnPwcIMkN6tqEe/M=
=nrKm
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
