Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaHFSSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:18:31 -0400
Received: from mxf3.bahnhof.se ([213.80.101.27]:54022 "EHLO mxf3.bahnhof.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349AbaHFSS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:18:28 -0400
X-Greylist: delayed 1369 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2014 14:18:28 EDT
X-Spam-Score: 0
From: Niklas Svensson <nks@flawful.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Niklas Svensson <nks@flawful.org>,
        Raghavendra Ganiga <ravi23ganiga@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: fixing coding style problems
Date: Wed,  6 Aug 2014 19:55:10 +0200
Message-Id: <1407347710-11460-1-git-send-email-nks@flawful.org>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes warnings of checkpatch.pl script:

CHECK:UNNECESSARY_PARENTHESES: Unnecessary parentheses around devpriv->timer
+        init_timer(&(devpriv->timer));

CHECK:PARENTHESIS_ALIGNMENT: Alignment should match open parenthesis
+        dev_info(dev->class_dev,
+                "%s: %i microvolt, %li microsecond waveform attached\n",

Task of Eudyptula challenge.

Signed-off-by: Niklas Svensson <nks@flawful.org>
---
 drivers/staging/comedi/drivers/comedi_test.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index 845a679..7aa23db 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -415,14 +415,14 @@ static int waveform_attach(struct comedi_device *dev,
 	for (i = 0; i < s->n_chan; i++)
 		devpriv->ao_loopbacks[i] = s->maxdata / 2;
 
-	init_timer(&(devpriv->timer));
+	init_timer(&devpriv->timer);
 	devpriv->timer.function = waveform_ai_interrupt;
 	devpriv->timer.data = (unsigned long)dev;
 
 	dev_info(dev->class_dev,
-		"%s: %i microvolt, %li microsecond waveform attached\n",
-		dev->board_name,
-		devpriv->uvolt_amplitude, devpriv->usec_period);
+		 "%s: %i microvolt, %li microsecond waveform attached\n",
+		 dev->board_name,
+		 devpriv->uvolt_amplitude, devpriv->usec_period);
 
 	return 0;
 }
-- 
2.0.4

