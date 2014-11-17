Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaKQAmQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 19:42:16 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46315 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaKQAmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 19:42:15 -0500
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: byungchul.park@lge.com
From: byungchul.park@lge.com
To: rostedt@goodmis.org, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, seungho1.park@lge.com, jolsa@redhat.com,
        Byungchul Park <byungchul.park@lge.com>
Subject: [PATCH v3 0/3] tracing: signaling large duration and delay
Date: Mon, 17 Nov 2014 09:41:55 +0900
Message-Id: <1416184918-10471-1-git-send-email-byungchul.park@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Byungchul Park <byungchul.park@lge.com>

Changes from v2 to v3
* use inline function instead of macro
* enhance readablity

Changes from v1 to v2
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

Byungchul Park (3):
  tracing, function_graph: fix micro seconds notation in comment
  tracing, function_graph: add additional marks to signal very large
    function execution time
  tracing: add additional marks to signal very large delay

 Documentation/trace/ftrace.txt       |   10 +++++++---
 kernel/trace/trace.h                 |   19 +++++++++++++++++++
 kernel/trace/trace_functions_graph.c |   28 ++++++++++++++++++----------
 kernel/trace/trace_output.c          |   20 +++++++++++++++-----
 4 files changed, 59 insertions(+), 18 deletions(-)

-- 
1.7.9.5

