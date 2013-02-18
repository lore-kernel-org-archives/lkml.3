Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab3BRUzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 15:55:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36037 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab3BRUzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 15:55:09 -0500
Date: Mon, 18 Feb 2013 12:53:52 -0800
From: tip-bot for Chris Metcalf <tipbot@zytor.com>
Message-ID: <tip-36a5df85e9a3c218b73f6cf80098016ca3f0410d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        cmetcalf@tilera.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cmetcalf@tilera.com, tglx@linutronix.de
In-Reply-To: <201302012043.r11KhNZF024371@farm-0021.internal.tilera.com>
References: <201302012043.r11KhNZF024371@farm-0021.internal.tilera.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Export enable/disable_percpu_irq()
Git-Commit-ID: 36a5df85e9a3c218b73f6cf80098016ca3f0410d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Feb 2013 12:53:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36a5df85e9a3c218b73f6cf80098016ca3f0410d
Gitweb:     http://git.kernel.org/tip/36a5df85e9a3c218b73f6cf80098016ca3f0410d
Author:     Chris Metcalf <cmetcalf@tilera.com>
AuthorDate: Fri, 1 Feb 2013 15:04:26 -0500
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 18 Feb 2013 21:42:25 +0100

genirq: Export enable/disable_percpu_irq()

These functions are used by the tilegx onchip network driver, and it's
useful to be able to load that driver as a module.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Link: http://lkml.kernel.org/r/201302012043.r11KhNZF024371@farm-0021.internal.tilera.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index e49a288..88e7bed 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1524,6 +1524,7 @@ void enable_percpu_irq(unsigned int irq, unsigned int type)
 out:
 	irq_put_desc_unlock(desc, flags);
 }
+EXPORT_SYMBOL_GPL(enable_percpu_irq);
 
 void disable_percpu_irq(unsigned int irq)
 {
@@ -1537,6 +1538,7 @@ void disable_percpu_irq(unsigned int irq)
 	irq_percpu_disable(desc, cpu);
 	irq_put_desc_unlock(desc, flags);
 }
+EXPORT_SYMBOL_GPL(disable_percpu_irq);
 
 /*
  * Internal function to unregister a percpu irqaction.
