Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbaE1QoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:44:13 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20864 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbaE1QoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:44:10 -0400
Date: Wed, 28 May 2014 19:43:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mei: me: remove unneeded condition
Message-ID: <20140528164354.GE1824@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We know that "err" is zero from the line before.  No need to check
again.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 6a2d272..86694093 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -274,8 +274,7 @@ static int mei_me_hw_ready_wait(struct mei_device *dev)
 			mei_secs_to_jiffies(MEI_HW_READY_TIMEOUT));
 	mutex_lock(&dev->device_lock);
 	if (!err && !dev->recvd_hw_ready) {
-		if (!err)
-			err = -ETIME;
+		err = -ETIME;
 		dev_err(&dev->pdev->dev,
 			"wait hw ready failed. status = %d\n", err);
 		return err;
