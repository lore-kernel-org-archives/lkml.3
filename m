Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaBEJW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:22:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57363 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaBEJWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:22:25 -0500
Date: Wed, 5 Feb 2014 01:22:07 -0800
From: tip-bot for Nitin A Kamble <tipbot@zytor.com>
Message-ID: <tip-923fa4ea382f592dee2ba3b205befb90cbddf3af@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        nitin.a.kamble@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        nitin.a.kamble@intel.com, tglx@linutronix.de
In-Reply-To: <1391129410-54548-2-git-send-email-nitin.a.kamble@intel.com>
References: <1391129410-54548-2-git-send-email-nitin.a.kamble@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: Generic irq chip requires IRQ_DOMAIN
Git-Commit-ID: 923fa4ea382f592dee2ba3b205befb90cbddf3af
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 05 Feb 2014 01:22:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  923fa4ea382f592dee2ba3b205befb90cbddf3af
Gitweb:     http://git.kernel.org/tip/923fa4ea382f592dee2ba3b205befb90cbddf3af
Author:     Nitin A Kamble <nitin.a.kamble@intel.com>
AuthorDate: Thu, 30 Jan 2014 16:50:10 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 5 Feb 2014 10:17:32 +0100

genirq: Generic irq chip requires IRQ_DOMAIN

The generic_chip.c uses interfaces from irq_domain.c which is
controlled by the IRQ_DOMAIN config option, but there is no Kconfig
dependency so the build can fail:

linux/kernel/irq/generic-chip.c:400:11: error:
'irq_domain_xlate_onetwocell' undeclared here (not in a function)

Select IRQ_DOMAIN when GENERIC_IRQ_CHIP is selected.

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Link: http://lkml.kernel.org/r/1391129410-54548-2-git-send-email-nitin.a.kamble@intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org # 3.11+
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
