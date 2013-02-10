Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab3BJF7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 00:59:38 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:34102 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3BJF6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 00:58:52 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 15/16] PM idle: remove global declaration of pm_idle
Date: Sun, 10 Feb 2013 00:58:22 -0500
Message-Id: <9ba4b07d809ec52dad63f11365df5166989edb46.1360475150.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360475903-30007-1-git-send-email-lenb@kernel.org>
References: <1360475903-30007-1-git-send-email-lenb@kernel.org>
In-Reply-To: <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
References: <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

pm_idle appears in no generic Linux code,
it appears only in architecture-specific code.

Thus, pm_idle should not be declared in pm.h.

Architectures that  use an idle function pointer
should delcare one local to their architecture,
and/or use cpuidle.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: linux-pm@vger.kernel.org
---
 include/linux/pm.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 03d7bb1..97bcf23 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -31,7 +31,6 @@
 /*
  * Callbacks for platform drivers to implement.
  */
-extern void (*pm_idle)(void);
 extern void (*pm_power_off)(void);
 extern void (*pm_power_off_prepare)(void);
 
-- 
1.8.1.3.535.ga923c31

