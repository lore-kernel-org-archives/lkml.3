Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaAMImJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:42:09 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18759 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaAMImI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:42:08 -0500
Date: Mon, 13 Jan 2014 11:41:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Florian Fainelli <florian@openwrt.org>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia@diku.dk>
Subject: [patch -resend] vlynq: fix another resource size off by 1 error
Message-ID: <20140113084147.GA7499@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2337301.FMvHPCUCYL@lenovo>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We fixed the call to request_mem_region() patch
3354f73 ('drivers/vlynq/vlynq.c: fix resource size off by 1 error').
But we need to fix the call the release_mem_region() as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Resending (again) with Andrew's email corrected.

Hi, Andrew, Florian says this has to go through your tree.  I assume
that means he has Acked it.  :)

diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
index 7b07135..c0227f9 100644
--- a/drivers/vlynq/vlynq.c
+++ b/drivers/vlynq/vlynq.c
@@ -762,7 +762,8 @@ static int vlynq_remove(struct platform_device *pdev)
 
 	device_unregister(&dev->dev);
 	iounmap(dev->local);
-	release_mem_region(dev->regs_start, dev->regs_end - dev->regs_start);
+	release_mem_region(dev->regs_start,
+			   dev->regs_end - dev->regs_start + 1);
 
 	kfree(dev);
 
--
To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
