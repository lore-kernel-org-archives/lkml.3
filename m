Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab3HOPgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 11:36:12 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40055 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637Ab3HOPgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 11:36:09 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] power/reset: Make vexpress driver depend on required infrastructure
Date: Thu, 15 Aug 2013 16:35:52 +0100
Message-Id: <1376580952-21677-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20130815114401.GD23006@n2100.arm.linux.org.uk>
References: <20130815114401.GD23006@n2100.arm.linux.org.uk>
X-OriginalArrivalTime: 15 Aug 2013 15:36:05.0771 (UTC) FILETIME=[27F005B0:01CE99CD]
X-MC-Unique: 113081516360700201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7FFaOHG016579

ARM Versatile Express reset driver requires platform-specific
config infrastructure to be present in the kernel. When
VEXPRESS_CONFIG is not selected, the build will fail like this:

drivers/built-in.o: In function `vexpress_reset_do.clone.0':
iio-trig-interrupt.c:(.text+0x1aff38): undefined reference to `__vexpress_config_func_get'
iio-trig-interrupt.c:(.text+0x1aff4c): undefined reference to `vexpress_config_write'

Added required dependency to the Kconfig entry.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/power/reset/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index ee039dc..26d79df 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -34,7 +34,7 @@ config POWER_RESET_RESTART
 config POWER_RESET_VEXPRESS
 	bool "ARM Versatile Express power-off and reset driver"
 	depends on ARM || ARM64
-	depends on POWER_RESET
+	depends on POWER_RESET && VEXPRESS_CONFIG
 	help
 	  Power off and reset support for the ARM Ltd. Versatile
 	  Express boards.
-- 
1.8.1.2


