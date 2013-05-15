Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3EOV3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:29:55 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:56393
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab3EOV2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:28:43 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 6/6] Drivers: scsi: storvsc: Support FC devices
Date: Wed, 15 May 2013 15:02:34 -0700
Message-Id: <1368655354-27651-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1368655354-27651-1-git-send-email-kys@microsoft.com>
References: <1368655320-27599-1-git-send-email-kys@microsoft.com>
 <1368655354-27651-1-git-send-email-kys@microsoft.com>
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
index bed8d23..14bc922 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1698,6 +1698,7 @@ static struct scsi_host_template scsi_driver = {
 enum {
 	SCSI_GUID,
 	IDE_GUID,
+	SFC_GUID,
 };
 
 static const struct hv_vmbus_device_id id_table[] = {
@@ -1709,6 +1710,11 @@ static const struct hv_vmbus_device_id id_table[] = {
 	{ HV_IDE_GUID,
 	  .driver_data = IDE_GUID
 	},
+	/* Fiber Channel GUID */
+	{
+	  HV_SYNTHFC_GUID,
+	  .driver_data = SFC_GUID
+	},
 	{ },
 };
 
-- 
1.7.4.1

