Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbaKTAPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 19:15:44 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:60927 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552AbaKTAPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 19:15:41 -0500
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: byungchul.park@lge.com
From: byungchul.park@lge.com
To: rostedt@goodmis.org
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, seungho1.park@lge.com,
        jolsa@redhat.com, Byungchul Park <byungchul.park@lge.com>
Subject: [PATCH v5 0/2] tracing: signaling large duration and delay
Date: Thu, 20 Nov 2014 09:15:33 +0900
Message-Id: <1416442535-31188-1-git-send-email-byungchul.park@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Byungchul Park <byungchul.park@lge.com>

Changes since v4
* move implementing from .h to .c

Changes since v3
* re-position define macro and undef explicitly
* enhance readablity

Changes since v2
* use inline function instead of macro
* enhance readablity

Changes since v1
* update Document/trace/ftrace.txt
* seperate the implementation as a macro
* apply the implementation to delay printing, too

Hello.

When I analysis the exit_mm() function to find out the reason why the
function spends much time occasionally, this patch was very useful.
I thought this patch cannot be useful only for me, but can be also
useful for anybody who want to be signaled for very large function
execution time, so I decided to submit this patchset.

Nobody who have such a demand? :)

Thanks,
Byungchul.

Byungchul Park (2):
  tracing, function_graph: fix micro seconds notation in comment
  tracing: add additional marks to signal very large time

 Documentation/trace/ftrace.txt       |   10 +++++++---
 kernel/trace/trace.h                 |    2 ++
 kernel/trace/trace_functions_graph.c |   15 +++++----------
 kernel/trace/trace_output.c          |   35 +++++++++++++++++++++++++++++-----
 4 files changed, 44 insertions(+), 18 deletions(-)

-- 
1.7.9.5

