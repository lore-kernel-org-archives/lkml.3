Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161031Ab3FGXJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:09:43 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:48909 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab3FGXDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:51 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 16/31] mips/kvm: Add exception handler for MIPSVZ Guest exceptions.
Date: Fri,  7 Jun 2013 16:03:20 -0700
Message-Id: <1370646215-6543-17-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/kernel/genex.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/mips/kernel/genex.S b/arch/mips/kernel/genex.S
index 163e299..ce0be96 100644
--- a/arch/mips/kernel/genex.S
+++ b/arch/mips/kernel/genex.S
@@ -486,6 +486,9 @@ NESTED(nmi_handler, PT_SIZE, sp)
 	BUILD_HANDLER mcheck mcheck cli verbose		/* #24 */
 	BUILD_HANDLER mt mt sti silent			/* #25 */
 	BUILD_HANDLER dsp dsp sti silent		/* #26 */
+#ifdef CONFIG_KVM_MIPSVZ
+	BUILD_HANDLER hypervisor hypervisor cli silent	/* #27 */
+#endif
 	BUILD_HANDLER reserved reserved sti verbose	/* others */
 
 	.align	5
-- 
1.7.11.7

