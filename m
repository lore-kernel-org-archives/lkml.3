Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaH2NKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:10:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:23684 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbaH2NKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:10:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,424,1406617200"; 
   d="scan'208";a="473804986"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: rusty@rustcorp.com.au
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] moduleparam: Resolve missing-field-initializer warning
Date: Fri, 29 Aug 2014 06:08:29 -0700
Message-Id: <1409317709-5005-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Resolve a missing-field-initializer warning, that is produced
by every reference to module_param_call, by using designated
initialization for the first field. That is enough to silence
the complaint.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 include/linux/moduleparam.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 494f99e..d99a9e9 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -196,7 +196,7 @@ struct kparam_array
 /* Obsolete - use module_param_cb() */
 #define module_param_call(name, set, get, arg, perm)			\
 	static struct kernel_param_ops __param_ops_##name =		\
-		{ 0, (void *)set, (void *)get };			\
+		{ .flags = 0, (void *)set, (void *)get };		\
 	__module_param_call(MODULE_PARAM_PREFIX,			\
 			    name, &__param_ops_##name, arg,		\
 			    (perm) + sizeof(__check_old_set_param(set))*0, -1)
-- 
1.9.3

