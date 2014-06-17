Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbaFQOby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:31:54 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50255 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921AbaFQObw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:31:52 -0400
Message-ID: <53A0512D.1090909@oracle.com>
Date: Tue, 17 Jun 2014 22:31:09 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: benh@kernel.crashing.org, paulus@samba.org
CC: linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/24] powerpc: check/return actual error on sysfs functions
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Liu <jeff.liu@oracle.com>

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 arch/powerpc/platforms/powernv/opal-dump.c | 2 +-
 arch/powerpc/platforms/powernv/opal-elog.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/opal-dump.c b/arch/powerpc/platforms/powernv/opal-dump.c
index 788a197..e718baf 100644
--- a/arch/powerpc/platforms/powernv/opal-dump.c
+++ b/arch/powerpc/platforms/powernv/opal-dump.c
@@ -424,7 +424,7 @@ void __init opal_platform_dump_init(void)
 	int rc;
 
 	dump_kset = kset_create_and_add("dump", NULL, opal_kobj);
-	if (!dump_kset) {
+	if (IS_ERR(dump_kset)) {
 		pr_warn("%s: Failed to create dump kset\n", __func__);
 		return;
 	}
diff --git a/arch/powerpc/platforms/powernv/opal-elog.c b/arch/powerpc/platforms/powernv/opal-elog.c
index 10268c4..09c1f6f 100644
--- a/arch/powerpc/platforms/powernv/opal-elog.c
+++ b/arch/powerpc/platforms/powernv/opal-elog.c
@@ -296,9 +296,9 @@ int __init opal_elog_init(void)
 	int rc = 0;
 
 	elog_kset = kset_create_and_add("elog", NULL, opal_kobj);
-	if (!elog_kset) {
+	if (IS_ERR(elog_kset)) {
 		pr_warn("%s: failed to create elog kset\n", __func__);
-		return -1;
+		return PTR_ERR(elog_kset);
 	}
 
 	rc = opal_notifier_register(&elog_nb);
-- 
1.8.3.2
