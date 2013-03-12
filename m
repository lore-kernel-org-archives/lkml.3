Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab3CLW5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:57:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab3CLWoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:44:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Oliver Neukum <oliver@neukum.org>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 04/40] SCSI: dc395x: uninitialized variable in device_alloc()
Date: Tue, 12 Mar 2013 15:43:25 -0700
Message-Id: <20130312223211.959015821@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223211.492954675@linuxfoundation.org>
References: <20130312223211.492954675@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 208afec4f3be8c51ad6eebe6611dd6d2ad2fa298 upstream.

This bug was introduced back in bitkeeper days in 2003.  We use
"dcb->dev_mode" before it has been initialized.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


