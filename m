Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab3CCF4O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 00:56:14 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:53166 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab3CCF4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 00:56:13 -0500
From: Takahisa Tanaka <mc74hc00@gmail.com>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Arkadiusz Miskiewicz <arekm@maven.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        Florian Mickler <florian@mickler.org>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Joseph Salisbury <josephtsalisbury@gmail.com>,
        Takahisa Tanaka <mc74hc00@gmail.com>
Subject: [PATCH] sp5100_tco: Fix the AcpiMmioSel bitmask value
Date: Sun,  3 Mar 2013 14:48:00 +0900
Message-Id: <1362289680-3527-1-git-send-email-mc74hc00@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AcpiMmioSel bit is the bit1 in AcpiMmioEn register, but, current
sp5100_tco driver was using bit2.

The sp5100_tco driver expects zero as a value of AcpiMmioSel (bit1).
fortunately, The problem didn't occur by this typo, because the default
value of misused bit2 is zero. However, the sp5100_tco driver should use
the correct bitmask value.

Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
---
 drivers/watchdog/sp5100_tco.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/sp5100_tco.h b/drivers/watchdog/sp5100_tco.h
index 71594a0..2b28c00 100644
--- a/drivers/watchdog/sp5100_tco.h
+++ b/drivers/watchdog/sp5100_tco.h
@@ -57,7 +57,7 @@
 #define SB800_PM_WATCHDOG_DISABLE	(1 << 2)
 #define SB800_PM_WATCHDOG_SECOND_RES	(3 << 0)
 #define SB800_ACPI_MMIO_DECODE_EN	(1 << 0)
-#define SB800_ACPI_MMIO_SEL		(1 << 2)
+#define SB800_ACPI_MMIO_SEL		(1 << 1)
 
 
 #define SB800_PM_WDT_MMIO_OFFSET	0xB00
-- 
1.8.1.4

