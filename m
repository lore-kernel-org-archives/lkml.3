Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab3CAUdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:33:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36427 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3CAUdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 15:33:10 -0500
Date: Fri, 1 Mar 2013 23:31:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] applicom: use correct array offset
Message-ID: <20130301203146.GC22066@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're iterating through abps[] printing information, but here we
use the wrong array index.  IndexCard comes from the user and in
this case it was specifically not range checked because we didn't
expect to use it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 25373df..974321a 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -804,8 +804,8 @@ static long ac_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 			printk(KERN_INFO "Prom version board %d ....... V%d.%d %s",
 			       i+1,
-			       (int)(readb(apbs[IndexCard].RamIO + VERS) >> 4),
-			       (int)(readb(apbs[IndexCard].RamIO + VERS) & 0xF),
+			       (int)(readb(apbs[i].RamIO + VERS) >> 4),
+			       (int)(readb(apbs[i].RamIO + VERS) & 0xF),
 			       boardname);
 
 
