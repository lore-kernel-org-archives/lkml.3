Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaJBORw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:17:52 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:42448 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaJBORu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:17:50 -0400
Message-ID: <542D5FE5.2040400@gmail.com>
Date: Thu, 02 Oct 2014 22:23:33 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: davem@davemloft.net, antoine.tenart@free-electrons.com, arnd@arndb.de,
        jason@lakedaemon.net, richard@nod.at, mw@semihalf.com,
        thomas.petazzoni@free-electrons.com
CC: netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/net/ethernet/marvell/Kconfig: Let PXA168_ETH depend
 on HAS_IOMEM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PXA168_ETH need HAS_IOMEM, so depend on it, the related error (with
allmodconfig under um):

    CC [M]  drivers/net/ethernet/marvell/pxa168_eth.o
  drivers/net/ethernet/marvell/pxa168_eth.c: In function ‘pxa168_eth_probe’:
  drivers/net/ethernet/marvell/pxa168_eth.c:1605:2: error: implicit declaration of function ‘iounmap’ [-Werror=implicit-function-declaration]
    iounmap(pep->base);
    ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/net/ethernet/marvell/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
index bed8fbb..b3b72ad 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -64,7 +64,7 @@ config MVPP2
 
 config PXA168_ETH
 	tristate "Marvell pxa168 ethernet support"
-	depends on CPU_PXA168 || ARCH_BERLIN || COMPILE_TEST
+	depends on (CPU_PXA168 || ARCH_BERLIN || COMPILE_TEST) && HAS_IOMEM
 	select PHYLIB
 	---help---
 	  This driver supports the pxa168 Ethernet ports.
-- 
1.9.3
