Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965613Ab3GSF0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:26:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39648 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965433Ab3GSF0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [ 11/72] pch_uart: Add uart_clk selection for the MinnowBoard
Date: Thu, 18 Jul 2013 22:25:28 -0700
Message-Id: <20130719052600.630717522@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/tty/serial/pch_uart.c |    5 +++++
 1 file changed, 5 insertions(+)

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
 


