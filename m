Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab3AKNOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:14:03 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36718 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3AKNNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:13:54 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 18/18] power: ab8500_fg: Remove pointless round_jiffies() call
Date: Fri, 11 Jan 2013 13:13:06 +0000
Message-Id: <1357909986-9262-19-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
References: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As HZ is a full-second, there is little point in rounding it.
Let's save a few cycles by using HZ directly.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_fg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 4bc2c2d..a22f6ce 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -1854,7 +1854,7 @@ static void ab8500_fg_check_hw_failure_work(struct work_struct *work)
 		}
 		/* Not yet recovered from ovv, reschedule this test */
 		queue_delayed_work(di->fg_wq, &di->fg_check_hw_failure_work,
-				   round_jiffies(HZ));
+				   HZ);
 		} else {
 			dev_dbg(di->dev, "Battery recovered from OVV\n");
 			di->flags.bat_ovv = false;
-- 
1.7.9.5

