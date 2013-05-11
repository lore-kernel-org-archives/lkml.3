Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab3EKANp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:13:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11649 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab3EKANI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:08 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=eRzDlewj5ewA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=CS8ug4Mk4GEA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=VnNF1IyMAAAA:8 a=arZ6SeXbPmP6ca6IZTcA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=4-E8n_-o32CM1vvhTX4A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001306.094372368@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:21 -0400
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
Subject: [PATCH 15/18] tracing/kprobes: Increment probe hit-count even if it is used by
 perf
References: <20130511001206.477862307@goodmis.org>
Content-Disposition: inline; filename=0015-tracing-kprobes-Increment-probe-hit-count-even-if-it.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Increment probe hit-count for profiling even if it is used
by perf tool. Same thing has already done in trace_uprobe.

Link: http://lkml.kernel.org/r/20130509054436.30398.21133.stgit@mhiramat-M0=
-7522

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 0b7386a..6e86fbb 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -733,8 +733,6 @@ static __kprobes void kprobe_trace_func(struct kprobe *=
kp, struct pt_regs *regs)
 	unsigned long irq_flags;
 	struct ftrace_event_call *call =3D &tp->call;
=20
-	tp->nhit++;
-
 	local_save_flags(irq_flags);
 	pc =3D preempt_count();
=20
@@ -767,8 +765,6 @@ static __kprobes void kretprobe_trace_func(struct kretp=
robe_instance *ri,
 	unsigned long irq_flags;
 	struct ftrace_event_call *call =3D &tp->call;
=20
-	tp->nhit++;
-
 	local_save_flags(irq_flags);
 	pc =3D preempt_count();
=20
@@ -1075,6 +1071,8 @@ int kprobe_dispatcher(struct kprobe *kp, struct pt_re=
gs *regs)
 {
 	struct trace_probe *tp =3D container_of(kp, struct trace_probe, rp.kp);
=20
+	tp->nhit++;
+
 	if (tp->flags & TP_FLAG_TRACE)
 		kprobe_trace_func(kp, regs);
 #ifdef CONFIG_PERF_EVENTS
@@ -1089,6 +1087,8 @@ int kretprobe_dispatcher(struct kretprobe_instance *r=
i, struct pt_regs *regs)
 {
 	struct trace_probe *tp =3D container_of(ri->rp, struct trace_probe, rp);
=20
+	tp->nhit++;
+
 	if (tp->flags & TP_FLAG_TRACE)
 		kretprobe_trace_func(ri, regs);
 #ifdef CONFIG_PERF_EVENTS
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRjY0SAAoJEOdOSU1xswtMvaEIAIHrQzvv0cN0UNK0YP+eHuVK
xvfp0jmTnwObss0GBKlSX625ENUYSGuLJpx8ZYmfc4BnN3KY5mHNw3brXjwPsseR
o2i3upVLlHWMmC9aUk2Mm+MvVybPuQBx2Zb+mmfGy5IHEdm/G6GPbWfPyC+0vq2q
BnwzE7AmqgfIf4fNMojp+KlY/KiQ7KGU0LEFP9W0+Ee7EysufTPwBMEq/h+kcOH3
i1L0ZkwEKR0qjFiibfqnEAUbskqWDQy/90JwhitkNVU1ECXdUHNbL0eG8TrAZ3Zo
kNN8n/tAQZ0wbX0Zi8vJiIY4a/tgrbFsYviURxyF3KDmymODIMU0FVYbDKp69I0=
=2J6X
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
