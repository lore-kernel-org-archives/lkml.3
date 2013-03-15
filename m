Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab3COFUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:20:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13908 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab3COFUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:20:34 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=E1LtTWjVx6EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=UT4QVkSPEkIA:10 a=VwQbUJbxAAAA:8 a=B338KiplTNBcL9N_ccMA:9 a=QEXdDO2ut3YA:10 a=5qRdPj1n6qdlmhr6jncA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315050616.512983245@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 01:06:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3 v2] [GIT PULL][3.9] tracing: Fixes with flags and latency tracers
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

Here's take two of the last patch series I sent. The only difference
with this series is that I encapsulate the max_tr reference with
the #ifdef CONFIG_TRACER_MAX_TRACE. Other than that, it's the same.

Here's the recap:

The first patch fixes a long standing bug where the changing of
the trace options has absolutely no protection against multiple
changers. Luckily, this is something that requires human (root)
action, and is usually performed by a single individual. But as
scripts are starting to become more active, this bug is bound to
be triggered.

The second patch is a bug where the setting of the overwrite flag
can cause the max and normal buffers to get out of sync. This
is more predomitinant with the 3.9 snapshot feature, but still
has an affect on the latency tracers. Which bring us to the third
patch.

The third patch I found out that disabling overwrite to the buffers
screws with the latency tracers. If the buffer is in produce consumer
mode, the irqsoff tracer and friends wont show any output at all.
This was a bit frustrating to figure out.

Hopefully this time it's good.

Thanks,

-- Steve

Please pull the latest tip/perf/urgent-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent-2

Head SHA1: 613f04a0f51e6e68ac6fe571ab79da3c0a5eb4da


Steven Rostedt (Red Hat) (3):
      tracing: Protect tracer flags with trace_types_lock
      tracing: Keep overwrite in sync between regular and snapshot buffers
      tracing: Prevent buffer overwrite disabled for latency tracers

----
 kernel/trace/trace.c              |   56 +++++++++++++++++++++++++++++----=
----
 kernel/trace/trace.h              |    6 ++++
 kernel/trace/trace_irqsoff.c      |   19 +++++++++----
 kernel/trace/trace_sched_wakeup.c |   18 ++++++++----
 4 files changed, 78 insertions(+), 21 deletions(-)


--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQq+dAAoJEOdOSU1xswtMI/cH/idk+g70ueDPTiQDDtz3+C0n
w/6xZVSM8F5JmmK4up6oglkXUgDkuJLflWU9xK2++GdyeZK7XvMNiRI0HaGg0kGS
NIPMRIfVs5XyvC3eN7aNIPQTuzQLLrvhx2gIroA8hp2Y7UrD6KuJki2EY7Q7br9z
eMmCUdWN+2CWlot4g7wWPcRdxRK62H3uKePX7yDZdEXEt297L93a+2rjOBy1iY14
v8bLLTWDqSrPVH/7RZKvTs9H1GI4StHDRfqdBZYeOSPxgJN2odFBlmu2OBv6nRQ2
WeKKollXx2Xh2V9cDDkLx+FNToY4Gyv2mzZIZK4WvXNR9yqJd8pdWuajJQNXqUU=
=UYYi
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
