Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaKXG5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 01:57:07 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:28313 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbaKXG5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 01:57:02 -0500
X-AuditID: cbfee61a-f79c06d000004e71-0d-5472d6bdb367
From: Robert Baldyga <r.baldyga@samsung.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, jslaby@suse.cz, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 4/4] serial: samsung: use port->fifosize instead of hardcoded
 values
Date: Mon, 24 Nov 2014 07:56:24 +0100
Message-id: <1416812184-4496-5-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1416812184-4496-1-git-send-email-r.baldyga@samsung.com>
References: <1416812184-4496-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t9jAd2914pCDJbd5LSYs34Nm0Xz4vVs
	Fp9/72K1uLxrDpvFmcW97BZrj9xlt3hweCe7A7vHiRm/WTz2z13D7tG3ZRWjx5kFR9g9Pm+S
	C2CN4rJJSc3JLEst0rdL4Mpo7rzKXjCTo+Lu+YIGxudsXYycHBICJhJb391ggbDFJC7cWw8U
	5+IQEljEKDFhYy8jSEJIoJ1J4vNiQRCbTUBHYsv3CWBxEQE5iSe3/zCDNDALrGeUeHF/BTtI
	QlggTGLdpstgNouAqkR/71xWEJtXwEXiy4k+VohtchInj00GszkFXCWe35zKBrHMReLTigns
	Exh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDqpnUjsYVzZYHGIU4GBU4uH9sLEo
	RIg1say4MvcQowQHs5II79l/hSFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeW/czA0REkhPLEnN
	Tk0tSC2CyTJxcEo1MNac+ap6y+379NopG30it4iwxe0R/7Pyxpz1ew5b91pH99ilHVs1tyZ5
	5q7uifoXpukGuT2uv3TtlXdy8UYm1a5ZbBF2HpKzw6qc/hUemj7zl++yI34czrdXKQedvpEy
	rz7c2UPF9bpm/PPP13xe/P0osvNLdqDYYsW/CcV+3azBbDfTP964+EOJpTgj0VCLuag4EQAj
	n7OVJgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hardcoded FIFO size can cause hardware performance limitation.
Using real size value provides better FIFO usage.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/tty/serial/samsung.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 8808490..c622cf1 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -239,7 +239,7 @@ s3c24xx_serial_rx_chars(int irq, void *dev_id)
 	struct uart_port *port = &ourport->port;
 	unsigned int ufcon, ch, flag, ufstat, uerstat;
 	unsigned long flags;
-	int max_count = 64;
+	int max_count = port->fifosize;
 
 	spin_lock_irqsave(&port->lock, flags);
 
@@ -330,7 +330,7 @@ static irqreturn_t s3c24xx_serial_tx_chars(int irq, void *id)
 	struct uart_port *port = &ourport->port;
 	struct circ_buf *xmit = &port->state->xmit;
 	unsigned long flags;
-	int count = 256;
+	int count = port->fifosize;
 
 	spin_lock_irqsave(&port->lock, flags);
 
-- 
1.9.1

