Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab3EJQsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 12:48:10 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:38093 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab3EJQsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 12:48:08 -0400
Message-ID: <518D24D7.3030309@gmail.com>
Date: Sat, 11 May 2013 00:48:23 +0800
From: Libo Chen <chenlibo.3@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: stern@rowland.harvard.edu
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        lizefan@huawei.com
Subject: [RFC PATCH] usb: fsl: add missing platform_driver owner
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Libo Chen <libo.chen@huawei.com>

set the owner of platform_driver, to ensure that the
caller of driver holds a module refernece

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/usb/host/ehci-fsl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index 3be3df2..bd831ec 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -732,6 +732,7 @@ static struct platform_driver ehci_fsl_driver = {
 	.shutdown = usb_hcd_platform_shutdown,
 	.driver = {
 		.name = "fsl-ehci",
+		.owner	= THIS_MODULE,
 		.pm = EHCI_FSL_PM_OPS,
 	},
 };
-- 
1.8.1.2
