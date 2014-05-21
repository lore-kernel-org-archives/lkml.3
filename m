Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaEUC2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:28:20 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:43537
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751417AbaEUC2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:28:17 -0400
From: Huang Shijie <b32955@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH 2/2 v2] serial: imx: remove the redundant code
Date: Wed, 21 May 2014 09:09:47 +0800
Message-ID: <1400634587-513-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1400633789-31979-2-git-send-email-b32955@freescale.com>
References: <1400633789-31979-2-git-send-email-b32955@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(77096999)(89996001)(79102001)(81342001)(88136002)(83072002)(92726001)(33646001)(93916002)(84676001)(68736004)(87936001)(77982001)(81156002)(21056001)(92566001)(87286001)(69596002)(62966002)(36756003)(50466002)(20776003)(102836001)(46102001)(76482001)(47776003)(19580395003)(83322001)(19580405001)(80022001)(44976005)(64706001)(97736001)(74662001)(48376002)(50226001)(31966008)(6806004)(74502001)(76176999)(85852003)(99396002)(50986999)(81542001)(77156001)(4396001)(42262001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB426;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0218A015FA
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=shijie.huang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the imx_startup(), we will reset the uart port which will reset all
the FIFOs, including the URXD.

So the code to clear the RX FIFO is redundant. Just remove it.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
fix the typo.
---
 drivers/tty/serial/imx.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 64901d0..febf400 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1161,15 +1161,6 @@ static int imx_startup(struct uart_port *port)
 		temp |= UCR2_IRTS;
 	writel(temp, sport->port.membase + UCR2);
 
-	if (USE_IRDA(sport)) {
-		/* clear RX-FIFO */
-		int i = 64;
-		while ((--i > 0) &&
-			(readl(sport->port.membase + URXD0) & URXD_CHARRDY)) {
-			barrier();
-		}
-	}
-
 	if (!is_imx1_uart(sport)) {
 		temp = readl(sport->port.membase + UCR3);
 		temp |= IMX21_UCR3_RXDMUXSEL;
-- 
1.7.8

