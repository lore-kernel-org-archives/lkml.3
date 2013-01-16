Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3APP6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:58:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35657 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab3APP6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:58:07 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Beulich <jbeulich@suse.com>, Thomas Gleixner <tglx@linutronix.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 011/222] x86: hpet: Fix masking of MSI interrupts
Date: Wed, 16 Jan 2013 13:53:31 -0200
Message-Id: <1358351822-7675-12-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@suse.com>

commit 6acf5a8c931da9d26c8dd77d784daaf07fa2bff0 upstream.

HPET_TN_FSB is not a proper mask bit; it merely toggles between MSI and
legacy interrupt delivery. The proper mask bit is HPET_TN_ENABLE, so
use both bits when (un)masking the interrupt.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/5093E09002000078000A60E6@nat28.tlf.novell.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/kernel/hpet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 1460a5d..e28670f 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -434,7 +434,7 @@ void hpet_msi_unmask(struct irq_data *data)
 
 	/* unmask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
-	cfg |= HPET_TN_FSB;
+	cfg |= HPET_TN_ENABLE | HPET_TN_FSB;
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
@@ -445,7 +445,7 @@ void hpet_msi_mask(struct irq_data *data)
 
 	/* mask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
-	cfg &= ~HPET_TN_FSB;
+	cfg &= ~(HPET_TN_ENABLE | HPET_TN_FSB);
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
-- 
1.7.9.5

