Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3EFQ2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 12:28:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab3EFQ2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 12:28:06 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 0/2] perf: Fix/factor auxiliary events
Date: Mon,  6 May 2013 18:27:16 +0200
Message-Id: <1367857638-27631-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending fix for issue caused by using smp_processor_id()
in preemptible path discussed in here:
http://marc.info/?l=linux-kernel&m=136733569907888&w=2

I also noticed there's a space for some code factoring
saving some .text size and centralizing auxiliary
events notification.

Changes could be reached in here:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
perf/aux4

thanks,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Borislav Petkov <bp@alien8.de>
---
Jiri Olsa (2):
      perf: Fix EXIT event notification
      perf: Factor auxiliary events notification

 kernel/events/core.c | 240 +++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------
 1 file changed, 89 insertions(+), 151 deletions(-)
