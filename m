Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaF2AUm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 20:20:42 -0400
Received: from smtprelay0042.hostedemail.com ([216.40.44.42]:33529 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751920AbaF2AUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 20:20:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3870:3874:4321:4605:5007:6261:10004:10026:10848:11026:11473:11658:11914:12043:12114:12296:12438:12517:12519:12555:13161:13229:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fish87_22434a3f8ab1e
X-Filterd-Recvd-Size: 2233
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Luca Tettamanti <kronos.it@gmail.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/4] fs: asus_atk0110: Fix DEFINE_SIMPLE_ATTRIBUTE semicolon definition and use
Date: Sat, 28 Jun 2014 17:20:16 -0700
Message-Id: <530fc2e19919f12996227b27645be7e8f911a7ba.1403999769.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403999769.git.joe@perches.com>
References: <cover.1403999769.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DEFINE_SIMPLE_ATTRIBUTE macro should not end in a ;
Fix the one use in the kernel tree that did not have a semicolon.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hwmon/asus_atk0110.c | 2 +-
 include/linux/fs.h           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
index ae208f6..cccef87 100644
--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -688,7 +688,7 @@ static int atk_debugfs_gitm_get(void *p, u64 *val)
 DEFINE_SIMPLE_ATTRIBUTE(atk_debugfs_gitm,
 			atk_debugfs_gitm_get,
 			NULL,
-			"0x%08llx\n")
+			"0x%08llx\n");
 
 static int atk_acpi_print(char *buf, size_t sz, union acpi_object *obj)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8a9e7f8..e78e9ac 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2701,7 +2701,7 @@ static const struct file_operations __fops = {				\
 	.read	 = simple_attr_read,					\
 	.write	 = simple_attr_write,					\
 	.llseek	 = generic_file_llseek,					\
-};
+}
 
 static inline __printf(1, 2)
 void __simple_attr_check_format(const char *fmt, ...)
-- 
1.8.1.2.459.gbcd45b4.dirty

