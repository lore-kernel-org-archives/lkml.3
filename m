Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab3K2CNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 21:13:24 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:50296 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab3K2CNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 21:13:22 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Nov 2013 21:13:21 EST
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
To: alexander.shishkin@linux.intel.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ruehl <chris.ruehl@gtsys.com.hk>
Subject: [PATCH 1/3] usb: chipidea: Reallocate regmap only if lpm is detected
Date: Fri, 29 Nov 2013 10:06:58 +0800
Message-Id: <1385690818-32226-1-git-send-email-chris.ruehl@gtsys.com.hk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

