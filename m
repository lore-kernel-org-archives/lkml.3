Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab3GEQWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:22:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60344 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192Ab3GEQWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:22:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khc@pm.waw.pl>, Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 7/8] ARM: ixp4xx: avoid circular header dependency
Date: Fri,  5 Jul 2013 18:23:36 +0200
Message-Id: <1373041417-217728-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1373041417-217728-1-git-send-email-arnd@arndb.de>
References: <1373041417-217728-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:P0JfcEgx7j1pgWie2OJCar5VVtvWx6GvzcnCJy5E9vR
 TcqxQ21ap1kwTj5YPrLm3+mFIJH8V/nKCJLNB2btIbkLGm2JQ2
 gStvdT9pqUZzbIeLYfnRyPs9S6O602lMEEzsdaqQiMa9n6CxeV
 ogllNcwAEkhRIoHEvHc7U3hG+kCwpuBXKCRSXQy51rLShhJ+hr
 Wun6rHevjz11x4djnzrndhcszPZuUKltRBKQ9Vu/vXAwI9iM50
 1bmFgvZDr6li0wEauCnIvWQDhwfmdqbVL1RJRjrXaoSMqIWsle
 pEooDBldT/dYBkHzNJWvb3+lUjjSd4XbZo030rx+Mr4g+K+gLQ
 H7oyXFId+1mvyjg6XHgII33HchFJ/gWxwQxTYJ0cs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new linux/reboot.h header file dependency added, we can no
longer build ixp4xx. The easiest way to avoid that is to remove the
inclusion of mach/hardware.h from mach/timex.h, which does not need
that header anyway.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Imre Kaloz <kaloz@openwrt.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jason Cooper <jason@lakedaemon.net>
---
 arch/arm/mach-ixp4xx/include/mach/timex.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-ixp4xx/include/mach/timex.h b/arch/arm/mach-ixp4xx/include/mach/timex.h
index c9e930f..0396d89 100644
--- a/arch/arm/mach-ixp4xx/include/mach/timex.h
+++ b/arch/arm/mach-ixp4xx/include/mach/timex.h
@@ -3,7 +3,7 @@
  * 
  */
 
-#include <mach/hardware.h>
+#include <mach/ixp4xx-regs.h>
 
 /*
  * We use IXP425 General purpose timer for our timer needs, it runs at 
-- 
1.8.3.1

