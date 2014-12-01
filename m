Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaLAIso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:48:44 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:2191 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbaLAIsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:48:43 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <tixy@linaro.org>, <masami.hiramatsu.pt@hitachi.com>,
        <linux@arm.linux.org.uk>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v11 0/7] ARM: kprobes: OPTPROBES and other improvements.
Date: Mon, 1 Dec 2014 16:45:13 +0800
Message-ID: <1417423513-47161-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.547C2B68.00D0,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 29f8ae1442f5c301de0fae44dbbd5449
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 11 of optprobe related patch series. I decide to merge
all related patches in one series to make my work easier. This series is
grouped by 3 different parts:

Patch 1/7 moves all ARM probe related code to arch/arm/probes according
to suggestion from Russell King.

Patch 2/7 - 5/7 introduce checker framework and use it to detect stack
consumption for each probed instructions. Previous discussion can
be found from:

https://lkml.org/lkml/2014/11/22/18
https://lkml.org/lkml/2014/11/21/55
https://lkml.org/lkml/2014/11/18/26

Patch 6/7 and 7/7 are for real optprobe work. Previous discussion can
be found from:

https://lkml.org/lkml/2014/11/19/31
https://lkml.org/lkml/2014/11/18/41
https://lkml.org/lkml/2014/10/25/48
https://lkml.org/lkml/2014/10/22/254
https://lkml.org/lkml/2014/8/27/255
https://lkml.org/lkml/2014/8/12/12
https://lkml.org/lkml/2014/8/8/992
https://lkml.org/lkml/2014/8/8/5
https://lkml.org/lkml/2014/8/5/63

The main modifications in this series are reside in patch 7/7. Please refer
to its own commit message.

Masami Hiramatsu (1):
  kprobes: Pass the original kprobe for preparing optimized kprobe

Wang Nan (6):
  ARM: probes: move all probe code to dedicate directory
  ARM: kprobes: introduces checker
  ARM: kprobes: collects stack consumption for store instructions
  ARM: kprobes: disallow probing stack consuming instructions
  ARM: kprobes: Add test cases for stack consuming instructions
  ARM: kprobes: enable OPTPROBES for ARM 32

 arch/arm/Kconfig                                 |   1 +
 arch/arm/Makefile                                |   1 +
 arch/arm/{kernel => include/asm}/insn.h          |   0
 arch/arm/include/asm/kprobes.h                   |  35 ++-
 arch/arm/{kernel => include/asm}/patch.h         |   0
 arch/arm/include/asm/probes.h                    |  13 +
 arch/arm/kernel/Makefile                         |  16 +-
 arch/arm/kernel/entry-armv.S                     |   3 +-
 arch/arm/kernel/ftrace.c                         |   3 +-
 arch/arm/kernel/jump_label.c                     |   5 +-
 arch/arm/kernel/patch.c                          |   3 +-
 arch/arm/probes/Makefile                         |  16 ++
 arch/arm/{kernel => probes}/kprobes-arm.c        |   3 +
 arch/arm/{kernel => probes}/kprobes-common.c     |   0
 arch/arm/probes/kprobes-opt-arm.c                | 343 +++++++++++++++++++++++
 arch/arm/{kernel => probes}/kprobes-test-arm.c   |  29 +-
 arch/arm/{kernel => probes}/kprobes-test-thumb.c |  12 +
 arch/arm/{kernel => probes}/kprobes-test.c       |   0
 arch/arm/{kernel => probes}/kprobes-test.h       |   0
 arch/arm/{kernel => probes}/kprobes-thumb.c      |   4 +
 arch/arm/{kernel => probes}/kprobes.c            |  17 +-
 arch/arm/{kernel => probes}/kprobes.h            |   7 +-
 arch/arm/{kernel => probes}/probes-arm.c         |   5 +-
 arch/arm/{kernel => probes}/probes-arm.h         |   3 +-
 arch/arm/probes/probes-checkers-arm.c            |  99 +++++++
 arch/arm/probes/probes-checkers-common.c         | 101 +++++++
 arch/arm/probes/probes-checkers-thumb.c          | 110 ++++++++
 arch/arm/probes/probes-checkers.h                |  54 ++++
 arch/arm/{kernel => probes}/probes-thumb.c       |  10 +-
 arch/arm/{kernel => probes}/probes-thumb.h       |   6 +-
 arch/arm/{kernel => probes}/probes.c             |  70 ++++-
 arch/arm/{kernel => probes}/probes.h             |  11 +-
 arch/arm/{kernel => probes}/uprobes-arm.c        |   0
 arch/arm/{kernel => probes}/uprobes.c            |   2 +-
 arch/arm/{kernel => probes}/uprobes.h            |   0
 arch/x86/kernel/kprobes/opt.c                    |   3 +-
 include/linux/kprobes.h                          |   3 +-
 kernel/kprobes.c                                 |   8 +-
 38 files changed, 942 insertions(+), 54 deletions(-)
 rename arch/arm/{kernel => include/asm}/insn.h (100%)
 rename arch/arm/{kernel => include/asm}/patch.h (100%)
 create mode 100644 arch/arm/probes/Makefile
 rename arch/arm/{kernel => probes}/kprobes-arm.c (98%)
 rename arch/arm/{kernel => probes}/kprobes-common.c (100%)
 create mode 100644 arch/arm/probes/kprobes-opt-arm.c
 rename arch/arm/{kernel => probes}/kprobes-test-arm.c (97%)
 rename arch/arm/{kernel => probes}/kprobes-test-thumb.c (98%)
 rename arch/arm/{kernel => probes}/kprobes-test.c (100%)
 rename arch/arm/{kernel => probes}/kprobes-test.h (100%)
 rename arch/arm/{kernel => probes}/kprobes-thumb.c (99%)
 rename arch/arm/{kernel => probes}/kprobes.c (97%)
 rename arch/arm/{kernel => probes}/kprobes.h (85%)
 rename arch/arm/{kernel => probes}/probes-arm.c (99%)
 rename arch/arm/{kernel => probes}/probes-arm.h (95%)
 create mode 100644 arch/arm/probes/probes-checkers-arm.c
 create mode 100644 arch/arm/probes/probes-checkers-common.c
 create mode 100644 arch/arm/probes/probes-checkers-thumb.c
 create mode 100644 arch/arm/probes/probes-checkers.h
 rename arch/arm/{kernel => probes}/probes-thumb.c (99%)
 rename arch/arm/{kernel => probes}/probes-thumb.h (92%)
 rename arch/arm/{kernel => probes}/probes.c (86%)
 rename arch/arm/{kernel => probes}/probes.h (97%)
 rename arch/arm/{kernel => probes}/uprobes-arm.c (100%)
 rename arch/arm/{kernel => probes}/uprobes.c (99%)
 rename arch/arm/{kernel => probes}/uprobes.h (100%)

-- 
1.8.4

