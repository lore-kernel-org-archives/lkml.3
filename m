Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab3GKMZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 08:25:12 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:41870 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab3GKMZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 08:25:10 -0400
From: Julien Delacou <julien.delacou.st@gmail.com>
To: Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Julien Delacou <julien.delacou@stericsson.com>
Subject: [PATCH] staging: dwc2: fix value used in dwc2_set_all_params
Date: Thu, 11 Jul 2013 14:24:10 +0200
Message-Id: <1373545450-5251-1-git-send-email-julien.delacou.st@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julien Delacou <julien.delacou@stericsson.com>

This fix uses 'value' parameter as it should be instead
of hardcoded -1.

Signed-off-by: Julien Delacou <julien.delacou@stericsson.com>
Acked-by: Paul Zimmerman <paulz@synopys.com>
---
 drivers/staging/dwc2/hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/dwc2/hcd.c b/drivers/staging/dwc2/hcd.c
index 2ed54b1..ca38aaa 100644
--- a/drivers/staging/dwc2/hcd.c
+++ b/drivers/staging/dwc2/hcd.c
@@ -2690,7 +2690,7 @@ void dwc2_set_all_params(struct dwc2_core_params *params, int value)
 	int i;
 
 	for (i = 0; i < size; i++)
-		p[i] = -1;
+		p[i] = value;
 }
 EXPORT_SYMBOL_GPL(dwc2_set_all_params);
 
-- 
1.7.9.5

