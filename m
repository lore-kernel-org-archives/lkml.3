Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab3AOD1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 22:27:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4854 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab3AOD1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 22:27:21 -0500
X-Authority-Analysis: v=2.0 cv=T70Ovo2Q c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=DXHtxVeGgCgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=S3AnTL8OHHUA:10 a=VwQbUJbxAAAA:8 a=UIgQSPybMy2PmZUroHkA:9 a=QEXdDO2ut3YA:10 a=eWxbj_mtwpcw8fxWuSAA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130115032042.472099050@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 14 Jan 2013 22:20:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] tracing: A couple more regression fixes
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Linus,

The clean up patch commit 0fb9656d "tracing: Make tracing_enabled be equal
to tracing_on" caused two regressions.

1) The irqs off latency tracer no longer starts if tracing_on is off
  when the tracer is set, and then tracing_on is enabled. The tracing_on
  file needs the hook that tracing_enabled had to enable tracers if they
  request it (call the tracer's start() method).

2) That commit had a separate change that really should have been a
  separate patch, but it must have been added accidently with the -a
  option of git commit. But as the change is still related to the commit
  it wasn't noticed in review. That change, changed the way blocking is
  done by the trace_pipe file with respect to the tracing_on settings.
  I've been told that this change breaks current userspace, and this
  specific change is being reverted.

Please pull trace-3.8-rc3-regression-fix, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-3.8-rc3-regression-fix

Head SHA1: 84c630600dc007d2fbd307088b87c9be85b40a97


Liu Bo (1):
      tracing: Fix regression of trace_pipe

Steven Rostedt (1):
      tracing: Fix regression with irqsoff tracer and tracing_on file

----
 kernel/trace/trace.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQ9MyKAAoJEOdOSU1xswtMY4QH/3gxLKSETNqixnDzqA8/Q0Jn
W/6f3zvYxXWt6pIZTPKtp+H/BYUV86twPs3fMIHnBpi+rRiT8habdGax3iKZdmqE
6Qpz4DefCOBjLTsTfnwtKeRj1oWQpo45z38PpAsA0IxZAYjrDsPgWFpONuHEHwU4
em1mmRST8FFT4irbYH95PMvvY3O9ZWNbDR2YUk+q9QxrUZnJieWakR7ueaT55ONI
UduFia83IRxMTxTVb7rwTF7MpklY1dK+u1WDDzGa9Cef+XaA09YkDNJnO6vwNQQS
lHwax5Os9aFSwDwUtLPuoPSB8G7g2Xtk/g0TbCzJGgkB6VgIvPI6omV8yD2DbZs=
=Yh6A
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
