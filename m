Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3HBQaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:30:05 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:38254 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab3HBQaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:30:03 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Kevin Hilman <khilman@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/3] perf: Fixes on event accounting
Date: Fri,  2 Aug 2013 18:29:53 +0200
Message-Id: <1375460996-16329-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, Jiri,

Here is a proposed set of fixes after the discussion we had about the
last changes in the event accounting code.

Thanks,
	Frederic
---

Frederic Weisbecker (3):
      perf: Rollback callchain buffer refcount under the callchain mutex
      perf: Account freq events globally
      nohz: Include local CPU in full dynticks global kick


 kernel/events/callchain.c |    3 ++-
 kernel/events/core.c      |   19 ++++++++-----------
 kernel/time/tick-sched.c  |    1 +
 3 files changed, 11 insertions(+), 12 deletions(-)
