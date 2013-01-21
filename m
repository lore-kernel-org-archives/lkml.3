Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3AUMIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:08:21 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:56966 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab3AUMEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:51 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru,
        =?UTF-8?q?Martin=20Bergstr=C3=B6m?= 
	<martin.bergstrom@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 15/24] ab8500-fg: Go to INIT_RECOVERY when charger removed
Date: Mon, 21 Jan 2013 12:03:51 +0000
Message-Id: <1358769840-4763-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Bergström <martin.bergstrom@stericsson.com>

When the charger is removed we need to go to INIT_RECOVERY
state instead of directly to RECOVERY state.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Martin Bergstrom <martin.bergstrom@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_fg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 238eeee..0378aab 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -1450,7 +1450,7 @@ static void ab8500_fg_algorithm_discharging(struct ab8500_fg *di)
 
 			if (di->recovery_needed) {
 				ab8500_fg_discharge_state_to(di,
-					AB8500_FG_DISCHARGE_RECOVERY);
+					AB8500_FG_DISCHARGE_INIT_RECOVERY);
 
 				queue_delayed_work(di->fg_wq,
 					&di->fg_periodic_work, 0);
-- 
1.7.9.5

