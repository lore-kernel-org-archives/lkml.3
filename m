Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab3KGHtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 02:49:39 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38238 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab3KGHta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 02:49:30 -0500
Date: Thu, 7 Nov 2013 10:49:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Suman Anna <s-anna@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mailbox/omap: make mbox->irq signed for error handling
Message-ID: <20131107074918.GG21844@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bug in omap2_mbox_probe() where we try do:

		mbox->irq = platform_get_irq(pdev, info->irq_id);
		if (mbox->irq < 0) {

The problem is that mbox->irq is unsigned so the error handling doesn't
work.  I've changed it to a signed integer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/mailbox/omap-mbox.h b/drivers/mailbox/omap-mbox.h
index 6cd38fc..86d7518 100644
--- a/drivers/mailbox/omap-mbox.h
+++ b/drivers/mailbox/omap-mbox.h
@@ -52,7 +52,7 @@ struct omap_mbox_queue {
 
 struct omap_mbox {
 	const char		*name;
-	unsigned int		irq;
+	int			irq;
 	struct omap_mbox_queue	*txq, *rxq;
 	struct omap_mbox_ops	*ops;
 	struct device		*dev;
