Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab3EUCoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:44:05 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:35642 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758793Ab3EUCoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:44:00 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <alexander.shishkin@linux.intel.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>
Subject: [PATCH 03/19] drivers/usb/chipidea: add missing platform_driver owner
Date: Tue, 21 May 2013 10:42:10 +0800
Message-ID: <1369104130-27064-1-git-send-email-libo.chen@huawei.com>
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
 drivers/usb/chipidea/ci13xxx_msm.c |    2 +-
 drivers/usb/chipidea/core.c        |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/chipidea/ci13xxx_msm.c b/drivers/usb/chipidea/ci13xxx_msm.c
index 7d16681..5e6bdb0 100644
--- a/drivers/usb/chipidea/ci13xxx_msm.c
+++ b/drivers/usb/chipidea/ci13xxx_msm.c
@@ -90,7 +90,7 @@ static int ci13xxx_msm_remove(struct platform_device *pdev)
 static struct platform_driver ci13xxx_msm_driver = {
 	.probe = ci13xxx_msm_probe,
 	.remove = ci13xxx_msm_remove,
-	.driver = { .name = "msm_hsusb", },
+	.driver = { .name = "msm_hsusb", .owner	= THIS_MODULE,},
 };
 
 module_platform_driver(ci13xxx_msm_driver);
diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 49b098b..74e6b57 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -482,6 +482,7 @@ static struct platform_driver ci_hdrc_driver = {
 	.remove	= ci_hdrc_remove,
 	.driver	= {
 		.name	= "ci_hdrc",
+		.owner	= THIS_MODULE,
 	},
 };
 
-- 
1.7.1


