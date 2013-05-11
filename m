Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab3EKANy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:13:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4056 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966Ab3EKANH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:07 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=T0Y_FsPlAm0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=I9PlRUdPBqkA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=QyXUC8HyAAAA:8 a=l4-8ysrOY-yO-mCvIQoA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=ckZmKN8NeBc8b4OMbpIA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001304.590286395@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Subject: [PATCH 08/18] tracing: Indicate enabled soft-mode in enable file
References: <20130511001206.477862307@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-Indicate-enabled-soft-mode-in-enable-file.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Indicate enabled soft-mode event as "1*" in "enable" file
for each event, because it can be soft-disabled when disable_event
trigger is hit.

Link: http://lkml.kernel.org/r/20130509054426.30398.28202.stgit@mhiramat-M0=
-7522

Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 87e826f..915c136 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -623,6 +623,8 @@ event_enable_read(struct file *filp, char __user *ubuf,=
 size_t cnt,
 	if (file->flags & FTRACE_EVENT_FL_ENABLED) {
 		if (file->flags & FTRACE_EVENT_FL_SOFT_DISABLED)
 			buf =3D "0*\n";
+		else if (file->flags & FTRACE_EVENT_FL_SOFT_MODE)
+			buf =3D "1*\n";
 		else
 			buf =3D "1\n";
 	} else
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRjY0QAAoJEOdOSU1xswtMoEgH/1hq36qXXiVxgCQpuC4d/ceB
bYA1YKL3KcOWt6p+OkSotvoD/s0fe4DCKcggt44aFZVDo11qCKNIzIz3pTvSll+p
JNKpbx0usuypCGzbLQV7hfpDfX/aXJR1Lc0RWsAwfuIXL9McLi0R4b+HNFDstHe+
aC+SHVhJ+uAnwfSqA0zDBQD90jCr9XmeCZpox1raBGQwVDIE+zjY9K9O4ynAoD0N
cBSjMG6dP6e/MlGqDjD/tX5PuFxUiBOjinMQXHPCbwFmM02kmW7LDmzKYKHdnZLt
pZsGRdL5wz5Pth++dr1J1XmQ3ap5sjqPNxUOl5EdTgid2C79wyUZZvbxwbYmxi4=
=y+pF
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
