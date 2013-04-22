Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3DVFt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 01:49:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65390 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752004Ab3DVFt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 01:49:27 -0400
X-IronPort-AV: E=Sophos;i="4.87,524,1363104000"; 
   d="scan'208";a="7109996"
From: liguang <lig.fnst@cn.fujitsu.com>
To: tglx@linutronix.de, peterz@infradead.org, akpm@linux-foundation.org,
        shli@fusionio.com, srivatsa.bhat@linux.vnet.ibm.com,
        suresh.b.siddha@intel.com, fweisbec@gmail.com, sedat.dilek@gmail.com,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] smp: use '|=' for csd_lock
Date: Mon, 22 Apr 2013 13:47:22 +0800
Message-Id: <1366609643-17628-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/22 13:47:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/22 13:47:49,
	Serialize complete at 2013/04/22 13:47:49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

originally, 'data->flags = CSD_FLAG_LOCK',
and we use 'data->flags &= ~CSD_FLAG_LOCK'
for csd_unlock, they are not symmetrix operations
so use '|=' instead of '='.
though, now data->flags only hold CSD_FLAG_LOCK,
it's not so meaningful to use '|=' to set 1 bit,
and '&= ~' to clear 1 bit.

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 kernel/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 1818dc0..2d5deb4 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -109,7 +109,7 @@ static void csd_lock_wait(struct call_single_data *data)
 static void csd_lock(struct call_single_data *data)
 {
 	csd_lock_wait(data);
-	data->flags = CSD_FLAG_LOCK;
+	data->flags |= CSD_FLAG_LOCK;
 
 	/*
 	 * prevent CPU from reordering the above assignment
-- 
1.7.2.5

