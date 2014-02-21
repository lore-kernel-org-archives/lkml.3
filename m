Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbaBUNxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:53:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46812 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbaBUMto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nitin A Kamble <nitin.a.kamble@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 025/121] genirq: Generic irq chip requires IRQ_DOMAIN
Date: Fri, 21 Feb 2014 12:47:29 +0000
Message-Id: <1392986945-9693-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitin A Kamble <nitin.a.kamble@intel.com>

commit 923fa4ea382f592dee2ba3b205befb90cbddf3af upstream.

The generic_chip.c uses interfaces from irq_domain.c which is
controlled by the IRQ_DOMAIN config option, but there is no Kconfig
dependency so the build can fail:

linux/kernel/irq/generic-chip.c:400:11: error:
'irq_domain_xlate_onetwocell' undeclared here (not in a function)

Select IRQ_DOMAIN when GENERIC_IRQ_CHIP is selected.

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Link: http://lkml.kernel.org/r/1391129410-54548-2-git-send-email-nitin.a.kamble@intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/irq/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index d1a758b..baceec2 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -51,6 +51,7 @@ config IRQ_EDGE_EOI_HANDLER
 # Generic configurable interrupt chip implementation
 config GENERIC_IRQ_CHIP
        bool
+       select IRQ_DOMAIN
 
 # Generic irq_domain hw <--> linux irq number translation
 config IRQ_DOMAIN
-- 
1.9.0

