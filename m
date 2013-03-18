Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab3CREay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:30:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33383 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312Ab3CREaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:02 -0400
Message-Id: <20130318042144.956545927@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:21:51 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Oliver Neukum <oliver@neukum.org>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 07/82] [SCSI] dc395x: uninitialized variable in device_alloc()
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 208afec4f3be8c51ad6eebe6611dd6d2ad2fa298 upstream.

This bug was introduced back in bitkeeper days in 2003.  We use
"dcb->dev_mode" before it has been initialized.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/dc395x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3747,13 +3747,13 @@ static struct DeviceCtlBlk *device_alloc
 	dcb->max_command = 1;
 	dcb->target_id = target;
 	dcb->target_lun = lun;
+	dcb->dev_mode = eeprom->target[target].cfg0;
 #ifndef DC395x_NO_DISCONNECT
 	dcb->identify_msg =
 	    IDENTIFY(dcb->dev_mode & NTC_DO_DISCONNECT, lun);
 #else
 	dcb->identify_msg = IDENTIFY(0, lun);
 #endif
-	dcb->dev_mode = eeprom->target[target].cfg0;
 	dcb->inquiry7 = 0;
 	dcb->sync_mode = 0;
 	dcb->min_nego_period = clock_period[period_index];


