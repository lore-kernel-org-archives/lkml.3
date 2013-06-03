Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852Ab3FCWrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:47:12 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:60044
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759402Ab3FCWqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:46:24 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 4/5] Drivers: scsi: storvsc: Support FC devices
Date: Mon,  3 Jun 2013 16:21:27 -0700
Message-Id: <1370301688-27286-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1370301688-27286-1-git-send-email-kys@microsoft.com>
References: <1370301519-27196-1-git-send-email-kys@microsoft.com>
 <1370301688-27286-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for synthetic Fiber Channel devices.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index c89acf5..a728179 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1704,6 +1704,7 @@ static struct scsi_host_template scsi_driver = {
 enum {
 	SCSI_GUID,
 	IDE_GUID,
+	SFC_GUID,
 };
 
 static const struct hv_vmbus_device_id id_table[] = {
@@ -1715,6 +1716,11 @@ static const struct hv_vmbus_device_id id_table[] = {
 	{ HV_IDE_GUID,
 	  .driver_data = IDE_GUID
 	},
+	/* Fibre Channel GUID */
+	{
+	  HV_SYNTHFC_GUID,
+	  .driver_data = SFC_GUID
+	},
 	{ },
 };
 
-- 
1.7.4.1

