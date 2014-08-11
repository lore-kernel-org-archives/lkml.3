Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbaHKNyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:54:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:63446 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbaHKNyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:54:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,841,1400050800"; 
   d="scan'208";a="583180277"
From: Jani Nikula <jani.nikula@intel.com>
To: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Jon Mason <jon.mason@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, jani.nikula@intel.com
Subject: [PATCH 1/4] module: rename KERNEL_PARAM_FL_NOARG to avoid confusion
Date: Mon, 11 Aug 2014 16:52:19 +0300
Message-Id: <c73feef3c3195af18a12f6bbab06f86ca42772c1.1407764272.git.jani.nikula@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1407764272.git.jani.nikula@intel.com>
References: <cover.1407764272.git.jani.nikula@intel.com>
In-Reply-To: <cover.1407764272.git.jani.nikula@intel.com>
References: <cover.1407764272.git.jani.nikula@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it clear this is about kernel_param_ops, not kernel_param (which
will soon have a flags field of its own). No functional changes.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Jon Mason <jon.mason@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 include/linux/moduleparam.h | 2 +-
 kernel/module.c             | 2 +-
 kernel/params.c             | 6 +++---
 security/apparmor/lsm.c     | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 494f99e852da..16fdddab856a 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -42,7 +42,7 @@ struct kernel_param;
  * NOARG - the parameter allows for no argument (foo instead of foo=1)
  */
 enum {
-	KERNEL_PARAM_FL_NOARG = (1 << 0)
+	KERNEL_PARAM_OPS_FL_NOARG = (1 << 0)
 };
 
 struct kernel_param_ops {
diff --git a/kernel/module.c b/kernel/module.c
index ae79ce615cb9..c8f04f9bdba0 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -135,7 +135,7 @@ static int param_set_bool_enable_only(const char *val,
 }
 
 static const struct kernel_param_ops param_ops_bool_enable_only = {
-	.flags = KERNEL_PARAM_FL_NOARG,
+	.flags = KERNEL_PARAM_OPS_FL_NOARG,
 	.set = param_set_bool_enable_only,
 	.get = param_get_bool,
 };
diff --git a/kernel/params.c b/kernel/params.c
index 34f527023794..8a484fc8bde8 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -104,7 +104,7 @@ static int parse_one(char *param,
 				return 0;
 			/* No one handled NULL, so do it here. */
 			if (!val &&
-			    !(params[i].ops->flags & KERNEL_PARAM_FL_NOARG))
+			    !(params[i].ops->flags & KERNEL_PARAM_OPS_FL_NOARG))
 				return -EINVAL;
 			pr_debug("handling %s with %p\n", param,
 				params[i].ops->set);
@@ -318,7 +318,7 @@ int param_get_bool(char *buffer, const struct kernel_param *kp)
 EXPORT_SYMBOL(param_get_bool);
 
 struct kernel_param_ops param_ops_bool = {
-	.flags = KERNEL_PARAM_FL_NOARG,
+	.flags = KERNEL_PARAM_OPS_FL_NOARG,
 	.set = param_set_bool,
 	.get = param_get_bool,
 };
@@ -369,7 +369,7 @@ int param_set_bint(const char *val, const struct kernel_param *kp)
 EXPORT_SYMBOL(param_set_bint);
 
 struct kernel_param_ops param_ops_bint = {
-	.flags = KERNEL_PARAM_FL_NOARG,
+	.flags = KERNEL_PARAM_OPS_FL_NOARG,
 	.set = param_set_bint,
 	.get = param_get_int,
 };
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 998100093332..65ca451a764d 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -668,7 +668,7 @@ static int param_set_aabool(const char *val, const struct kernel_param *kp);
 static int param_get_aabool(char *buffer, const struct kernel_param *kp);
 #define param_check_aabool param_check_bool
 static struct kernel_param_ops param_ops_aabool = {
-	.flags = KERNEL_PARAM_FL_NOARG,
+	.flags = KERNEL_PARAM_OPS_FL_NOARG,
 	.set = param_set_aabool,
 	.get = param_get_aabool
 };
@@ -685,7 +685,7 @@ static int param_set_aalockpolicy(const char *val, const struct kernel_param *kp
 static int param_get_aalockpolicy(char *buffer, const struct kernel_param *kp);
 #define param_check_aalockpolicy param_check_bool
 static struct kernel_param_ops param_ops_aalockpolicy = {
-	.flags = KERNEL_PARAM_FL_NOARG,
+	.flags = KERNEL_PARAM_OPS_FL_NOARG,
 	.set = param_set_aalockpolicy,
 	.get = param_get_aalockpolicy
 };
-- 
1.9.1

