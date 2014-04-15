Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbaDOKxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:53:36 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:58632 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbaDOKxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:53:32 -0400
From: asnast@gmail.com
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, Alex Snast <alexsn@il.ibm.com>
Subject: [PATCH 2/2] ftrace: draw_funcgraph.py: Allow reading input from files in addition to stdin
Date: Tue, 15 Apr 2014 13:53:20 +0300
Message-Id: <1397559200-15520-3-git-send-email-alexsn@il.ibm.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397559200-15520-1-git-send-email-alexsn@il.ibm.com>
References: <1397559200-15520-1-git-send-email-alexsn@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Snast <alexsn@il.ibm.com>

Signed-off-by: Alex Snast <alexsn@il.ibm.com>
---
 scripts/tracing/draw_functrace.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/tracing/draw_functrace.py b/scripts/tracing/draw_functrace.py
index 358bc9f..333ab42 100644
--- a/scripts/tracing/draw_functrace.py
+++ b/scripts/tracing/draw_functrace.py
@@ -22,7 +22,7 @@ Usage:
 """
 
 
-import sys, re
+import fileinput, re
 
 class CallTree:
 	""" This class provides a tree representation of the functions
@@ -113,7 +113,7 @@ def main():
 	CallTree.ROOT = CallTree("Root (Nowhere)", None, None)
 	tree = CallTree.ROOT
 
-	for line in sys.stdin:
+	for line in fileinput.input():
 		try:
 			calltime, callee, caller = parseLine(line)
 		except BrokenLineException:
-- 
1.9.2

