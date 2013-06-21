Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946173Ab3FUVuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:50:09 -0400
Received: from mail-la0-f68.google.com ([209.85.215.68]:60677 "EHLO
	mail-la0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946129Ab3FUVuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:50:08 -0400
MIME-Version: 1.0
Date: Fri, 21 Jun 2013 14:50:06 -0700
Message-ID: <CANV78LQqr8sd3JXBCDGKVY8KNWY67gWRxZRV6uAGdWND7fWL6g@mail.gmail.com>
Subject: [PATCH] Minor patch for drivers/misc/mei/pci-me.c: Delete stray
 dev_err() calls.
From: Charles Anthony <charles.unix.pro@gmail.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pci-me.c code contains 2 dev_err() calls which are apparently left
over from debugging; they do not represent actual error conditions.
They do produce messages in a "quiet" kernel, and add ERROR entries to
the logger.

Signed-off-by: "charles anthony" <charles.unix.pro@gmail.com>

Linux 3.10-rc6

--- linux-3.10-rc6/drivers/misc/mei/pci-me.c.orig	2013-06-21
14:30:33.916202629 -0700
+++ linux-3.10-rc6/drivers/misc/mei/pci-me.c	2013-06-21 14:30:59.023519010 -0700
@@ -248,7 +248,6 @@ static void mei_me_remove(struct pci_dev
 	hw = to_me_hw(dev);


-	dev_err(&pdev->dev, "stop\n");
 	mei_stop(dev);

 	mei_pdev = NULL;
@@ -281,8 +280,6 @@ static int mei_me_pci_suspend(struct dev
 	if (!dev)
 		return -ENODEV;

-	dev_err(&pdev->dev, "suspend\n");
-
 	mei_stop(dev);

 	mei_disable_interrupts(dev);
