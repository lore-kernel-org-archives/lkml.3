Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaB1PDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:03:11 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:27975 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaB1PBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:01:36 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-01-5310a4cdca4d
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, casey.schaufler@intel.com,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 2/8] integrity: fix checkpatch errors
Date: Fri, 28 Feb 2014 16:59:26 +0200
Message-id: <ffe24f199d8af75172b4cd23507a529f4a2d5c5a.1393599538.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xa7pnlwgEG6x8a2xxY8UCJotbf/cy
	W3xZWmexbv1iJovLu+awWXzoecRm8WnFJGYHdo+ds+6yeyze85LJ48GhzSwePd+TPfq2rGL0
	+LxJLoAtissmJTUnsyy1SN8ugSuj6fw09oIr7YwVt769Y2tgPFLQxcjJISFgIrGx+Rk7hC0m
	ceHeerYuRi4OIYGljBJL2u6yQzidTBJP7k8Cq2IT0JPY0PwDzBYRcJZYdKudFaSIWWAqo8Sr
	W9NYQBLCAqYS9778AbNZBFQlJj+cDdTAwcErECfx+KcNxDYFiWVf1jKD2JwCVhJbLt9jBbGF
	BCwlrj6by4ZLfAIj/wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIeH4dQfj0mNWhxgF
	OBiVeHglFgkEC7EmlhVX5h5ilOBgVhLhvbQYKMSbklhZlVqUH19UmpNafIiRiYNTqoEx0jph
	Z2SlxQy7h30X6wsC2qfOiGVcwNm/5x/Xke0GSvEq79LTpx/+GOnVfUd8ZfQF+UcR54+u2ndm
	3a6PDla9mi9sfrRrKf2uilE5tp3tjl+3wFQGW8ZawW2MNxbEat07L8HElFi4W+TrI/UfGWev
	Hm/WX3vhrZCrk+O1IyvWtp2946ZiJWquxFKckWioxVxUnAgAcPv1ayUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfixed checkpatch errors make it difficult to see new errors..
This patch fix them.
Some lines with over 80 chars remained unchanged to improve
code readability.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/evm/evm.h          | 28 +++++++-------
 security/integrity/evm/evm_crypto.c   |  4 +-
 security/integrity/iint.c             |  2 +-
 security/integrity/ima/ima_api.c      |  8 ++--
 security/integrity/ima/ima_crypto.c   |  2 +-
 security/integrity/ima/ima_fs.c       |  6 +--
 security/integrity/ima/ima_main.c     |  4 +-
 security/integrity/ima/ima_policy.c   | 69 +++++++++++++++++------------------
 security/integrity/ima/ima_queue.c    |  4 +-
 security/integrity/ima/ima_template.c | 14 +++----
 security/integrity/integrity_audit.c  |  4 +-
 11 files changed, 72 insertions(+), 73 deletions(-)

diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
index 30bd1ec..37c88dd 100644
--- a/security/integrity/evm/evm.h
+++ b/security/integrity/evm/evm.h
@@ -32,19 +32,19 @@ extern struct crypto_shash *hash_tfm;
 /* List of EVM protected security xattrs */
 extern char *evm_config_xattrnames[];
 
-extern int evm_init_key(void);
-extern int evm_update_evmxattr(struct dentry *dentry,
-			       const char *req_xattr_name,
-			       const char *req_xattr_value,
-			       size_t req_xattr_value_len);
-extern int evm_calc_hmac(struct dentry *dentry, const char *req_xattr_name,
-			 const char *req_xattr_value,
-			 size_t req_xattr_value_len, char *digest);
-extern int evm_calc_hash(struct dentry *dentry, const char *req_xattr_name,
-			 const char *req_xattr_value,
-			 size_t req_xattr_value_len, char *digest);
-extern int evm_init_hmac(struct inode *inode, const struct xattr *xattr,
-			 char *hmac_val);
-extern int evm_init_secfs(void);
+int evm_init_key(void);
+int evm_update_evmxattr(struct dentry *dentry,
+			const char *req_xattr_name,
+			const char *req_xattr_value,
+			size_t req_xattr_value_len);
+int evm_calc_hmac(struct dentry *dentry, const char *req_xattr_name,
+		  const char *req_xattr_value,
+		  size_t req_xattr_value_len, char *digest);
+int evm_calc_hash(struct dentry *dentry, const char *req_xattr_name,
+		  const char *req_xattr_value,
+		  size_t req_xattr_value_len, char *digest);
+int evm_init_hmac(struct inode *inode, const struct xattr *xattr,
+		  char *hmac_val);
+int evm_init_secfs(void);
 
 #endif
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 9bd329f..babd862 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -105,13 +105,13 @@ static void hmac_add_misc(struct shash_desc *desc, struct inode *inode,
 		umode_t mode;
 	} hmac_misc;
 
