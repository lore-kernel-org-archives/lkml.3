Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894AbaFQNaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 09:30:13 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54739 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066AbaFQNaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 09:30:12 -0400
Message-ID: <53A0430D.8000006@gmail.com>
Date: Tue, 17 Jun 2014 15:30:53 +0200
From: Wladislav Wiebe <wladislav.kw@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org, paulus@samba.org,
        scottwood@freescale.com, mikey@neuling.org, mahesh@linux.vnet.ibm.com,
        michael@ellerman.id.au, anton@samba.org, r65777@freescale.com,
        haokexin@gmail.com
CC: linux-kernel@vger.kernel.org, wladislav.kw@gmail.com
Subject: [PATCH 1/1] powerpc/traps/e500: fix misleading error output
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In machine_check_e500 exception handler is a wrong indication
in case of MCSR_BUS_WBERR - so print "Write" instead of "Read".

Signed-off-by: Wladislav Wiebe <wladislav.kw@gmail.com>
---
 arch/powerpc/kernel/traps.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 239f1cd..cb9cfe4 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -609,7 +609,7 @@ int machine_check_e500(struct pt_regs *regs)
 	if (reason & MCSR_BUS_RBERR)
 		printk("Bus - Read Data Bus Error\n");
 	if (reason & MCSR_BUS_WBERR)
-		printk("Bus - Read Data Bus Error\n");
+		printk("Bus - Write Data Bus Error\n");
 	if (reason & MCSR_BUS_IPERR)
 		printk("Bus - Instruction Parity Error\n");
 	if (reason & MCSR_BUS_RPERR)
-- 
1.7.1
