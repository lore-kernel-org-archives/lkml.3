Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab3EOTmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:42:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23277 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab3EOTm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:42:26 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=OGgnL5qRWUQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=2EtF5ySqFW4A:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=O77O0tlvH4OdaY5DkwAA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=4j-Be1SvLWM7uFvNU_IA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130515194224.384991784@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 15 May 2013 15:39:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 3/4] tracing/kprobes: Fix a sparse warning for incorrect type in
 assignment
References: <20130515193922.094868872@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-kprobes-Fix-a-sparse-warning-for-incorrect-t.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix a sparse warning about the rcu operated pointer is
defined without __rcu address space.

Link: http://lkml.kernel.org/r/20130513115837.6545.23322.stgit@mhiramat-M0-=
7522

Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 0a3d8d5..81c5109 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -35,7 +35,7 @@ struct trace_probe {
 	const char		*symbol;	/* symbol name */
 	struct ftrace_event_class	class;
 	struct ftrace_event_call	call;
-	struct ftrace_event_file	**files;
+	struct ftrace_event_file * __rcu *files;
 	ssize_t			size;		/* trace entry size */
 	unsigned int		nr_args;
 	struct probe_arg	args[];
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRk+UgAAoJEOdOSU1xswtMMqIH/jNg2bFdfnpij9hS2dDaU7oc
4zRRZMZrcuYLLPC15rKYUzpePlHhldnYh/C1Ar5TWx1ifia/OlIxvXQTP0L7OcqB
jwG1+YWwWZubw8KO3NEWVX1wgTAA0lPaDLmvxkdrFE1KWY/rZjw1gJpshh01W5r/
hFr+2CagMH+OMoi3knsdkBf0WuFTvfQ4W39n0r2vOI19u6J4M55WKbbhyEZ8z3fp
lL266D5namhLvrZkhR1H5ws5qKQm9MkG/DWNE4R2wgx3tfqhk9LsqgBq6FEUHUaZ
4ASJTUuQLVbq2X8ymFoYMcV3bUtxmqTjpg7DkQKQkIlVDW5hCpFCVSgSXlnoLWA=
=pxht
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