-	memset(&hmac_misc, 0, sizeof hmac_misc);
+	memset(&hmac_misc, 0, sizeof(hmac_misc));
 	hmac_misc.ino = inode->i_ino;
 	hmac_misc.generation = inode->i_generation;
 	hmac_misc.uid = from_kuid(&init_user_ns, inode->i_uid);
 	hmac_misc.gid = from_kgid(&init_user_ns, inode->i_gid);
 	hmac_misc.mode = inode->i_mode;
-	crypto_shash_update(desc, (const u8 *)&hmac_misc, sizeof hmac_misc);
+	crypto_shash_update(desc, (const u8 *)&hmac_misc, sizeof(hmac_misc));
 	if (evm_hmac_version > 1)
 		crypto_shash_update(desc, inode->i_sb->s_uuid,
 				    sizeof(inode->i_sb->s_uuid));
diff --git a/security/integrity/iint.c b/security/integrity/iint.c
index c49d3f1..a521edf 100644
--- a/security/integrity/iint.c
+++ b/security/integrity/iint.c
@@ -151,7 +151,7 @@ static void init_once(void *foo)
 {
 	struct integrity_iint_cache *iint = foo;
 
-	memset(iint, 0, sizeof *iint);
+	memset(iint, 0, sizeof(*iint));
 	iint->version = 0;
 	iint->flags = 0UL;
 	iint->ima_file_status = INTEGRITY_UNKNOWN;
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 393b9d4..c6b4a73 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -160,10 +160,10 @@ err_out:
  * @function: calling function (FILE_CHECK, BPRM_CHECK, MMAP_CHECK, MODULE_CHECK)
  *
  * The policy is defined in terms of keypairs:
- * 		subj=, obj=, type=, func=, mask=, fsmagic=
+ *		subj=, obj=, type=, func=, mask=, fsmagic=
  *	subj,obj, and type: are LSM specific.
- * 	func: FILE_CHECK | BPRM_CHECK | MMAP_CHECK | MODULE_CHECK
- * 	mask: contains the permission mask
+ *	func: FILE_CHECK | BPRM_CHECK | MMAP_CHECK | MODULE_CHECK
+ *	mask: contains the permission mask
  *	fsmagic: hex value
  *
  * Returns IMA_MEASURE, IMA_APPRAISE mask.
@@ -248,7 +248,7 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
  *
  * We only get here if the inode has not already been measured,
  * but the measurement could already exist:
- * 	- multiple copies of the same file on either the same or
+ *	- multiple copies of the same file on either the same or
  *	  different filesystems.
  *	- the inode was previously flushed as well as the iint info,
  *	  containing the hashing info.
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 9999057..d257e36 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -10,7 +10,7 @@
  * the Free Software Foundation, version 2 of the License.
  *
  * File: ima_crypto.c
- * 	Calculates md5/sha1 file hash, template hash, boot-aggreate hash
+ *	Calculates md5/sha1 file hash, template hash, boot-aggreate hash
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 468a3ba..da92fcc 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -133,14 +133,14 @@ static int ima_measurements_show(struct seq_file *m, void *v)
 	 * PCR used is always the same (config option) in
 	 * little-endian format
 	 */
-	ima_putc(m, &pcr, sizeof pcr);
+	ima_putc(m, &pcr, sizeof(pcr));
 
 	/* 2nd: template digest */
 	ima_putc(m, e->digest, TPM_DIGEST_SIZE);
 
 	/* 3rd: template name size */
 	namelen = strlen(e->template_desc->name);
-	ima_putc(m, &namelen, sizeof namelen);
+	ima_putc(m, &namelen, sizeof(namelen));
 
 	/* 4th:  template name */
 	ima_putc(m, e->template_desc->name, namelen);
@@ -292,7 +292,7 @@ static atomic_t policy_opencount = ATOMIC_INIT(1);
 /*
  * ima_open_policy: sequentialize access to the policy file
  */
-static int ima_open_policy(struct inode * inode, struct file * filp)
+static int ima_open_policy(struct inode *inode, struct file *filp)
 {
 	/* No point in being allowed to open it if you aren't going to write */
 	if (!(filp->f_flags & O_WRONLY))
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 149ee11..50413d0 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -71,10 +71,10 @@ __setup("ima_hash=", hash_setup);
  * ima_rdwr_violation_check
  *
  * Only invalidate the PCR for measured files:
- * 	- Opening a file for write when already open for read,
+ *	- Opening a file for write when already open for read,
  *	  results in a time of measure, time of use (ToMToU) error.
  *	- Opening a file for read when already open for write,
- * 	  could result in a file measurement error.
+ *	  could result in a file measurement error.
  *
  */
 static void ima_rdwr_violation_check(struct file *file)
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 947cdbe..41021b4 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -7,7 +7,7 @@
  * the Free Software Foundation, version 2 of the License.
  *
  * ima_policy.c
- * 	- initialize default measure policy rules
+ *	- initialize default measure policy rules
  *
  */
 #include <linux/module.h>
@@ -21,8 +21,8 @@
 #include "ima.h"
 
 /* flags definitions */
-#define IMA_FUNC 	0x0001
-#define IMA_MASK 	0x0002
+#define IMA_FUNC	0x0001
+#define IMA_MASK	0x0002
 #define IMA_FSMAGIC	0x0004
 #define IMA_UID		0x0008
 #define IMA_FOWNER	0x0010
@@ -69,35 +69,35 @@ struct ima_rule_entry {
  * and running executables.
  */
 static struct ima_rule_entry default_rules[] = {
-	{.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_MEASURE,.fsmagic = SYSFS_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_MEASURE,.fsmagic = DEBUGFS_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_MEASURE,.fsmagic = TMPFS_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_MEASURE,.fsmagic = DEVPTS_SUPER_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_MEASURE,.fsmagic = BINFMTFS_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_MEASURE,.fsmagic = SECURITYFS_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_MEASURE,.fsmagic = SELINUX_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = MEASURE,.func = MMAP_CHECK,.mask = MAY_EXEC,
+	{.action = DONT_MEASURE, .fsmagic = PROC_SUPER_MAGIC, .flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE, .fsmagic = SYSFS_MAGIC, .flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE, .fsmagic = DEBUGFS_MAGIC, .flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE, .fsmagic = TMPFS_MAGIC, .flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE, .fsmagic = DEVPTS_SUPER_MAGIC, .flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE, .fsmagic = BINFMTFS_MAGIC, .flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE, .fsmagic = SECURITYFS_MAGIC, .flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE, .fsmagic = SELINUX_MAGIC, .flags = IMA_FSMAGIC},
+	{.action = MEASURE, .func = MMAP_CHECK, .mask = MAY_EXEC,
 	 .flags = IMA_FUNC | IMA_MASK},
-	{.action = MEASURE,.func = BPRM_CHECK,.mask = MAY_EXEC,
+	{.action = MEASURE, .func = BPRM_CHECK, .mask = MAY_EXEC,
 	 .flags = IMA_FUNC | IMA_MASK},
-	{.action = MEASURE,.func = FILE_CHECK,.mask = MAY_READ,.uid = GLOBAL_ROOT_UID,
+	{.action = MEASURE, .func = FILE_CHECK, .mask = MAY_READ, .uid = GLOBAL_ROOT_UID,
 	 .flags = IMA_FUNC | IMA_MASK | IMA_UID},
-	{.action = MEASURE,.func = MODULE_CHECK, .flags = IMA_FUNC},
+	{.action = MEASURE, .func = MODULE_CHECK, .flags = IMA_FUNC},
 };
 
 static struct ima_rule_entry default_appraise_rules[] = {
-	{.action = DONT_APPRAISE,.fsmagic = PROC_SUPER_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_APPRAISE,.fsmagic = SYSFS_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_APPRAISE,.fsmagic = DEBUGFS_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_APPRAISE,.fsmagic = TMPFS_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_APPRAISE,.fsmagic = RAMFS_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_APPRAISE,.fsmagic = DEVPTS_SUPER_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_APPRAISE,.fsmagic = BINFMTFS_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_APPRAISE,.fsmagic = SECURITYFS_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_APPRAISE,.fsmagic = SELINUX_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_APPRAISE,.fsmagic = CGROUP_SUPER_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = APPRAISE,.fowner = GLOBAL_ROOT_UID,.flags = IMA_FOWNER},
+	{.action = DONT_APPRAISE, .fsmagic = PROC_SUPER_MAGIC, .flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE, .fsmagic = SYSFS_MAGIC, .flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE, .fsmagic = DEBUGFS_MAGIC, .flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE, .fsmagic = TMPFS_MAGIC, .flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE, .fsmagic = RAMFS_MAGIC, .flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE, .fsmagic = DEVPTS_SUPER_MAGIC, .flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE, .fsmagic = BINFMTFS_MAGIC, .flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE, .fsmagic = SECURITYFS_MAGIC, .flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE, .fsmagic = SELINUX_MAGIC, .flags = IMA_FSMAGIC},
+	{.action = DONT_APPRAISE, .fsmagic = CGROUP_SUPER_MAGIC, .flags = IMA_FSMAGIC},
+	{.action = APPRAISE, .fowner = GLOBAL_ROOT_UID, .flags = IMA_FOWNER},
 };
 
 static LIST_HEAD(ima_default_rules);
@@ -122,12 +122,12 @@ static int __init default_appraise_policy_setup(char *str)
 }
 __setup("ima_appraise_tcb", default_appraise_policy_setup);
 
-/* 
+/*
  * Although the IMA policy does not change, the LSM policy can be
  * reloaded, leaving the IMA LSM based rules referring to the old,
  * stale LSM policy.
  *
- * Update the IMA LSM based rules to reflect the reloaded LSM policy. 
+ * Update the IMA LSM based rules to reflect the reloaded LSM policy.
  * We assume the rules still exist; and BUG_ON() if they don't.
  */
 static void ima_lsm_update_rules(void)
@@ -218,7 +218,7 @@ retry:
 			retried = 1;
 			ima_lsm_update_rules();
 			goto retry;
-		} 
+		}
 		if (!rc)
 			return false;
 	}
@@ -234,7 +234,7 @@ static int get_subaction(struct ima_rule_entry *rule, int func)
 	if (!(rule->flags & IMA_FUNC))
 		return IMA_FILE_APPRAISE;
 
-	switch(func) {
+	switch (func) {
 	case MMAP_CHECK:
 		return IMA_MMAP_APPRAISE;
 	case BPRM_CHECK:
@@ -306,7 +306,7 @@ void __init ima_init_policy(void)
 	measure_entries = ima_use_tcb ? ARRAY_SIZE(default_rules) : 0;
 	appraise_entries = ima_use_appraise_tcb ?
 			 ARRAY_SIZE(default_appraise_rules) : 0;
-	
+
 	for (i = 0; i < measure_entries + appraise_entries; i++) {
 		if (i < measure_entries)
 			list_add_tail(&default_rules[i].list,
@@ -522,8 +522,7 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 				break;
 			}
 
-			result = strict_strtoul(args[0].from, 16,
-						&entry->fsmagic);
+			result = kstrtoul(args[0].from, 16, &entry->fsmagic);
 			if (!result)
 				entry->flags |= IMA_FSMAGIC;
 			break;
@@ -549,7 +548,7 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 				break;
 			}
 
-			result = strict_strtoul(args[0].from, 10, &lnum);
+			result = kstrtoul(args[0].from, 10, &lnum);
 			if (!result) {
 				entry->uid = make_kuid(current_user_ns(), (uid_t)lnum);
 				if (!uid_valid(entry->uid) || (((uid_t)lnum) != lnum))
@@ -566,7 +565,7 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 				break;
 			}
 
-			result = strict_strtoul(args[0].from, 10, &lnum);
+			result = kstrtoul(args[0].from, 10, &lnum);
 			if (!result) {
 				entry->fowner = make_kuid(current_user_ns(), (uid_t)lnum);
 				if (!uid_valid(entry->fowner) || (((uid_t)lnum) != lnum))
diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index 91128b4..552705d 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -117,7 +117,7 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 
 	mutex_lock(&ima_extend_list_mutex);
 	if (!violation) {
-		memcpy(digest, entry->digest, sizeof digest);
+		memcpy(digest, entry->digest, sizeof(digest));
 		if (ima_lookup_digest_entry(digest)) {
 			audit_cause = "hash_exists";
 			result = -EEXIST;
@@ -133,7 +133,7 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 	}
 
 	if (violation)		/* invalidate pcr */
-		memset(digest, 0xff, sizeof digest);
+		memset(digest, 0xff, sizeof(digest));
 
 	tpmresult = ima_pcr_extend(digest);
 	if (tpmresult != 0) {
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 9a4a0d1..a076a96 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -22,20 +22,20 @@
 
 static struct ima_template_desc defined_templates[] = {
 	{.name = IMA_TEMPLATE_IMA_NAME, .fmt = IMA_TEMPLATE_IMA_FMT},
-	{.name = "ima-ng",.fmt = "d-ng|n-ng"},
-	{.name = "ima-sig",.fmt = "d-ng|n-ng|sig"},
+	{.name = "ima-ng", .fmt = "d-ng|n-ng"},
+	{.name = "ima-sig", .fmt = "d-ng|n-ng|sig"},
 };
 
 static struct ima_template_field supported_fields[] = {
-	{.field_id = "d",.field_init = ima_eventdigest_init,
+	{.field_id = "d", .field_init = ima_eventdigest_init,
 	 .field_show = ima_show_template_digest},
-	{.field_id = "n",.field_init = ima_eventname_init,
+	{.field_id = "n", .field_init = ima_eventname_init,
 	 .field_show = ima_show_template_string},
-	{.field_id = "d-ng",.field_init = ima_eventdigest_ng_init,
+	{.field_id = "d-ng", .field_init = ima_eventdigest_ng_init,
 	 .field_show = ima_show_template_digest_ng},
-	{.field_id = "n-ng",.field_init = ima_eventname_ng_init,
+	{.field_id = "n-ng", .field_init = ima_eventname_ng_init,
 	 .field_show = ima_show_template_string},
-	{.field_id = "sig",.field_init = ima_eventsig_init,
+	{.field_id = "sig", .field_init = ima_eventsig_init,
 	 .field_show = ima_show_template_sig},
 };
 
diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
index 793d7be..aab9fa5 100644
--- a/security/integrity/integrity_audit.c
+++ b/security/integrity/integrity_audit.c
@@ -7,7 +7,7 @@
  * the Free Software Foundation, version 2 of the License.
  *
  * File: integrity_audit.c
- * 	Audit calls for the integrity subsystem
+ *	Audit calls for the integrity subsystem
  */
 
 #include <linux/fs.h>
@@ -22,7 +22,7 @@ static int __init integrity_audit_setup(char *str)
 {
 	unsigned long audit;
 
-	if (!strict_strtoul(str, 0, &audit))
+	if (!kstrtoul(str, 0, &audit))
 		integrity_audit_info = audit ? 1 : 0;
 	return 1;
 }
-- 
1.8.3.2

