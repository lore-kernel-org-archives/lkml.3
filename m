Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab3AUUtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:49:00 -0500
Received: from mout.gmx.net ([212.227.15.18]:51247 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab3AUUs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:48:56 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/cqKRnjc3cEIrr4WH7WteDLeBCCifOT0fwKb7t0Q
	ysRFBDUVJdH9rm
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging/comedi: remove workaround for !pci_driver.name
Date: Mon, 21 Jan 2013 21:51:57 +0100
Message-Id: <1358801517-18265-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1358801517-18265-1-git-send-email-peterhuewe@gmx.de>
References: <1358801517-18265-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All pci drivers in drivers/ have the pci_driver.name field set, so we
can remove this workaround and the accompanying todo.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/drivers.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 8b681ac..cebdd9e 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -536,10 +536,6 @@ int comedi_pci_driver_register(struct comedi_driver *comedi_driver,
 	if (ret < 0)
 		return ret;
 
-	/* FIXME: Remove this test after auditing all comedi pci drivers */
-	if (!pci_driver->name)
-		pci_driver->name = comedi_driver->driver_name;
-
 	ret = pci_register_driver(pci_driver);
 	if (ret < 0) {
 		comedi_driver_unregister(comedi_driver);
-- 
1.7.8.6

