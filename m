Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab3EKANe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:13:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26184 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab3EKANF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:05 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=GStjNMxbR8YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=x5WakLIlGG8A:10 a=VwQbUJbxAAAA:8 a=CHCILrIdagMFVPOuee8A:9 a=QEXdDO2ut3YA:10 a=4FH3H3nfmdhEOStzjIEA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001206.477862307@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 00/18] tracing/kprobes: Update kprobes with new ftrace changes
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Linus,

The majority of these changes are from Masami Hiramatsu bringing
kprobes up to par with the latest changes to ftrace (multi buffering
and the new function probes).

He also discovered and fixed some bugs in doing so. When pulling in his
patches, I also found a few minor bugs as well and fixed them.

This also includes a compile fix for some archs that select the ring buffer
but not tracing.

I based this off of the last patch you took from me that fixed the merge
conflict error, as that was the commit that had all the changes I needed
for this set of changes.


Please pull the latest trace-fixes-v3.10 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.10

Tag SHA1: b3955bf07072c5eb343b45faec09fee2d09cf695
Head SHA1: b8820084f2130b3dcfb09c78ac16cdd2194a345b


Masami Hiramatsu (11):
      tracing: Don't succeed if event_enable_func did not register anything
      ftrace, kprobes: Fix a deadlock on ftrace_regex_lock
      ftrace: Cleanup regex_lock and ftrace_lock around hash updating
      tracing/kprobes: Fix to increment return event probe hit-count
      tracing: Indicate enabled soft-mode in enable file
      tracing: Modify soft-mode only if there's no other referrer
      tracing/kprobes: Use bool for retprobe checker
      tracing/kprobes: Increment probe hit-count even if it is used by perf
      tracing/kprobes: Pass trace_probe directly from dispatcher
      tracing/kprobes: Support ftrace_event_file base multibuffer
      tracing/kprobes: Support soft-mode disabling

Steven Rostedt (Red Hat) (7):
      ring-buffer: Select IRQ_WORK
      tracing: Return error if register_ftrace_function_probe() fails for e=
vent_enable_func()
      ftrace: Have ftrace_regex_write() return either read or error
      tracing: Add helper function trace_create_new_event() to remove dupli=
cate code
      ftrace: Fix locking in register_ftrace_function_probe()
      ftrace: Fix the output of enabled_functions debug file
      ftrace: Fix function probe when more than one probe is added

----
 include/linux/ftrace.h       |    4 +
 include/linux/ftrace_event.h |    1 +
 kernel/trace/Kconfig         |    2 +-
 kernel/trace/ftrace.c        |  126 ++++++++++++------
 kernel/trace/trace_events.c  |   54 ++++++--
 kernel/trace/trace_kprobe.c  |  289 ++++++++++++++++++++++++++++++++++----=
----
 6 files changed, 368 insertions(+), 108 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRjY0LAAoJEOdOSU1xswtM7dMIAJ+u4Qd0qmT3ApMqe2nkj1dH
7TsqehYesc7FgkpLIuPYIFc/R0haSI4PTJt+BV3T3M3842uY4HsfOkF3AeoGpInZ
b/xHLv3FlyFMCXfw/7HkRskSOIapdRSXGvVTGJ+yUGMMQWjImKM1BIVS+m0jpeBW
nDeMvvky4+DzymsmnJ1S7xKUvNbptCdgp6ftb/iAatDnG9lYaWrFz52c2xTLpBXw
5yPCvpwnphluhmWAAQQegN7G1sp7Ji7GPT4scHblwjDBdE3ok+1J8OMjGCRXp1Rg
Vf42I6SeAbw1uslunk/lKhpbAJZATzMb46qoguIYFURz4w8GawtoMVU2MBoVqWw=
=+/sb
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
