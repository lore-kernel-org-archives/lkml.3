Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaC1VU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:20:57 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:35149 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaC1VUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:20:39 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 2/2] misc: arm-charlcd: add DT probe support
Date: Fri, 28 Mar 2014 16:20:29 -0500
Message-Id: <1396041629-28820-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396041629-28820-1-git-send-email-robherring2@gmail.com>
References: <1396041629-28820-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Add the DT match table to enable DT based probe matching.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/arm-charlcd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/misc/arm-charlcd.c b/drivers/misc/arm-charlcd.c
index b7ebf80..c72e96b 100644
--- a/drivers/misc/arm-charlcd.c
+++ b/drivers/misc/arm-charlcd.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/io.h>
@@ -366,11 +367,17 @@ static const struct dev_pm_ops charlcd_pm_ops = {
 	.resume = charlcd_resume,
 };
 
+static const struct of_device_id charlcd_match[] = {
+	{ .compatible = "arm,versatile-lcd", },
+	{}
+};
+
 static struct platform_driver charlcd_driver = {
 	.driver = {
 		.name = DRIVERNAME,
 		.owner = THIS_MODULE,
 		.pm = &charlcd_pm_ops,
+		.of_match_table = of_match_ptr(charlcd_match),
 	},
 	.remove = __exit_p(charlcd_remove),
 };
-- 
1.8.3.2

