Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab3LFXd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:33:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48839 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289Ab3LFXTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:19:25 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mimi Zohar <zohar@us.ibm.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 024/152] Revert "ima: policy for RAMFS"
Date: Fri,  6 Dec 2013 15:09:08 -0800
Message-Id: <1386371476-2477-25-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mimi Zohar <zohar@linux.vnet.ibm.com>

commit 08de59eb144d7c41351a467442f898d720f0f15f upstream.

This reverts commit 4c2c392763a682354fac65b6a569adec4e4b5387.

Everything in the initramfs should be measured and appraised,
but until the initramfs has extended attribute support, at
least measured.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 security/integrity/ima/ima_policy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 479fca9..cb98e81 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -69,7 +69,6 @@ static struct ima_rule_entry default_rules[] = {
 	{.action = DONT_MEASURE,.fsmagic = SYSFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = DEBUGFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = TMPFS_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_MEASURE,.fsmagic = RAMFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = DEVPTS_SUPER_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = BINFMTFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = SECURITYFS_MAGIC,.flags = IMA_FSMAGIC},
-- 
1.8.3.2

