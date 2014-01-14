Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaANA1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:27:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbaANA0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:26:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH 3.10 01/62] irqchip: renesas-irqc: Fix irqc_probe error handling
Date: Mon, 13 Jan 2014 16:26:26 -0800
Message-Id: <20140114002710.508747601@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit dfaf820a13ec160f06556e08dab423818ba87f14 upstream.

The code in goto err3 path is wrong because it will call fee_irq() with k == 0,
which means it does free_irq(p->irq[-1].requested_irq, &p->irq[-1]);

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-renesas-irqc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/irqchip/irq-renesas-irqc.c
+++ b/drivers/irqchip/irq-renesas-irqc.c
@@ -248,8 +248,8 @@ static int irqc_probe(struct platform_de
 
 	return 0;
 err3:
-	for (; k >= 0; k--)
-		free_irq(p->irq[k - 1].requested_irq, &p->irq[k - 1]);
+	while (--k >= 0)
+		free_irq(p->irq[k].requested_irq, &p->irq[k]);
 
 	irq_domain_remove(p->irq_domain);
 err2:


