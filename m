Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab3K2HTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 02:19:47 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:50135 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab3K2HTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 02:19:45 -0500
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
To: alexander.shishkin@linux.intel.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ruehl <chris.ruehl@gtsys.com.hk>
Subject: [PATCH 1/3 v2] usb: chipidea: Reallocate regmap only if lpm is detected
Date: Fri, 29 Nov 2013 15:19:33 +0800
Message-Id: <1385709573-10419-1-git-send-email-chris.ruehl@gtsys.com.hk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb: chipidea: Reallocate regmap only if lpm is detected

The regmap only needs to reallocate if the hw_read on the CAP register shows
lpm is used. Therefore the if() statement check the change.

Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
---
 drivers/usb/chipidea/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 5d8981c..5075407 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -208,7 +208,8 @@ static int hw_device_init(struct ci_hdrc *ci, void __iomem *base)
 	reg = hw_read(ci, CAP_HCCPARAMS, HCCPARAMS_LEN) >>
 		__ffs(HCCPARAMS_LEN);
 	ci->hw_bank.lpm  = reg;
-	hw_alloc_regmap(ci, !!reg);
+	if (reg)
+		hw_alloc_regmap(ci, !!reg);
 	ci->hw_bank.size = ci->hw_bank.op - ci->hw_bank.abs;
 	ci->hw_bank.size += OP_LAST;
 	ci->hw_bank.size /= sizeof(u32);
-- 
1.7.10.4

