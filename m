Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbaGYJKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:10:54 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:41141 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759856AbaGYJFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:05:18 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] staging: comedi: amplc_pc236: no need to set hw_dev
Date: Fri, 25 Jul 2014 10:04:51 +0100
Message-Id: <1406279098-8498-6-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
References: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call to `comedi_set_hw_dev()` from `pc236_pci_common_attach()` is
now unnecessary since `pc236_pci_common_attach()` is now only called
from this driver's `auto_attach` hook `pc236_auto_attach()` and the
comedi core now calls `comedi_set_hw_dev()` before calling that.  Remove
the unnecessary call.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pc236.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index cf45c58..f99c7f1 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -358,8 +358,6 @@ static int pc236_pci_common_attach(struct comedi_device *dev,
 	unsigned long iobase;
 	int ret;
 
-	comedi_set_hw_dev(dev, &pci_dev->dev);
-
 	ret = comedi_pci_enable(dev);
 	if (ret)
 		return ret;
-- 
2.0.0

