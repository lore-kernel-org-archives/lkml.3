Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaHSLcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:32:51 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57781 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaHSLcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:32:50 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: amplc_pci230: fix DACOUT write
Date: Tue, 19 Aug 2014 12:32:36 +0100
Message-Id: <1408447956-10139-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4f9c63fe5333b27ab23ed399830c7977f6970744 ("staging: comedi:
amplc_pci230: refactor iobase addresses") removed some parentheses
(presumably to keep the line withing 80 chars) in
`pci230_ao_write_nofifo()` when writing to the DACOUT1 or DACOUT2
registers, but it removed the wrong parentheses.  Fix it.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
This bug is in linux-next master and staging-next.
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 0fd212f..dd69e47 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -628,7 +628,7 @@ static inline void pci230_ao_write_nofifo(struct comedi_device *dev,
 
 	/* Write mangled datum to appropriate DACOUT register. */
 	outw(pci230_ao_mangle_datum(dev, datum),
-	     devpriv->daqio + ((chan) == 0) ? PCI230_DACOUT1 : PCI230_DACOUT2);
+	     devpriv->daqio + (chan == 0 ? PCI230_DACOUT1 : PCI230_DACOUT2));
 }
 
 static inline void pci230_ao_write_fifo(struct comedi_device *dev,
-- 
2.0.4

