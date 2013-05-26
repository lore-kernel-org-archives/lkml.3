Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453Ab3EZAZG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 20:25:06 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33440 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370Ab3EZAZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 20:25:03 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@kernel.org, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 00/16] perf: kvm live mode
Date: Sat, 25 May 2013 18:24:40 -0600
Message-Id: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version addresses all of the comments from the last review and
includes an enhancement from Runzhen Wang. I still need to add Ingo's
enhancements -- aliasing 'perf stat kvm' to 'perf kvm stat live', and
adding options to parallel top (--repeat <n>).

patchset can also be obtained from github.com/dsahern/linux,
perf-kvm-live-wip branch.

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
  perf kvm: add min and max stats to display
  perf kvm: option to print events that exceed a threshold
  perf kvm: debug for missing vmexit/vmentry event

Runzhen Wang (3):
  perf kvm: reuse some code of perf_kvm__timerfd_create()
  perf kvm: move the prompt_integer() to /util/top.c
  perf kvm: set live mode refresh time dynamically

 tools/perf/builtin-kvm.c  |  723 ++++++++++++++++++++++++++++++++++++++++++---
 tools/perf/builtin-top.c  |   28 --
 tools/perf/util/evlist.c  |  128 ++++++++
 tools/perf/util/evlist.h  |   10 +
 tools/perf/util/header.c  |   44 ---
 tools/perf/util/session.c |   13 +-
 tools/perf/util/session.h |    7 +
 tools/perf/util/stat.c    |    8 +-
 tools/perf/util/stat.h    |    9 +
 tools/perf/util/top.c     |   30 ++
 tools/perf/util/top.h     |    3 +
 11 files changed, 881 insertions(+), 122 deletions(-)

-- 
1.7.10.1

