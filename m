Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab3KLOrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:47:14 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:52233 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3KLOrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:47:12 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, jolsa@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/5] perf record: mmap output file - v5
Date: Tue, 12 Nov 2013 07:46:52 -0700
Message-Id: <1384267617-3446-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Next round or mmap based output. This round addresses re-use of
mmap-pages argument parsing, adds -O shortcut for --out-pages,
allows -O0 to use write instead of mmap, and handles out of space
failures.

David Ahern (5):
  perf record: Fix segfault with --no-mmap-pages
  perf tool: Round mmap pages to power 2 - v2
  perf tool: Refactor mmap_pages parsing
  perf record: mmap output file - v5
  perf record: Handle out of space failures writing data with mmap

 tools/perf/Documentation/perf-record.txt |   7 ++
 tools/perf/builtin-record.c              | 174 +++++++++++++++++++++++++++++++
 tools/perf/util/evlist.c                 |  75 +++++++++----
 tools/perf/util/evlist.h                 |   3 +
 4 files changed, 240 insertions(+), 19 deletions(-)

-- 
1.8.3.4 (Apple Git-47)

