Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab3AKNQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:16:58 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58897 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab3AKNNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:13:35 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/18] power: ab8500_fg: balance IRQ enable
Date: Fri, 11 Jan 2013 13:12:55 +0000
Message-Id: <1357909986-9262-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
References: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Andersson <rickard.andersson@stericsson.com>

In case of time out error IRQ needs to be disabled
otherwise we will get unbalanced enable/disable pairs.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Rickard Andersson <rickard.andersson@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_fg.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 328717b..7cfc48a 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -745,6 +745,7 @@ int ab8500_fg_inst_curr_blocking(struct ab8500_fg *di)
 	dev_dbg(di->dev, "%s instant current: %d", __func__, res);
 	return res;
 fail:
+	disable_irq(di->irq);
 	mutex_unlock(&di->cc_lock);
 	return ret;
 }
-- 
1.7.9.5

