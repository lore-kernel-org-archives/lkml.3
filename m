Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaCLTEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:04:22 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:64396 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaCLTEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:04:10 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v3 4/9] tty: xuartps: Print warning in clock notifier
Date: Wed, 12 Mar 2014 12:02:58 -0700
Message-Id: <1394650983-24780-5-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
In-Reply-To: <1394650983-24780-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1394650983-24780-1-git-send-email-soren.brinkmann@xilinx.com>
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
index 787a12064fa0..814391038abb 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -429,8 +429,10 @@ static int xuartps_clk_notifier_cb(struct notifier_block *nb,
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

