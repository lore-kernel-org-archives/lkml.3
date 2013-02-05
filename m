Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab3BEQGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:06:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933Ab3BEQGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:06:52 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Andrew Jones <drjones@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/2] perf scripts: Fix rwtop script
Date: Tue,  5 Feb 2013 17:05:49 +0100
Message-Id: <1360080351-3246-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending patches for rwtop race issue caused by rwtop script
triggering SIGALRM and underneath pipe reading layer reporting
error when interrupted.

It's discussed in here:
https://lkml.org/lkml/2012/9/14/381

thanks,
jirka

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Andrew Jones <drjones@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
Jiri Olsa (2):
      perf scripts: Fix SIGALRM and pipe read race for rwtop
      perf scripts: Fix rwtop record script

 tools/perf/scripts/perl/bin/rwtop-record | 2 +-
 tools/perf/scripts/perl/rwtop.pl         | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)
