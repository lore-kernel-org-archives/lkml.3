Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab3IMM7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:59:24 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46375 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab3IMM6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:58:40 -0400
From: Andy Whitcroft <apw@canonical.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc: Andy Whitcroft <apw@canonical.com>, Ben Howard <ben.howard@canonical.com>,
        linux-scsi@vger.kernel.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] scsi: hyper-v storage -- mark as VPD capable at SPC-2
Date: Fri, 13 Sep 2013 13:58:28 +0100
Message-Id: <1379077109-29606-4-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379077109-29606-1-git-send-email-apw@canonical.com>
References: <1379077109-29606-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/1223499
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/scsi/storvsc_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 1a28f56..14ba8fd 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1437,6 +1437,7 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 	blk_queue_rq_timeout(sdevice->request_queue, (storvsc_timeout * HZ));
 
 	sdevice->no_write_same = 1;
+	sdevice->use_vpd_spc2 = 1;
 
 	return 0;
 }
-- 
1.8.1.2

