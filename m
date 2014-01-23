Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaAWTGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:06:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbaAWTGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:06:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 3.12 05/27] staging: comedi: adl_pci9111: fix incorrect irq passed to request_irq()
Date: Thu, 23 Jan 2014 11:06:42 -0800
Message-Id: <20140123190649.272291296@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140123190648.720195687@linuxfoundation.org>
References: <20140123190648.720195687@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: H Hartley Sweeten <hsweeten@visionengravers.com>

commit 48108fe3daa0d142f9b97178fdb23704ea3a407b upstream.

The dev->irq passed to request_irq() will always be 0 when the auto_attach
function is called. The pcidev->irq should be used instead to get the correct
irq number.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/adl_pci9111.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -869,7 +869,7 @@ static int pci9111_auto_attach(struct co
 	pci9111_reset(dev);
 
 	if (pcidev->irq > 0) {
-		ret = request_irq(dev->irq, pci9111_interrupt,
+		ret = request_irq(pcidev->irq, pci9111_interrupt,
 				  IRQF_SHARED, dev->board_name, dev);
 		if (ret)
 			return ret;


