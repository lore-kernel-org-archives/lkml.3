Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaKJUXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:23:41 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:12858 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751759AbaKJUXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:23:11 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsNAMAdYVRXQ4qy/2dsb2JhbABcgw6BLbgoBQF0miwCgScXAQEBAQF9hAMBBScvIxBROR4ZiEUBvRyPfwEBAQEGIoY6ilsHFoQ1BZ4ljQOJXYN7PC+CSwEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Jens Axboe <axboe@kernel.dk>,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH v2 08/10 linux-next] cdrom: fix init_cdrom_command in dvd_do_auth
Date: Mon, 10 Nov 2014 21:21:53 +0100
Message-Id: <1415650916-9975-9-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415650916-9975-1-git-send-email-fabf@skynet.be>
References: <1415650916-9975-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove memset 0 (init_cdrom_command already does it)
and send sizeof(buf) instead of 0 for buffer size.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/cdrom/cdrom.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 9b08f91..d397591 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -1639,8 +1639,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 	struct cdrom_device_ops *cdo = cdi->ops;
 	rpc_state_t rpc_state;
 
-	memset(buf, 0, sizeof(buf));
-	init_cdrom_command(&cgc, buf, 0, CGC_DATA_READ);
+	init_cdrom_command(&cgc, buf, sizeof(buf), CGC_DATA_READ);
 
 	switch (ai->type) {
 	/* LU data send */
-- 
1.9.1

