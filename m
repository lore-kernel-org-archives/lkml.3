Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaHDE2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:28:21 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:10884 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaHDE2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:28:20 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <Marc.Zyngier@arm.com>, <will.deacon@arm.com>
CC: <nicolas.pitre@linaro.org>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <peifeiyue@huawei.com>, <liusdu@126.com>, <wangnan0@huawei.com>,
        <ebiederm@xmission.com>, Liu Hua <sdu.liu@huawei.com>
Subject: [PATCH V2 0/1] irqchip: GIC: check and clear GIC interupt active state
Date: Mon, 4 Aug 2014 12:17:39 +0800
Message-ID: <1407125860-37718-1-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.53DF0BE1.0072,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 080e987910c090976d518192da4c5550
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For this version of GIC codes, kernel assumes that all the interrupt
status of GIC is inactive. So the kernel does not check this when 
booting.

This is no problem on must sitations. But when kdump is deplayed.
And a panic occurs when an interrupt is being handled (may be PPI 
). We have no chance to write relative bit to GICC_EOIR. So this 
interrupt remains active. And GIC will not deliver this type 
interrupt to cpu interface. And the capture kernel may  fail to boot
becase of lacking of certain interrupt (such as timer interupt).

I have test this patch on arma9el(GIC v1), arma15el and arma15eb(GIC v2) 
platforms. And the tests passed.

changes from V1:

  - used for_each_set_bit instead of find_next_bit
  - removed the GIC version indentifying codes.
  - used one way to inactive GIC interupt states for all GIC version

Liu Hua (1):
  GIC: introduce method to deactive interupts

 drivers/irqchip/irq-gic.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

-- 
1.9.0

