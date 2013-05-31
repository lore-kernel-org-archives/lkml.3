Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab3EaWZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:25:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50345 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757628Ab3EaWXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:23:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Magnus Damm <damm@opensource.se>
Subject: [PATCH 01/15] irqdomain: export irq_domain_add_simple
Date: Sat,  1 Jun 2013 00:22:38 +0200
Message-Id: <1370038972-2318779-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:E/poqzUDoHWbCqkaJmu9ovoKVH2U4R16KlL4jGLlKkn
 HuZ5FEMH7EdHbmjUk1r+i8D5inVs4qjPZ1jppbEG3fCf5ZLm+s
 N7JSxu4ax4jFty6GZ3bZmUJoCZAJ+N6B5TFhFiBoYEyh7SarY9
 Owx+JgBGa7TyWu6aoP/e/tj+vW20Jy6mR2VhDiX9UEdlINdcVm
 Kp8rl6JxzljyhKq5pZuXY/xKNo81DaZDOlUrTOefPYf1vuH9/k
 SgYmJpF96Ef742hoIs9mucIT05fMW+fP3GK9gMmQwcqaDUtG3a
 zNRziKGvdBAgRVCn8dQhwcNC+EijPy013iuCVG3iAnM7zKPGFV
 2Md/cR5aqXYq8xMptGP1YtUU3Uc6vJiIdtrFgAttm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All other irq_domain_add_* functions are exported already, and apparently
this one got left out by mistake, which causes build errors for ARM
allmodconfig kernels:

ERROR: "irq_domain_add_simple" [drivers/gpio/gpio-rcar.ko] undefined!
ERROR: "irq_domain_add_simple" [drivers/gpio/gpio-em.ko] undefined!

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Simon Horman <horms+renesas@verge.net.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Magnus Damm <damm@opensource.se>
---
 kernel/irq/irqdomain.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index af804b5..47d0564 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -194,6 +194,7 @@ struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
 	/* A linear domain is the default */
 	return irq_domain_add_linear(of_node, size, ops, host_data);
 }
+EXPORT_SYMBOL_GPL(irq_domain_add_simple);
 
 /**
  * irq_domain_add_legacy() - Allocate and register a legacy revmap irq_domain.
-- 
1.8.1.2

