Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031Ab3GZUtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:49:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759926Ab3GZUss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>
Subject: [ 44/79] RAPIDIO: IDT_GEN2: Fix build error.
Date: Fri, 26 Jul 2013 13:47:34 -0700
Message-Id: <20130726204727.096571298@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Baechle <ralf@linux-mips.org>

commit 27f62b9f294b7e2019c94c385abda43a0af6bb8b upstream.

  CC      drivers/rapidio/switches/idt_gen2.o
drivers/rapidio/switches/idt_gen2.c: In function ‘idtg2_show_errlog’:
drivers/rapidio/switches/idt_gen2.c:379:30: error: ‘PAGE_SIZE’ undeclared (first use in this function)
drivers/rapidio/switches/idt_gen2.c:379:30: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rapidio/switches/idt_gen2.c |    2 ++
 1 file changed, 2 insertions(+)

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


