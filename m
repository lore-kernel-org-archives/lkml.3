Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab3CDIHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:07:06 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14644 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab3CDIHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:07:03 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-9d-51345626694e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 23/24] rtc: rtc-tegra: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 17:07:01 +0900
Message-id: <015001ce18af$406753e0$c135fba0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAAU/DQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zI121MJNAg6d9nBZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBlTLx3hLHgHHvFmoctzA2Mx9i6GDk5JARMJO5NnM8OYYtJXLi3HijOxSEksIxR4tqZ
	hawwRScfdLJAJKYzStz61MQO4fxilOg8t5QFpIpNQE3iy5fDQAkODhEBfYm2Fg2QGmaBXkaJ
	M727wVYICdhKfHn4gAnE5hSwk7h/bhXYBmEBT4nJrVfBbBYBVYntWz6A2bxA9ct2b4eyBSV+
	TL4HtotZQEti/c7jTBC2vMTmNW+ZQfZKCKhLPPqrCxIWETCSeDTtMRtEiYjEvhfvGEHukRC4
	xy6xfOJ3JohdAhLfJh9igeiVldh0gBniYUmJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhF
	UwuSC4qT0ouM9IoTc4tL89L1kvNzNzFCYrVvB+PNA9aHGJOB1k9klhJNzgfGel5JvKGxsYmZ
	iamJuaWpuSlpwkrivPKXZAKFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MEpIzVM+wrWr8fWq
	+UlBO7rjOf9M5m6Su/JD6MJdLvbd2jmzTfmi2/P2T3xoFymp93viwvoXYsX/9BI0Dx7OKmxg
	E9c5PeXcub1aTvO+Kd+9eqm8c6eMqc2sb7y2dVvtNV8HHjv5fY7nvkkKnI/TrCbt17zby/zy
	2Ien7f3GD1v5F/vmf7sWeECJpTgj0VCLuag4EQC1C3W86wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQV21MJNAg22vWCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzJh47whjwTn2ijUPW5gbGI+xdTFyckgImEic
	fNDJAmGLSVy4tx4ozsUhJDCdUeLWpyZ2COcXo0TnuaVgVWwCahJfvhwGSnBwiAjoS7S1aIDU
	MAv0Mkqc6d3NDlIjJGAr8eXhAyYQm1PATuL+uVWsILawgKfE5NarYDaLgKrE9i0fwGxeoPpl
	u7dD2YISPybfA9vFLKAlsX7ncSYIW15i85q3zCB7JQTUJR791QUJiwgYSTya9pgNokREYt+L
	d4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcCJ4JrWD
	cWWDxSFGAQ5GJR5egU/GgUKsiWXFlbmHGCU4mJVEeMskTAKFeFMSK6tSi/Lji0pzUosPMSYD
	PTqRWUo0OR+YpPJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRASCA9sSQ1OzW1ILUIZgsTB6dU
	A2PBRe0cdq8yhu1qRjMFJ2y9sOdGj7v20rVlrFvOv7xeNsnhY+XG017SUjtKG5L63W8IWf3b
	l3RxR1s5c0xt68fQyjUrBOp2GmrU8E1MnnxJXZH9kfyvBB2pRj22Jon7px7lqh7Ydjr1ZJ/E
	iVfPfU36/P96fJI1miVdy8C31HjJ2Qfl/5/nnFNiKc5INNRiLipOBAB0eGEkSAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-tegra.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index 0020bab..9447d65 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -452,17 +452,7 @@ static struct platform_driver tegra_rtc_driver = {
 #endif
 };
 
-static int __init tegra_rtc_init(void)
-{
-	return platform_driver_probe(&tegra_rtc_driver, tegra_rtc_probe);
-}
-module_init(tegra_rtc_init);
-
-static void __exit tegra_rtc_exit(void)
-{
-	platform_driver_unregister(&tegra_rtc_driver);
-}
-module_exit(tegra_rtc_exit);
+module_platform_driver_probe(tegra_rtc_driver, tegra_rtc_probe);
 
 MODULE_AUTHOR("Jon Mayo <jmayo@nvidia.com>");
 MODULE_DESCRIPTION("driver for Tegra internal RTC");
-- 
1.7.2.5


