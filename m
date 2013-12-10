Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3LJNi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 08:38:28 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:53741 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab3LJNiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 08:38:09 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH V2 3/3] PM / Sleep: Add macro to define common late/early system PM callbacks
Date: Tue, 10 Dec 2013 14:37:42 +0100
Message-Id: <1386682662-17633-4-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386682662-17633-1-git-send-email-ulf.hansson@linaro.org>
References: <1386682662-17633-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use the same approach as for the existing SET_SYSTEM_SLEEP_PM_OPS,
but for the late and early callbacks instead.

The new SET_LATE_SYSTEM_SLEEP_PM_OPS, defined for CONFIG_PM_SLEEP, will
point ->suspend_late, ->freeze_late and ->poweroff_late to the same
function. Vice verse happens for ->resume_early, ->thaw_early and
->restore_early.

Cc: Kevin Hilman <khilman@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 include/linux/pm.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 7a830a7..8c6583a 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -311,6 +311,18 @@ struct dev_pm_ops {
 #define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
 #endif
 
+#ifdef CONFIG_PM_SLEEP
+#define SET_LATE_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+	.suspend_late = suspend_fn, \
+	.resume_early = resume_fn, \
+	.freeze_late = suspend_fn, \
+	.thaw_early = resume_fn, \
+	.poweroff_late = suspend_fn, \
+	.restore_early = resume_fn,
+#else
+#define SET_LATE_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
+#endif
+
 #ifdef CONFIG_PM_RUNTIME
 #define SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
 	.runtime_suspend = suspend_fn, \
-- 
1.7.9.5

