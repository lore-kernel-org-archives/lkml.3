Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaG2MD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:03:59 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51661 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbaG2L6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:58:44 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/19] staging: comedi: amplc_pci230: usleep_range is preferred over udelay
Date: Tue, 29 Jul 2014 12:58:14 +0100
Message-Id: <1406635107-27950-7-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch issue: "CHECK: usleep_range is preferred over udelay; see
Documentation/timers/timers-howto.txt".  I picked 100 us as a reasonable
upper bound, but it's not that critical.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 76c4625..00d7a22 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2480,7 +2480,7 @@ static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	 * channel gains and scan list _before_ the first FIFO reset also
 	 * helps, though only slightly.
 	 */
-	udelay(25);
+	usleep_range(25, 100);
 
 	/* Reset FIFO again. */
 	outw(adccon | PCI230_ADC_FIFO_RESET, dev->iobase + PCI230_ADCCON);
-- 
2.0.0

