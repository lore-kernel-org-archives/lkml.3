Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbaICMzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:55:22 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44685 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932495AbaICMqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:17 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/37] staging: comedi: amplc_pci230: use CMDF_WAKE_EOS
Date: Wed,  3 Sep 2014 13:45:34 +0100
Message-Id: <1409748360-17063-12-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace use of `TRIG_WAKE_EOS` command flag with the new name
`CMDF_WAKE_EOS`.  The numeric value is unchanged.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 66e7a47..6642744 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -1765,7 +1765,7 @@ static void pci230_ai_update_fifo_trigger_level(struct comedi_device *dev,
 	unsigned short triglev;
 	unsigned short adccon;
 
-	if (cmd->flags & TRIG_WAKE_EOS)
+	if (cmd->flags & CMDF_WAKE_EOS)
 		wake = scanlen - devpriv->ai_scan_pos;
 	else if (cmd->stop_src != TRIG_COUNT ||
 		 devpriv->ai_scan_count >= PCI230_ADC_FIFOLEVEL_HALFFULL ||
-- 
2.1.0

