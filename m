Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaGLAHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 20:07:35 -0400
Received: from lhrrgout.huawei.com ([194.213.3.17]:59207 "EHLO
	lhrrgout.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbaGLAHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 20:07:34 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <tglx@linutronix.de>, <jason@lakedaemon.net>, <nicolas.pitre@linaro.org>,
        <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <ebiederm@xmission.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wangnan0@huawei.com>, <liuxueliu.liu@huawei.com>,
        <peifeiyue@huawei.com>, <liusdu@huawei.com>,
        Liu Hua <sdu.liu@huawei.com>
Subject: [RFC PATCH 0/2] irqchip: GIC: check and clear GIC interupt active status
Date: Fri, 11 Jul 2014 14:46:15 +0800
Message-ID: <1405061177-43834-1-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For this version of GIC codes, kernel assumes that all the interrupt
status of GIC is inactive. So the kernel does not check this when 
booting.

This is no problem on must sitations. But when kdump is deplayed.
And a panic occurs when a interrupt is being handled (may be PPI 
and SPI). We have no chance to write relative bit to GICC_EOIR.
So this interrupt remains active. And GIC will not deliver this
type interrupt to cpu interface. And the capture kernel may 
fail to boot becase of lacking of certain interrupt (such as timer 
interupt).


I glanced over the GIC Architecture Specification, but did not 
find a simple way to deactive state of all interrupts. For GICv1,
I can only deal with one abnormal interrupt state one time. For 
GICv2, I can deactive 32 one time.


So guys, Do you know a better way to do that? 


Liu Hua (2):
  irqchip: gic: introduce ICPIDR2 register interface
  irqchip: GIC: introduce method to deactive interupts

 drivers/irqchip/irq-gic.c       | 57 +++++++++++++++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic.h |  1 +
 2 files changed, 58 insertions(+)

-- 
1.9.0

