Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbaJUONE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:13:04 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:57315 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884AbaJUOMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:12:54 -0400
From: Xia Kaixu <kaixu.xia@linaro.org>
To: rmk+kernel@arm.linux.org.uk, arm@kernel.org
Cc: kaixu.xia@linaro.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/4] ARM: restrict CPU_BIG_ENDIAN configuration option
Date: Tue, 21 Oct 2014 22:11:33 +0800
Message-Id: <1413900694-29571-4-git-send-email-kaixu.xia@linaro.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413900694-29571-1-git-send-email-kaixu.xia@linaro.org>
References: <1413900694-29571-1-git-send-email-kaixu.xia@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms don't work when CPU_BIG_ENDIAN is enabled.
So It can get a dependency on !ARCH_MULTIPLATFORM_STRICT.

Signed-off-by: Xia Kaixu <kaixu.xia@linaro.org>
---
 arch/arm/mm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index ae69809..d510448 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -698,6 +698,7 @@ config SWP_EMULATE
 config CPU_BIG_ENDIAN
 	bool "Build big-endian kernel"
 	depends on ARCH_SUPPORTS_BIG_ENDIAN
+	depends on !ARCH_MULTIPLATFORM_STRICT
 	help
 	  Say Y if you plan on running a kernel in big-endian mode.
 	  Note that your board must be properly built and your board
-- 
2.1.1

