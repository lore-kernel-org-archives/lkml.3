Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaG0PJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 11:09:56 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62934 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbaG0PJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 11:09:54 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Adam Radford <linuxraid@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: 3w-9xxx.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 27 Jul 2014 17:11:18 +0200
Message-Id: <1406473878-12715-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
And use the sizeof on the to string rather than strlen on the from string.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/3w-9xxx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 0a73253..f4d2331 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -621,7 +621,8 @@ static int twa_check_srl(TW_Device_Extension *tw_dev, int *flashed)
 	}
 
 	/* Load rest of compatibility struct */
-	strncpy(tw_dev->tw_compat_info.driver_version, TW_DRIVER_VERSION, strlen(TW_DRIVER_VERSION));
+	strlcpy(tw_dev->tw_compat_info.driver_version, TW_DRIVER_VERSION,
+		sizeof(tw_dev->tw_compat_info.driver_version));
 	tw_dev->tw_compat_info.driver_srl_high = TW_CURRENT_DRIVER_SRL;
 	tw_dev->tw_compat_info.driver_branch_high = TW_CURRENT_DRIVER_BRANCH;
 	tw_dev->tw_compat_info.driver_build_high = TW_CURRENT_DRIVER_BUILD;
-- 
1.7.10.4

