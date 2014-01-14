Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaANPqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:46:13 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751805AbaANPqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:46:11 -0500
From: Richard Weinberger <richard@nod.at>
To: kishon@ti.com, anton@enomsg.org, dwmw2@infradead.org,
        richardcochran@gmail.com, lidza.louina@gmail.com,
        gregkh@linuxfoundation.org, jic23@kernel.org, davem@davemloft.net
Cc: sebastian.hesselbarth@gmail.com, florian@openwrt.org,
        thomas.petazzoni@free-electrons.com, lars@metafoo.de, marex@denx.de,
        acourbot@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-iio@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/7] ptp_pch: Add dependency on HAS_IOMEM
Date: Tue, 14 Jan 2014 16:45:39 +0100
Message-Id: <1389714345-20165-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On archs like S390 or um this driver cannot build nor work.
Make it depend on HAS_IOMEM to bypass build failures.

drivers/ptp/ptp_pch.c: In function ‘pch_remove’:
drivers/ptp/ptp_pch.c:571:3: error: implicit declaration of function ‘iounmap’ [-Werror=implicit-function-declaration]
drivers/ptp/ptp_pch.c: In function ‘pch_probe’:
drivers/ptp/ptp_pch.c:621:2: error: implicit declaration of function ‘ioremap’ [-Werror=implicit-function-declaration]

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/ptp/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 5be73ba..5a7910e 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -73,6 +73,7 @@ config DP83640_PHY
 config PTP_1588_CLOCK_PCH
 	tristate "Intel PCH EG20T as PTP clock"
 	depends on X86 || COMPILE_TEST
+	depends on HAS_IOMEM
 	select PTP_1588_CLOCK
 	help
 	  This driver adds support for using the PCH EG20T as a PTP
-- 
1.8.1.4

