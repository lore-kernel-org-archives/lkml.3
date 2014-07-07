Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbaGGXy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:54:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbaGGXyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.15 082/122] net: allwinner: emac: Add missing free_irq
Date: Mon,  7 Jul 2014 16:57:24 -0700
Message-Id: <20140707235736.714976531@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <maxime.ripard@free-electrons.com>

commit b91113282bf44df46aba374a0b8f88a75bfd4b3f upstream.

If the mdio probe function fails in emac_open, the interrupt we just requested
isn't freed. If emac_open is called again, for example because we try to set up
the interface again, the kernel will oops because the interrupt wasn't properly
released.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/allwinner/sun4i-emac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -736,6 +736,7 @@ static int emac_open(struct net_device *
 
 	ret = emac_mdio_probe(dev);
 	if (ret < 0) {
+		free_irq(dev->irq, dev);
 		netdev_err(dev, "cannot probe MDIO bus\n");
 		return ret;
 	}


