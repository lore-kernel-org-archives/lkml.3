Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaCWPJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 11:09:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:58021 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaCWPJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 11:09:19 -0400
Message-Id: <20140323150753.665598815@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Mar 2014 15:09:29 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <kmo@daterainc.com>
Subject: [patch 10/16] block: umem: Use del_timer_sync() in exit path
References: <20140323150557.288925975@linutronix.de>
Content-Disposition: inline; filename=block-umem-use-del_timer_sync.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure no callback is running before removing the module.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kent Overstreet <kmo@daterainc.com>
---
 drivers/block/umem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/drivers/block/umem.c
===================================================================
--- tip.orig/drivers/block/umem.c
+++ tip/drivers/block/umem.c
@@ -746,7 +746,7 @@ static void init_battery_timer(void)
 
 static void del_battery_timer(void)
 {
-	del_timer(&battery_timer);
+	del_timer_sync(&battery_timer);
 }
 
 /*


