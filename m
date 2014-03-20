Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbaCTLMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:12:34 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51230 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712AbaCTLML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:12:11 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Cc: lee.jones@linaro.org, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, angus.clark@st.com
Subject: [PATCH 5/5] mtd: st_spi_fsm: Succinctly reorganise .remove()
Date: Thu, 20 Mar 2014 11:11:47 +0000
Message-Id: <1395313907-25318-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395313907-25318-1-git-send-email-lee.jones@linaro.org>
References: <1395313907-25318-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 921b44a..bea1416 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -2081,13 +2081,8 @@ static int stfsm_probe(struct platform_device *pdev)
 static int stfsm_remove(struct platform_device *pdev)
 {
 	struct stfsm *fsm = platform_get_drvdata(pdev);
-	int err;
 
-	err = mtd_device_unregister(&fsm->mtd);
-	if (err)
-		return err;
-
-	return 0;
+	return mtd_device_unregister(&fsm->mtd);
 }
 
 static struct of_device_id stfsm_match[] = {
-- 
1.8.3.2

