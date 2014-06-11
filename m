Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaFKSyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:54:22 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:46498 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754122AbaFKSyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:54:20 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugHAOakmFNbslCP/2dsb2JhbABagw2rdAUBAQEBAQEFAZkbgQgXdYQxLyOBGjeIRgHQFBeFXIgZZB2EKwSaLosqiCGBfIFCO4Ew
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 1/1] drivers/xen/events/events_base.c:  remove unnecessary test on unsigned value
Date: Wed, 11 Jun 2014 20:53:02 +0200
Message-Id: <1402512782-17072-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned value is never < 0

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
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
1.8.4.5

