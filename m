Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaEWFwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 01:52:08 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:1855
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751417AbaEWFwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 01:52:06 -0400
From: Huang Shijie <b32955@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH 2/2] serial: imx: disable the receiver ready interrupt for imx_stop_rx
Date: Fri, 23 May 2014 12:32:54 +0800
Message-ID: <1400819575-20435-2-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1400819575-20435-1-git-send-email-b32955@freescale.com>
References: <1400819575-20435-1-git-send-email-b32955@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(50466002)(85852003)(83072002)(62966002)(77156001)(76482001)(26826002)(36756003)(93916002)(46102001)(77982001)(102836001)(92726001)(81542001)(50986999)(76176999)(92566001)(4396001)(99396002)(50226001)(81342001)(33646001)(80022001)(31966008)(64706001)(74662001)(19580395003)(19580405001)(79102001)(20776003)(87286001)(44976005)(74502001)(47776003)(83322001)(89996001)(77096999)(48376002)(87936001)(6806004)(21056001)(88136002)(42262001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB432;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:gate-tx3.freescale.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0220D4B98D
Authentication-Results: spf=fail (sender IP is 192.88.168.1)
 smtp.mailfrom=shijie.huang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch disables the receiver ready interrupt for imx_stop_rx.
It reduces the interrupt numbers when the uart is going to close
or suspend.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/tty/serial/imx.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index ed6cdf7..6026101 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -440,6 +440,10 @@ static void imx_stop_rx(struct uart_port *port)
 
 	temp = readl(sport->port.membase + UCR2);
 	writel(temp & ~UCR2_RXEN, sport->port.membase + UCR2);
+
+	/* disable the `Receiver Ready Interrrupt` */
+	temp = readl(sport->port.membase + UCR1);
+	writel(temp & ~UCR1_RRDYEN, sport->port.membase + UCR1);
 }
 
 /*
-- 
1.7.8

