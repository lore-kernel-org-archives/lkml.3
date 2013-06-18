Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab3FRNJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:09:45 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:38277 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab3FRNJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:09:44 -0400
MIME-Version: 1.0
Date: Tue, 18 Jun 2013 21:09:42 +0800
Message-ID: <CAPgLHd-HMw40igirFvFHtN3HNy2utXHVAVERxKQ-vwF9ecUaSw@mail.gmail.com>
Subject: [PATCH] ALSA: firewire: fix error return code in scs_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: clemens@ladisch.de, perex@perex.cz, tiwai@suse.de
Cc: yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the kmalloc() error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/firewire/scs1x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/firewire/scs1x.c b/sound/firewire/scs1x.c
index 844a555..b252c21 100644
--- a/sound/firewire/scs1x.c
+++ b/sound/firewire/scs1x.c
@@ -405,8 +405,10 @@ static int scs_probe(struct device *unit_dev)
 	scs->output_idle = true;
 
 	scs->buffer = kmalloc(HSS1394_MAX_PACKET_SIZE, GFP_KERNEL);
-	if (!scs->buffer)
+	if (!scs->buffer) {
+		err = -ENOMEM;
 		goto err_card;
+	}
 
 	scs->hss_handler.length = HSS1394_MAX_PACKET_SIZE;
 	scs->hss_handler.address_callback = handle_hss;

