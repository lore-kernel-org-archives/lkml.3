Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760835AbaGYRH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:07:29 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:43469 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760534AbaGYRH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:07:27 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] staging: comedi: amplc_dio200_common: remove some tests from amplc_dio200_common_detach()
Date: Fri, 25 Jul 2014 18:07:08 +0100
Message-Id: <1406308029-15712-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406308029-15712-1-git-send-email-abbotti@mev.co.uk>
References: <1406308029-15712-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`amplc_dio200_common_detach()` doesn't do much apart from freeing the
IRQ handler that was requested by `amplc_dio200_common_attach()` if
`dev->irq` is non-zero.  There is no need to check if the pointer to
the constant board data or the pointer to private per-device data
exist, so remove those tests.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_dio200_common.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_dio200_common.c b/drivers/staging/comedi/drivers/amplc_dio200_common.c
index 3592e58..4cf9e9e 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200_common.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200_common.c
@@ -1197,11 +1197,6 @@ EXPORT_SYMBOL_GPL(amplc_dio200_common_attach);
 
 void amplc_dio200_common_detach(struct comedi_device *dev)
 {
-	const struct dio200_board *thisboard = comedi_board(dev);
-	struct dio200_private *devpriv = dev->private;
-
-	if (!thisboard || !devpriv)
-		return;
 	if (dev->irq) {
 		free_irq(dev->irq, dev);
 		dev->irq = 0;
-- 
2.0.0

