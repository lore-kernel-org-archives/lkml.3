Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaBXWA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:00:26 -0500
Received: from smtprelay0038.hostedemail.com ([216.40.44.38]:42050 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752160AbaBXWAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:00:23 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:196:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1544:1622:1711:1730:1747:1777:1792:2393:2559:2562:2894:2910:3138:3139:3140:3141:3142:3354:3503:3504:3505:3867:3872:4250:4321:4419:4605:5007:6119:6261:7774:8957:10004:10026:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grape41_203b5dd0fbe3f
X-Filterd-Recvd-Size: 4885
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: John Johansen <john.johansen@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH 2/8] security: apparmor: Use a more current logging style
Date: Mon, 24 Feb 2014 13:59:55 -0800
Message-Id: <ff8a7d422cfa605de40dc64c103f27ed7a76e0cf.1393279025.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1393279025.git.joe@perches.com>
References: <cover.1393279025.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert printks to pr_<level>.
Add pr_fmt.
Coalesce formats.
Remove embedded prefixes from logging.

Signed-off-by: Joe Perches <joe@perches.com>
---
 security/apparmor/apparmorfs.c       | 2 ++
 security/apparmor/crypto.c           | 2 ++
 security/apparmor/include/apparmor.h | 2 +-
 security/apparmor/lib.c              | 4 +++-
 security/apparmor/lsm.c              | 2 ++
 security/apparmor/match.c            | 5 +++--
 security/apparmor/policy.c           | 2 ++
 security/apparmor/procattr.c         | 2 ++
 8 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 7db9954..d4b65cc 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -12,6 +12,8 @@
  * License.
  */
 
+#define pr_fmt(fmt) "AppArmor: " fmt
+
 #include <linux/ctype.h>
 #include <linux/security.h>
 #include <linux/vmalloc.h>
diff --git a/security/apparmor/crypto.c b/security/apparmor/crypto.c
index 532471d..9506544 100644
--- a/security/apparmor/crypto.c
+++ b/security/apparmor/crypto.c
@@ -15,6 +15,8 @@
  * it should be.
  */
 
+#define pr_fmt(fmt) "AppArmor: " fmt
+
 #include <crypto/hash.h>
 
 #include "include/apparmor.h"
diff --git a/security/apparmor/include/apparmor.h b/security/apparmor/include/apparmor.h
index 8fb1488..3065025 100644
--- a/security/apparmor/include/apparmor.h
+++ b/security/apparmor/include/apparmor.h
@@ -56,7 +56,7 @@ extern unsigned int aa_g_path_max;
 #define AA_ERROR(fmt, args...)						\
 	do {								\
 		if (printk_ratelimit())					\
-			printk(KERN_ERR "AppArmor: " fmt, ##args);	\
+			pr_err(fmt, ##args);				\
 	} while (0)
 
 /* Flag indicating whether initialization completed */
diff --git a/security/apparmor/lib.c b/security/apparmor/lib.c
index 6968992..432b1b6 100644
--- a/security/apparmor/lib.c
+++ b/security/apparmor/lib.c
@@ -12,6 +12,8 @@
  * License.
  */
 
+#define pr_fmt(fmt) "AppArmor: " fmt
+
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -73,7 +75,7 @@ void aa_info_message(const char *str)
 		aad.info = str;
 		aa_audit_msg(AUDIT_APPARMOR_STATUS, &sa, NULL);
 	}
-	printk(KERN_INFO "AppArmor: %s\n", str);
+	pr_info("%s\n", str);
 }
 
 /**
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 9981000..49f0180 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -12,6 +12,8 @@
  * License.
  */
 
+#define pr_fmt(fmt) "AppArmor: " fmt
+
 #include <linux/security.h>
 #include <linux/moduleparam.h>
 #include <linux/mm.h>
diff --git a/security/apparmor/match.c b/security/apparmor/match.c
index 727eb42..688482a 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -12,6 +12,8 @@
  * License.
  */
 
+#define pr_fmt(fmt) "AppArmor: " fmt
+
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
@@ -140,8 +142,7 @@ static int verify_dfa(struct aa_dfa *dfa, int flags)
 			if (DEFAULT_TABLE(dfa)[i] >= state_count)
 				goto out;
 			if (base_idx(BASE_TABLE(dfa)[i]) + 255 >= trans_count) {
-				printk(KERN_ERR "AppArmor DFA next/check upper "
-				       "bounds error\n");
+				pr_err("DFA next/check upper bounds error\n");
 				goto out;
 			}
 		}
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 705c287..4e20c1f 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -73,6 +73,8 @@
  * FIXME: move profile lists to using rcu_lists
  */
 
+#define pr_fmt(fmt) "AppArmor: " fmt
+
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
diff --git a/security/apparmor/procattr.c b/security/apparmor/procattr.c
index b125acc..c105fc5 100644
--- a/security/apparmor/procattr.c
+++ b/security/apparmor/procattr.c
@@ -12,6 +12,8 @@
  * License.
  */
 
+#define pr_fmt(fmt) "AppArmor: " fmt
+
 #include "include/apparmor.h"
 #include "include/context.h"
 #include "include/policy.h"
-- 
1.8.1.2.459.gbcd45b4.dirty

