Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaAaAwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 19:52:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:7938 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbaAaAwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 19:52:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,753,1384329600"; 
   d="scan'208";a="467565330"
From: nitin.a.kamble@intel.com
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        nitin.a.kamble@intel.com
Subject: [PATCH] irq: fix a Kconfig dependency
Date: Thu, 30 Jan 2014 16:50:10 -0800
Message-Id: <1391129410-54548-2-git-send-email-nitin.a.kamble@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1391129410-54548-1-git-send-email-nitin.a.kamble@intel.com>
References: <1391129410-54548-1-git-send-email-nitin.a.kamble@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

The generic_chip.c uses interfaces from irq_domain.c which is controlled by
the IRQ_DOMAIN config option.

Add a select statement in the Kconfig to reflect this requirement.

Without this fix, the generic_chip.c compilation fails like this:

linux/kernel/irq/generic-chip.c:400:11:
  error: 'irq_domain_xlate_onetwocell' undeclared here (not in a function)

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
---
 kernel/irq/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 4a1fef0..07cbdfe 100644
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
1.8.1.4

