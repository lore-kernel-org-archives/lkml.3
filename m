Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab3EIEb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 00:31:58 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:47930 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab3EIEb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 00:31:57 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@kernel.org, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH 00/13] perf: kvm live mode
Date: Wed,  8 May 2013 22:31:36 -0600
Message-Id: <1368073909-8825-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the consolidation of the open counters code in December 2012
(late to the party figuring that out) I think all of the past
comments on the live mode for perf-kvm have been resolved.

David Ahern (13):
  perf evlist: restore methods removed in earlier cleanup
  perf evlist: move tracepoint processing code to evlist.c
  perf evlist: add initialzation function for tracepoints
  perf session: export a few functions for event processing
  perf top: move CONSOLE_CLEAR to header file
  perf kvm: handle realloc failures
  perf kvm: split out tracepoints from record args
  perf stats: fix divide by 0 in variance
  perf stats: add max and min stats
  perf kvm: add live mode
  perf kvm: add min and max stats to results display
  perf kvm: option to print events that exceed a threshold
  perf kvm: debug for missing vmexit/vmentry event

 tools/perf/builtin-kvm.c  |  694 ++++++++++++++++++++++++++++++++++++++++++---
 tools/perf/builtin-top.c  |    2 -
 tools/perf/util/evlist.c  |  120 ++++++++
 tools/perf/util/evlist.h  |   10 +
 tools/perf/util/header.c  |   44 ---
 tools/perf/util/session.c |   15 +-
 tools/perf/util/session.h |    9 +
 tools/perf/util/stat.c    |    8 +-
 tools/perf/util/stat.h    |    9 +
 tools/perf/util/top.h     |    2 +
 10 files changed, 816 insertions(+), 97 deletions(-)

-- 
1.7.10.1

