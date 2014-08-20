Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaHTDYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 23:24:17 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:35224 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaHTDYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 23:24:16 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Grant Likely <grant.likely@linaro.org>,
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] powerpc: Export dcr_ind_lock to fix build error
Date: Tue, 19 Aug 2014 23:24:15 -0400
Message-Id: <1408505056-24248-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build error caused by missing export:

ERROR: "dcr_ind_lock" [drivers/net/ethernet/ibm/emac/ibm_emac.ko] undefined!

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/powerpc/sysdev/dcr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/sysdev/dcr.c b/arch/powerpc/sysdev/dcr.c
index e9056e4..2d8a101 100644
--- a/arch/powerpc/sysdev/dcr.c
+++ b/arch/powerpc/sysdev/dcr.c
@@ -230,5 +230,6 @@ EXPORT_SYMBOL_GPL(dcr_unmap_mmio);
 
 #ifdef CONFIG_PPC_DCR_NATIVE
 DEFINE_SPINLOCK(dcr_ind_lock);
+EXPORT_SYMBOL_GPL(dcr_ind_lock);
 #endif	/* defined(CONFIG_PPC_DCR_NATIVE) */
 
-- 
1.9.1

