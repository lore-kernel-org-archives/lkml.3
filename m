Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3IXMuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:50:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51918 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3IXMuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:50:46 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-14-52418aa425ad
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: rjw@sisk.pl, kgene.kim@samsung.com
Cc: viresh.kumar@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        kyungmin.park@samsung.com, ben-linux@fluff.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net, mturquette@linaro.org,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        s.nawrocki@samsung.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, t.stanislaws@samsung.com,
        m.szyprowski@samsung.com, b.zolnierkie@samsung.com,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v5 2/3] Cpufreq: s5pv210 cpufreq fixes for CCF
Date: Tue, 24 Sep 2013 14:50:08 +0200
Message-id: <1380027009-2239-3-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1380027009-2239-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1380027009-2239-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jAd2lXY5BBmumsltsnLGe1WLSugNM
	Fk+bfrBbzD9yjtXi3KuVjBa9C66yWZxtesNusenxNVaLhW1LWCwu75rDZvG59wijxYzz+5gs
	bl/mtTi95hSzxdojd9ktll6/CDRkwkU2iwnT17JY9C/sZbI4vAJo8LqX01ksDr9pZ7V4dbCN
	xWJe+0tWi2MzljBarNr1h9Fi41cPB2mPNfPWMHq0NPeweSz4fIXd4++qF8weO2fdZfdYufwL
	m8er1TNZPe5c28PmsXlJvcfBd3uYPPq2rGL0eLS4hdHj8yY5j41zQwP4orhsUlJzMstSi/Tt
	ErgyZjX3sxe85KhoeXKTvYFxM3sXIyeHhICJxO0pi5ghbDGJC/fWs3UxcnEICSxilDjV3sIK
	khASaGeSaHtoC2KzCZhLTHy2iaWLkYNDREBNYuomZ5B6ZoFNrBL/P/aDDRUWsJM4v/E0E0gN
	i4CqxPGrPCBhXgFfidmnL7BC7FKQ+Hn5BBuIzSngJzHj3TdmiFW+Evv+b2WawMi7gJFhFaNo
	akFyQXFSeq6RXnFibnFpXrpecn7uJkZwtD2T3sG4qsHiEKMAB6MSD++FBIcgIdbEsuLK3EOM
	EhzMSiK8mrWOQUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeWpGanphakFsFkmTg4
	pRoY7e7OvbWxjr9N3abkiwXf9jAtvtQ+HxHPRpm0xfOaOxqMftYkZDSE6Exxef413Crgx+8E
	jgJB1RkneR8q9qp4se6JuM/tPNmqs/RQ5+dZ977de26UuuPkzpf2vq/WLt7H33E4V9d0m4/1
	lO/zwja++8/bLNV85aJEE9c0uSNnHXcbrNj/JOuNEktxRqKhFnNRcSIAxbzvDLICAAA=
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

