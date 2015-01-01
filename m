Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbbAARBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 12:01:54 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35609 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbbAARBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 12:01:52 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] power: ab8500_fg.c:  Remove unused function
Date: Thu,  1 Jan 2015 18:04:52 +0100
Message-Id: <1420131892-31486-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function ab8500_fg_reinit() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/power/ab8500_fg.c            |   14 --------------
 include/linux/mfd/abx500/ab8500-bm.h |    1 -
 2 files changed, 15 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 217da4b..72c82ab 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2434,20 +2434,6 @@ static void ab8500_fg_reinit_work(struct work_struct *work)
 	}
 }
 
-/**
- * ab8500_fg_reinit() - forces FG algorithm to reinitialize with current values
- *
- * This function can be used to force the FG algorithm to recalculate a new
- * voltage based battery capacity.
- */
-void ab8500_fg_reinit(void)
-{
-	struct ab8500_fg *di = ab8500_fg_get();
-	/* User won't be notified if a null pointer returned. */
-	if (di != NULL)
-		queue_delayed_work(di->fg_wq, &di->fg_reinit_work, 0);
-}
-
 /* Exposure to the sysfs interface */
 
 struct ab8500_fg_sysfs_entry {
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index cc892a8..12a5b39 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -461,7 +461,6 @@ struct ab8500_fg;
 #ifdef CONFIG_AB8500_BM
 extern struct abx500_bm_data ab8500_bm_data;
 
-void ab8500_fg_reinit(void);
 void ab8500_charger_usb_state_changed(u8 bm_usb_state, u16 mA);
 struct ab8500_btemp *ab8500_btemp_get(void);
 int ab8500_btemp_get_batctrl_temp(struct ab8500_btemp *btemp);
-- 
1.7.10.4

