Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934523AbaH0NPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:15:48 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:22630 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934440AbaH0NPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:15:47 -0400
From: Wang Nan <wangnan0@huawei.com>
To: Russell King <linux@arm.linux.org.uk>,
        "David A. Long" <dave.long@linaro.org>, Jon Medhurst <tixy@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Will Deacon <will.deacon@arm.com>
CC: Wang Nan <wangnan0@huawei.com>, Pei Feiyue <peifeiyue@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 0/3] kprobes: arm: enable OPTPROBES for ARM 32
Date: Wed, 27 Aug 2014 21:02:29 +0800
Message-ID: <1409144552-12751-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following 3 patches are the 5th version of kprobe optimization for arm.
The main difference is disallowing optimize stack store instructions,
such as "str r0, [sp]" and "push {r0 - r4}".

The first patch improve arm instruction decoder to detect such
instructions, following 2 patches make it unoptimizable.

Wang Nan (3):
  ARM: probes: check stack operation when decoding
  kprobes: copy ainsn after alloc aggr kprobe
  kprobes: arm: enable OPTPROBES for ARM 32

 arch/arm/Kconfig                 |   1 +
 arch/arm/include/asm/kprobes.h   |  28 +++++
 arch/arm/include/asm/probes.h    |   1 +
 arch/arm/kernel/Makefile         |   3 +-
 arch/arm/kernel/kprobes-common.c |   4 +
 arch/arm/kernel/kprobes-opt.c    | 259 +++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/probes-arm.c     |   4 +-
 arch/arm/kernel/probes-thumb.c   |   6 +-
 arch/arm/kernel/probes.c         |  20 ++-
 arch/arm/kernel/probes.h         |   6 +
 kernel/kprobes.c                 |   7 +-
 11 files changed, 330 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm/kernel/kprobes-opt.c

Cc: Russell King <linux@arm.linux.org.uk>
Cc: "David A. Long" <dave.long@linaro.org> 
Cc: Jon Medhurst <tixy@linaro.org>
Cc: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Will Deacon <will.deacon@arm.com>

-- 
1.8.4

