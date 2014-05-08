Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbaEHVHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 17:07:54 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:31775 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753994AbaEHVHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 17:07:52 -0400
Message-Id: <20140508210703.464573159@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 08 May 2014 17:07:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 0/2] [GIT PULL] tracing: A couple of fixes to tracepoints
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

This contains two fixes.

The first is a long standing bug that causes bogus data to show up
in the refcnt field of the module_refcnt tracepoint. It was
introduced by a merge conflict resolution back in 2.6.35-rc days.

The result should be refcnt = incs - decs, but instead it did
refcnt = incs + decs.

The second fix is to a bug that was introduced in this merge window
that allowed for a tracepoint funcs pointer to be used after it
was freed. Moving the location of where the probes are released
solved the problem.

Please pull the latest trace-fixes-v3.15-rc4-v2 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.15-rc4-v2

Tag SHA1: 3c46db2195fb760afba9f01a495557e78ca8226e
Head SHA1: 8058bd0faad860e75547cc5cb5d4ade016247a79


Mathieu Desnoyers (1):
      tracepoint: Fix use of tracepoint funcs after rcu free

Romain Izard (1):
      trace: module: Maintain a valid user count

----
 include/trace/events/module.h | 2 +-
 kernel/tracepoint.c           | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)
