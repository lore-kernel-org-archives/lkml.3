Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab3EKANj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:13:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11649 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab3EKANJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:09 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3Sy-jfKgP8gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ooQyfMh2t7cA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=VnNF1IyMAAAA:8 a=gJq9AGUoqJ39Dg-WvVQA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=tVoZ0KTDtnP5G8oRcIkA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001306.751690762@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:24 -0400
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
Subject: [PATCH 18/18] tracing/kprobes: Support soft-mode disabling
References: <20130511001206.477862307@goodmis.org>
Content-Disposition: inline; filename=0018-tracing-kprobes-Support-soft-mode-disabling.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Support soft-mode disabling on kprobe-based dynamic events.
Soft-disabling is just ignoring recording if the soft disabled
flag is set.

Link: http://lkml.kernel.org/r/20130509054454.30398.7237.stgit@mhiramat-M0-=
7522

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index fee865d..636d45f 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -845,6 +845,9 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_r=
egs *regs,
=20
 	WARN_ON(call !=3D ftrace_file->event_call);
=20
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+		return;
+
 	local_save_flags(irq_flags);
 	pc =3D preempt_count();
=20
@@ -893,6 +896,9 @@ __kretprobe_trace_func(struct trace_probe *tp, struct k=
retprobe_instance *ri,
=20
 	WARN_ON(call !=3D ftrace_file->event_call);
=20
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+		return;
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

iQEcBAABAgAGBQJRjY0SAAoJEOdOSU1xswtM5/sH/2CN0GTDNiqWJ4fBcR/kTxHz
yOs0hU4QsDQc3LMEShlFwN3sVclWFYxVXRcmoyLGntyjg2z/LgOuhLOD0o5Pkp7f
jZPJlUD6XUYAp27dv35dMM4tKAroNODd28ylqLc3YWFe8ieyLRMYB8zC1czDA+48
reZNROp+fX26S9yQr89p0/238KZa1wBi25icFLrcS/biDlGJkrKWccggzorlOyrY
CHztQgsUpRVEXFNxsWjSHiMfYlc8OfeEaax4iiJQGhRy8amFNG980sdNEMkyg9IE
bBXN8hXvRWpW1MO+PDm7/ye56bkjMJoN9rYajlhUlTgTh/XtN1XbWi5/30J+qpA=
=s7JJ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
