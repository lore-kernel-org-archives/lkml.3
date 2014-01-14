Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaANPqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:46:30 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1676 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751957AbaANPqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:46:21 -0500
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
Subject: [PATCH 6/7] power,goldfish: Add dependency on HAS_IOMEM
Date: Tue, 14 Jan 2014 16:45:44 +0100
Message-Id: <1389714345-20165-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389714345-20165-1-git-send-email-richard@nod.at>
References: <1389714345-20165-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On archs like S390 or um this driver cannot build nor work.
Make it depend on HAS_IOMEM to bypass build failures.

drivers/built-in.o: In function `goldfish_battery_probe':
drivers/power/goldfish_battery.c:181: undefined reference to `devm_ioremap'

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/power/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 85ad58c..32c6294 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -377,6 +377,7 @@ config AB8500_BM
 config BATTERY_GOLDFISH
 	tristate "Goldfish battery driver"
 	depends on GOLDFISH || COMPILE_TEST
+	depends on HAS_IOMEM
 	help
 	  Say Y to enable support for the battery and AC power in the
 	  Goldfish emulator.
-- 
1.8.1.4

