Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbaBRWrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:47:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbaBRWrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nitin A Kamble <nitin.a.kamble@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.13 32/40] genirq: Generic irq chip requires IRQ_DOMAIN
Date: Tue, 18 Feb 2014 14:47:33 -0800
Message-Id: <20140218224434.239745347@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224433.337299968@linuxfoundation.org>
References: <20140218224433.337299968@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -40,6 +40,7 @@ config IRQ_EDGE_EOI_HANDLER
 # Generic configurable interrupt chip implementation
 config GENERIC_IRQ_CHIP
        bool
+       select IRQ_DOMAIN
 
 # Generic irq_domain hw <--> linux irq number translation
 config IRQ_DOMAIN


