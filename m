Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaBXWAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:00:30 -0500
Received: from smtprelay0192.hostedemail.com ([216.40.44.192]:42058 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752900AbaBXWA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:00:27 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:2:41:355:379:541:800:960:968:973:982:988:989:1260:1345:1359:1437:1535:1730:1747:1777:1792:2393:2559:2562:2894:3138:3139:3140:3141:3142:3355:3865:3866:3867:3868:3871:4049:4118:4250:4321:4419:4605:5007:6119:6261:7809:9010:9040:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plate90_20c29d94e3e42
X-Filterd-Recvd-Size: 7005
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@us.ibm.com>, James Morris <james.l.morris@oracle.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH 3/8] security: integrity: Use a more current logging style
Date: Mon, 24 Feb 2014 13:59:56 -0800
Message-Id: <25bc41150cc3966f5c8dfcd028ad3652e19f5efa.1393279025.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1393279025.git.joe@perches.com>
References: <cover.1393279025.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert printks to pr_<level>.
Add pr_fmt.
Remove embedded prefixes.

Signed-off-by: Joe Perches <joe@perches.com>
---
 security/integrity/evm/evm_crypto.c   | 4 +++-
 security/integrity/evm/evm_main.c     | 6 ++++--
 security/integrity/evm/evm_secfs.c    | 6 ++++--
 security/integrity/ima/ima_crypto.c   | 4 +++-
 security/integrity/ima/ima_init.c     | 5 ++++-
 security/integrity/ima/ima_queue.c    | 8 +++++---
 security/integrity/ima/ima_template.c | 5 ++++-
 7 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 3bab89e..9bd329f 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -13,6 +13,8 @@
  *	 Using root's kernel master key (kmk), calculate the HMAC
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/crypto.h>
 #include <linux/xattr.h>
@@ -221,7 +223,7 @@ int evm_init_hmac(struct inode *inode, const struct xattr *lsm_xattr,
 
 	desc = init_desc(EVM_XATTR_HMAC);
 	if (IS_ERR(desc)) {
-		printk(KERN_INFO "init_desc failed\n");
+		pr_info("init_desc failed\n");
 		return PTR_ERR(desc);
 	}
 
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 336b3dd..996092f 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -14,6 +14,8 @@
  *	evm_inode_removexattr, and evm_verifyxattr
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/crypto.h>
 #include <linux/audit.h>
@@ -432,7 +434,7 @@ static int __init init_evm(void)
 
 	error = evm_init_secfs();
 	if (error < 0) {
-		printk(KERN_INFO "EVM: Error registering secfs\n");
+		pr_info("Error registering secfs\n");
 		goto err;
 	}
 
@@ -449,7 +451,7 @@ static int __init evm_display_config(void)
 	char **xattrname;
 
 	for (xattrname = evm_config_xattrnames; *xattrname != NULL; xattrname++)
-		printk(KERN_INFO "EVM: %s\n", *xattrname);
+		pr_info("%s\n", *xattrname);
 	return 0;
 }
 
diff --git a/security/integrity/evm/evm_secfs.c b/security/integrity/evm/evm_secfs.c
index 30f670a..cf12a04 100644
--- a/security/integrity/evm/evm_secfs.c
+++ b/security/integrity/evm/evm_secfs.c
@@ -13,6 +13,8 @@
  *	- Get the key and enable EVM
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include "evm.h"
@@ -79,9 +81,9 @@ static ssize_t evm_write_key(struct file *file, const char __user *buf,
 	error = evm_init_key();
 	if (!error) {
 		evm_initialized = 1;
-		pr_info("EVM: initialized\n");
+		pr_info("initialized\n");
 	} else
-		pr_err("EVM: initialization failed\n");
+		pr_err("initialization failed\n");
 	return count;
 }
 
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index fdf60de..972df659 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -13,6 +13,8 @@
  * 	Calculates md5/sha1 file hash, template hash, boot-aggreate hash
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/file.h>
 #include <linux/crypto.h>
@@ -205,7 +207,7 @@ static void __init ima_pcrread(int idx, u8 *pcr)
 		return;
 
 	if (tpm_pcr_read(TPM_ANY_NUM, idx, pcr) != 0)
-		pr_err("IMA: Error Communicating to TPM chip\n");
+		pr_err("Error Communicating to TPM chip\n");
 }
 
 /*
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 3712276..b3bc313 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -14,6 +14,9 @@
  * File: ima_init.c
  *             initialization and cleanup functions
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
@@ -93,7 +96,7 @@ int __init ima_init(void)
 		ima_used_chip = 1;
 
 	if (!ima_used_chip)
-		pr_info("IMA: No TPM chip found, activating TPM-bypass!\n");
+		pr_info("No TPM chip found, activating TPM-bypass!\n");
 
 	rc = ima_init_crypto();
 	if (rc)
diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index d85e997..91128b4 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -18,6 +18,9 @@
  *       The measurement list is append-only. No entry is
  *       ever removed or changed during the boot-cycle.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/rculist.h>
 #include <linux/slab.h>
@@ -72,7 +75,7 @@ static int ima_add_digest_entry(struct ima_template_entry *entry)
 
 	qe = kmalloc(sizeof(*qe), GFP_KERNEL);
 	if (qe == NULL) {
-		pr_err("IMA: OUT OF MEMORY ERROR creating queue entry.\n");
+		pr_err("OUT OF MEMORY ERROR creating queue entry\n");
 		return -ENOMEM;
 	}
 	qe->entry = entry;
@@ -95,8 +98,7 @@ static int ima_pcr_extend(const u8 *hash)
 
 	result = tpm_pcr_extend(TPM_ANY_NUM, CONFIG_IMA_MEASURE_PCR_IDX, hash);
 	if (result != 0)
-		pr_err("IMA: Error Communicating to TPM chip, result: %d\n",
-		       result);
+		pr_err("Error Communicating to TPM chip, result: %d\n", result);
 	return result;
 }
 
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 635695f..9a4a0d1 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -12,6 +12,9 @@
  * File: ima_template.c
  *      Helpers to manage template descriptors.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <crypto/hash_info.h>
 
 #include "ima.h"
@@ -58,7 +61,7 @@ static int __init ima_template_setup(char *str)
 	 */
 	if (template_len == 3 && strcmp(str, IMA_TEMPLATE_IMA_NAME) == 0 &&
 	    ima_hash_algo != HASH_ALGO_SHA1 && ima_hash_algo != HASH_ALGO_MD5) {
-		pr_err("IMA: template does not support hash alg\n");
+		pr_err("template does not support hash alg\n");
 		return 1;
 	}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

