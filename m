Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756Ab3EUCnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:43:13 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:34745 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758638Ab3EUCnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:43:09 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <libo.chen@huawei.com>
Subject: [PATCH 04/19] drivers/usb/dwc3: add missing platform_driver owner
Date: Tue, 21 May 2013 10:42:12 +0800
Message-ID: <1369104132-7060-1-git-send-email-libo.chen@huawei.com>
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
 drivers/usb/dwc3/core.c        |    1 +
 drivers/usb/dwc3/dwc3-exynos.c |    1 +
 drivers/usb/dwc3/dwc3-omap.c   |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index c35d49d..570c2df 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -766,6 +766,7 @@ static struct platform_driver dwc3_driver = {
 	.remove		= dwc3_remove,
 	.driver		= {
 		.name	= "dwc3",
+		.owner	= THIS_MODULE,
 		.of_match_table	= of_match_ptr(of_dwc3_match),
 		.pm	= DWC3_PM_OPS,
 	},
diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index a8afe6e..831aa81 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -219,6 +219,7 @@ static struct platform_driver dwc3_exynos_driver = {
 	.remove		= dwc3_exynos_remove,
 	.driver		= {
 		.name	= "exynos-dwc3",
+		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(exynos_dwc3_match),
 		.pm	= DEV_PM_OPS,
 	},
diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 34638b9..3aaf87f 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -468,6 +468,7 @@ static struct platform_driver dwc3_omap_driver = {
 	.remove		= dwc3_omap_remove,
 	.driver		= {
 		.name	= "omap-dwc3",
+		.owner	= THIS_MODULE,
 		.of_match_table	= of_dwc3_match,
 		.pm	= DEV_PM_OPS,
 	},
-- 
1.7.1


