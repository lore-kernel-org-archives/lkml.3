Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaEGTxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:53:24 -0400
Received: from mout.gmx.net ([212.227.17.21]:64080 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbaEGTxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:53:22 -0400
Date: Wed, 7 May 2014 21:45:52 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: hsweeten@visionengravers.com, abbotti@mev.co.uk,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: comedi: ii_pci20kc: fix usage of uninit scalar
 in ii20k_attach()
Message-ID: <20140507214552.0d2d72b2@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:swzhBPhgOI7yFG0VbuuxQGFmKKL/tI1vlZQJX62WDihRSNBwzGR
 FUsOC2C+MbI5TrgljF5Pw3Xjrf9ozxA0UsTKytI7x+AxStS189IdtOcnBd9YUuCVz/RLGbh
 TPc6zn7Wvmsb68xzoVU0kdwwjd21GtqFeweTMWSrRxMSi8llP0ZO+rbLFGfCkwuuN12Bo+A
 4uaHyzjE1i2wzkvLNfCoQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver supports the PCI-20001C-1a and PCI-20001C-2a carrier boards.
The -2a version has 32 on-board DIO channels. In case this variant is
detected, local variable 'has_dio' is set accordingly. Otherwise it is
left uninitialized and the following subdevice instantiation depends on
the stack. Detected by Coverity - CID 1077830.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
v2: Resend after v1 failed to apply

   * rebased against staging-next - commit 09c3fbba (staging: rtl8188eu:
     Remove 'u8 *pbuf' from struct recv_buf)
   * fixed mua: no multipart, 7bit text/plain us-ascii

Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/comedi/drivers/ii_pci20kc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/drivers/ii_pci20kc.c b/drivers/staging/comedi/drivers/ii_pci20kc.c
index 3558ab3..2516ce8 100644
--- a/drivers/staging/comedi/drivers/ii_pci20kc.c
+++ b/drivers/staging/comedi/drivers/ii_pci20kc.c
@@ -461,6 +461,7 @@ static int ii20k_attach(struct comedi_device *dev,
 	id = readb(devpriv->ioaddr + II20K_ID_REG);
 	switch (id & II20K_ID_MASK) {
 	case II20K_ID_PCI20001C_1A:
+		has_dio = false;
 		break;
 	case II20K_ID_PCI20001C_2A:
 		has_dio = true;
-- 
1.9.1

