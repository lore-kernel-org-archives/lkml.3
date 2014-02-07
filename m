Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbaBGNRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:17:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41549 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbaBGLs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 036/233] staging: comedi: adl_pci9111: fix incorrect irq passed to request_irq()
Date: Fri,  7 Feb 2014 11:44:15 +0000
Message-Id: <1391773652-25214-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: H Hartley Sweeten <hsweeten@visionengravers.com>

commit 48108fe3daa0d142f9b97178fdb23704ea3a407b upstream.

The dev->irq passed to request_irq() will always be 0 when the auto_attach
function is called. The pcidev->irq should be used instead to get the correct
irq number.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/drivers/adl_pci9111.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index af51c74..98f7167 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -869,7 +869,7 @@ static int pci9111_auto_attach(struct comedi_device *dev,
 	pci9111_reset(dev);
 
 	if (pcidev->irq > 0) {
-		ret = request_irq(dev->irq, pci9111_interrupt,
+		ret = request_irq(pcidev->irq, pci9111_interrupt,
 				  IRQF_SHARED, dev->board_name, dev);
 		if (ret)
 			return ret;
-- 
1.8.3.2

