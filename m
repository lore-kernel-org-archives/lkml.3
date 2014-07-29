Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaG2LQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:16:30 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:42225 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbaG2LQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:16:28 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Julian Andres Klode <jak@jak-linux.org>, Marc Dietrich <marvin24@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ac100@lists.launchpad.net, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging/nvec: Use platform_get_irq()
Date: Tue, 29 Jul 2014 13:16:15 +0200
Message-Id: <1406632575-26075-2-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1406632575-26075-1-git-send-email-thierry.reding@gmail.com>
References: <1406632575-26075-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

As opposed to platform_get_resource(), the platform_get_irq() function
has special code to handle driver probe deferral when booting using DT
and where an interrupt provider hasn't been registered yet. While this
is unlikely to become an issue for nvec, platform_get_irq() is the
recommended way to get at interrupts.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/staging/nvec/nvec.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index 815065837ce7..a93208adbfcf 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -821,8 +821,8 @@ static int tegra_nvec_probe(struct platform_device *pdev)
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!res) {
+	nvec->irq = platform_get_irq(pdev, 0);
+	if (nvec->irq < 0) {
 		dev_err(&pdev->dev, "no irq resource?\n");
 		return -ENODEV;
 	}
@@ -840,7 +840,6 @@ static int tegra_nvec_probe(struct platform_device *pdev)
 	}
 
 	nvec->base = base;
-	nvec->irq = res->start;
 	nvec->i2c_clk = i2c_clk;
 	nvec->rx = &nvec->msg_pool[0];
 
-- 
2.0.2

