Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab3AUVUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:20:44 -0500
Received: from mout.gmx.net ([212.227.15.18]:64500 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab3AUVUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:20:42 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18DLe9OJ8kDuSRnMNkfslT2TKQYVoaqhYTxd/qRmQ
	oTKh3CRelsTG/h
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging/comedi: Add pci_driver.name to skel driver
Date: Mon, 21 Jan 2013 22:23:46 +0100
Message-Id: <1358803426-9852-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00207A6F6949C@AUSP01VMBX24.collaborationhost.net>
References: <ADE657CA350FB648AAC2C43247A983F00207A6F6949C@AUSP01VMBX24.collaborationhost.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the comedi_driver.name to pci_driver.name
to the skel driver, so we can remove the workaround in drivers.c

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
missed a comma, sorry
 drivers/staging/comedi/drivers/skel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index e2d7970..48178ca 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -713,6 +713,7 @@ static void skel_pci_remove(struct pci_dev *dev)
 }
 
 static struct pci_driver skel_pci_driver = {
+	.name = "dummy",
 	.id_table = skel_pci_table,
 	.probe = &skel_pci_probe,
 	.remove = &skel_pci_remove
-- 
1.7.8.6

