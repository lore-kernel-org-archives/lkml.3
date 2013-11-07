Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3KGHtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 02:49:09 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38079 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab3KGHs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 02:48:58 -0500
Date: Thu, 7 Nov 2013 10:48:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] net: make ndev->irq signed for error handling
Message-ID: <20131107074849.GF21844@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bug in cpsw_probe() where we do:

	ndev->irq = platform_get_irq(pdev, 0);
	if (ndev->irq < 0) {

The problem is that "ndev->irq" is unsigned so the error handling
doesn't work.  I have changed it to a regular int.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9da6a04..bb011f6 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1132,7 +1132,7 @@ struct net_device {
 	unsigned long		mem_end;	/* shared mem end	*/
 	unsigned long		mem_start;	/* shared mem start	*/
 	unsigned long		base_addr;	/* device I/O address	*/
-	unsigned int		irq;		/* device IRQ number	*/
+	int			irq;		/* device IRQ number	*/
 
 	/*
 	 *	Some hardware also needs these fields, but they are not
