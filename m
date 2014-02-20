Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbaBTQJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:09:09 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45596 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaBTQJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:09:06 -0500
From: Kumar Gala <galak@codeaurora.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        svarbanov@mm-sol.com
Subject: [PATCH v2] hwrng: msm: switch Kconfig to ARCH_QCOM depends
Date: Thu, 20 Feb 2014 10:09:02 -0600
Message-Id: <1392912542-5349-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've split Qualcomm MSM support into legacy and multiplatform.  The RNG
driver is only relevant on the multiplatform supported SoCs so switch the
Kconfig depends to ARCH_QCOM.

CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: Stanimir Varbanov <svarbanov@mm-sol.com>
Signed-off-by: Kumar Gala <galak@codeaurora.org>
---

Herbert,

If you can ack this I'll send it via linux-qcom/arm-soc tree's

thanks

v2:
* Updated help text to remove MSM references, made more generic

 drivers/char/hw_random/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 2f2b084..f2b9f8c 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -342,11 +342,11 @@ config HW_RANDOM_TPM
 	  If unsure, say Y.
 
 config HW_RANDOM_MSM
-	tristate "Qualcomm MSM Random Number Generator support"
-	depends on HW_RANDOM && ARCH_MSM
+	tristate "Qualcomm ARM SoCs Random Number Generator support"
+	depends on HW_RANDOM && ARCH_QCOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
-	  Generator hardware found on Qualcomm MSM SoCs.
+	  Generator hardware found on Qualcomm ARM SoCs.
 
 	  To compile this driver as a module, choose M here. the
 	  module will be called msm-rng.
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

