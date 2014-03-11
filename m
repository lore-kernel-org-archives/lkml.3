Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaCKFBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 01:01:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34290 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbaCKFBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 01:01:37 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9676432"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/15] workqueue: Replace hardcoding of -20 with MIN_NICE.
Date: Tue, 11 Mar 2014 12:59:18 +0800
Message-Id: <bf63ce762ede3412e05516d6e6c1cb662b6a0911.1394513466.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 12:58:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 12:58:50,
	Serialize complete at 2014/03/11 12:58:50
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

