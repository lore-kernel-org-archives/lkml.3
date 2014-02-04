Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaBDKs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 05:48:27 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:10455 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaBDKsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:48:17 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-20-52f0c570b35f
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: thomas.abraham@linaro.org, daniel.lezcano@linaro.org, tglx@linutronix.de,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] clocksource: exynos4: Fix wrong bit operation in
 exynos4_mct_write()
Date: Tue, 04 Feb 2014 19:48:12 +0900
Message-id: <1391510892-27467-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWyRsSkQLfg6Icgg2dz2CzmfZa16Dz7hNni
	8i4g73bjCjaLzZumMlscm7GE0YHN4861PWwe786dY/fo27KK0ePzJrkAligum5TUnMyy1CJ9
	uwSujF8PjjIX9HJUzJ/wmr2B8QlbFyMnh4SAicT679tYIWwxiQv31gPFuTiEBJYySizcPZUZ
	rqizhREisYhR4uzBT0wQThuTxNfz25lAqtgEdCT+77vJDmKLCChIbO59xgpSxCwwn1Fi2ZYp
	YKOEBcIlph/6AGazCKhK7Hl/HayBV8BD4u6yzUArOIDWKUjMmWQD0ish8JlNYu3GXywQ9QIS
	3yYfYoGokZXYdADqOkmJgytusExgFFzAyLCKUTS1ILmgOCm9yFSvODG3uDQvXS85P3cTIzBE
	T/97NnEH4/0D1ocYk4HGTWSWEk3OB4Z4Xkm8obGZkYWpiamxkbmlGWnCSuK86Y+SgoQE0hNL
	UrNTUwtSi+KLSnNSiw8xMnFwSjUw2ssf37/19zTbSyfnPZ7IszqmS+JQVWfnC1k7lb27Hr04
	8We7aN305D1//n092c90+llGu7W3ldn5busX5uVqYjMKXl/jqu/g6wm4O7cpbdnTf4YJ8e9W
	VzUoBVR38ts+lal9z9PSL7aCWWbilQDvlVm5P5T+3T3ZfTRz96cTBntv+r3/eHD7RyWW4oxE
	Qy3mouJEACr/ZuBnAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t9jAd38ox+CDPbtsbaY91nWovPsE2aL
	y7vmsFncblzBZrF501Rmi2MzljA6sHncubaHzePduXPsHn1bVjF6fN4kF8AS1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY8evBUeaCXo6K+RNeszcwPmHrYuTkkBAwkVjf
	2cIIYYtJXLi3HijOxSEksIhR4uzBT0wQThuTxNfz25lAqtgEdCT+77vJDmKLCChIbO59xgpS
	xCwwn1Fi2ZYpzCAJYYFwiemHPoDZLAKqEnveXwdr4BXwkLi7bDPQOg6gdQoScybZTGDkXsDI
	sIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOAKeSe9gXNVgcYhRgINRiYdXQeVDkBBrYllx
	Ze4hRgkOZiURXvNtQCHelMTKqtSi/Pii0pzU4kOMyUDLJzJLiSbnA6MzryTe0NjEzMjSyNzQ
	wsjYnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYlYNmSr35H3/eLP8/S5Aa94RDc+9N
	9lgc+ORDbTXD5NPcBwsf3z34o/+/5l6FTLNNVmmmalmRodUS3YbXn327UPV0wRvvGLX0NqHw
	/AAN2wMTJou11XVtbPkbP22RblaR3WT292e33JbOSSy/MGWyxhXXL40tXaLLqkQN+s3P76xW
	OjFXstdCiaU4I9FQi7moOBEAeL+HV8QCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a faulty bit operation during checking offset in exynos4_mct_write().
This patch fixes it correctly.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/clocksource/exynos_mct.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 62b0de6..e60b019 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -94,8 +94,8 @@ static void exynos4_mct_write(unsigned int value, unsigned long offset)
 	__raw_writel(value, reg_base + offset);
 
 	if (likely(offset >= EXYNOS4_MCT_L_BASE(0))) {
-		stat_addr = (offset & ~EXYNOS4_MCT_L_MASK) + MCT_L_WSTAT_OFFSET;
-		switch (offset & EXYNOS4_MCT_L_MASK) {
+		stat_addr = (offset & EXYNOS4_MCT_L_MASK) + MCT_L_WSTAT_OFFSET;
+		switch (offset & ~EXYNOS4_MCT_L_MASK) {
 		case MCT_L_TCON_OFFSET:
 			mask = 1 << 3;		/* L_TCON write status */
 			break;
-- 
1.7.9.5

