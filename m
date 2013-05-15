Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab3EOTma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:42:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab3EOTm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:42:26 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Gj-vt-Affh0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=HYRmSkBpoVkA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=ViCslrFICJ3MyFOPiZYA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rTPQq76IRA2uKfz74NcA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130515194224.572820464@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 15 May 2013 15:39:26 -0400
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
Subject: [PATCH 4/4] tracing/kprobes: Make print_*probe_event static
References: <20130515193922.094868872@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-kprobes-Make-print_-probe_event-static.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

According to sparse warning, print_*probe_event static because
those functions are not directly called from outside.

Link: http://lkml.kernel.org/r/20130513115839.6545.83067.stgit@mhiramat-M0-=
7522

Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 81c5109..9f46e98 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -962,7 +962,7 @@ kretprobe_trace_func(struct trace_probe *tp, struct kre=
tprobe_instance *ri,
 }
=20
 /* Event entry printers */
-enum print_line_t
+static enum print_line_t
 print_kprobe_event(struct trace_iterator *iter, int flags,
 		   struct trace_event *event)
 {
@@ -998,7 +998,7 @@ partial:
 	return TRACE_TYPE_PARTIAL_LINE;
 }
=20
-enum print_line_t
+static enum print_line_t
 print_kretprobe_event(struct trace_iterator *iter, int flags,
 		      struct trace_event *event)
 {
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRk+UgAAoJEOdOSU1xswtM8hIH/iCvX6oZF7rC3RuGeVJGa4JT
MG2Yg27TM8EefuaOWNN8DkQw9ANsu4NsuxEC4WBvCUe2expnDnziWmxbf17vMizA
vra5HIR9HgU7qW4/HfTnZWCiUnVKfUFC+BxHIqBEH9wXTzXWhC+NfV6Z3Iwqfd8t
obFR0lt09Jnd6Y4l9Pcq8E8gqnBEc+2o3yXrO4yK4UMePg+ZnMdno+okuOlIwmqC
B05gGBb+g0sIvvFSis1JcMpIu3X8c1xa2NO3zzbK8d1S8lGOtp/qDnr21ZOvzCnv
6OoOFcxep4YWF9IneytyHHslj0ytY11saJ2Y7ngQnd5JI9M7zchW9PCMJmkFhUI=
=LVgd
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
