Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaAVGEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 01:04:43 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:60586 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbaAVGEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 01:04:38 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH Resend] PM: Remove unnecessary !!
Date: Wed, 22 Jan 2014 11:34:31 +0530
Message-Id: <dda85a5e41fbb1995fe3bda810a7a8297ccf1dcb.1390370582.git.viresh.kumar@linaro.org>
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

