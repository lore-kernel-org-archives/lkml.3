Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaAQPem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:34:42 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34596 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaAQPek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:34:40 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, jolsa@redhat.com,
        dsahern@gmail.com, Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/2] perf stat: fix memory corruption and core dump
Date: Fri, 17 Jan 2014 16:34:04 +0100
Message-Id: <1389972846-6566-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This short patch series fixes two problems:
 - segfault  for perf stat -e cpu/event=0x3c ls
 - memory corruption via xyarray of evsel->fd.

The patch is relative to tip.get


Stephane Eranian (2):
  perf stat: fix NULL pointer reference bug with event unit
  perf stat: fix memory corruption of xyarray when cpumask is used

 tools/perf/util/evlist.c       |    7 +++++--
 tools/perf/util/evsel.c        |    2 --
 tools/perf/util/parse-events.c |    2 +-
 tools/perf/util/pmu.c          |   24 ++++++++++++++++++++----
 tools/perf/util/pmu.h          |    2 +-
 5 files changed, 27 insertions(+), 10 deletions(-)

-- 
1.7.9.5

