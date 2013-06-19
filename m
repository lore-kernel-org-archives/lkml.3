Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934630Ab3FSKit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:38:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:4563 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933991Ab3FSKis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:38:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,896,1363158000"; 
   d="scan'208";a="319357723"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: apw@canonical.com, joe@perches.com
Cc: Jacob Keller <jacob.e.keller@intel.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net] checkpatch: modify logFunction regular expression to allow repeated front tags
Date: Wed, 19 Jun 2013 03:38:43 -0700
Message-Id: <1371638323-20999-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The previous logFunction regular expression allowed names for log functions like
dev_warn or e_dbg and so forth, but some log functions are of the forms
similar to e_dev_warn, (adding an additional tag in front of a standard name
like dev_warn).

This patch modifies checkpatch to enable use of this type of log function name.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b954de5..a38d71e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -269,7 +269,7 @@ our $typeTypedefs = qr{(?x:
 
 our $logFunctions = qr{(?x:
 	printk(?:_ratelimited|_once|)|
-	[a-z0-9]+_(?:printk|emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|
+	(?:[a-z0-9]+_)+(?:printk|emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|
 	WARN(?:_RATELIMIT|_ONCE|)|
 	panic|
 	MODULE_[A-Z_]+
-- 
1.7.11.7

