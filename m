Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaJFPiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:38:04 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:18814 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753026AbaJFPgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:36:48 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvENAEC2MlRXQzrG/2dsb2JhbABfgw6BK7gQAQUBc5pnAoEDFwF7hAQBBScvIxBROR4ZiEIBsluONxiGIIlBZAcWhDUFnT6MUokug2U7L4EGgUQBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>, iss_storagedev@hp.com
Subject: [PATCH 4/7 linux-next] cpqarray: remove deprecated IRQF_DISABLED
Date: Mon,  6 Oct 2014 17:35:51 +0200
Message-Id: <1412609755-28627-5-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412609755-28627-1-git-send-email-fabf@skynet.be>
References: <1412609755-28627-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See include/linux/interrupt.h:
"This flag is a NOOP and scheduled to be removed"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/block/cpqarray.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 2b94403..370721e 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -406,7 +406,7 @@ static int cpqarray_register_ctlr(int i, struct pci_dev *pdev)
 	}
 	hba[i]->access.set_intr_mask(hba[i], 0);
 	if (request_irq(hba[i]->intr, do_ida_intr,
-		IRQF_DISABLED|IRQF_SHARED, hba[i]->devname, hba[i]))
+		IRQF_SHARED, hba[i]->devname, hba[i]))
 	{
 		printk(KERN_ERR "cpqarray: Unable to get irq %d for %s\n",
 				hba[i]->intr, hba[i]->devname);
-- 
1.9.3

