Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbaCKJW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:22:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65276 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbaCKJWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:22:54 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9677980"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/16] workqueue: Replace hardcoding of -20 with MIN_NICE.
Date: Tue, 11 Mar 2014 17:20:24 +0800
Message-Id: <b364c0e8d8360d6883c74d3618666fa85293a0e0.1394529373.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:19:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:20:05,
	Serialize complete at 2014/03/11 17:20:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3fa5b8f..7528bec 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -100,10 +100,10 @@ enum {
 
 	/*
 	 * Rescue workers are used only on emergencies and shared by
-	 * all cpus.  Give -20.
+	 * all cpus.  Give MIN_NICE.
 	 */
-	RESCUER_NICE_LEVEL	= -20,
-	HIGHPRI_NICE_LEVEL	= -20,
+	RESCUER_NICE_LEVEL	= MIN_NICE,
+	HIGHPRI_NICE_LEVEL	= MIN_NICE,
 
 	WQ_NAME_LEN		= 24,
 };
-- 
1.8.2.1

