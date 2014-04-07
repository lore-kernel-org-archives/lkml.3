Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbaDGOP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:15:57 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:60183 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755363AbaDGOPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:15:47 -0400
Message-ID: <1396880145.12738.6.camel@x220>
Subject: [PATCH] [RESEND] spi: qup: Depend on ARCH_QCOM
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Brown <broonie@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
Cc: linux-spi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 07 Apr 2014 16:15:45 +0200
In-Reply-To: <20140407130853.GG14763@sirena.org.uk>
References: <1396784733.30640.25.camel@x220>
	 <20140407130853.GG14763@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Apr 2014 14:15:46.0254 (UTC) FILETIME=[DE5B56E0:01CF526B]
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
Resending, because Mark suggested to include the Qualcomm people (who
know what's going on with these symbols).

Still untested!

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

