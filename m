Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaJAUfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:35:40 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:64820 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaJAUfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:35:39 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, neilb@suse.de,
        sasha.levin@oracle.com, rientjes@google.com, hughd@google.com,
        joe@perches.com, paul.gortmaker@windriver.com,
        liwanp@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com,
        iamjoonsoo.kim@lge.com, akpm@linux-foundation.org
Subject: [PATCH] mm: ksm use pr_err instead of printk
Date: Wed,  1 Oct 2014 21:35:30 +0100
Message-Id: <1412195730-9629-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: Prefer: pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 mm/ksm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index fb75902..79a26b4 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2310,7 +2310,7 @@ static int __init ksm_init(void)
 
 	ksm_thread = kthread_run(ksm_scan_thread, NULL, "ksmd");
 	if (IS_ERR(ksm_thread)) {
-		printk(KERN_ERR "ksm: creating kthread failed\n");
+		pr_err(KERN_ERR "ksm: creating kthread failed\n");
 		err = PTR_ERR(ksm_thread);
 		goto out_free;
 	}
@@ -2318,7 +2318,7 @@ static int __init ksm_init(void)
 #ifdef CONFIG_SYSFS
 	err = sysfs_create_group(mm_kobj, &ksm_attr_group);
 	if (err) {
-		printk(KERN_ERR "ksm: register sysfs failed\n");
+		pr_err(KERN_ERR "ksm: register sysfs failed\n");
 		kthread_stop(ksm_thread);
 		goto out_free;
 	}
-- 
1.9.1

