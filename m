Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3CEWRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:17:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55088 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab3CEWRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:17:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Tony Prisk <linux@prisktech.co.nz>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 1/9] clk: vt8500: Fix "fix device clock divisor calculations"
Date: Tue,  5 Mar 2013 23:16:41 +0100
Message-Id: <1362521809-22989-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362521809-22989-1-git-send-email-arnd@arndb.de>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:I+xnnFbDUDqHjE0qmz3pr7f0bLC/s8YGSV8zhYFZ06c
 4yNjJBG0dKwULtXwjZKCOW0/pqBpqFDv8tad7MmSniylqxzrMy
 PSkjgDUuEtRnx0DTpQKpD+Tm5VVKRKMVm6+1p0LZtzCAo3/ueO
 IBCsnMpMdTRGFTKBRthI06pXn6HPFN8r1Vab5Wmwx5Ta1qmjHh
 vGC28v8noXCYsWpp3gHIG+1CItvHPGVkErpaMAycJU8jRMv/0D
 qbaiGu89JBVMxMlDYC+WK6GA+xRh/gdqXcYJHlPd5I7TqFZ/0Z
 ZKKM0EEumemm+nUJJeIeWy2O/n35VyaGsQLsxsm/4OwYd4mSPC
 UBibK7UWC9jfmf5IteKqiZ51DtgtzjEKT/4XXnEgO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 72480014b8 "Fix device clock divisor calculations" was apparently
rebased incorrectly before it got upstream, causing a build error.

Replacing the "prate" pointer with the local parent_rate is most
likely the correct solution.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Prisk <linux@prisktech.co.nz>
Cc: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/clk-vt8500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
index b5538bb..09c6331 100644
--- a/drivers/clk/clk-vt8500.c
+++ b/drivers/clk/clk-vt8500.c
@@ -157,7 +157,7 @@ static int vt8500_dclk_set_rate(struct clk_hw *hw, unsigned long rate,
 	divisor =  parent_rate / rate;
 
 	/* If prate / rate would be decimal, incr the divisor */
-	if (rate * divisor < *prate)
+	if (rate * divisor < parent_rate)
 		divisor++;
 
 	if (divisor == cdev->div_mask + 1)
-- 
1.8.1.2

