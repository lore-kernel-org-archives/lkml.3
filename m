Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab3FJPMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 11:12:14 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57528 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab3FJPMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 11:12:13 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] power/reset: Make the vexpress driver optional on arm and arm64
Date: Mon, 10 Jun 2013 16:12:01 +0100
Message-Id: <1370877121-26211-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.1.2
X-OriginalArrivalTime: 10 Jun 2013 15:12:09.0502 (UTC) FILETIME=[E09743E0:01CE65EC]
X-MC-Unique: 113061016121110301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r5AFCLL9005286

The driver can be used on either arm or arm64 platforms, but
the latter doesn't have any platform-specific configuration
options, so it must be possible to manually enable the driver.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 drivers/power/reset/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Hello Anton, David,

Would you be so kind to queue this small change for 3.11?

Thanks!

Pawel

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index 349e9ae..ee039dc 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -32,7 +32,8 @@ config POWER_RESET_RESTART
 	  user presses a key. u-boot then boots into Linux.
 
 config POWER_RESET_VEXPRESS
-	bool
+	bool "ARM Versatile Express power-off and reset driver"
+	depends on ARM || ARM64
 	depends on POWER_RESET
 	help
 	  Power off and reset support for the ARM Ltd. Versatile
-- 
1.8.1.2


