Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaDXCkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 22:40:39 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:37428 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751269AbaDXCki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 22:40:38 -0400
Date: Wed, 23 Apr 2014 22:40:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH] spi-bfin: Add missing gpio.h include
Message-ID: <20140423224035.1de64093@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running my ktest.pl tests on all the archs, I stumbled over this for
3.15-rc2:

drivers/spi/spi-bfin5xx.c: In function 'bfin_spi_cs_active':
drivers/spi/spi-bfin5xx.c:169:3: error: implicit declaration of function 'gpio_set_value' [-Werror=implicit-function-declaration]
drivers/spi/spi-bfin5xx.c: In function 'bfin_spi_setup':
drivers/spi/spi-bfin5xx.c:1097:4: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]
drivers/spi/spi-bfin5xx.c:1102:4: error: implicit declaration of function 'gpio_direction_output' [-Werror=implicit-function-declaration]
drivers/spi/spi-bfin5xx.c:1130:3: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]

The problem is that the spi-bfin5xx driver is missing an include for
the gpio.h file.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
diff --git a/drivers/spi/spi-bfin5xx.c b/drivers/spi/spi-bfin5xx.c
index 55e57c3..da8baa5 100644
--- a/drivers/spi/spi-bfin5xx.c
+++ b/drivers/spi/spi-bfin5xx.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
+#include <linux/gpio.h>
 #include <linux/irq.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
