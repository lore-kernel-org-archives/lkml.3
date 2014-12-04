Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaLDLZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:25:48 -0500
Received: from sci-ig2.spreadtrum.com ([222.66.158.135]:11080 "EHLO
	SHSQR01.spreadtrum.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753500AbaLDLZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:25:46 -0500
From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
To: <zhang.lyra@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm64/include/asm: Fixed a warning about 'struct pt_regs'
Date: Thu, 4 Dec 2014 19:24:24 +0800
Message-ID: <1417692264-18553-1-git-send-email-chunyan.zhang@spreadtrum.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.0.67.89]
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 SHMBX01.spreadtrum.com (10.0.1.203)
X-MAIL: SHSQR01.spreadtrum.com sB4BOTGv094919
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I include asm/irq.h on the top of my code, and set ARCH=arm64,
I'll get a compile warning, details are below:
warning: ‘struct pt_regs’
declared inside parameter list [enabled by default]

This patch is suggested by Arnd, see:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/308270.html

Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
---
 arch/arm64/include/asm/irq.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/irq.h b/arch/arm64/include/asm/irq.h
index e1f7ecd..acedc7e 100644
--- a/arch/arm64/include/asm/irq.h
+++ b/arch/arm64/include/asm/irq.h
@@ -3,6 +3,8 @@
 
 #include <asm-generic/irq.h>
 
+struct pt_regs;
+
 extern void (*handle_arch_irq)(struct pt_regs *);
 extern void migrate_irqs(void);
 extern void set_handle_irq(void (*handle_irq)(struct pt_regs *));
-- 
1.7.9.5

