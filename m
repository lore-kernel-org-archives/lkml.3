Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaDFLph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 07:45:37 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:55458 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753312AbaDFLpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 07:45:35 -0400
Message-ID: <1396784733.30640.25.camel@x220>
Subject: [PATCH] spi: qup: Depend on ARCH_QCOM
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 06 Apr 2014 13:45:33 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Apr 2014 11:45:34.0172 (UTC) FILETIME=[B85301C0:01CF518D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8fc1b0f87d9f ("ARM: qcom: Split Qualcomm support into legacy and
multiplatform") removed Kconfig symbol ARCH_MSM_DT. But that commit
left one (optional) dependency on ARCH_MSM_DT untouched.

Three Kconfig symbols used to depend on ARCH_MSM_DT: ARCH_MSM8X60,
ARCH_MSM8960, and ARCH_MSM8974. These three symbols now depend on
ARCH_QCOM. So it appears this driver needs to depend on ARCH_QCOM too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested!

Note that this is basically guesswork: looking at commit 8fc1b0f87d9f it
appears to make sense to pick ARCH_QCOM here.

 drivers/spi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index efe1960af2b3..60f2b41c7310 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -383,7 +383,7 @@ config SPI_RSPI
 
 config SPI_QUP
 	tristate "Qualcomm SPI controller with QUP interface"
-	depends on ARCH_MSM_DT || (ARM && COMPILE_TEST)
+	depends on ARCH_QCOM || (ARM && COMPILE_TEST)
 	help
 	  Qualcomm Universal Peripheral (QUP) core is an AHB slave that
 	  provides a common data path (an output FIFO and an input FIFO)
-- 
1.9.0

