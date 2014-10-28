Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbaJ1LCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:02:08 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:64425 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbaJ1LCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:02:04 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Frank Li <Frank.Li@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv2 4/6] net: fec: use swab32s() instead of cpu_to_be32()
Date: Tue, 28 Oct 2014 12:01:42 +0100
Message-Id: <1414494104-27943-5-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414494104-27943-1-git-send-email-LW@KARO-electronics.de>
References: <1414494104-27943-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when swap_buffer() is being called, we know for sure, that we need to
byte swap the data. Also this function is called for swapping data in
both directions. Thus cpu_to_be32() is semantically not correct for
all use cases. Use swab32s() to reflect this.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/net/ethernet/freescale/fec_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 323ae2e..3a103e9 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -334,7 +334,7 @@ static void *swap_buffer(void *bufaddr, int len)
 	unsigned int *buf = bufaddr;
 
 	for (i = 0; i < DIV_ROUND_UP(len, 4); i++, buf++)
-		*buf = cpu_to_be32(*buf);
+		swab32s(buf);
 
 	return bufaddr;
 }
-- 
1.7.10.4

