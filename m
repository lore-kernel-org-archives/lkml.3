Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852Ab3EUCnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:43:42 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:32880 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758602Ab3EUCnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:43:39 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <samuel@sortiz.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <lizefan@huawei.com>, <libo.chen@huawei.com>
Subject: [PATCH 15/19] drivers/net/irda: add missing platform_driver owner
Date: Tue, 21 May 2013 10:42:43 +0800
Message-ID: <1369104163-38628-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set the owner of platform_driver, to ensure that the
caller of driver holds a module refernece

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/net/irda/bfin_sir.c   |    1 +
 drivers/net/irda/sh_irda.c    |    1 +
 drivers/net/irda/sh_sir.c     |    1 +
 drivers/net/irda/smsc-ircc2.c |    1 +
 4 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/irda/bfin_sir.c b/drivers/net/irda/bfin_sir.c
index 22b4527..bf976f3 100644
--- a/drivers/net/irda/bfin_sir.c
+++ b/drivers/net/irda/bfin_sir.c
@@ -806,6 +806,7 @@ static struct platform_driver bfin_ir_driver = {
 	.resume  = bfin_sir_resume,
 	.driver  = {
 		.name = DRIVER_NAME,
+		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/net/irda/sh_irda.c b/drivers/net/irda/sh_irda.c
index 9448587..f14ea43 100644
--- a/drivers/net/irda/sh_irda.c
+++ b/drivers/net/irda/sh_irda.c
@@ -865,6 +865,7 @@ static struct platform_driver sh_irda_driver = {
 	.remove	= sh_irda_remove,
 	.driver	= {
 		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
 		.pm	= &sh_irda_pm_ops,
 	},
 };
diff --git a/drivers/net/irda/sh_sir.c b/drivers/net/irda/sh_sir.c
index 24aefcd..3bd058d 100644
--- a/drivers/net/irda/sh_sir.c
+++ b/drivers/net/irda/sh_sir.c
@@ -806,6 +806,7 @@ static struct platform_driver sh_sir_driver = {
 	.remove  = sh_sir_remove,
 	.driver  = {
 		.name = DRIVER_NAME,
+		.owner = THIS_MODULE,
 	},
 };
 
diff --git a/drivers/net/irda/smsc-ircc2.c b/drivers/net/irda/smsc-ircc2.c
index aa05dad..5b3e4d2 100644
--- a/drivers/net/irda/smsc-ircc2.c
+++ b/drivers/net/irda/smsc-ircc2.c
@@ -260,6 +260,7 @@ static struct platform_driver smsc_ircc_driver = {
 	.resume		= smsc_ircc_resume,
 	.driver		= {
 		.name	= SMSC_IRCC2_DRIVER_NAME,
+		.owner	= THIS_MODULE,
 	},
 };
 
-- 
1.7.1


