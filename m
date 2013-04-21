Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab3DULKg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 07:10:36 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28059 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab3DULKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 07:10:34 -0400
Date: Sun, 21 Apr 2013 14:10:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] gru: info leak in gru_get_config_info()
Message-ID: <20130421111031.GE6171@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "info.fill" array isn't initialized so it can leak uninitialized
stack information to user space.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index 44d273c..ed5fc43 100644
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -176,6 +176,7 @@ static long gru_get_config_info(unsigned long arg)
 	info.nodes = num_online_nodes();
 	info.blades = info.nodes / nodesperblade;
 	info.chiplets = GRU_CHIPLETS_PER_BLADE * info.blades;
+	memset(&info.fill, 0, sizeof(info.fill));
 
 	if (copy_to_user((void __user *)arg, &info, sizeof(info)))
 		return -EFAULT;
