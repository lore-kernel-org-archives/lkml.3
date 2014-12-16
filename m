Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbaLPH16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 02:27:58 -0500
Received: from mail-bn1on0083.outbound.protection.outlook.com ([157.56.110.83]:23096
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750863AbaLPH15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 02:27:57 -0500
From: Ley Foon Tan <lftan@altera.com>
To: Tobias Klauser <tklauser@distanz.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <linux-serial@vger.kernel.org>,
        <nios2-dev@lists.rocketboards.org>
Subject: [PATCH] serial: altera-juart: fix NULL device in log message
Date: Tue, 16 Dec 2014 15:27:46 +0800
Message-ID: <1418714866-2744-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(50226001)(84676001)(50466002)(48376002)(64706001)(20776003)(99396003)(47776003)(68736005)(97736003)(4396001)(46102003)(50986999)(86362001)(36756003)(19580405001)(19580395003)(6806004)(92566001)(33646002)(120916001)(106466001)(105596002)(31966008)(77156002)(107046002)(89996001)(229853001)(21056001)(42186005)(87936001)(62966003)(7099022);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB224;H:sj-itexedge03.altera.priv.altera.com;FPR:;SPF:SoftFail;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB224;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR03MB224;
X-Forefront-PRVS: 04270EF89C
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB224;
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device pointer to port->dev.

Before:

"(NULL device *): ttyJ0 at MMIO 0x1008 (irq = 2, base_baud = 0) is a
Altera JTAG UART"

After:
"altera_jtaguart 1008.serial: ttyJ0 at MMIO 0x1008 (irq = 2, base_baud = 0) is a
Altera JTAG UART"

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 drivers/tty/serial/altera_jtaguart.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/altera_jtaguart.c b/drivers/tty/serial/altera_jtaguart.c
index 192d043..0fefdd8 100644
--- a/drivers/tty/serial/altera_jtaguart.c
+++ b/drivers/tty/serial/altera_jtaguart.c
@@ -441,6 +441,7 @@ static int altera_jtaguart_probe(struct platform_device *pdev)
 	port->iotype = SERIAL_IO_MEM;
 	port->ops = &altera_jtaguart_ops;
 	port->flags = UPF_BOOT_AUTOCONF;
+	port->dev = &pdev->dev;
 
 	uart_add_one_port(&altera_jtaguart_driver, port);
 
-- 
1.8.2.1

