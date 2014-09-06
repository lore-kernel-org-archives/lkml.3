Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaIFRW2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 13:22:28 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:64443 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaIFRWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 13:22:19 -0400
From: Alexey Charkov <alchark@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Prisk <linux@prisktech.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Cc: Alexey Charkov <alchark@gmail.com>
Subject: [PATCH 2/4] tty: vt8500_serial: add missing support for RTS setting
Date: Sat,  6 Sep 2014 21:21:13 +0400
Message-Id: <1410024075-1354-3-git-send-email-alchark@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1410024075-1354-1-git-send-email-alchark@gmail.com>
References: <1410024075-1354-1-git-send-email-alchark@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Charkov <alchark@gmail.com>
---
 drivers/tty/serial/vt8500_serial.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
index f225719..47e74f9 100644
--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -291,6 +291,14 @@ static unsigned int vt8500_get_mctrl(struct uart_port *port)
 
 static void vt8500_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
+	unsigned int lcr = vt8500_read(port, VT8500_URLCR);
+
+	if (mctrl & TIOCM_RTS)
+		lcr |= VT8500_RTS;
+	else
+		lcr &= ~VT8500_RTS;
+
+	vt8500_write(port, lcr, VT8500_URLCR);
 }
 
 static void vt8500_break_ctl(struct uart_port *port, int break_ctl)
-- 
2.0.0

