Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbaCXUbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:31:52 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:35623 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbaCXUbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:31:44 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 4/5] PM / Runtime: GENERIC_SUBSYS_PM_OPS is gone
Date: Mon, 24 Mar 2014 21:31:30 +0100
Message-Id: <1395693091-4813-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395693091-4813-1-git-send-email-geert@linux-m68k.org>
References: <1395693091-4813-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Update the documentation for the removal of GENERIC_SUBSYS_PM_OPS in commit
90363ddf0a1a4dccfbb8d0c10b8f488bc7fa69f8 ("PM: Drop generic_subsys_pm_ops")

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/power/runtime_pm.txt |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
index 8cc48b05939d..0c1c4124d23a 100644
--- a/Documentation/power/runtime_pm.txt
+++ b/Documentation/power/runtime_pm.txt
@@ -727,15 +727,12 @@ driver/base/power/generic_ops.c:
   int pm_generic_restore_noirq(struct device *dev);
     - invoke the ->restore_noirq() callback provided by the device's driver
 
-These functions can be assigned to the ->runtime_idle(), ->runtime_suspend(),
+These functions are the defaults used by the PM core, if a subsystem doesn't
+provide its own callbacks for ->runtime_idle(), ->runtime_suspend(),
 ->runtime_resume(), ->suspend(), ->suspend_noirq(), ->resume(),
 ->resume_noirq(), ->freeze(), ->freeze_noirq(), ->thaw(), ->thaw_noirq(),
-->poweroff(), ->poweroff_noirq(), ->restore(), ->restore_noirq() callback
-pointers in the subsystem-level dev_pm_ops structures.
-
-If a subsystem wishes to use all of them at the same time, it can simply assign
-the GENERIC_SUBSYS_PM_OPS macro, defined in include/linux/pm.h, to its
-dev_pm_ops structure pointer.
+->poweroff(), ->poweroff_noirq(), ->restore(), ->restore_noirq() in the
+subsystem-level dev_pm_ops structure.
 
 Device drivers that wish to use the same function as a system suspend, freeze,
 poweroff and runtime suspend callback, and similarly for system resume, thaw,
-- 
1.7.9.5

