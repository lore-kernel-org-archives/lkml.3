Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbaDQHxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 03:53:31 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54761 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaDQHx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 03:53:28 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 0/3] perf top/tui: Fixes for percentage filter behavior
Date: Thu, 17 Apr 2014 16:53:23 +0900
Message-Id: <1397721206-15393-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a small fixes for a bug in perf top I found during some tests.
It gets segfault if symbol filter found no entries - accessing NULL
pointer in that case.

The patches are also available at perf/percentage-v9 branch on my tree
for your convenience.  I'm sorry for causing this bug..

Thanks,
Namhyung


Namhyung Kim (3):
  perf hists: Add missing updates on nr_non_filtered_entries
  perf ui/tui: Fix off-by-one in hist_browser__update_nr_entries()
  perf top/tui: Update nr_entries properly after filter is applied

 tools/perf/ui/browsers/hists.c | 34 +++++++++++++++++++---------------
 tools/perf/util/hist.c         |  8 +++++++-
 tools/perf/util/hist.h         |  6 ++++++
 3 files changed, 32 insertions(+), 16 deletions(-)

-- 
1.9.2

