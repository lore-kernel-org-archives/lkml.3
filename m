Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaCJOCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:02:30 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35912 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbaCJOC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:02:27 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH Resend] PM: Remove unnecessary !!
Date: Mon, 10 Mar 2014 19:31:51 +0530
Message-Id: <40f994376d56b4fa090fc2d27403c2188a4af0a4.1394460079.git.viresh.kumar@linaro.org>
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

