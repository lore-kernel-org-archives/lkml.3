Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab3IKG5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 02:57:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3IKG4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 02:56:45 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=iJ6K2jAyqRgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=RmRcEZCvlD4A:10 a=WPyIoOwQAAAA:8 a=EvKqFsTwAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=1DbiqZag68YA:10 a=8k1GBl_MtaQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042902.650063524@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>
Subject: [061/251] RAPIDIO: IDT_GEN2: Fix build error.
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0061-RAPIDIO-IDT_GEN2-Fix-build-error.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ralf Baechle <ralf@linux-mips.org>

[ Upstream commit 27f62b9f294b7e2019c94c385abda43a0af6bb8b ]

  CC      drivers/rapidio/switches/idt_gen2.o
drivers/rapidio/switches/idt_gen2.c: In function ‘idtg2_show_errlog’:
drivers/rapidio/switches/idt_gen2.c:379:30: error: ‘PAGE_SIZE’ undeclared (first use in this function)
drivers/rapidio/switches/idt_gen2.c:379:30: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/rapidio/switches/idt_gen2.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rapidio/switches/idt_gen2.c b/drivers/rapidio/switches/idt_gen2.c
index 809b7a3..5d3b0f0 100644
--- a/drivers/rapidio/switches/idt_gen2.c
+++ b/drivers/rapidio/switches/idt_gen2.c
@@ -15,6 +15,8 @@
 #include <linux/rio_drv.h>
 #include <linux/rio_ids.h>
 #include <linux/delay.h>
+
+#include <asm/page.h>
 #include "../rio.h"
 
 #define LOCAL_RTE_CONF_DESTID_SEL	0x010070
-- 
1.7.10.4


