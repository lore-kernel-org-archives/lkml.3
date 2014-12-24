Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaLXDPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 22:15:06 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:7428 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaLXDOA (ORCPT
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
Subject: [PATCH 0/7] ARM: hisi: enable HiP01 SoC
Date: Wed, 24 Dec 2014 03:09:55 +0000
Message-ID: <1419390602-193123-1-git-send-email-long.wanglong@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.200]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.549A2F47.0145,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 9b67a183f8ec7345f0dd7937022258f0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Xu Wei

This series patch enable Hisilicon HiP01 SoC. The HiP01 SoC series
chip is designed for networking product, it integrates a rich peripheral
interfaces to support network applications and supports both one 
core or dual cores and quad cores. The core is Cortex A9. 

This series patch rebased on Linux 3.19-rc1.

Best Regards

Wang Long (7):
  ARM: debug: add HiP01 debug uart
  ARM: hisi: enable HiP01 SoC
  ARM: dts: Add hip01-ca9x2 dts file
  ARM: config: enable ARCH_HIP01
  ARM: hisi: add a common smp_prepares_cpus function
  ARM: hisi: rename secondary_startup function
  ARM: hisi: enable smp for HiP01

 .../bindings/arm/hisilicon/hisilicon.txt           |  25 +++++
 arch/arm/Kconfig.debug                             |  10 ++
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/hip01-ca9x2.dts                  |  51 ++++++++++
 arch/arm/boot/dts/hip01.dtsi                       | 110 +++++++++++++++++++++
 arch/arm/configs/hisi_defconfig                    |   1 +
 arch/arm/configs/multi_v7_defconfig                |   1 +
 arch/arm/mach-hisi/Kconfig                         |   8 ++
 arch/arm/mach-hisi/core.h                          |   5 +-
 arch/arm/mach-hisi/headsmp.S                       |   2 +-
 arch/arm/mach-hisi/hisilicon.c                     |  10 ++
 arch/arm/mach-hisi/hotplug.c                       |  31 ++++++
 arch/arm/mach-hisi/platsmp.c                       |  56 ++++++++++-
 13 files changed, 306 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/boot/dts/hip01-ca9x2.dts
 create mode 100644 arch/arm/boot/dts/hip01.dtsi

-- 
1.8.3.4

