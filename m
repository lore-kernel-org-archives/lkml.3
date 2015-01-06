Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbbAFL1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:27:13 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:43270 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbbAFL1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:27:10 -0500
From: esben.haabendal@gmail.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Esben Haabendal <eha@deif.com>
Subject: [PATCH 1/3] powerpc: ipic: Fix mcp status helper functions
Date: Tue,  6 Jan 2015 12:26:58 +0100
Message-Id: <1420543620-20658-1-git-send-email-esben.haabendal@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Esben Haabendal <eha@deif.com>

Read and write the SERSR (System Error Status Register) instead of the
SERMR (System Error Mask Register), to actually get and clear the status
bits.

Signed-off-by: Esben Haabendal <eha@deif.com>
---
 arch/powerpc/sysdev/ipic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/sysdev/ipic.c b/arch/powerpc/sysdev/ipic.c
index b287337..2e41a73 100644
--- a/arch/powerpc/sysdev/ipic.c
+++ b/arch/powerpc/sysdev/ipic.c
@@ -843,12 +843,12 @@ void ipic_disable_mcp(enum ipic_mcp_irq mcp_irq)
 
 u32 ipic_get_mcp_status(void)
 {
-	return ipic_read(primary_ipic->regs, IPIC_SERMR);
+	return ipic_read(primary_ipic->regs, IPIC_SERSR);
 }
 
 void ipic_clear_mcp_status(u32 mask)
 {
-	ipic_write(primary_ipic->regs, IPIC_SERMR, mask);
+	ipic_write(primary_ipic->regs, IPIC_SERSR, mask);
 }
 
 /* Return an interrupt vector or NO_IRQ if no interrupt is pending. */
-- 
2.1.4

