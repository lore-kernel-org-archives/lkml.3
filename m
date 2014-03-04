Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbaCDSQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 13:16:28 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:56910 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaCDSQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 13:16:26 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC 2/6] tty: xemacps: Print warning in clock notifier
Date: Tue,  4 Mar 2014 09:17:25 -0800
Message-Id: <1393953449-28551-3-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
In-Reply-To: <1393953449-28551-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1393953449-28551-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print a warning if the clock notifier rejects a clock frequency change
to facilitate debugging (see:
http://thread.gmane.org/gmane.linux.ports.arm.kernel/304329/focus=304379)

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/tty/serial/xilinx_uartps.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 8769b68534b1..4eee8031ae25 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -430,8 +430,10 @@ static int xuartps_clk_notifier_cb(struct notifier_block *nb,
 		 * frequency.
 		 */
 		if (!xuartps_calc_baud_divs(ndata->new_rate, xuartps->baud,
-					&bdiv, &cd, &div8))
+					&bdiv, &cd, &div8)) {
+			dev_warn(port->dev, "clock rate change rejected\n");
 			return NOTIFY_BAD;
+		}
 
 		spin_lock_irqsave(&xuartps->port->lock, flags);
 
-- 
1.9.0.1.g4196000

