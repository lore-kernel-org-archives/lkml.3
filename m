Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaGaNtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:49:06 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57920 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbaGaNsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:16 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/18] staging: comedi: amplc_pci224: no need to comedi_set_hw_dev() here
Date: Thu, 31 Jul 2014 14:47:55 +0100
Message-Id: <1406814475-5923-19-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comedi core module calls `comedi_set_hw_dev()` to associate the
hardware `struct device` with the `struct comedi_device` before it calls
the comedi driver's "auto_attach" hook `pci224_auto_attach()`.  There is
no need for `pci224_auto_attach()` to call `comedi_set_hw_dev()` itself,
so remove the call.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 4b45319..6fed6b8 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1084,8 +1084,6 @@ pci224_auto_attach(struct comedi_device *dev, unsigned long context_model)
 	if (!devpriv)
 		return -ENOMEM;
 
-	comedi_set_hw_dev(dev, &pci_dev->dev);
-
 	ret = comedi_pci_enable(dev);
 	if (ret)
 		return ret;
-- 
2.0.0

