Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbaKMKf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:35:59 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30432 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaKMKf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:35:57 -0500
Date: Thu, 13 Nov 2014 13:35:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 1/2 -next] mfd: dln2: add a limit check for invalid "echo"
Message-ID: <20141113103525.GA17038@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We check the other variables and traditionally we don't trust data from
USB devices so adding a check here is normal.  This silences a static
checker warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I am unsure if this fix is correct and I don't have the hardware.
Please review this one carefully.  The "goto out;" seems to use the
invalid data and I don't understand why.

diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
index 9765a17..3101e5e 100644
--- a/drivers/mfd/dln2.c
+++ b/drivers/mfd/dln2.c
@@ -280,6 +280,11 @@ static void dln2_rx(struct urb *urb)
 		goto out;
 	}
 
+	if (echo >= DLN2_MAX_RX_SLOTS) {
+		dev_warn(dev, "invalid echo %d\n", echo);
+		goto out;
+	}
+
 	data = urb->transfer_buffer + sizeof(struct dln2_header);
 	len = urb->actual_length - sizeof(struct dln2_header);
 
