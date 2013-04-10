Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab3DJVFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:05:41 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:40367 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3DJVFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:05:40 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-usb@vger.kernel.org
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] drivers: usb: chipidea: convert to devm_ioremap_resource()
Date: Thu, 11 Apr 2013 00:05:35 +0300
Message-Id: <1365627935-17561-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert  use of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 drivers/usb/chipidea/core.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 57cae1f..7f3a9e1 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -410,11 +410,9 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	base = devm_request_and_ioremap(dev, res);
-	if (!base) {
-		dev_err(dev, "can't request and ioremap resource\n");
-		return -ENOMEM;
-	}
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	ci = devm_kzalloc(dev, sizeof(*ci), GFP_KERNEL);
 	if (!ci) {
-- 
1.7.9.5

