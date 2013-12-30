Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab3L3UPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 15:15:00 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37503 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3L3UOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 15:14:22 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-edac@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 2/6] genirq: export percpu irq functions for module usage
Date: Mon, 30 Dec 2013 12:14:13 -0800
Message-Id: <1388434457-4194-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org>
References: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future we're going to use these percpu irq functions
in the Krait CPU EDAC driver. Export them so that the EDAC driver
can be compiled as a module.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 kernel/irq/manage.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 481a13c..facb34f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1623,6 +1623,7 @@ void free_percpu_irq(unsigned int irq, void __percpu *dev_id)
 	kfree(__free_percpu_irq(irq, dev_id));
 	chip_bus_sync_unlock(desc);
 }
+EXPORT_SYMBOL_GPL(free_percpu_irq);
 
 /**
  *	setup_percpu_irq - setup a per-cpu interrupt
@@ -1693,3 +1694,4 @@ int request_percpu_irq(unsigned int irq, irq_handler_t handler,
 
 	return retval;
 }
+EXPORT_SYMBOL_GPL(request_percpu_irq);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

