Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbaJBO1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:27:14 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:38969 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbaJBO1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:27:12 -0400
Message-ID: <542D6218.3040609@gmail.com>
Date: Thu, 02 Oct 2014 22:32:56 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: samuel@sortiz.org
CC: Richard Weinberger <richard@nod.at>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/net/irda/Kconfig: Let SH_IRDA depend on HAS_IOMEM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SH_IRDA needs HAS_IOMEM, so depend on it. The related error(with
allmodconfig under um):

    CC [M]  drivers/net/irda/sh_irda.o
  drivers/net/irda/sh_irda.c: In function ‘sh_irda_probe’:
  drivers/net/irda/sh_irda.c:776:2: error: implicit declaration of function ‘ioremap_nocache’ [-Werror=implicit-function-declaration]
    self->membase = ioremap_nocache(res->start, resource_size(res));
    ^
  drivers/net/irda/sh_irda.c:776:16: warning: assignment makes pointer from integer without a cast [enabled by default]
    self->membase = ioremap_nocache(res->start, resource_size(res));
                  ^
  drivers/net/irda/sh_irda.c:821:2: error: implicit declaration of function ‘iounmap’ [-Werror=implicit-function-declaration]
    iounmap(self->membase);
    ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/net/irda/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/irda/Kconfig b/drivers/net/irda/Kconfig
index 8d101d6..a2c227b 100644
--- a/drivers/net/irda/Kconfig
+++ b/drivers/net/irda/Kconfig
@@ -397,7 +397,7 @@ config MCS_FIR
 config SH_IRDA
 	tristate "SuperH IrDA driver"
 	depends on IRDA
-	depends on ARCH_SHMOBILE || COMPILE_TEST
+	depends on (ARCH_SHMOBILE || COMPILE_TEST) && HAS_IOMEM
 	help
 	  Say Y here if your want to enable SuperH IrDA devices.
 
-- 
1.9.3
