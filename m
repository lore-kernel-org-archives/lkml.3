Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaJPOHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 10:07:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbaJPOHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:07:30 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCHv2 0/7] perf tools: Fix branch report segfaults
Date: Thu, 16 Oct 2014 16:07:00 +0200
Message-Id: <1413468427-31049-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding some branch_info checks to prevent segfaults
on data without branch info.

v2: using cmp_null as suggested by Namhyung

jirka

available at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/abort_fix_2

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/sort.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 76 insertions(+), 26 deletions(-)
