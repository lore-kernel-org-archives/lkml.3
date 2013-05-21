Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab3EUCmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:42:35 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:32102 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab3EUCme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:42:34 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>
Subject: [PATCH 05/19] drivers/ust/renesas_usbhs: add missing platform_driver owner
Date: Tue, 21 May 2013 10:42:15 +0800
Message-ID: <1369104135-28484-1-git-send-email-libo.chen@huawei.com>
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
 drivers/usb/renesas_usbhs/common.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/common.c b/drivers/usb/renesas_usbhs/common.c
index cfd2050..0d98cd3 100644
--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -632,6 +632,7 @@ static const struct dev_pm_ops usbhsc_pm_ops = {
 static struct platform_driver renesas_usbhs_driver = {
 	.driver		= {
 		.name	= "renesas_usbhs",
+		.owner	= THIS_MODULE,
 		.pm	= &usbhsc_pm_ops,
 	},
 	.probe		= usbhs_probe,
-- 
1.7.1


