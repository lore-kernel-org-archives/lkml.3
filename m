Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab3GYMNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 08:13:51 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:57912 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab3GYMNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 08:13:48 -0400
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vineet.Gupta1@synopsys.com
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>
Subject: [PATCH] input/serio: disable i8042 PC keyboard ctrl for ARC
Date: Thu, 25 Jul 2013 14:13:41 +0200
Message-Id: <1374754421-27433-1-git-send-email-mjonker@synopsys.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It causes crashes when enabled, and we don't have such a peripheral
anyway on ARC platforms.

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
---
 drivers/input/serio/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 94c17c2..1e691a3 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -22,7 +22,8 @@ config SERIO_I8042
 	tristate "i8042 PC Keyboard controller" if EXPERT || !X86
 	default y
 	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
-		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN && !S390
+		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN && !S390 && \
+		   !ARC
 	help
 	  i8042 is the chip over which the standard AT keyboard and PS/2
 	  mouse are connected to the computer. If you use these devices,
-- 
1.7.9.5

