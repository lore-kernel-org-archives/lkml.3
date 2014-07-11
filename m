Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaGKECr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 00:02:47 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:38538 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaGKECq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 00:02:46 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 2/4] staging: comedi: addi_apci_1564: remove unnecessary dev->board_name initialization
Date: Thu, 10 Jul 2014 23:02:04 -0500
Message-Id: <b1dbc9e4e2bfc601409c44352959efbc41d0ebb1.1405050794.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <cover.1405050794.git.chase.southwood@gmail.com>
References: <cover.1405050794.git.chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev->board_name is now initialized by the comedi core before calling
the(*attach) or (*auto_attach) function in a driver. As long as the driver
does no additional probing, it's no longer necessary initialize the board_name.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi_apci_1564.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 675054f..e3dcab7 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -353,8 +353,6 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 	int ret;
 
-	dev->board_name = dev->driver->driver_name;
-
 	devpriv = comedi_alloc_devpriv(dev, sizeof(*devpriv));
 	if (!devpriv)
 		return -ENOMEM;
-- 
2.0.1

