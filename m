Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbaBYXE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 18:04:58 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:50838 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbaBYXEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 18:04:55 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: abbotti@mev.co.uk
Cc: hsweeten@visionengravers.com, gregkh@linuxfoundation.org,
        chase.southwood@yahoo.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: comedi: drivers: fix for a potential NULL pointer dereference
Date: Wed, 26 Feb 2014 01:04:45 +0200
Message-Id: <1393369485-10801-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENOMEM in ni_E_init if ni_gpct_device_construct returns NULL

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/comedi/drivers/ni_mio_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 8adb535..3a86d48 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -4407,6 +4407,9 @@ static int ni_E_init(struct comedi_device *dev)
 							&ni_gpct_read_register,
 							counter_variant,
 							NUM_GPCT);
+	if (!devpriv->counter_dev)
+		return -ENOMEM;
+
 	/* General purpose counters */
 	for (j = 0; j < NUM_GPCT; ++j) {
 		s = &dev->subdevices[NI_GPCT_SUBDEV(j)];
-- 
1.8.5.3

