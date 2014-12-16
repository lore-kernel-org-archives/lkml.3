Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419AbaLPHn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 02:43:59 -0500
Received: from mail-by2on0060.outbound.protection.outlook.com ([207.46.100.60]:48448
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750863AbaLPHn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 02:43:57 -0500
From: Ley Foon Tan <lftan@altera.com>
To: Tobias Klauser <tklauser@distanz.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <linux-serial@vger.kernel.org>,
        <nios2-dev@lists.rocketboards.org>
Subject: [PATCH] serial: altera-uart: fix NULL device in log message
Date: Tue, 16 Dec 2014 15:28:34 +0800
Message-ID: <1418714914-2836-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(64706001)(50986999)(106466001)(229853001)(105596002)(33646002)(6806004)(89996001)(19580405001)(50466002)(87936001)(19580395003)(50226001)(42186005)(92566001)(48376002)(86362001)(120916001)(107046002)(31966008)(62966003)(20776003)(77156002)(46102003)(21056001)(47776003)(84676001)(97736003)(4396001)(68736005)(99396003)(36756003)(7099022);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB216;H:sj-itexedge03.altera.priv.altera.com;FPR:;SPF:SoftFail;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB216;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR03MB216;
X-Forefront-PRVS: 04270EF89C
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB216;
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device pointer to port->dev.

Before:

"(NULL device *): ttyAL0 at MMIO 0x2020 (irq = 6, base_baud = 3125000)
is a Altera UART"

After:
"altera_uart 2020.serial: ttyAL0 at MMIO 0x2020 (irq = 6, base_baud = 3125000)
is a Altera UART"

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 drivers/tty/serial/altera_uart.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/altera_uart.c b/drivers/tty/serial/altera_uart.c
index eb15a50..b2859fe 100644
--- a/drivers/tty/serial/altera_uart.c
+++ b/drivers/tty/serial/altera_uart.c
@@ -589,6 +589,7 @@ static int altera_uart_probe(struct platform_device *pdev)
 	port->iotype = SERIAL_IO_MEM;
 	port->ops = &altera_uart_ops;
 	port->flags = UPF_BOOT_AUTOCONF;
+	port->dev = &pdev->dev;
 
 	platform_set_drvdata(pdev, port);
 
-- 
1.8.2.1

