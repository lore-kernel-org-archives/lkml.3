Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229AbaFQO3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:29:17 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47379 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaFQO3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:29:14 -0400
Message-ID: <53A050B3.6050301@oracle.com>
Date: Tue, 17 Jun 2014 22:29:07 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <cl@gentwo.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/24] kernel: return actual error on param_sysfs_init
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Liu <jeff.liu@oracle.com>

Return the actual error code if kset_create_and_add() failed

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 kernel/params.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 1e52ca2..a110987 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -928,10 +928,9 @@ struct kobj_type module_ktype = {
 static int __init param_sysfs_init(void)
 {
 	module_kset = kset_create_and_add("module", &module_uevent_ops, NULL);
-	if (!module_kset) {
-		printk(KERN_WARNING "%s (%d): error creating kset\n",
-			__FILE__, __LINE__);
-		return -ENOMEM;
+	if (IS_ERR(module_kset)) {
+		pr_warn("%s (%d): error creating kset\n", __FILE__, __LINE__);
+		return PTR_ERR(module_kset);
 	}
 	module_sysfs_initialized = 1;
 
-- 
1.8.3.2
