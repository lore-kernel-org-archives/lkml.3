Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaEWPQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:16:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbaEWPQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:16:03 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [RFC/PATCH 0/2] perf tools: Factor sort elide
Date: Fri, 23 May 2014 17:15:45 +0200
Message-Id: <1400858147-7155-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
factoring the elide code to make perf_hpp__should_skip
function cheap call/check again.

Also I was wondering.. do we want to get rid of sort_entry
structs in favor of perf_hpp__* stuff? Any plans?

I'm sending this a RFC, since any other such refactoring
would change this stuff for sure as well ;-).

thanks,
jirka


Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/browsers/hists.c |   8 ++++----
 tools/perf/util/hist.h         |   8 +++++++-
 tools/perf/util/sort.c         | 102 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------
 tools/perf/util/sort.h         |   2 +-
 4 files changed, 67 insertions(+), 53 deletions(-)
