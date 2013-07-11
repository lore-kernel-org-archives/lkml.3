Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab3GKQ0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:26:49 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:46360 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3GKQ0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:26:48 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 00/11] perf: kvm live mode
Date: Thu, 11 Jul 2013 10:26:31 -0600
Message-Id: <1373560002-14618-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo:

There were no comments from the last round, so this is the same patches
rebased to your latest perf/core branch.

David Ahern (11):
  perf evlist: restore methods removed in earlier cleanup
  perf evlist: move tracepoint processing code to evlist.c
  perf evlist: add initialzation function for tracepoints
  perf session: export a few functions for event processing
  perf top: move CONSOLE_CLEAR to header file
  perf kvm: split out tracepoints from record args
  perf stats: add max and min stats
  perf kvm: add live mode
  perf kvm: add min and max stats to display
  perf kvm: option to print events that exceed a threshold
  perf kvm: debug for missing vmexit/vmentry event

 tools/perf/builtin-kvm.c  |  685 ++++++++++++++++++++++++++++++++++++++++++---
 tools/perf/builtin-top.c  |    2 -
 tools/perf/util/evlist.c  |  128 +++++++++
 tools/perf/util/evlist.h  |   10 +
 tools/perf/util/header.c  |   44 ---
 tools/perf/util/session.c |   12 +-
 tools/perf/util/session.h |    7 +
 tools/perf/util/stat.c    |    6 +
 tools/perf/util/stat.h    |    9 +
 tools/perf/util/top.h     |    2 +
 10 files changed, 811 insertions(+), 94 deletions(-)

-- 
1.7.10.1

