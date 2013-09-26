Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3IZO4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:56:30 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:47637 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab3IZO4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:56:23 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 27/27] mmc: core: Remove deprecated mmc_suspend|resume_host APIs
Date: Thu, 26 Sep 2013 16:54:52 +0200
Message-Id: <1380207292-16968-28-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
References: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The are no more users of the deprecated mmc_suspend|resume_host API,
so let's remove it.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/core/core.c  |   22 ----------------------
 include/linux/mmc/host.h |    3 ---
 2 files changed, 25 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 006ead2..be24b87 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2632,28 +2632,6 @@ EXPORT_SYMBOL(mmc_cache_ctrl);
 
 #ifdef CONFIG_PM
 
-/**
- *	mmc_suspend_host - suspend a host
- *	@host: mmc host
- */
-int mmc_suspend_host(struct mmc_host *host)
-{
-	/* This function is deprecated */
-	return 0;
-}
-EXPORT_SYMBOL(mmc_suspend_host);
-
-/**
- *	mmc_resume_host - resume a previously suspended host
- *	@host: mmc host
- */
-int mmc_resume_host(struct mmc_host *host)
-{
-	/* This function is deprecated */
-	return 0;
-}
-EXPORT_SYMBOL(mmc_resume_host);
-
 /* Do the card removal on suspend if card is assumed removeable
  * Do that in pm notifier while userspace isn't yet frozen, so we will be able
    to sync the card.
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 3b0c33a..a579d3a 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -382,9 +382,6 @@ static inline void *mmc_priv(struct mmc_host *host)
 #define mmc_classdev(x)	(&(x)->class_dev)
 #define mmc_hostname(x)	(dev_name(&(x)->class_dev))
 
-int mmc_suspend_host(struct mmc_host *);
-int mmc_resume_host(struct mmc_host *);
-
 int mmc_power_save_host(struct mmc_host *host);
 int mmc_power_restore_host(struct mmc_host *host);
 
-- 
1.7.9.5

