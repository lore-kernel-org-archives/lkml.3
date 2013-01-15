Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab3AOSwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:52:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:34012 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757640Ab3AOSwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:52:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 005/221] bcma: mips: fix clearing device IRQ
Date: Tue, 15 Jan 2013 10:48:52 -0800
Message-Id: <20130115184958.430116245@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <zajec5@gmail.com>

commit cbbc0138efe1dcd5426b8fc5d87741f5057aee72 upstream.

We were using wrong IRQ number so clearing wasn't working at all.
Depending on a platform this could result in a one device having two
interrupts assigned. On BCM4706 this resulted in all IRQs being broken.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bcma/driver_mips.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -115,7 +115,7 @@ static void bcma_core_mips_set_irq(struc
 			    bcma_read32(mdev, BCMA_MIPS_MIPS74K_INTMASK(0)) &
 			    ~(1 << irqflag));
 	else
-		bcma_write32(mdev, BCMA_MIPS_MIPS74K_INTMASK(irq), 0);
+		bcma_write32(mdev, BCMA_MIPS_MIPS74K_INTMASK(oldirq), 0);
 
 	/* assign the new one */
 	if (irq == 0) {


