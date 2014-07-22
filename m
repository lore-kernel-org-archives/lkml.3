Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbaGVOTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:19:46 -0400
Received: from m12-14.163.com ([220.181.12.14]:44089 "EHLO m12-14.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbaGVOTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:19:44 -0400
X-Coremail-DSSMTP: 180.110.253.254
From: weiyj_lk@163.com
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH -next] ARM: mvebu: fix return value check in armada_xp_pmsu_cpufreq_init()
Date: Tue, 22 Jul 2014 22:18:08 +0800
Message-Id: <1406038688-26417-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: DsCowECJ90u3cs5T7XfNCQ--.26S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr4kCr4kWrWxAw4xJFWUurg_yoW3CFbEk3
	ySg3W7GrySgF42vr17uw45J3yaka1F9r48Zry8tw43ArW5Kr45uryktr98Jr93tw4vkFW3
	GrWfZrySkw17AjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUY1bytUUUUU==
X-Originating-IP: [180.110.253.254]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiJQDQ1k9pFtHyogAAsS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function clk_get() returns ERR_PTR()
and never returns NULL. The NULL test in the return value
check should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/arm/mach-mvebu/pmsu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
index c30b7d7..4f6ef6e 100644
--- a/arch/arm/mach-mvebu/pmsu.c
+++ b/arch/arm/mach-mvebu/pmsu.c
@@ -637,9 +637,9 @@ static int __init armada_xp_pmsu_cpufreq_init(void)
 		}
 
 		clk = clk_get(cpu_dev, 0);
-		if (!clk) {
+		if (IS_ERR(clk)) {
 			pr_err("Cannot get clock for CPU %d\n", cpu);
-			return -ENODEV;
+			return PTR_ERR(clk);
 		}
 
 		/*

