Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3LDB4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:56:40 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:51217 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab3LDB4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:56:37 -0500
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
To: peter.chen@freescale.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Ruehl <chris.ruehl@gtsys.com.hk>
Subject: [PATCH 1/3 v5] usb: chipidea: Reallocate regmap only if lpm is detected
Date: Wed,  4 Dec 2013 09:56:17 +0800
Message-Id: <1386122179-4158-1-git-send-email-chris.ruehl@gtsys.com.hk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb: chipidea: Reallocate regmap only if lpm is detected

The regmap only needs to reallocate if the hw_read on the CAP register shows
lpm is used. Therefore the if() statement check the change.

Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Acked-by: Peter Chen <peter.chen@freescale.com>
---
 drivers/usb/chipidea/core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 5d8981c..9a5ef20 100644
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

