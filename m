Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457Ab3EWPUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:20:55 -0400
Received: from smtp16.protectedservice.net ([217.154.106.151]:41346 "EHLO
	smtp16.protectedservice.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758652Ab3EWPUy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:20:54 -0400
X-Greylist: delayed 1160 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 May 2013 11:20:54 EDT
Date: Thu, 23 May 2013 16:01:24 +0100 (BST)
From: =?utf-8?Q?J=C3=A9r=C3=B4me_Arzel?= <jerome.arzel@gnuside.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <1161491426.132128.1369321284187.JavaMail.root@gnuside.com>
In-Reply-To: <731282360.131628.1369320249704.JavaMail.root@gnuside.com>
Subject: [PATCH] powerpc: wrong error message for e500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Mailer: Zimbra 7.2.3_GA_2872 (ZimbraWebClient - GC26 (Linux)/7.2.3_GA_2872)
X-Authenticated-Sender: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is a bus error while machine check for e500,
the MCSR_BUS_WBERR error type prints a read error message
instead of a write error.

Signed-off-by: Jérôme Arzel <jerome.arzel@gnuside.com>
---
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -589,7 +589,7 @@ int machine_check_e500(struct pt_regs *r
 	if (reason & MCSR_BUS_RBERR)
 		printk("Bus - Read Data Bus Error\n");
 	if (reason & MCSR_BUS_WBERR)
-		printk("Bus - Read Data Bus Error\n");
+		printk("Bus - Write Bus Error\n");
 	if (reason & MCSR_BUS_IPERR)
 		printk("Bus - Instruction Parity Error\n");
 	if (reason & MCSR_BUS_RPERR)

