Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbaCXUbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:31:48 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:34351 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbaCXUbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:31:43 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 3/5] PM / Runtime: Correct documented return values for generic PM callbacks
Date: Mon, 24 Mar 2014 21:31:29 +0100
Message-Id: <1395693091-4813-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395693091-4813-1-git-send-email-geert@linux-m68k.org>
References: <1395693091-4813-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

As of commit 05aa55dddb9ee4045c320661068bea78dad6a6e5 ("PM / Runtime:
Lenient generic runtime pm callbacks"), the generic power management
callbacks pm_generic_runtime_suspend() and pm_generic_runtime_resume()
return 0, not -EINVAL, if the device doesn't provide its own callbacks.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/power/runtime_pm.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
index f62deb66d5c1..8cc48b05939d 100644
--- a/Documentation/power/runtime_pm.txt
+++ b/Documentation/power/runtime_pm.txt
@@ -667,11 +667,11 @@ driver/base/power/generic_ops.c:
 
   int pm_generic_runtime_suspend(struct device *dev);
     - invoke the ->runtime_suspend() callback provided by the driver of this
-      device and return its result, or return -EINVAL if not defined
+      device and return its result, or return 0 if not defined
 
   int pm_generic_runtime_resume(struct device *dev);
     - invoke the ->runtime_resume() callback provided by the driver of this
-      device and return its result, or return -EINVAL if not defined
+      device and return its result, or return 0 if not defined
 
   int pm_generic_suspend(struct device *dev);
     - if the device has not been suspended at run time, invoke the ->suspend()
-- 
1.7.9.5

