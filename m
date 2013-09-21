Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab3IURnS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 13:43:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11669 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3IURnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 13:43:00 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-c1-523ddaa22d41
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: mturquette@linaro.org
Cc: rob@landley.net, ijc+devicetree@hellion.org.uk, swarren@wwwdotorg.org,
        mark.rutland@arm.com, pawel.moll@arm.com, rob.herring@calxeda.com,
        kgene.kim@samsung.com, ben-linux@fluff.org, kyungmin.park@samsung.com,
        linux@arm.linux.org.uk, tomasz.figa@gmail.com, t.figa@samsung.com,
        thomas.abraham@linaro.org, s.nawrocki@samsung.com, rjw@sisk.pl,
        viresh.kumar@linaro.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v4 2/3] Cpufreq: s5pv210 cpufreq fixes for CCF
Date: Sat, 21 Sep 2013 19:42:21 +0200
Message-id: <1379785342-25107-3-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1379785342-25107-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1379785342-25107-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jQd1Ft2yDDNr6zS0mrTvAZPG06Qe7
	xfwj51gtzr1ayWjRu+Aqm8XZpjfsFpseX2O1WNi2hMXi8q45bBafe48wWty+zGtxes0pZoul
	1y8CtU64yGYxYfpaFov+hb1MFodXAI1b93I6i8XhN+2sFq8OtrFYrJ/xmsXi2IwljBardv1h
	tNj41cNBwmPNvDWMHi3NPWweCz5fYff4u+oFs8fOWXfZPVYu/8Lm8Wr1TFaPO9f2sHlsXlLv
	cfDdHiaPvi2rGD0eLW5h9Pi8Sc5j49zQAL4oLpuU1JzMstQifbsEroxZzf3sBS85Klqe3GRv
	YNzM3sXIySEhYCLx+ehLVghbTOLCvfVsXYxcHEIC0xklDr3/xgThtDNJNFx4xgRSxSZgLjHx
	2SYWEFtEQFLiwefpLCBFzAIPWCRmPrrOCJIQFrCT2DnlBpjNIqAqcWDuP7BmXgE/iQt7n7JB
	rFOQ+Hn5BJjNKeAv0bhgAVi9EFDN7AddbBMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vO
	z93ECI6qZ1I7GFc2WBxiFOBgVOLhzUiyDRJiTSwrrsw9xCjBwawkwiuyCyjEm5JYWZValB9f
	VJqTWnyIUZqDRUmc90CrdaCQQHpiSWp2ampBahFMlomDU6qB8cjKcO+JLiJS/1M4V/y54MPy
	UeDz8UMBGd07je2cBKea77GQF7zdXPDW5jqTr2Tqv1VRPzRYZ65ympNab3v+RaY7r8hOLaeb
	kQf6Z6Yqp6hNexZj1cxRsC439XLo85huw4XC292SD+dNLVj6hTPUoHzNLqnkc1e5tH/E7Thn
	ZTop9P3bVx7nlViKMxINtZiLihMB0wwdrqYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common clock framework api to get clock.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/cpufreq/s5pv210-cpufreq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index 5c77570..33948d6 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -511,17 +511,17 @@ static int __init s5pv210_cpu_init(struct cpufreq_policy *policy)
 	unsigned long mem_type;
 	int ret;
 
-	cpu_clk = clk_get(NULL, "armclk");
+	cpu_clk = clk_get_sys("s5pv210-cpufreq", "armclk");
 	if (IS_ERR(cpu_clk))
 		return PTR_ERR(cpu_clk);
 
-	dmc0_clk = clk_get(NULL, "sclk_dmc0");
+	dmc0_clk = clk_get_sys("s5pv210-cpufreq", "sclk_dmc0");
 	if (IS_ERR(dmc0_clk)) {
 		ret = PTR_ERR(dmc0_clk);
 		goto out_dmc0;
 	}
 
-	dmc1_clk = clk_get(NULL, "hclk_msys");
+	dmc1_clk = clk_get_sys("s5pv210-cpufreq", "hclk_msys");
 	if (IS_ERR(dmc1_clk)) {
 		ret = PTR_ERR(dmc1_clk);
 		goto out_dmc1;
-- 
1.8.1.2

