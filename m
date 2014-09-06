Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaIFCzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 22:55:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:51354 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbaIFCzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 22:55:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="382222538"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] tty/serial/8250: Resolve missing-field-initializers warnings
Date: Fri,  5 Sep 2014 19:55:49 -0700
Message-Id: <1409972149-26272-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Resolve some missing-field-initializers warnings by using
designated initialization in the expansion of the SERIAL_PORT_DFNS
macro.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 arch/x86/include/asm/serial.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/serial.h b/arch/x86/include/asm/serial.h
index 628c801..03ece8e 100644
--- a/arch/x86/include/asm/serial.h
+++ b/arch/x86/include/asm/serial.h
@@ -21,9 +21,9 @@
 
 #define SERIAL_PORT_DFNS			\
 	/* UART CLK   PORT IRQ     FLAGS        */			\
-	{ 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS },	/* ttyS0 */	\
-	{ 0, BASE_BAUD, 0x2F8, 3, STD_COM_FLAGS },	/* ttyS1 */	\
-	{ 0, BASE_BAUD, 0x3E8, 4, STD_COM_FLAGS },	/* ttyS2 */	\
-	{ 0, BASE_BAUD, 0x2E8, 3, STD_COM4_FLAGS },	/* ttyS3 */
+	{ .uart = 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS }, /* ttyS0 */	\
+	{ .uart = 0, BASE_BAUD, 0x2F8, 3, STD_COM_FLAGS }, /* ttyS1 */	\
+	{ .uart = 0, BASE_BAUD, 0x3E8, 4, STD_COM_FLAGS }, /* ttyS2 */	\
+	{ .uart = 0, BASE_BAUD, 0x2E8, 3, STD_COM4_FLAGS }, /* ttyS3 */
 
 #endif /* _ASM_X86_SERIAL_H */
-- 
1.9.3

