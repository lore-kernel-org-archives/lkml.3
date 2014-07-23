Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbaGWK5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:57:14 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36230 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433AbaGWKy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:54:29 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 16/25] clocksource: Kconfig: Let EM_TIMER_STI depend on HAS_IOMEM
Date: Wed, 23 Jul 2014 12:53:58 +0200
Message-Id: <1406112847-26275-16-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
References: <53CF93B2.6040903@linaro.org>
 <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Gang <gang.chen.5i5j@gmail.com>

In 'em_sti.c', it will call devm_ioremap_resource() which need
HAS_IOMEM. So need let EM_TIMER_STI depend on HAS_IOMEM, too.

The related error (with allmodconfig under score):

  LD      init/built-in.o
em_sti.c:(.text.em_sti_probe+0x84): undefined reference to `devm_ioremap_resource'
make: *** [vmlinux] Error 1

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 497356d..7ea7d7c 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -194,7 +194,7 @@ config SH_TIMER_TMU
 
 config EM_TIMER_STI
 	bool "Renesas STI timer driver" if COMPILE_TEST
-	depends on GENERIC_CLOCKEVENTS
+	depends on GENERIC_CLOCKEVENTS && HAS_IOMEM
 	default SYS_SUPPORTS_EM_STI
 	help
 	  This enables build of a clocksource and clockevent driver for
-- 
1.7.9.5

