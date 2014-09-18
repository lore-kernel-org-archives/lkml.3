Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbaIRRI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:08:26 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:36264 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714AbaIRRIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:08:25 -0400
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
Subject: [PATCH 0/2] perf kvm stat live: Copy events
Date: Thu, 18 Sep 2014 21:07:37 +0400
Message-Id: <1411060059-23589-1-git-send-email-yarygin@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091817-0542-0000-0000-000000D403CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a second attempt to fix 'perf kvm stat live' crash when it tries
to parse events that have been already overwritten by the kernel.
Previous thread: https://lkml.org/lkml/2014/9/12/450

Patches
- 1/2 is patch by David Ahern (https://lkml.org/lkml/2013/9/6/388)
  rebased to the current upstream (hope I did it right). It adds an option
  to copy events when they are pushed to the samples queue.
- 2/2 enables the copying for perf kvm stat live.

Looks like we have to live with possibility to get thousands malloc()s/free()s
per second...

Alexander Yarygin (2):
  perf session: Add option to copy events when queueing
  perf kvm stat live: Enable events copying

 tools/perf/builtin-kvm.c         |  1 +
 tools/perf/util/ordered-events.c | 12 +++++++++---
 tools/perf/util/ordered-events.h |  2 +-
 tools/perf/util/session.c        | 12 +++++++++---
 tools/perf/util/session.h        |  1 +
 5 files changed, 21 insertions(+), 7 deletions(-)

-- 
1.9.1

