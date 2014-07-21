Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaGUWEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:04:53 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:60225
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaGUWEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:04:52 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com, apw@canonical.com,
        jasowang@redhat.com, jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Date: Mon, 21 Jul 2014 16:06:01 -0700
Message-Id: <1405983961-18782-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add blist flags to permit the reading of the VPD pages even when
the target may claim SPC-2 compliance. MSFT targets currently
claim SPC-2 compliance while they implement post SPC-2 features.
With this patch we can correctly handle WRITE_SAME_16 issues.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 29d0329..15ba695 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -327,6 +327,8 @@ MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
  */
 static int storvsc_timeout = 180;
 
+static int msft_blist_flags = BLIST_TRY_VPD_PAGES;
+
 #define STORVSC_MAX_IO_REQUESTS				200
 
 static void storvsc_on_channel_callback(void *context);
@@ -1449,6 +1451,14 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 
 	sdevice->no_write_same = 1;
 
+	/*
+	 * Add blist flags to permit the reading of the VPD pages even when
+	 * the target may claim SPC-2 compliance. MSFT targets currently
+	 * claim SPC-2 compliance while they implement post SPC-2 features.
+	 * With this patch we can correctly handle WRITE_SAME_16 issues.
+	 */
+	sdevice->sdev_bflags |= msft_blist_flags;
+
 	return 0;
 }
 
-- 
1.7.4.1

