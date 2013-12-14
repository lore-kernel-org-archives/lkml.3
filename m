Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab3LNNQk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 08:16:40 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:63034 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab3LNNQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 08:16:39 -0500
Date: Sat, 14 Dec 2013 18:46:31 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH] drivers: mmc: Mark the function sdhci_disable_irq_wakeups()
 as static in sdhci.c
Message-ID: <20131214131631.GA8543@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function sdhci_disable_irq_wakeups() as static in
host/sdhci.c because it is not used outside this file.

Thus, it also eliminates the following warning in host/sdhci.c:
drivers/mmc/host/sdhci.c:2553:6: warning: no previous prototype for ‘sdhci_disable_irq_wakeups’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/mmc/host/sdhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index bd8a098..8de50e8 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2550,7 +2550,7 @@ void sdhci_enable_irq_wakeups(struct sdhci_host *host)
 }
 EXPORT_SYMBOL_GPL(sdhci_enable_irq_wakeups);
 
-void sdhci_disable_irq_wakeups(struct sdhci_host *host)
+static void sdhci_disable_irq_wakeups(struct sdhci_host *host)
 {
 	u8 val;
 	u8 mask = SDHCI_WAKE_ON_INSERT | SDHCI_WAKE_ON_REMOVE
-- 
1.7.9.5

