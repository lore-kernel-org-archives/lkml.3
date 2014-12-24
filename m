Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbaLXDOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 22:14:05 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:7424 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaLXDOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 22:14:00 -0500
From: Wang Long <long.wanglong@huawei.com>
To: <xuwei5@hisilicon.com>
CC: <arnd@arndb.de>, <yanhaifeng@gmail.com>, <zhangfei.gao@linaro.org>,
        <haojian.zhuang@linaro.org>, <khilman@linaro.org>,
        <lee.jones@linaro.org>, <linux@arm.linux.org.uk>,
        <long.wanglong@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <peifeiyue@huawei.com>,
        <huxinwei@huawei.com>
Subject: [PATCH 6/7] ARM: hisi: rename secondary_startup function
Date: Wed, 24 Dec 2014 03:10:01 +0000
Message-ID: <1419390602-193123-7-git-send-email-long.wanglong@huawei.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1419390602-193123-1-git-send-email-long.wanglong@huawei.com>
References: <1419390602-193123-1-git-send-email-long.wanglong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.200]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.549A2F3E.0237,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 1eabafe99d18690253cb81fb6fcddd04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As hix5hd2 and hip01 has the same secondary_startup
so rename hix5hd2_secondary_startup to
to hisi_secondary_startup.

the hip01 will use hisi_secondary_startup for the
secondary core boot.

Signed-off-by: Wang Long <long.wanglong@huawei.com>
---
 arch/arm/mach-hisi/core.h    | 2 +-
 arch/arm/mach-hisi/headsmp.S | 2 +-
 arch/arm/mach-hisi/platsmp.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-hisi/core.h b/arch/arm/mach-hisi/core.h
index 88b1f48..75520b0 100644
--- a/arch/arm/mach-hisi/core.h
+++ b/arch/arm/mach-hisi/core.h
@@ -12,7 +12,7 @@ extern void hi3xxx_cpu_die(unsigned int cpu);
 extern int hi3xxx_cpu_kill(unsigned int cpu);
 extern void hi3xxx_set_cpu(int cpu, bool enable);
 
-extern void hix5hd2_secondary_startup(void);
+extern void hisi_secondary_startup(void);
 extern struct smp_operations hix5hd2_smp_ops;
 extern void hix5hd2_set_cpu(int cpu, bool enable);
 extern void hix5hd2_cpu_die(unsigned int cpu);
diff --git a/arch/arm/mach-hisi/headsmp.S b/arch/arm/mach-hisi/headsmp.S
index 278889c..81e35b1 100644
--- a/arch/arm/mach-hisi/headsmp.S
+++ b/arch/arm/mach-hisi/headsmp.S
@@ -11,6 +11,6 @@
 
 	__CPUINIT
 
-ENTRY(hix5hd2_secondary_startup)
+ENTRY(hisi_secondary_startup)
 	bl	v7_invalidate_l1
 	b	secondary_startup
diff --git a/arch/arm/mach-hisi/platsmp.c b/arch/arm/mach-hisi/platsmp.c
index b3c3a58..4a70f56 100644
--- a/arch/arm/mach-hisi/platsmp.c
+++ b/arch/arm/mach-hisi/platsmp.c
@@ -116,7 +116,7 @@ static int hix5hd2_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	phys_addr_t jumpaddr;
 
-	jumpaddr = virt_to_phys(hix5hd2_secondary_startup);
+	jumpaddr = virt_to_phys(hisi_secondary_startup);
 	hix5hd2_set_scu_boot_addr(HIX5HD2_BOOT_ADDRESS, jumpaddr);
 	hix5hd2_set_cpu(cpu, true);
 	arch_send_wakeup_ipi_mask(cpumask_of(cpu));
-- 
1.8.3.4

