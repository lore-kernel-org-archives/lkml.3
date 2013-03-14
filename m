Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab3CNVkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 17:40:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10477 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3CNVka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 17:40:30 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=1wJRR4cYkmsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ANdvieVncrYA:10 a=VwQbUJbxAAAA:8 a=B338KiplTNBcL9N_ccMA:9 a=QEXdDO2ut3YA:10 a=p1R48vrxUe8vqdWU8RoA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130314213303.302538352@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 14 Mar 2013 17:33:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL][3.9] tracing: Fixes with flags and latency tracers
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

Seems that the more I work on my 3.10 queue, the more I stumble
over 3.9 and long standing bugs :-p

Here's yet another patch (set) that needs to go into 3.9 and stable.

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

Anyway, here's hopefully my final series of changes for 3.9.
(Famous last words)

Thanks,

-- Steve

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: 8a28b54f3cadbc026a1debc28773848427e19bd6


Steven Rostedt (Red Hat) (3):
      tracing: Protect tracer flags with trace_types_lock
      tracing: Keep overwrite in sync between regular and snapshot buffers
      tracing: Prevent buffer overwrite disabled for latency tracers

----
 kernel/trace/trace.c              |   54 +++++++++++++++++++++++++++++----=
----
 kernel/trace/trace.h              |    6 +++++
 kernel/trace/trace_irqsoff.c      |   19 +++++++++----
 kernel/trace/trace_sched_wakeup.c |   18 +++++++++----
 4 files changed, 76 insertions(+), 21 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQkPJAAoJEOdOSU1xswtMJBkIAMtjmfhuP5bVZjNGXaNKxiYQ
1hq5x2HiUHgOewMo76jKjKo6Wo53efmZac2zXQPUEKxSqeMxQrxLJ2KTb5upQcjo
152N5cNJfxdCO5T7PSQNoVw3VPHYNq6Xae6YSy3aBiHZqp9YeZyktBMR41N+tzQ1
8nBdwvy1Sv7HgVAKWxPgjvcjKZnpdc1OuPiNX2SDX0CL5yySYTDy8WCLZ9tOqLL3
9CrvgrjtTDld86j152uPWevgkJ0mLaaYymaMelnqVjX36qYT+HVyCJR4VdcdaEFy
EYBqCzffxlgH7Uv031iud2EBa4eVggPDHVIXI6UKzx8T3sHMP5GcNnfrj85PZts=
=5aSE
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
