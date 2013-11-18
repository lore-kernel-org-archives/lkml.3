Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab3KRPq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:46:56 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36088 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab3KRPqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:46:47 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] PM: Remove unnecessary !!
Date: Mon, 18 Nov 2013 21:16:34 +0530
Message-Id: <16bb76315fce72c969e417e6dd093b6371a1f234.1384789554.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Double ! or !! are normally required to get 0 or 1 out of a expression. A
comparision always returns 0 or 1 and hence there is no need to apply double !
over it again.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/power/suspend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 62ee437..90b3d93 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -39,7 +39,7 @@ static const struct platform_suspend_ops *suspend_ops;
 
 static bool need_suspend_ops(suspend_state_t state)
 {
-	return !!(state > PM_SUSPEND_FREEZE);
+	return state > PM_SUSPEND_FREEZE;
 }
 
 static DECLARE_WAIT_QUEUE_HEAD(suspend_freeze_wait_head);
-- 
1.7.12.rc2.18.g61b472e

