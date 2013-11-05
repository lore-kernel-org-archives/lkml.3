Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3KER1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:27:54 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:60106 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab3KER1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:27:51 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-c1-52792a96e179
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH v10 6/7] cpufreq:exynos4x12: Change L0 driver data to
 CPUFREQ_BOOST_FREQ
Date: Tue, 05 Nov 2013 18:26:50 +0100
Message-id: <1383672411-26324-7-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1383672411-26324-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1383672411-26324-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t9jQd1pWpVBBjPuGVg0XA2x2DhjPavF
	06Yf7BZ9P68wW6zZ/5PJovPsE2aLN4+4Ld483MxocXnXHDaLz71HGC1uN65gszhz+hKrxZOH
	fWwWG796OPB5LN7zksnjzrU9bB7rpr1l9thytZ3Fo2/LKkaP4ze2M3l83iQXwB7FZZOSmpNZ
	llqkb5fAlbFtxT6Wgj8cFbOXTGVpYFzP3sXIySEhYCIx+fZVRghbTOLCvfVsXYxcHEIC0xkl
	5nTMZIRwupgklu77A1bFJqAn8fnuUyaQhIjAEkaJ100LWEEcZoG9zBKT/qwFcjg4hAWiJFou
	yoM0sAioSlzd/J0ZxOYVcJM4unAmK8Q6eYmn9/vYQGxOAXeJHbP2Qq1uYpR4c3sC0wRG3gWM
	DKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgsP1mdQOxpUNFocYBTgYlXh4E+Qrg4RYE8uK
	K3MPMUpwMCuJ8B77XxEkxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6YklqdmpqQWoR
	TJaJg1OqgZF985VzkxR25xsGRUoabZ2r4btoq5RQf0/IzoNnRR3PKseF3Pv0snZueuX2yWfE
	mlYmr9R9Y/3x5HK2+baFPyXm/nFkVJNLrtn7/piBbdyCfe2SE+1UxaP0WeWl68yNN0cbMc7b
	Vr2k5sDi+DmdS5avKg49fP+P22u1BcyexaltMq/ni54TYlRiKc5INNRiLipOBACTFtlZUwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Special driver data flag (CPUFREQ_BOOST_FREQ) has been added to indicate
frequency, which can be only enabled for BOOST mode.
This frequency shall be used only for limited time, since it might cause
target device to overheat.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

---
Changes for v10:
- None

Changes for v9:
- None

Changes for v8:
- None

Changes for v7:
- None

Changes for v6:
- New patch

 drivers/cpufreq/exynos4x12-cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/exynos4x12-cpufreq.c b/drivers/cpufreq/exynos4x12-cpufreq.c
index 8683304..b2d3a6b1 100644
--- a/drivers/cpufreq/exynos4x12-cpufreq.c
+++ b/drivers/cpufreq/exynos4x12-cpufreq.c
@@ -32,7 +32,7 @@ static unsigned int exynos4x12_volt_table[] = {
 };
 
 static struct cpufreq_frequency_table exynos4x12_freq_table[] = {
-	{L0, CPUFREQ_ENTRY_INVALID},
+	{CPUFREQ_BOOST_FREQ, 1500 * 1000},
 	{L1, 1400 * 1000},
 	{L2, 1300 * 1000},
 	{L3, 1200 * 1000},
-- 
1.7.10.4

