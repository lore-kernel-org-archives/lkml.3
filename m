Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbbAGUxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 15:53:46 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41139 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142AbbAGUxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 15:53:20 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: initramfs <initramfs@vger.kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 8/9] ima: include tmpfs in ima_appraise_tcb policy
Date: Wed,  7 Jan 2015 15:52:59 -0500
Message-Id: <1420663980-20842-9-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1420663980-20842-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1420663980-20842-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010720-0037-0000-0000-00000049B602
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the rootfs includes extended attributes, don't
automatically exclude tmpfs file systems from being appraised.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/evm/evm_main.c   | 1 +
 security/integrity/ima/ima_policy.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 9c71af7..e942e63 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/crypto.h>
 #include <linux/audit.h>
+#include <linux/magic.h>
 #include <linux/xattr.h>
 #include <linux/integrity.h>
 #include <linux/evm.h>
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index d1eefb9..7267eac 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -93,7 +93,9 @@ static struct ima_rule_entry default_appraise_rules[] = {
 	{.action = DONT_APPRAISE, .fsmagic = PROC_SUPER_MAGIC, .flags = IMA_FSMAGIC},
 	{.action = DONT_APPRAISE, .fsmagic = SYSFS_MAGIC, .flags = IMA_FSMAGIC},
 	{.action = DONT_APPRAISE, .fsmagic = DEBUGFS_MAGIC, .flags = IMA_FSMAGIC},
+#ifndef CONFIG_IMA_LOAD_X509
 	{.action = DONT_APPRAISE, .fsmagic = TMPFS_MAGIC, .flags = IMA_FSMAGIC},
+#endif
 	{.action = DONT_APPRAISE, .fsmagic = RAMFS_MAGIC, .flags = IMA_FSMAGIC},
 	{.action = DONT_APPRAISE, .fsmagic = DEVPTS_SUPER_MAGIC, .flags = IMA_FSMAGIC},
 	{.action = DONT_APPRAISE, .fsmagic = BINFMTFS_MAGIC, .flags = IMA_FSMAGIC},
-- 
1.8.1.4

