Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaLXDOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 22:14:04 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:7422 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaLXDN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 22:13:59 -0500
From: Wang Long <long.wanglong@huawei.com>
To: <xuwei5@hisilicon.com>
CC: <arnd@arndb.de>, <yanhaifeng@gmail.com>, <zhangfei.gao@linaro.org>,
        <haojian.zhuang@linaro.org>, <khilman@linaro.org>,
        <lee.jones@linaro.org>, <linux@arm.linux.org.uk>,
        <long.wanglong@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <peifeiyue@huawei.com>,
        <huxinwei@huawei.com>
Subject: [PATCH 5/7] ARM: hisi: add a common smp_prepares_cpus function
Date: Wed, 24 Dec 2014 03:10:00 +0000
Message-ID: <1419390602-193123-6-git-send-email-long.wanglong@huawei.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1419390602-193123-1-git-send-email-long.wanglong@huawei.com>
References: <1419390602-193123-1-git-send-email-long.wanglong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.200]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.549A2F3E.0101,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 22fd0f6180f5e66bcd2a4870b1fbbfa7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As hix5hd2 and hip01 has the same .smp_prepare_cpus
in struct smp_operations, so rename hix5hd2_smp_prepare_cpus
to hisi_common_smp_prepare_cpus.

the hip01 will use hisi_common_smp_prepare_cpus in its
struct smp_operations.

Signed-off-by: Wang Long <long.wanglong@huawei.com>
---
 arch/arm/mach-hisi/platsmp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-hisi/platsmp.c b/arch/arm/mach-hisi/platsmp.c
index 575dd82..b3c3a58 100644
--- a/arch/arm/mach-hisi/platsmp.c
+++ b/arch/arm/mach-hisi/platsmp.c
@@ -96,7 +96,7 @@ struct smp_operations hi3xxx_smp_ops __initdata = {
 #endif
 };
 
-static void __init hix5hd2_smp_prepare_cpus(unsigned int max_cpus)
+static void __init hisi_common_smp_prepare_cpus(unsigned int max_cpus)
 {
 	hisi_enable_scu_a9();
 }
@@ -125,7 +125,7 @@ static int hix5hd2_boot_secondary(unsigned int cpu, struct task_struct *idle)
 
 
 struct smp_operations hix5hd2_smp_ops __initdata = {
-	.smp_prepare_cpus	= hix5hd2_smp_prepare_cpus,
+	.smp_prepare_cpus	= hisi_common_smp_prepare_cpus,
 	.smp_boot_secondary	= hix5hd2_boot_secondary,
 #ifdef CONFIG_HOTPLUG_CPU
 	.cpu_die		= hix5hd2_cpu_die,
-- 
1.8.3.4

