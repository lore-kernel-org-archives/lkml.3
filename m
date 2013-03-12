Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab3CLFq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:46:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33733 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab3CLFqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:46:24 -0400
X-AuditID: cbfee68e-b7f946d000001e37-fe-513ec12ec303
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Matt Mackall'" <mpm@selenic.com>,
        "'Herbert Xu'" <herbert@gondor.hengli.com.au>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] hwrng: exynos - add CONFIG_PM_SLEEP to suspend/resume functions
Date: Tue, 12 Mar 2013 14:46:22 +0900
Message-id: <003a01ce1ee4$ed8842b0$c898c810$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4e5OiAZ5g7NBjLRumw0P5S25o2nA==
Content-language: ko
x-cr-hashedpuzzle: BISX EA8P Ifsp K6zy MCaL Of2x R1gy TR8D WbhZ cldx hO0T ihQv
 js4U nGM6 vTzX
 1QRc;5;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGgAZQByAGIAZQByAHQAQABnAG8AbgBkAG8AcgAuAGEAcABhAG4AYQAuAG8AcgBnAC4AYQB1ADsAagBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAHAAbQBAAHMAZQBsAGUAbgBpAGMALgBjAG8AbQA=;Sosha1_v1;7;{725CD89F-1554-4BCC-84D6-4F356746A523};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Tue,
 12 Mar 2013 05:46:14
 GMT;WwBQAEEAVABDAEgAXQAgAGgAdwByAG4AZwA6ACAAZQB4AHkAbgBvAHMAIAAtACAAYQBkAGQAIABDAE8ATgBGAEkARwBfAFAATQBfAFMATABFAEUAUAAgAHQAbwAgAHMAdQBzAHAAZQBuAGQALwByAGUAcwB1AG0AZQAgAGYAdQBuAGMAdABpAG8AbgBzAA==
x-cr-puzzleid: {725CD89F-1554-4BCC-84D6-4F356746A523}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zI129g3aBBs9umlhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mk1u8C/5xVrSc2MfawHiWo4uRk0NCwERiblM/M4QtJnHh3nq2
	LkYuDiGBZYwS85+uYYYpunb/GjNEYhGjxNFdhxghnNlMEk8WTmMHqWITUJP48uUwkM3BISKg
	L9HWogFSwywwhVHi4tpmJpAaYYEAie1Ht7OA2CwCqhLL7hwFi/MK2Eq8ermQEcIWlPgx+R5Y
	DbOAlsT6nceZIGx5ic1r3jKDzJcQUJd49FcXJCwioCfxZ1s3I0SJiMS+F+/AbpMQ+MAqMa/v
	CSvEB6YS7dMXMEEklrFL7PvxD+oIAYlvkw+xQAyVldh0AOpjSYmDK26wTGCUmIXkpFlITpqF
	5KRZSHYvYGRZxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iRESW307GG8esD7EmAy0fiKzlGhy
	PjA280riDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	uEq3cDevyp8rBXZpjRcDPl14e31pVPP2xGk8ysn/tz2r1wn8F65TH3PIa+0RmRa1lqbI1VO5
	nFdcX8/slXla/eraJY23U3YuWrT2plBU7C7nV294zspOvnNS9EVF0pEn2l8zp7hm9nPUd6uz
	f8qoic88ffbQ45xpWpeOvGHjPXU3/bLFua0sl5VYijMSDbWYi4oTAXoGv1rDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgK7eQbtAg7Y+fYvLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcXKLd8E/zoqWE/tYGxjP
	cnQxcnJICJhIXLt/jRnCFpO4cG89WxcjF4eQwCJGiaO7DjFCOLOZJJ4snMYOUsUmoCbx5cth
	IJuDQ0RAX6KtRQOkhllgCqPExbXNTCA1wgIBEtuPbmcBsVkEVCWW3TkKFucVsJV49XIhI4Qt
	KPFj8j2wGmYBLYn1O48zQdjyEpvXvGUGmS8hoC7x6K8uSFhEQE/iz7ZuRogSEYl9L96B3SYh
	8IFVYl7fE1aID0wl2qcvYJrAKDQLyYpZSFbMQrJiFpJZCxhZVjGKphYkFxQnpeca6hUn5haX
	5qXrJefnbmIER+4zqR2MKxssDjEKcDAq8fAqfrMNFGJNLCuuzD3EKMHBrCTCm7HZLlCINyWx
	siq1KD++qDQntfgQYzIwBCYyS4km5wOTSl5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNIT
	S1KzU1MLUotgtjBxcEo1MGqd5Df6tv6T1I8GrY4Ct57tz1/43VO/mnO7/mS6TUvnm5v7kxmm
	nlSaoX8jWW+L2W/JqEl5Jww0zhr16n1ZnxA353LrtenBn4QPqu2/ZDfp2Jb/rBJFS3y5hBJS
	pivpTzY3SHqR5OFm9iP56YzS6tQt+/uZra7lRvb8Ddvez34y/UdYJVvOUyWW4oxEQy3mouJE
	AG9gAFggAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds CONFIG_PM_SLEEP to suspend/resume functions to fix
the following build warning when CONFIG_PM_SLEEP is not selected.

drivers/char/hw_random/exynos-rng.c:147:12: warning: 'exynos_rng_runtime_suspend' defined but not used [-Wunused-function]
drivers/char/hw_random/exynos-rng.c:157:12: warning: 'exynos_rng_runtime_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/char/hw_random/exynos-rng.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
index ac47631..b7e48a2 100644
--- a/drivers/char/hw_random/exynos-rng.c
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -144,6 +144,7 @@ static int exynos_rng_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int exynos_rng_runtime_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -161,7 +162,7 @@ static int exynos_rng_runtime_resume(struct device *dev)
 
 	return clk_prepare_enable(exynos_rng->clk);
 }
-
+#endif
 
 static UNIVERSAL_DEV_PM_OPS(exynos_rng_pm_ops, exynos_rng_runtime_suspend,
 					exynos_rng_runtime_resume, NULL);
-- 
1.7.2.5


