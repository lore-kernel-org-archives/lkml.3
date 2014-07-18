Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762031AbaGRMbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:31:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40762 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761631AbaGRMaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:30:15 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v10 5/8] ata: ahci_platform: add a generic AHCI compatible
Date: Fri, 18 Jul 2014 14:30:04 +0200
Message-Id: <1405686607-8126-6-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405686607-8126-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1405686607-8126-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ahci_platform driver is a generic driver using the libahci_platform
functions. Add a generic compatible to avoid having an endless list of
compatibles with no differences for the same driver.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 drivers/ata/ahci_platform.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 95f9ca82082a..61b15e784020 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -77,6 +77,8 @@ static SIMPLE_DEV_PM_OPS(ahci_pm_ops, ahci_platform_suspend,
 			 ahci_platform_resume);
 
 static const struct of_device_id ahci_of_match[] = {
+	{ .compatible = "generic-ahci", },
+	/* Keep the following compatibles for device tree compatibility */
 	{ .compatible = "snps,spear-ahci", },
 	{ .compatible = "snps,exynos5440-ahci", },
 	{ .compatible = "ibm,476gtr-ahci", },
-- 
1.9.1

