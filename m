Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624Ab3B0S2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:28:19 -0500
Received: from mail.windriver.com ([147.11.1.11]:54792 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760175Ab3B0S2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:28:18 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] power: make goldfish option have a dependency on goldfish
Date: Wed, 27 Feb 2013 13:27:46 -0500
Message-ID: <1361989666-1922-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nearly all the other goldfish peripherals (mtd, keyboard, etc)
have a dependency on the main platform's GOLDFISH Kconfig item,
but this one got skipped, so add it.

Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/power/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 9e00c38..d314528 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -348,7 +348,7 @@ config AB8500_BM
 
 config BATTERY_GOLDFISH
 	tristate "Goldfish battery driver"
-	depends on GENERIC_HARDIRQS
+	depends on GENERIC_HARDIRQS && GOLDFISH
 	help
 	  Say Y to enable support for the battery and AC power in the
 	  Goldfish emulator.
-- 
1.8.1.2

