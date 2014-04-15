Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbaDOKxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:53:32 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:63440 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbaDOKx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:53:29 -0400
From: asnast@gmail.com
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, Alex Snast <alexsn@il.ibm.com>
Subject: [PATCH 1/2] ftrace: draw_funcgraph.py: Handle dots in function names
Date: Tue, 15 Apr 2014 13:53:19 +0300
Message-Id: <1397559200-15520-2-git-send-email-alexsn@il.ibm.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397559200-15520-1-git-send-email-alexsn@il.ibm.com>
References: <1397559200-15520-1-git-send-email-alexsn@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Snast <alexsn@il.ibm.com>

ftrace function tracer can output the following line:
mmcommon-3250  [001] 969103.003748: clear_buddies.isra.59 <-dequeue_task_fair

However the regex used by draw_functrace.py would fail to match the '.'
character

Signed-off-by: Alex Snast <alexsn@il.ibm.com>
---
 scripts/tracing/draw_functrace.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/tracing/draw_functrace.py b/scripts/tracing/draw_functrace.py
index db40fa0..358bc9f 100644
--- a/scripts/tracing/draw_functrace.py
+++ b/scripts/tracing/draw_functrace.py
@@ -103,10 +103,10 @@ def parseLine(line):
 	line = line.strip()
 	if line.startswith("#"):
 		raise CommentLineException
-	m = re.match("[^]]+?\\] +([0-9.]+): (\\w+) <-(\\w+)", line)
+	m = re.match(r"[^]]+?\] +(\d+\.\d+): ([\w.]+) <-([\w.]+)", line)
 	if m is None:
 		raise BrokenLineException
-	return (m.group(1), m.group(2), m.group(3))
+	return m.group(1, 2, 3)
 
 
 def main():
-- 
1.9.2

