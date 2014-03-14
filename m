Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbaCNQSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:18:55 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:53964 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbaCNQSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:18:51 -0400
From: Levente Kurusa <levex@linux.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>, Levente Kurusa <levex@linux.com>
Subject: [PATCH] staging: comedi: fix memory leak
Date: Fri, 14 Mar 2014 17:16:15 +0100
Message-Id: <1394813775-12363-1-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call kfree() on bdev. The variable is otherwise leaked.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/staging/comedi/drivers/comedi_bond.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 51a59e5..406aedb 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -254,6 +254,7 @@ static int do_dev_config(struct comedi_device *dev, struct comedi_devconfig *it)
 			if (!devs) {
 				dev_err(dev->class_dev,
 					"Could not allocate memory. Out of memory?\n");
+				kfree(bdev);
 				return -ENOMEM;
 			}
 			devpriv->devs = devs;
-- 
1.8.3.1

