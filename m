Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbaEIUng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:43:36 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:59199 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaEIUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:43:35 -0400
From: Dan Streetman <ddstreet@ieee.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dan Streetman <ddstreet@ieee.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Weijie Yang <weijieut@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Shaohua Li <shli@fusionio.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] plist: make CONFIG_DEBUG_PI_LIST selectable
Date: Fri,  9 May 2014 16:42:24 -0400
Message-Id: <1399668144-19738-1-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20140505191341.GA18397@home.goodmis.org>
References: <20140505191341.GA18397@home.goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change CONFIG_DEBUG_PI_LIST to be user-selectable, and add a
title and description.  Remove the dependency on DEBUG_RT_MUTEXES
since they were changed to use rbtrees, and there are other users
of plists now.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 lib/Kconfig.debug | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e816930..a3b1d68 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -864,11 +864,6 @@ config DEBUG_RT_MUTEXES
 	 This allows rt mutex semantics violations and rt mutex related
 	 deadlocks (lockups) to be detected and reported automatically.
 
-config DEBUG_PI_LIST
-	bool
-	default y
-	depends on DEBUG_RT_MUTEXES
-
 config RT_MUTEX_TESTER
 	bool "Built-in scriptable tester for rt-mutexes"
 	depends on DEBUG_KERNEL && RT_MUTEXES
@@ -1094,6 +1089,16 @@ config DEBUG_LIST
 
 	  If unsure, say N.
 
+config DEBUG_PI_LIST
+	bool "Debug priority linked list manipulation"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to turn on extended checks in the priority-ordered
+	  linked-list (plist) walking routines.  This checks the entire
+	  list multiple times during each manipulation.
+
+	  If unsure, say N.
+
 config DEBUG_SG
 	bool "Debug SG table operations"
 	depends on DEBUG_KERNEL
-- 
1.8.3.1

