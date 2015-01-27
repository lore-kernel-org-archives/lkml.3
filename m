Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbbA0Ls4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 06:48:56 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:52541 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbbA0Lsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 06:48:53 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH] mmc: print message if a card supports secure erase/trim
Date: Tue, 27 Jan 2015 12:48:24 +0100
Message-Id: <1422359304-30321-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's an interesting detail, so inform the user about it.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/mmc/core/bus.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 8a1f124..4a60028 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -347,6 +347,10 @@ int mmc_add_card(struct mmc_card *card)
 			uhs_bus_speed_mode, type, card->rca);
 	}
 
+	if (mmc_can_secure_erase_trim(card))
+		pr_info("%s: card supports secure erase/trim\n",
+			mmc_hostname(card->host));
+
 #ifdef CONFIG_DEBUG_FS
 	mmc_add_card_debugfs(card);
 #endif
-- 
2.1.0

