Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab3GBT1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:27:36 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:62609 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab3GBT1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:27:31 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/6] perf: bug fixes, cleanup of parse events memory allocations
Date: Tue,  2 Jul 2013 13:27:19 -0600
Message-Id: <1372793245-4136-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ahern (6):
  perf evsel: fix count parameter to read call in event_format__new
  perf evlist: fix use of uninitialized variable
  perf event: initialize allocated memory for synthesized events
  perf: don't free list head in parse_events__free_terms
  perf test: make terms a stack variable in test_term
  perf parse events: demystify memory allocations

 tools/perf/tests/parse-events.c |   14 ++++-----
 tools/perf/util/event.c         |    8 ++---
 tools/perf/util/evlist.c        |    2 +-
 tools/perf/util/evsel.c         |    2 +-
 tools/perf/util/parse-events.c  |   54 ++++++++++------------------------
 tools/perf/util/parse-events.h  |   10 +++----
 tools/perf/util/parse-events.y  |   62 +++++++++++++++++++++++++--------------
 7 files changed, 72 insertions(+), 80 deletions(-)

-- 
1.7.10.1

