Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbaC0TmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 15:42:15 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:35642 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbaC0TmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 15:42:09 -0400
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Rob Herring <robh@kernel.org>
Subject: [RFC PATCH 1/4] irqchip: align irqchip OF match table section naming
Date: Thu, 27 Mar 2014 14:41:54 -0500
Message-Id: <1395949317-8738-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395949317-8738-1-git-send-email-robherring2@gmail.com>
References: <1395949317-8738-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Make the irqchip OF match table section naming aligned with other
OF match table sections in preparation to have a common definition.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/irqchip/irqchip.c         | 6 +++---
 include/asm-generic/vmlinux.lds.h | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irqchip.c b/drivers/irqchip/irqchip.c
index cad3e24..0fe2f71 100644
--- a/drivers/irqchip/irqchip.c
+++ b/drivers/irqchip/irqchip.c
@@ -19,11 +19,11 @@
  * special section.
  */
 static const struct of_device_id
-irqchip_of_match_end __used __section(__irqchip_of_end);
+irqchip_of_match_end __used __section(__irqchip_of_table_end);
 
-extern struct of_device_id __irqchip_begin[];
+extern struct of_device_id __irqchip_of_table[];
 
 void __init irqchip_init(void)
 {
-	of_irq_init(__irqchip_begin);
+	of_irq_init(__irqchip_of_table);
 }
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f7bf870..f8d1783 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -151,9 +151,9 @@
 #ifdef CONFIG_IRQCHIP
 #define IRQCHIP_OF_MATCH_TABLE()					\
 	. = ALIGN(8);							\
-	VMLINUX_SYMBOL(__irqchip_begin) = .;				\
+	VMLINUX_SYMBOL(__irqchip_of_table) = .;				\
 	*(__irqchip_of_table)		  				\
-	*(__irqchip_of_end)
+	*(__irqchip_of_table_end)
 #else
 #define IRQCHIP_OF_MATCH_TABLE()
 #endif
-- 
1.8.3.2

