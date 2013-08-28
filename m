Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab3H1SrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:47:13 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:43941 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3H1SrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:47:11 -0400
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>
Subject: [PATCH] input/serio: disable i8042 PC keyboard ctrl for ARC
Date: Wed, 28 Aug 2013 20:46:56 +0200
Message-Id: <1377715616-2548-1-git-send-email-mjonker@synopsys.com>
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

