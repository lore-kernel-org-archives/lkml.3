Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaKJUX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:23:26 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:13936 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827AbaKJUXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:23:12 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsNAMAdYVRXQ4qy/2dsb2JhbABcgw6BLbgoBQF0miwCgScXAQEBAQF9hAMBBScvIxBROR4ZiEUBvRyPfwEBAQEGIoY6ilsHFoQ1BZ4llmCDezwvgksBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Jens Axboe <axboe@kernel.dk>,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH v2 09/10 linux-next] cdrom: remove unnecessary status
Date: Mon, 10 Nov 2014 21:21:54 +0100
Message-Id: <1415650916-9975-10-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415650916-9975-1-git-send-email-fabf@skynet.be>
References: <1415650916-9975-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cdrom_number_of_slots returns nslots and doesn't need status
variable. Just remove it and test cdrom_read_mech_status().

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/cdrom/cdrom.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index d397591..9a6fa8f 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -1343,7 +1343,6 @@ out_free:
  */
 int cdrom_number_of_slots(struct cdrom_device_info *cdi) 
 {
-	int status;
 	int nslots = 1;
 	struct cdrom_changer_info *info;
 
@@ -1355,7 +1354,7 @@ int cdrom_number_of_slots(struct cdrom_device_info *cdi)
 	if (!info)
 		return -ENOMEM;
 
-	if ((status = cdrom_read_mech_status(cdi, info)) == 0)
+	if (!cdrom_read_mech_status(cdi, info))
 		nslots = info->hdr.nslots;
 
 	kfree(info);
-- 
1.9.1

