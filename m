Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab3AOD1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 22:27:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5043 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab3AOD1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 22:27:11 -0500
X-Authority-Analysis: v=2.0 cv=T70Ovo2Q c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Om9gs21YYNIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=jI7U8BSgD1AA:10 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=173D2eteMl7QsvqjTiQA:9 a=QEXdDO2ut3YA:10 a=2cfT85sH4i8A:10 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=3l7LBOaamcw3dpvTSr4A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130115032710.277660195@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 14 Jan 2013 22:20:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Liu Bo <bo.li.liu@oracle.com>
Subject: [PATCH 2/2] tracing: Fix regression of trace_pipe
References: <20130115032042.472099050@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Fix-regression-of-trace_pipe.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Liu Bo <bo.li.liu@oracle.com>

Commit 0fb9656d "tracing: Make tracing_enabled be equal to tracing_on"
changes the behaviour of trace_pipe, ie. it makes trace_pipe return if
we've read something and tracing is enabled, and this means that we have
to 'cat trace_pipe' again and again while running tests.

IMO the right way is if tracing is enabled, we always block and wait for
ring buffer, or we may lose what we want since ring buffer's size is limite=
d.

Link: http://lkml.kernel.org/r/1358132051-5410-1-git-send-email-bo.li.liu@o=
racle.com

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f3ec1cf..3c13e46 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3454,7 +3454,7 @@ static int tracing_wait_pipe(struct file *filp)
 			return -EINTR;
=20
 		/*
-		 * We block until we read something and tracing is enabled.
+		 * We block until we read something and tracing is disabled.
 		 * We still block if tracing is disabled, but we have never
 		 * read anything. This allows a user to cat this file, and
 		 * then enable tracing. But after we have read something,
@@ -3462,7 +3462,7 @@ static int tracing_wait_pipe(struct file *filp)
 		 *
 		 * iter->pos will be 0 if we haven't read anything.
 		 */
-		if (tracing_is_enabled() && iter->pos)
+		if (!tracing_is_enabled() && iter->pos)
 			break;
 	}
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQ9MyOAAoJEOdOSU1xswtMSCIH/iFAYc5Zy5mk5/+IDflSjqZK
dEANl9/8Z57JQN5zVWCkjl1AYKho3v94h5yWBjdA06RSmIB58MspmzsQdmoulUHh
deu03qN9qKeDk21i4XpVMTxXGdp4OlP9VCUFni64u4a8f3wmdLQqQTpCKxxkvPm0
U4jaDUCwDs1IjA3DAK00yq9nxRDowbXM3iDLzQKxOxYv97sJkSu3XiOVL4EGbs/5
Y9xjdanV3kHr/WaIjhlp2cnwIKpFkg03wl8nahe1xgN3NKTa0RwvHCz6Pxh6thKb
oEcbn4l8UeQ7QUiIg6PFGyGDRqRAdoJgkrb4PVJJZdeQ6V3+fySIZGNk5zQ31QY=
=gX+O
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
