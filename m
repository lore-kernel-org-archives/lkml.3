Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaF3DG6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 23:06:58 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:64114 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbaF3DG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 23:06:57 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: geert@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fixes q40_irq_startup to return -ENXIO
Date: Sun, 29 Jun 2014 23:06:50 -0400
Message-Id: <1404097610-5739-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes q40_irq_startup to return -ENXIO for cases 11-13 in the switch
statement of this function to handle these failure cases.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/m68k/q40/q40ints.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
index 513f9bb..9dfa1ea 100644
--- a/arch/m68k/q40/q40ints.c
+++ b/arch/m68k/q40/q40ints.c
@@ -49,7 +49,7 @@ static unsigned int q40_irq_startup(struct irq_data *data)
 	case 1: case 2: case 8: case 9:
 	case 11: case 12: case 13:
 		printk("%s: ISA IRQ %d not implemented by HW\n", __func__, irq);
-		/* FIXME return -ENXIO; */
+		return -ENXIO;
 	}
 	return 0;
 }
-- 
1.9.1

