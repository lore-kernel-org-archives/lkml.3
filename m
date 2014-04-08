Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbaDHGUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 02:20:40 -0400
Received: from script.cs.helsinki.fi ([128.214.11.1]:54584 "EHLO
	script.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaDHGUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 02:20:39 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Apr 2014 02:20:38 EDT
X-DKIM: Courier DKIM Filter v0.50+pk-2014-03-23 mail.cs.helsinki.fi Tue, 08 Apr 2014 09:15:30 +0300
From: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
Subject: [PATCH] staging: goldfish: Call free_irq in error path
Date: Tue,  8 Apr 2014 09:15:22 +0300
Message-Id: <1396937722-330-1-git-send-email-tuomas.tynkkynen@iki.fi>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If misc_register failed in goldfish_audio_probe, the already requested
IRQ wouldn't get freed. Add a call to free_irq() like there is in
goldfish_audio_remove().

Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
---
Only compile tested. For the Eudyptula Challenge.
 drivers/staging/goldfish/goldfish_audio.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/goldfish/goldfish_audio.c b/drivers/staging/goldfish/goldfish_audio.c
index f96dcec..7ac2602 100644
--- a/drivers/staging/goldfish/goldfish_audio.c
+++ b/drivers/staging/goldfish/goldfish_audio.c
@@ -334,6 +334,7 @@ static int goldfish_audio_probe(struct platform_device *pdev)
 	return 0;
 
 err_misc_register_failed:
+	free_irq(data->irq, data);
 err_request_irq_failed:
 	dma_free_coherent(&pdev->dev, COMBINED_BUFFER_SIZE,
 					data->buffer_virt, data->buffer_phys);
-- 
1.7.9.5

