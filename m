Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934740Ab3GQW5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:57:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56945 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934722Ab3GQW5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:57:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Darren Hart <dvhart@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 040/145] pch_uart: Add uart_clk selection for the MinnowBoard
Date: Wed, 17 Jul 2013 15:46:12 -0700
Message-Id: <1374101277-7915-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darren Hart <dvhart@linux.intel.com>

commit 29692d05647cb7ecea56242241f77291d5624b95 upstream.

Use DMI_BOARD_NAME to determine if we are running on a MinnowBoard and
set the uart clock to 50MHz if so. This removes the need to pass the
user_uartclk to the kernel at boot time.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Waskiewicz <peter.p.waskiewicz.jr@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/serial/pch_uart.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 8318925..a9e4be7 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -214,6 +214,7 @@ enum {
 #define FRI2_64_UARTCLK  64000000 /*  64.0000 MHz */
 #define FRI2_48_UARTCLK  48000000 /*  48.0000 MHz */
 #define NTC1_UARTCLK     64000000 /*  64.0000 MHz */
+#define MINNOW_UARTCLK   50000000 /*  50.0000 MHz */
 
 struct pch_uart_buffer {
 	unsigned char *buf;
@@ -395,6 +396,10 @@ static int pch_uart_get_uartclk(void)
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

