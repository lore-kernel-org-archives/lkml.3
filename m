Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab3FZBxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:53:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:22403 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab3FZBxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:53:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,940,1363158000"; 
   d="scan'208";a="335543119"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        andriy.shevchenko@linux.intel.com, danders@circuitco.com,
        vishal.l.verma@intel.com, dvhart@linux.intel.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: [PATCH 2/8] pch_uart: Add uart_clk selection for the MinnowBoard
Date: Tue, 25 Jun 2013 18:53:22 -0700
Message-Id: <6cc125b9eb85dd3cae4a2496fdb7f0d17b18f930.1372211451.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1372211451.git.dvhart@linux.intel.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
In-Reply-To: <cover.1372211451.git.dvhart@linux.intel.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DMI_BOARD_NAME to determine if we are running on a MinnowBoard and
set the uart clock to 50MHz if so. This removes the need to pass the
user_uartclk to the kernel at boot time.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Waskiewicz <peter.p.waskiewicz.jr@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/pch_uart.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 21a7e17..572d481 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -217,6 +217,7 @@ enum {
 #define FRI2_64_UARTCLK  64000000 /*  64.0000 MHz */
 #define FRI2_48_UARTCLK  48000000 /*  48.0000 MHz */
 #define NTC1_UARTCLK     64000000 /*  64.0000 MHz */
+#define MINNOW_UARTCLK   50000000 /*  50.0000 MHz */
 
 struct pch_uart_buffer {
 	unsigned char *buf;
@@ -398,6 +399,10 @@ static int pch_uart_get_uartclk(void)
 		    strstr(cmp, "nanoETXexpress-TT")))
 		return NTC1_UARTCLK;
 
+	cmp = dmi_get_system_info(DMI_BOARD_NAME);
+	if (cmp && strstr(cmp, "MinnowBoard"))
+		return MINNOW_UARTCLK;
+
 	return DEFAULT_UARTCLK;
 }
 
-- 
1.8.1.2

