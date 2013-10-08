Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab3JHKuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:50:21 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:36754 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab3JHKuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:50:20 -0400
Date: Tue, 8 Oct 2013 12:50:16 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: bitbucket@online.de, acme@redhat.com, peterz@infradead.org, mingo@elte.hu
Subject: [PATCH] perf tools: fix missing default initialization for
 tool->mmap2
Message-ID: <20131008105016.GA2446@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a SEGFAULT bug with perf sched
related to the new MMAP2 record type. There was
a missing default initialization for the tool->mmap2
pointer in perf_tool__fill_defaults().

Reproducer:
 # perf sched record -- sleep 1
 # perf sched lat

Reported-by: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Stephane Eranian <eranian@google.com>
--

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 211b325..8415c54 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -256,6 +256,8 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
 		tool->sample = process_event_sample_stub;
 	if (tool->mmap == NULL)
 		tool->mmap = process_event_stub;
+	if (tool->mmap2 == NULL)
+		tool->mmap2 = process_event_stub;
 	if (tool->comm == NULL)
 		tool->comm = process_event_stub;
 	if (tool->fork == NULL)
