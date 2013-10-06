Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3JFDxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 23:53:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40007 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474Ab3JFDwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 23:52:43 -0400
X-Sasl-enc: iPQW6bzAlKSXe5k3EQi3/u6lz4+9F2K2FHAySwLjTMlz 1381031562
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, david@hauweele.net
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH v1 3/3] mrf24j40: Use level-triggered interrupts
Date: Sat,  5 Oct 2013 23:52:24 -0400
Message-Id: <1381031544-2960-4-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381031544-2960-1-git-send-email-alan@signal11.us>
References: <1369188080-8904-1-git-send-email-alan@signal11.us>
 <1381031544-2960-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mrf24j40 generates level interrupts. There are rare cases where it
appears that the interrupt line never gets de-asserted between interrupts,
causing interrupts to be lost, and causing a hung device from the driver's
perspective.  Switching the driver to interpret these interrupts as
level-triggered fixes this issue.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 drivers/net/ieee802154/mrf24j40.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
index c1bc688..0632d34 100644
--- a/drivers/net/ieee802154/mrf24j40.c
+++ b/drivers/net/ieee802154/mrf24j40.c
@@ -678,7 +678,7 @@ static int mrf24j40_probe(struct spi_device *spi)
 	ret = request_threaded_irq(spi->irq,
 				   NULL,
 				   mrf24j40_isr,
-				   IRQF_TRIGGER_FALLING|IRQF_ONESHOT,
+				   IRQF_TRIGGER_LOW|IRQF_ONESHOT,
 				   dev_name(&spi->dev),
 				   devrec);
 
-- 
1.8.1.2

