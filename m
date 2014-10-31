Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbaJaVtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:49:19 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:2951 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760204AbaJaVtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:49:05 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvkNAKkCVFRXQwLV/2dsb2JhbABcgw6BLLlrBQF0mhoCgRgXAQEBAQF9hAMBBScvIxBROR4ZiEUBvDyOaAEBAQEGIoY3ilkHFoQ1BZ14jHOJVYN5PC+CSwEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 8/8] cdrom: fix init_cdrom_command in dvd_do_auth
Date: Fri, 31 Oct 2014 22:48:04 +0100
Message-Id: <1414792084-7739-9-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414792084-7739-1-git-send-email-fabf@skynet.be>
References: <1414792084-7739-1-git-send-email-fabf@skynet.be>
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
index 2afe89d..8fce522 100644
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
1.9.3

