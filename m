Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab3EKAN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:13:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11649 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3EKANG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:06 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=CpzqSvTAJ9kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=v-7ZpieLT78A:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=VnNF1IyMAAAA:8 a=Agago8-g5CfXUuHOHFUA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=Fzq_riUUHIEgtV36ge0A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001304.399413784@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH 07/18] tracing/kprobes: Fix to increment return event probe hit-count
References: <20130511001206.477862307@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-kprobes-Fix-to-increment-return-event-probe-.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix to increment probe hit-count for function return event.

Link: http://lkml.kernel.org/r/20130509054424.30398.34058.stgit@mhiramat-M0=
-7522

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 1865d5f..6928633 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -767,6 +767,8 @@ static __kprobes void kretprobe_trace_func(struct kretp=
robe_instance *ri,
 	unsigned long irq_flags;
 	struct ftrace_event_call *call =3D &tp->call;
=20
+	tp->nhit++;
+
 	local_save_flags(irq_flags);
 	pc =3D preempt_count();
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRjY0QAAoJEOdOSU1xswtM+JcIAIXxHG7rnvmVIsA+Qjm9LFEp
XTHqyi4dLuTVsMvDszgAMNLEvCenOeFl6Kg7iL2MMdGBluHDRLb6mNfPthZ0u9Qg
xTNHdJtjJUC2IrDqEyKbsvwWLYKX+GfwflFj/JFnQMS9YtUZCjZ5qi0aCUvTuiuj
eVo4L/MxYJJrYsiSCUI4igOXXKu5tzbXvHuBMLGa6be675NZk0ZeNJolT0PgnyLR
iVpzkwJEks8ZGcQwL7GW68btRBdt0eq8EL1RLt6Rk71JVBvNViVLC5Satz7EYYMV
px6taK1satLBp4Y7i7kQl2hgQaXIm1ewz4Iz0DpUUIjXFdk12iFAHnrMHOUuTwI=
=3vem
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
