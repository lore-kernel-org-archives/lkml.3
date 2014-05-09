Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbaEIL7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:59:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17856 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbaEIL7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:59:44 -0400
Date: Fri, 9 May 2014 14:59:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>, Christophe Lucas <clucas@rotomalug.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] applicom: dereferencing NULL on error path
Message-ID: <20140509115916.GD32027@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a static checker fix.  The "dev" variable is always NULL after
the while statement so we would be dereferencing a NULL pointer here.

Fixes: 819a3eba4233 ('[PATCH] applicom: fix error handling')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 974321a..1479030 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -345,7 +345,6 @@ out:
 			free_irq(apbs[i].irq, &dummy);
 		iounmap(apbs[i].RamIO);
 	}
-	pci_disable_device(dev);
 	return ret;
 }
 
