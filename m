Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbaCTTcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:32:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57401 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653AbaCTTck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:32:40 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <peter@hurleysoftware.com>, <m-karicheri2@ti.com>,
        <b32955@freescale.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 07/11] tty: serial: omap: remove unneeded singlethread workqueue
Date: Thu, 20 Mar 2014 14:30:03 -0500
Message-ID: <1395343807-21618-7-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.1.286.g5172cb3
In-Reply-To: <1395343807-21618-1-git-send-email-balbi@ti.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it wasn't used by anything, just remove it.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index c79d3e6..b092d3d 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -180,8 +180,6 @@ static struct uart_omap_port *ui[OMAP_MAX_HSUART_PORTS];
 /* Forward declaration of functions */
 static void serial_omap_mdr1_errataset(struct uart_omap_port *up, u8 mdr1);
 
-static struct workqueue_struct *serial_omap_uart_wq;
-
 static inline unsigned int serial_in(struct uart_omap_port *up, int offset)
 {
 	offset <<= up->port.regshift;
@@ -1684,7 +1682,6 @@ static int serial_omap_probe(struct platform_device *pdev)
 	up->calc_latency = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE;
 	pm_qos_add_request(&up->pm_qos_request,
 		PM_QOS_CPU_DMA_LATENCY, up->latency);
-	serial_omap_uart_wq = create_singlethread_workqueue(up->name);
 	INIT_WORK(&up->qos_work, serial_omap_uart_qos_work);
 
 	platform_set_drvdata(pdev, up);
-- 
1.9.1.286.g5172cb3

