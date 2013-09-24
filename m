Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750964Ab3IXHHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 03:07:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab3IXHHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 03:07:54 -0400
Date: Tue, 24 Sep 2013 15:05:57 +0800
From: Dong Zhu <bluezhudong@gmail.com>
To: Richard Cochran <richardcochran@gmail.com>,
        David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ptp: add range check on n_samples
Message-ID: <20130924070557.GA28795@zhudong.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d4eb97e8d5def76d46167c91059147e2c7d33433 Mon Sep 17 00:00:00 2001

When using PTP_SYS_OFFSET ioctl to measure the time offset between the
PHC and system clock, we need to specify the number of measurements, the
valid value of n_samples is between 1 to 25. If n_samples <= 0 or > 25
it makes no sense, so this patch intends to add a range check.

Signed-off-by: Dong Zhu <bluezhudong@gmail.com>
---
 drivers/ptp/ptp_chardev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 34a0c60..4e85b23 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -104,7 +104,8 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 			err = -EFAULT;
 			break;
 		}
-		if (sysoff->n_samples > PTP_MAX_SAMPLES) {
+		if (sysoff->n_samples <= 0 ||
+		    sysoff->n_samples > PTP_MAX_SAMPLES) {
 			err = -EINVAL;
 			break;
 		}
-- 
1.7.11.7

-- 
Best Regards,
Dong Zhu
