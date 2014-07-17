Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965765AbaGQQ0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:26:04 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:36769 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934026AbaGQQ0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:26:01 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Cc: wei.liu2@citrix.com, tglx@linutronix.de, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 1/4] drivers/xen/events/events_base.c: drop negativity check of unsigned parameter
Date: Thu, 17 Jul 2014 19:25:50 +0300
Message-Id: <1405614350-4453-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80531
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/xen/events/events_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index c919d3d..5b5c5ff 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -246,7 +246,7 @@ static void xen_irq_info_cleanup(struct irq_info *info)
  */
 unsigned int evtchn_from_irq(unsigned irq)
 {
-	if (unlikely(WARN(irq < 0 || irq >= nr_irqs, "Invalid irq %d!\n", irq)))
+	if (unlikely(WARN(irq >= nr_irqs, "Invalid irq %d!\n", irq)))
 		return 0;
 
 	return info_for_irq(irq)->evtchn;
-- 
1.8.5.5

