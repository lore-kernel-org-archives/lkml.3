Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbaLDSFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:05:06 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:38167 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaLDSFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:05:04 -0500
Date: Thu, 4 Dec 2014 13:05:00 -0500
From: Tejun Heo <tj@kernel.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH libata/for-3.19] libata: Remove FIXME comment in
 atapi_request_sense()
Message-ID: <20141204180500.GA4080@htj.dyndns.org>
References: <1417558142-2901-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417558142-2901-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2ba520f0cd65c2e688f8beb495bb6634a61ee17b Mon Sep 17 00:00:00 2001
From: Nicholas Krause <xerofoify@gmail.com>
Date: Tue, 2 Dec 2014 17:09:02 -0500

Remove the FIXME comment in atapi_request_sense() asking whether
memset of sense buffer is necessary.  The buffer may be partially or
fully filled by the device.  We want it to be cleared.

tj: Updated description.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to libata/for-3.19 with updated description.

Thanks.

 drivers/ata/libata-scsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1db6eab..6a5fcf1 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2595,7 +2595,6 @@ static void atapi_request_sense(struct ata_queued_cmd *qc)
 
 	DPRINTK("ATAPI request sense\n");
 
-	/* FIXME: is this needed? */
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 
 #ifdef CONFIG_ATA_SFF
-- 
2.1.0

