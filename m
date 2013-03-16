Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab3CPDbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 23:31:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22538 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab3CPDbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 23:31:44 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=8LeSToV485wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VphCAR9MWWUA:10 a=TrfKQu2bAfJm_jMsDQEA:9 a=QEXdDO2ut3YA:10 a=fIm2MWFmWNPN23bW9_YA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130316032412.416651612@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 23:24:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [for-next][PATCH 0/9] tracing: ring-buffer selftest, cleanups, ftrace_dump() fix and document
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

One more linux-next patch series.

The first patch is a ring buffer boot time selftest. A bug in my development
code looked like the ring buffer was dropping events, and I wrote a test
to make sure that wasn't the case. The bug ended up being a stupid
mistake in my development code, but the ring buffer test seemed like a
good idea to include in the kernel as an option.

Next is a series of clean ups by Jovi.

Jovi also pointed out issues with ftrace_dump(). It's been on my todo
list to clean up ftrace_dump() for a long time, and finally decided
to do so. It wasn't hard and was quick to do. There was a long standing
bug where an NMI triggering a dump while another dump was happening
could cause a deadlock. I marked that patch for stable, but since its
really just a debugging tool and I don't recall ever hitting the deadlock
(I might have), I decided it can wait for 3.10 and I'll do the backports
when I get the "Failed to apply" messages from Greg Kroah-Hartman's
stable scripts.

Last patch brings the README file in debugfs/tracing/ up to date with
more useful information.

Enjoy!

-- Steve


Steven Rostedt (Red Hat) (3):
      ring-buffer: Add ring buffer startup selftest
      tracing: Fix ftrace_dump()
      tracing: Update debugfs README file

zhangwei(Jovi) (6):
      tracing: Use pr_warn_once instead of open coded implementation
      tracing: Use TRACE_MAX_PRINT instead of constant
      tracing: Move find_event_field() into trace_events.c
      tracing: Convert trace_destroy_fields() to static
      tracing: Fix comment about prefix in arch_syscall_match_sym_name()
      tracing: Rename trace_event_mutex to trace_event_sem

----
 kernel/trace/Kconfig               |   23 +++
 kernel/trace/ring_buffer.c         |  319 ++++++++++++++++++++++++++++++++=
++++
 kernel/trace/trace.c               |  164 +++++++++++-------
 kernel/trace/trace.h               |    6 +-
 kernel/trace/trace_events.c        |   55 +++++--
 kernel/trace/trace_events_filter.c |   29 +---
 kernel/trace/trace_output.c        |   16 +-
 kernel/trace/trace_output.h        |    2 +-
 kernel/trace/trace_selftest.c      |    9 +-
 kernel/trace/trace_syscalls.c      |    2 +-
 10 files changed, 506 insertions(+), 119 deletions(-)


--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ+ebAAoJEOdOSU1xswtMU5sH/RUk6WBL2HWTTKUcGVfwbIbN
E8F1ZHoC2Hi9qwXi7K8sj3ZYH+faIMAh/LVsn6ybiyOvcOAOa8Dx4WZf0+7Uo7vG
Nbq5cS+Oz7TisvgywbppxDGWH6O9qiEF/V3yHHlSpMiABxTmJ49eDrqC1xp541fq
BFhHyNKfTUOJh2upQnAIHkcaGww5nWvMvRSkYFarX9A7HybQTJasnOBIKiXRdRc8
sbeHsybRg6tss9I8OtlqmLCzbYjlTgjOkdl9WDd4rQwgbqONvxvegEPhgj9pc+5n
UQybfmRtlM7sAcoEJUcoqsaA0fhA9kGkLQPnOCy9Kej6KZ9Nd9p7ohIgG6jeMZs=
=6i3R
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
