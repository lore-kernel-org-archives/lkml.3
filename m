Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934528Ab3DGXC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:02:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41831 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758832Ab3DGXC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:02:57 -0400
X-AuditID: cbfee68d-b7f786d000005188-a2-5161fb1f5f6e
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Kukjin'" <kgene.kim@samsung.com>,
        "'Thomas Abraham'" <thomas.ab@samsung.com>
References: 
In-reply-to: 
Subject: [RESEND PATCH 3.8-stable] ARM: EXYNOS: Fix crash on soft reset on
 EXYNOS5440
Date: Mon, 08 Apr 2013 08:02:55 +0900
Message-id: <004801ce33e4$0a2ffc00$1e8ff400$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAEJzDJAAAEqHoAC1cPGA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zA13534mBBgu2WVksaea26F1wlc3i
	8q45bBYLNj5itOhYxujA6tG3ZRWjx+dNcgFMUVw2Kak5mWWpRfp2CVwZ1yeuZSlo56l4cvoo
	SwPjd84uRk4OCQETiQ+zrjJD2GISF+6tZwOxhQSWMUp0PvaCqdm5cCJLFyMXUHwRo8ST7VMZ
	IYr+Mkp8vi0FYrMJ6EocW7+FFcQWEfCWODXlF9hQZoEMiSsNB4HiHED13BKrm4NAwpwCPBLr
	/nSClQgLhEus2DKZHcRmEVCV2Lj3KtgYXgE7iROn+qFsQYkfk++xQIzUkli/8zgThC0vsXnN
	W2aQ8RIC6hKP/upCXOAmcenVVzaIEhGJfS/eMYKcLyFwiF2ieVUz1C4BiW+TD7FA9MpKbDoA
	DQZJiYMrbrBMYJSYhWTzLCSbZyHZPAvJigWMLKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcx
	QmKwdwfj7QPWhxiTgdZPZJYSTc4HxnBeSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp
	2ampBalF8UWlOanFhxiZODilGhiZgzSVOq6tFU07nvA5cLfIatMS0da9Of6Pw2edD7f9tPpq
	9VdN65S6t1tuX+50zm38lqbT5HXI6dGqIq8JG5JLmd4+sbC5c77jseaE/7yhC1zkF5d5zdtk
	J3nua5eVOMsXw6VMt8vZ91t0CS9iNdhrpJSUJCh/uLKha3HKTd225qvuc2q/CiuxFGckGmox
	FxUnAgBWE9/i1wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jAV3534mBBt3/TSyWNHNb9C64ymZx
	edccNosFGx8xWnQsY3Rg9ejbsorR4/MmuQCmqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hT
	MwNDXUNLC3MlhbzE3FRbJRefAF23zBygZUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwjrGjOsT17IUtPNUPDl9lKWB8TtnFyMnh4SAicTOhRNZIGwxiQv31rN1MXJxCAks
	YpR4sn0qI0hCSOAvo8Tn21IgNpuArsSx9VtYQWwRAW+JU1N+MYPYzAIZElcaDgLFOYDquSVW
	NweBhDkFeCTW/ekEKxEWCJdYsWUyO4jNIqAqsXHvVbAxvAJ2EidO9UPZghI/Jt9jgRipJbF+
	53EmCFteYvOat8wg4yUE1CUe/dWFuMBN4tKrr2wQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKW
	BYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCY/yZ9A7GVQ0WhxgFOBiVeHgPfE0MFGJN
	LCuuzD3EKMHBrCTC2/sQKMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wPSTVxJvaGxiZmRp
	ZGZhZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MLcE+E+7KJu/eF1KuLr9lpcQu
	lRQmj2ffRROPS5j/EF1cK/2yjTnb8OTvM1FZ9ne8fA7vchUR2stT5diV1/rsKJPihcwTj4S+
	ddqpJn38vV3V5KoGs+7PmVGeFV7fWAJfuMRf8pq32WKOd/4LqW3WXYfbz/Mlun+8NnlzI+vq
	mVX8Wkc1i7yUWIozEg21mIuKEwEN3qm8NQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.8-stable tree, should we apply
it?

------------------

From: "Thomas Abraham <thomas.ab@samsung.com>"

commit 60db7e5f9c9a25a7a9b01007e6e3f5a93bc16a3a upstream

The soft-reset control register is located in the XMU controller space.
Map this controller space before writing to the soft-reset controller
register.

Signed-off-by: Thomas Abraham <thomas.ab@samsung.com>
Signed-off-by: Girish K S <ks.giri@samsung.com>
Signed-off-by: Kukjin <kgene.kim@samsung.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 arch/arm/mach-exynos/common.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index 1a89824..3b6de7a 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -299,6 +299,7 @@ void exynos4_restart(char mode, const char *cmd)
 
 void exynos5_restart(char mode, const char *cmd)
 {
+	struct device_node *np;
 	u32 val;
 	void __iomem *addr;
 
@@ -306,8 +307,9 @@ void exynos5_restart(char mode, const char *cmd)
 		val = 0x1;
 		addr = EXYNOS_SWRESET;
 	} else if (of_machine_is_compatible("samsung,exynos5440")) {
-		val = (0x10 << 20) | (0x1 << 16);
-		addr = EXYNOS5440_SWRESET;
+		np = of_find_compatible_node(NULL, NULL,
"samsung,exynos5440-clock");
+		addr = of_iomap(np, 0) + 0xcc;
+		val = (0xfff << 20) | (0x1 << 16);
 	} else {
 		pr_err("%s: cannot support non-DT\n", __func__);
 		return;
-- 
1.7.9.5

