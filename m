Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934421Ab3E2Cea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 22:34:30 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:9564 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580Ab3E2Ce2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 22:34:28 -0400
Message-ID: <51A568EC.2070103@huawei.com>
Date: Wed, 29 May 2013 10:33:16 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <timur@tabi.org>, Greg KH <gregkh@linuxfoundation.org>
CC: <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, <linux-serial@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH] driver: tty: add missing unregister in err case
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when platform_driver_register broken, we should unregister ucc_uart_driver

Signed-off-by: Libo chen <libo.chen@huawei.com>
---
 drivers/tty/serial/ucc_uart.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/ucc_uart.c b/drivers/tty/serial/ucc_uart.c
index 7355303..f86f447 100644
--- a/drivers/tty/serial/ucc_uart.c
+++ b/drivers/tty/serial/ucc_uart.c
@@ -1518,9 +1518,11 @@ static int __init ucc_uart_init(void)
 	}

 	ret = platform_driver_register(&ucc_uart_of_driver);
-	if (ret)
+	if (ret) {
 		printk(KERN_ERR
 		       "ucc-uart: could not register platform driver\n");
+		uart_unregister_driver(&ucc_uart_driver);
+	}

 	return ret;
 }
-- 
1.7.1


