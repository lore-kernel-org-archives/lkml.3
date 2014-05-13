Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbaEMU2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 16:28:19 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:49104 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbaEMU1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 16:27:50 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: manfred@colorfullife.com, akpm@linux-foundation.org
Cc: davidlohr@hp.com, aswin@hp.com, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] ipc,msg: document volatile r_msg
Date: Tue, 13 May 2014 13:27:36 -0700
Message-Id: <1400012857-11733-5-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1400012857-11733-1-git-send-email-davidlohr@hp.com>
References: <1400012857-11733-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The need for volatile is not obvious, document it.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 ipc/msg.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index c2cdb5b..956cd65 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -42,9 +42,7 @@
 #include <linux/uaccess.h>
 #include "util.h"
 
-/*
- * one msg_receiver structure for each sleeping receiver:
- */
+/* one msg_receiver structure for each sleeping receiver */
 struct msg_receiver {
 	struct list_head	r_list;
 	struct task_struct	*r_tsk;
@@ -54,6 +52,12 @@ struct msg_receiver {
 	long			r_msgtype;
 	long			r_maxsize;
 
+	/*
+	 * Mark r_msg volatile so that the compiler
+	 * does not try to get smart and optimize
+	 * it. We rely on this for the lockless
+	 * receive algorithm.
+	 */
 	struct msg_msg		*volatile r_msg;
 };
 
-- 
1.8.1.4

