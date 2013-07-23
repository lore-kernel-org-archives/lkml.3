Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3GWAbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 20:31:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60979 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab3GWAbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 20:31:12 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, Don Zickus <dzickus@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>
Subject: [PATCH 0/8] perf: Finer grained full dynticks handling 
Date: Tue, 23 Jul 2013 02:30:58 +0200
Message-Id: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset inspires from Peterz patch in http://marc.info/?l=linux-kernel&m=137155182121860
to make perf retain the timer tick less often, ie: only when there are freq events
or when one throttles.

The main purpose is to make the lockup detector work with full dynticks, as I suspect
that distros want to enable both...


You can fetch from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	perf/nohz

Thanks,
	Frederic
---

Frederic Weisbecker (8):
      perf: Fix branch stack refcount leak on callchain init failure
      perf: Sanitize get_callchain_buffer()
      perf: Gather event accounting code
      perf: Split per cpu event accounting code
      perf: Migrate per cpu event accounting
      perf: Account freq events per cpu
      perf: Finer grained full dynticks kick
      watchdog: Remove hack to make full dynticks working


 kernel/events/callchain.c |    2 +
 kernel/events/core.c      |  203 ++++++++++++++++++++++++++++-----------------
 kernel/watchdog.c         |    8 --
 3 files changed, 128 insertions(+), 85 deletions(-)
