Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbaKSH5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 02:57:40 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:18755 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaKSH5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 02:57:39 -0500
X-AuditID: cbfee68d-f79296d000004278-c1-546c4d71d6ce
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        kgene@kernel.org, kgene.kim@gmail.com
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, gregkh@linuxfoundation.org, jslaby@suse.cz,
        kesavan.abhilash@gmail.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2] serial: samsung: Fix serial config dependencies for exynos7
Date: Wed, 19 Nov 2014 13:26:52 +0530
Message-id: <1416383812-714-1-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416199491-4841-1-git-send-email-a.kesavan@samsung.com>
References: <1416199491-4841-1-git-send-email-a.kesavan@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkTrfQNyfEYP9JLou/k46xWzQvXs9m
	8fn3LlaLNX+VLA5uamS26F1wlc2i//FrZotNj6+xWlzeNYfNYsb5fUwWi7Z+YXfg9vj9axKj
	x85Zd9k9Nq3qZPPYP3cNu8fmJfUefVtWMXqcWXCE3ePzJrkAjigum5TUnMyy1CJ9uwSujJ0r
	/jEV3OeteL1wPXMD42buLkZODgkBE4kz1x4wQdhiEhfurWfrYuTiEBJYyiix8+hRRpiiGT8X
	s0IkpjNKHL87C6qqj0li6akJYO1sAnoSC/59ZQaxRQQyJNY1bmcCKWIWOM4o0flsDgtIQljA
	X+LqhB4wm0VAVeLd5U9gNq+As8Sy3bOBbA6gdQoScybZgIQ5BVwl5sx7AzZTSMBFYtKvb2Az
	JQTOsUs8b2ljh5gjIPFt8iGoXlmJTQeYIa6WlDi44gbLBEbhBYwMqxhFUwuSC4qT0osM9YoT
	c4tL89L1kvNzNzECY+X0v2e9OxhvH7A+xCjAwajEw/vibXaIEGtiWXFl7iFGU6ANE5mlRJPz
	gRGZVxJvaGxmZGFqYmpsZG5ppiTOqyj1M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDoza3
	mf3lnbcLhOvyGZnMRRTmqnBvDIxl+bpM3vhrsvb7+CMsXk0ztQ6urw9/uGHpqoc1H9nn/+3e
	8+FnytWDaXWOUaF8xXU1xhXfu7hb3d/c7jrzb8K33HOfgp195v588PnEs0ZO200upjvzpv+/
	pOv8fYeWu9mEPRMvOgT8urpoTrhvm7P4JyWW4oxEQy3mouJEANXEbPGQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t9jQd0C35wQg93LrC3+TjrGbtG8eD2b
	xeffu1gt1vxVsji4qZHZonfBVTaL/sevmS02Pb7GanF51xw2ixnn9zFZLNr6hd2B2+P3r0mM
	Hjtn3WX32LSqk81j/9w17B6bl9R79G1ZxehxZsERdo/Pm+QCOKIaGG0yUhNTUosUUvOS81My
	89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgA5VUihLzCkFCgUkFhcr6dthmhAa
	4qZrAdMYoesbEgTXY2SABhLWMGbsXPGPqeA+b8XrheuZGxg3c3cxcnJICJhIzPi5mBXCFpO4
	cG89WxcjF4eQwHRGieN3Z0E5fUwSS09NYAKpYhPQk1jw7ysziC0ikCGxrnE7E0gRs8BxRonO
	Z3NYQBLCAv4SVyf0gNksAqoS7y5/ArN5BZwllu2eDWRzAK1TkJgzyQYkzCngKjFn3huwmUIC
	LhKTfn1jmsDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcCQ+k9rBuLLB4hCjAAej
	Eg/vi7fZIUKsiWXFlbmHGCU4mJVEeE9654QI8aYkVlalFuXHF5XmpBYfYjQFOmois5Rocj4w
	SeSVxBsam5ibGptamliYmFkqifMeaLUOFBJITyxJzU5NLUgtgulj4uCUamDkcWpiTprGrt8t
	k9Z3rrVoTqPlqt6rEsvW7Cl6O/fLOWXHme8Z9rTXBW4JZ/5aqTJlyzL2A2xNRnKCk5g5ZV6v
	vnoq0F/vr+7xfTk395vOPr6y4XVpSNeWjpUC+7xTL5m+7zXZLbGj9YHfF2dznxc2AU0vDn6I
	5efg81F1bCoSP1i2e+W9TzJKLMUZiYZazEXFiQDu3dmS2gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pankaj Dubey <pankaj.dubey@samsung.com>

Exynos7 has a similar serial controller to that present in older Samsung
SoCs. To re-use the existing serial driver on Exynos7 we need to have
SERIAL_SAMSUNG_UARTS_4 and SERIAL_SAMSUNG_UARTS selected. This is not
possible because these symbols are dependent on PLAT_SAMSUNG which is
not present for the ARMv8 based exynos7.

Change the dependency of these symbols from PLAT_SAMSUNG to the serial
driver thus making it available on exynos7. As the existing platform
specific code making use of these symbols is related to uart driver this
change in dependency should not cause any issues.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Changes in v2:
	- Added Greg's ack and Kukjin Kim as a recepient

 drivers/tty/serial/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index e71a28b..d0ce88c 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -249,14 +249,14 @@ config SERIAL_SAMSUNG
 
 config SERIAL_SAMSUNG_UARTS_4
 	bool
-	depends on PLAT_SAMSUNG
+	depends on SERIAL_SAMSUNG
 	default y if !(CPU_S3C2410 || CPU_S3C2412 || CPU_S3C2440 || CPU_S3C2442)
 	help
 	  Internal node for the common case of 4 Samsung compatible UARTs
 
 config SERIAL_SAMSUNG_UARTS
 	int
-	depends on PLAT_SAMSUNG
+	depends on SERIAL_SAMSUNG
 	default 4 if SERIAL_SAMSUNG_UARTS_4 || CPU_S3C2416
 	default 3
 	help
-- 
1.7.9.5

