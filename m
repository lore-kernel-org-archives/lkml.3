Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbaGKQBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:01:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40507 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaGKQBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:01:19 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-a2-53c00a4cf011
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 2/2] digsig: make crypto builtin if digsig selected as builtin
Date: Fri, 11 Jul 2014 18:59:45 +0300
Message-id: <7afa0a5a9343ddb354478536bd9dc670057fbebe.1405094060.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1405094060.git.d.kasatkin@samsung.com>
References: <cover.1405094060.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1405094060.git.d.kasatkin@samsung.com>
References: <cover.1405094060.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e/4ZV0frgPBBj+361nc+ruX2eJd028W
	iy9L6yzu3/vJZHF51xw2iw89j9gsPq2YxOzA7rFz1l12jweHNrN4vN93lc2jb8sqRo/Pm+QC
	WKO4bFJSczLLUov07RK4Mj5c2sJecJ+lYl3vG6YGxifMXYycHBICJhI9F7ZA2WISF+6tZ+ti
	5OIQEljKKDF1QjMThNPJJPGn4TAbSBWbgJ7EhuYf7F2MHBwiAhUSt+5kgYSZBdIlPk3qZQex
	hQX8JO7tfgdWwiKgKjF1ihdImFcgTuJhYz8jxC45iZPHJrOC2JwCVhKvz7WxgNhCApYSl65v
	YcQlPoGRfwEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkAD8soNx8TGrQ4wCHIxKPLwa
	tbuDhVgTy4orcw8xSnAwK4nwXn2zP1iINyWxsiq1KD++qDQntfgQIxMHp1QDo19kg0nde5V1
	midfL1oSIy/EujfojQPrlbuFHKbWnCrnsuu4qx/rhFTqr5ZRuixuevbcpCv+ivf0JY+E9D48
	c/v3vK4Nuq/9mqc8/1fHoNRumJZ8Y4rVo7k1lyN/6KSw/XH8XLfw219Vwe3HTdd6Jz1dOf3k
	sa2pBpOfGeR/XnHdRZ49z4fvuhJLcUaioRZzUXEiAOgSDW0eAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When SIGNATURE=y but depends on CRYPTO=m, it selects MPILIB as module
producing build break. This patch makes digsig to select crypto for
correcting dependency.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 lib/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index 334f772..a8a775730 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -451,7 +451,8 @@ config MPILIB
 
 config SIGNATURE
 	tristate
-	depends on KEYS && CRYPTO
+	depends on KEYS
+	select CRYPTO
 	select CRYPTO_SHA1
 	select MPILIB
 	help
-- 
1.9.1

