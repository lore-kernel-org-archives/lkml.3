Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaJBQjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:39:08 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:38726 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaJBQjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:39:05 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH v3 0/2] perf kvm stat live: Copy events
Date: Thu,  2 Oct 2014 20:38:54 +0400
Message-Id: <1412267936-19827-1-git-send-email-yarygin@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100216-0342-0000-0000-00000142688C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a fix of 'perf kvm stat live' crash when it tries
to parse events that have been already overwritten by the kernel.

Patches
- 1/2 adds an option to copy events when they are pushed to the samples queue.  The patch is based on the patch by David Ahern (https://lkml.org/lkml/2013/9/6/388)
- 2/2 enables the copying for perf kvm stat live.

Changes in v3:
  - move repetitive code into functions

Changes in v2:
  - the option to copy events is now a part of ordered_events
  - use memdup() instead malloc()/memcpy()
  - events alocations are under the report.queue-size limit

Alexander Yarygin (2):
  perf tools: Add option to copy events when queueing
  perf kvm stat live: Enable events copying

 tools/perf/builtin-kvm.c         |  1 +
 tools/perf/util/ordered-events.c | 49 ++++++++++++++++++++++++++++++++++++----
 tools/perf/util/ordered-events.h | 10 +++++++-
 tools/perf/util/session.c        |  5 ++--
 4 files changed, 57 insertions(+), 8 deletions(-)

-- 
1.9.1

