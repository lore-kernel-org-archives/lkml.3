Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaHKLXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:23:47 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:36607 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaHKLXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:23:46 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH] mm: ksm: Remove unused function process_timeout()
Date: Mon, 11 Aug 2014 08:22:45 -0300
Message-Id: <1407756165-1906-1-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 2.1.0.rc1.204.gae8bc8d
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes compilation warning:

mm/ksm.c:1711:13: warning: ‘process_timeout’ defined but not used [-Wunused-function]

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 mm/ksm.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index f7de4c0..434a50a 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1708,11 +1708,6 @@ static void ksm_do_scan(unsigned int scan_npages)
 	}
 }
 
-static void process_timeout(unsigned long __data)
-{
-	wake_up_process((struct task_struct *)__data);
-}
-
 static int ksmd_should_run(void)
 {
 	return (ksm_run & KSM_RUN_MERGE) && !list_empty(&ksm_mm_head.mm_list);
-- 
2.1.0.rc1.204.gae8bc8d

