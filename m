Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab3IMM65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:58:57 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:39356 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab3IMM6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:58:42 -0400
From: Andy Whitcroft <apw@canonical.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc: Andy Whitcroft <apw@canonical.com>, Ben Howard <ben.howard@canonical.com>,
        linux-scsi@vger.kernel.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] scsi: hyper-v storage -- mark as preferring READ CAPACITY (16) at SPC-2
Date: Fri, 13 Sep 2013 13:58:29 +0100
Message-Id: <1379077109-29606-5-git-send-email-apw@canonical.com>
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
index 14ba8fd..25e7dd5 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1438,6 +1438,7 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 
 	sdevice->no_write_same = 1;
 	sdevice->use_vpd_spc2 = 1;
+	sdevice->try_rc_16_first = 1;
 
 	return 0;
 }
-- 
1.8.1.2

