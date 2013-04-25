Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab3DYRcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:32:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57868 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696Ab3DYR3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 12/21] irqchip: s3c24xx: add missing __init annotations
Date: Thu, 25 Apr 2013 19:28:55 +0200
Message-Id: <1366910944-3033663-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:KjPpaWU5+cxUAuENPT5N9Y4pLOkJemeTRxoudtqhfd7
 dmZ9TEgsaylbni+rW4HN7M2wxzbZfU9OSMnPNLKn9LhfGKjFkd
 QfMHpAy5MjSH7UiJLTdR9Z9Z3ROg39AgNdnsTdQE+A87QGkv56
 fLEpmcbUdKhSCMUf9ljNjHdoTuE9RMv0XaghVm1gq2aBpAbZH5
 CtLIUv/cI3I5Kui3Zf5Ni1j2tQEAZAyaXFvz1UffA5tWpQcgnT
 e4N1ht/eoiVzMq5iEDhzQbx7ybP2JNYUiE0qepf+4yPW8zdnA7
 nUbDaSBETdcrFOWiXPF4zGNuTWQpa+uu7Ali04fd3FKeqNbynH
 Ne/mB6CjOXlxsOKPrcfi9n1RuZs3FN+/zGyukFVqA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The s3c24xx_init_intc and s3c2412_init_irq functions are only called
at init time, and they call functions already marked __init, so they
should be marked in the same way. This was reported as

WARNING: vmlinux.o(.text+0x19e0b4): Section mismatch in reference from the function s3c2412_init_irq() to the function .init.text:s3c24xx_init_intc.constprop.8()
The function s3c2412_init_irq() references
the function __init s3c24xx_init_intc.constprop.8().
This is often because s3c2412_init_irq lacks a __init
annotation or the annotation of s3c24xx_init_intc.constprop.8 is wrong.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 drivers/irqchip/irq-s3c24xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-s3c24xx.c b/drivers/irqchip/irq-s3c24xx.c
index c8afd7b..bbcc944 100644
--- a/drivers/irqchip/irq-s3c24xx.c
+++ b/drivers/irqchip/irq-s3c24xx.c
@@ -535,7 +535,7 @@ static void s3c24xx_clear_intc(struct s3c_irq_intc *intc)
 	}
 }
 
-static struct s3c_irq_intc *s3c24xx_init_intc(struct device_node *np,
+static struct s3c_irq_intc * __init s3c24xx_init_intc(struct device_node *np,
 				       struct s3c_irq_data *irq_data,
 				       struct s3c_irq_intc *parent,
 				       unsigned long address)
@@ -795,7 +795,7 @@ static struct s3c_irq_data init_s3c2412subint[32] = {
 	{ .type = S3C_IRQTYPE_LEVEL, .parent_irq = 21 }, /* CF */
 };
 
-void s3c2412_init_irq(void)
+void __init s3c2412_init_irq(void)
 {
 	pr_info("S3C2412: IRQ Support\n");
 
-- 
1.8.1.2

