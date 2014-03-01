Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147AbaCAFiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 00:38:46 -0500
Received: from mail-qc0-f201.google.com ([209.85.216.201]:62427 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaCAFip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 00:38:45 -0500
From: Filipe Brandenburger <filbranden@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizefan@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH 0/3] tracing: fix macro expansion and refactor some of dynamic_array support
Date: Fri, 28 Feb 2014 21:32:15 -0800
Message-Id: <1393651938-16418-1-git-send-email-filbranden@google.com>
X-Mailer: git-send-email 1.9.0.279.gdc9e3eb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven Rostedt, Li Zefan,

This fixes an issue with macro expansion introduced in commit 7d536cb3f
(tracing/events: record the size of dynamic arrays).

I split it in 3 patches, the first fixes a bug, the second improves the code to
evaluate the expression only once and the third refactors an u32 holding two
pieces of data in lower/higher 16 bits into a struct to make the code cleaner.

I split them this way since I expect the first two to be more straightforward
while the third one might generate some discussion. I'd be happy to squash them
into a single one if you'd prefer that.

Cheers,
Filipe


Filipe Brandenburger (3):
  tracing: correctly expand len expressions from __dynamic_array macro
  tracing: evaluate len expression only once in __dynamic_array macro
  tracing: introduce a trace_data_offset struct to store array size

 include/linux/ftrace_event.h       |  5 +++++
 include/trace/ftrace.h             | 26 ++++++++++++++------------
 kernel/trace/trace_events_filter.c | 13 ++++++++++---
 3 files changed, 29 insertions(+), 15 deletions(-)

-- 
1.9.0.279.gdc9e3eb

