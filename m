Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab3DYRbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:31:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51379 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766Ab3DYR3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Simon Horman <horms+renesas@verge.net.au>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Magnus Damm <damm@opensource.se>
Subject: [PATCH 11/21] irqdomain: export irq_domain_add_simple
Date: Thu, 25 Apr 2013 19:28:54 +0200
Message-Id: <1366910944-3033663-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:gXxxLlxKqeb+GSgCerZ1huBN2aeEpcCSWcMUHPZ8agi
 P0re8fT5Um8GRAu0J/bf9BIxg6wcQzIxeAlbG671sy3b5W6XBz
 VCelyu3fjJEtdO1UflmU+uqZ2mlAek4QdEMUbHS1D2F6kOg9w1
 AWMYGopdExmCxHIc3K6Ou+yQk8lhNTZkGDP9XmC9X/Ku8NgRv1
 epLVkRchxFTRkZSMjYwtkJ9L4XEA4n9hbNMSrLeOWecWrwTgCR
 R898LrRJWVNZQReLiDnvyXjQ+24kftTTTtjBE+Se1qhK7wU+tW
 wAqfLKKYpCCa3IEuOX7nexmnZHWRgEufvv4cNBcsbRhOnwvn5n
 Uk11Lf7S+MVzeTKDE+mEOGSh4o46tdN8vowQ02q+7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All other irq_domain_add_* functions are exported already, and apparently
this one got left out by mistake, which causes build errors for ARM
allmodconfig kernels:

ERROR: "irq_domain_add_simple" [drivers/gpio/gpio-rcar.ko] undefined!
ERROR: "irq_domain_add_simple" [drivers/gpio/gpio-em.ko] undefined!

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Simon Horman <horms+renesas@verge.net.au>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Magnus Damm <damm@opensource.se>
---
 kernel/irq/irqdomain.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 059a280..c532c15 100644
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

