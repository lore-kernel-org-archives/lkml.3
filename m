Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab3FMPms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:42:48 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:34161 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab3FMPmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:42:47 -0400
Date: Thu, 13 Jun 2013 17:42:31 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] RAPIDIO: Fix idt_gen2.c build
Message-ID: <20130613154231.GA27745@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idt_gen2.c relies that one of the header files used will include
<asm/page.h> which will define the required symbol PAGE_SIZE.  On MIPS
for example <asm/page.h> will not be included implicitly which will
result in the following build error:

  CC      drivers/rapidio/switches/idt_gen2.o
drivers/rapidio/switches/idt_gen2.c: In function ‘idtg2_show_errlog’:
drivers/rapidio/switches/idt_gen2.c:379:30: error: ‘PAGE_SIZE’ undeclared (first use in this function)
drivers/rapidio/switches/idt_gen2.c:379:30: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---

If you're ok with this patch I can put it into my next pull request for
Linux.  Thanks!


 drivers/rapidio/switches/idt_gen2.c | 2 ++
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
