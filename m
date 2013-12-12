Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab3LLOXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:23:50 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:40432 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3LLOXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:23:48 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] genirq: Depend on IRQ_DOMAIN
Date: Thu, 12 Dec 2013 15:22:32 +0100
Message-Id: <1386858152-1048-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 088f40b7b027 (genirq: Generic chip: Add linear irq domain
support) makes reference to the irq_domain_xlate_onetwocell() function
which is only available when IRQ domain support is enabled.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 kernel/irq/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 4a1fef09f658..07cbdfea9ae2 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -40,6 +40,7 @@ config IRQ_EDGE_EOI_HANDLER
 # Generic configurable interrupt chip implementation
 config GENERIC_IRQ_CHIP
        bool
+       select IRQ_DOMAIN
 
 # Generic irq_domain hw <--> linux irq number translation
 config IRQ_DOMAIN
-- 
1.8.4.2

