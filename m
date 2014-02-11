Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbaBKUVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:21:54 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:48332 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbaBKUVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:21:51 -0500
From: Kumar Gala <galak@codeaurora.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] hwrng: msm: switch Kconfig to ARCH_QCOM depends
Date: Tue, 11 Feb 2014 14:21:45 -0600
Message-Id: <1392150105-21057-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the splits the Qualcomm MSM platform into legacy support that we will
not try and convert to multiplatform and multiplatform support.

- k

Changes from v2:
* Dropped ARCH_MSM depends from CLKSRC_QCOM, since we select it
* Fixed some grammar/typo's in commit messages
* kept smp ops code in platsmp.c to match what other mach's do
* Kept mach-qcom/Kconfig sorted alphabetically

Changes from v1:
* Added patch to remove hotplug.c
* Added patch to rename msm_ to qcom_
* Changes the Kconfig to drop CPU_V7
* used wfi() in cpu_die function
* Added git tree to MAINTAINERS file

Kumar Gala (5):

We've split Qualcomm MSM support into legacy and multiplatform.  The RNG
driver is only relevant on the multiplatform supported SoCs so switch the
Kconfig depends to ARCH_QCOM.

CC: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 drivers/char/hw_random/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 2f2b084..289bd3a 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -343,7 +343,7 @@ config HW_RANDOM_TPM
 
 config HW_RANDOM_MSM
 	tristate "Qualcomm MSM Random Number Generator support"
-	depends on HW_RANDOM && ARCH_MSM
+	depends on HW_RANDOM && ARCH_QCOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Qualcomm MSM SoCs.
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

