Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab3HXAer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 20:34:47 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:30210 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3HXAeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 20:34:46 -0400
From: Libin <huawei.libin@huawei.com>
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <wangyijing@huawei.com>,
        <guohanjun@huawei.com>
Subject: [PATCH] workqueue: remove unnecessary goto statement
Date: Sat, 24 Aug 2013 08:34:31 +0800
Message-ID: <1377304471-25232-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using return NULL to replace goto statement and avoiding a redundant
function call for free_workqueue_attrs(). If kzalloc for attrs of
struct workqueue_attrs is failed, alloc_workqueue_attrs return
NULL directedly. With no functional changs.

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7f5d4be..dabeb88 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3400,7 +3400,7 @@ struct workqueue_attrs *alloc_workqueue_attrs(gfp_t gfp_mask)
 
 	attrs = kzalloc(sizeof(*attrs), gfp_mask);
 	if (!attrs)
-		goto fail;
+		return NULL;
 	if (!alloc_cpumask_var(&attrs->cpumask, gfp_mask))
 		goto fail;
 
-- 
1.8.2.1


