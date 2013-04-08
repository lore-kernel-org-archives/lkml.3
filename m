Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965104Ab3DHVF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:05:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31580 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964951Ab3DHVFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:05:21 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=zlhBuWjBQ0gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=iGLzu7E53V8A:10 a=VwQbUJbxAAAA:8 a=tpETqHMvXi9VCWOkuAQA:9 a=QEXdDO2ut3YA:10 a=dP0ePcnYyIiIPA84BXsA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130408204937.649895945@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 08 Apr 2013 16:49:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL] tracing: three fixes
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Linus,

This includes three fixes. Two fix features added in 3.9 and one
fixes a long time minor bug.

The first patch fixes a race that can happen if the user switches
from the irqsoff tracer to another tracer. If a irqs off latency is
detected, it will try to use the snapshot buffer, but the new tracer
wont have it allocated. There's a nasty warning that gets printed and
the trace is ignored. Nothing crashes, just a nasty WARN_ON is shown.

The second patch fixes an issue where if the sysctl is used to disable
and enable function tracing, it can put the function tracing into an
unstable state.

The third patch fixes an issue with perf using the function tracer.
An update was done, where the stub function could be called during
the perf function tracing, and that stub function wont have the
"control" flag set and cause a nasty warning when running perf.



Please pull the latest trace-fixes-3.9-rc6 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-3.9-rc6

Head SHA1: 620bd150ec911fae0ad02e66fa003548505ec7f4


Jan Kiszka (1):
      ftrace: Consistently restore trace function on sysctl enabling

Steven Rostedt (Red Hat) (2):
      tracing: Fix race with update_max_tr_single and changing tracers
      ftrace: Do not call stub functions in control loop

----
 include/linux/ftrace.h |    2 ++
 kernel/trace/ftrace.c  |   13 +++++--------
 kernel/trace/trace.c   |    5 ++++-
 3 files changed, 11 insertions(+), 9 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRYzEKAAoJEOdOSU1xswtMNd0IAK+uMrofFY793zsJX2bBr1JO
bJDF58KsWz4w1K467qdLfJC2xT+I6LHIt2B3knLV1DAskiIHbuBng4a3sn2Ia2RU
Pmcdl45XCarKtk/ogV7WyGbzrqNCrxPrAPxrpmHEUqOPnwq5Buxy/XFPnffjmpFI
R+w2kbEsxpRjReAlerJjGPtLmZyoM36vYGk7Rpq/W7uioOkgcg1W3A99JxkQu/Oz
Mxq/Yb/gF+sr+zOvI1r5TZIGeGFsGg+vpcwb5vnfb9Cr4Q87r5Whqkjv4/LjK2v+
1Be4/vHX9I0pGfBRjXW7Ap3AhbC9/ODC1ecBNtcg8z7hjywv3L1wp3ddozldIjs=
=C83D
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
