Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214Ab3IJJOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:14:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40279 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3IJJOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:14:37 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-90-522ee2fb24d7
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        devicetree@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>,
        Rob Herring <robherring2@gmail.com>, Olof Johansson <olof@lixom.net>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] drivers: of: fix build break if asm/dma-contiguous.h is missing
Date: Tue, 10 Sep 2013 11:13:20 +0200
Message-id: <1378804400-31716-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t9jQd3fj/SCDJ5NNbb4O+kYu8X8I+dY
	LfrfLGS1eHVmI5vFm94OFouzTW/YLbZ3zmC3+HLlIZPF5V1z2CyeLDzDZLH2yF12iw0vDzJZ
	LL1+kcliwfEWVos/0+UsTl3/zGYxYfpaFovv376xWfzdvonF4vCbdqCZB9tYLNbPeM1isWrX
	H0YHcY8189Ywevz+NYnR4/XkCYwel/t6mTx2zrrL7nH732Nmjysnmlg91v15xeTR/9fAY+f3
	BnaPvi2rGD1+vtTx+LxJzmPj3NAAvigum5TUnMyy1CJ9uwSujF+3VrMW3GCtWLTsBmMD4z2W
	LkZODgkBE4m/D1eyQthiEhfurWfrYuTiEBKYzijRs3kFO4TTziTxvGcTWAebgKFE19suNhBb
	RCBO4trBHmaQImaBSWwSX3csZAdJCAsESHx6+hkowcHBIqAqcW5qKkiYV8BDYv7144wgYQkB
	BYk5k2wmMHIvYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcF8+kdjCubLA4xCjAwajE
	w6vxTjdIiDWxrLgy9xCjBAezkgiv+HS9ICHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qtA4UE
	0hNLUrNTUwtSi2CyTBycUg2MC9eyzvj2+N6hy484AmSFpYS0i+99Ffku2XerTqpEpfmy5K+Q
	+HcHuVas2aO/N6Qr5K1e/71O+dnptUn/+hv4czYuLcy6eDbpV+PP2QZTbm+7sLGeh38Ry5dl
	kiLx0nHFj2wvuc++md3KvK5GvuqAkUbTsdjmUlfjR6fNORxf7nqp68E/3cdZiaU4I9FQi7mo
	OBEAmrkY+IcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not needed to include asm/dma-contiguous.h header to compile
reserved memory initialization code, so remove it to avoid build break
on architectures without CMA support.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index a754b84..0fe40c7 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -11,8 +11,6 @@
  * License or (at your optional) any later version of the license.
  */
 
-#include <asm/dma-contiguous.h>
-
 #include <linux/memblock.h>
 #include <linux/err.h>
 #include <linux/of.h>
-- 
1.7.9.5

