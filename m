Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3HBUFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 16:05:54 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60682 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab3HBUFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 16:05:53 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/9] perf: kvm live mode
Date: Fri,  2 Aug 2013 14:05:38 -0600
Message-Id: <1375473947-64285-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo:

Update to the kvm-live series. Per your comment on IRC I removed
then need to refactor or restore an tracepoint parsing code.
Hopefully this is sufficient to make into your core branch and
be ready for 3.12.

David Ahern (9):
  perf top: move CONSOLE_CLEAR to header file
  perf stats: add max and min stats
  perf session: export a few functions for event processing
  perf kvm: split out tracepoints from record args
  perf kvm: add live mode - v3
  perf kvm: add min and max stats to display
  perf kvm: option to print events that exceed a threshold
  perf kvm: debug for missing vmexit/vmentry event
  perf kvm stat report: Add option to analyze specific VM

 tools/perf/builtin-kvm.c  |  755 ++++++++++++++++++++++++++++++++++++++++++---
 tools/perf/builtin-top.c  |    2 -
 tools/perf/perf.h         |    3 +
 tools/perf/util/session.c |   12 +-
 tools/perf/util/session.h |    7 +
 tools/perf/util/stat.c    |    6 +
 tools/perf/util/stat.h    |    9 +
 tools/perf/util/top.h     |    2 +
 8 files changed, 749 insertions(+), 47 deletions(-)

-- 
1.7.10.1

