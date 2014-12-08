Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaLHGbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:31:19 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:52054 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaLHGbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:31:18 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v14 0/7] ARM: kprobes: OPTPROBES and other improvements.
Date: Mon, 8 Dec 2014 14:27:20 +0800
Message-ID: <1418020040-68977-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.548545B3.027D,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 7cee8413bf8ebe27f6fb1053d0f2ca68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v14 of optprobe related patch series. This series fixes a bug
found by Tixy: a race between patch_text() and undef handler.

Previous discussions can be found:

https://lkml.org/lkml/2014/12/4/942
https://lkml.org/lkml/2014/12/4/4
https://lkml.org/lkml/2014/12/1/64
https://lkml.org/lkml/2014/11/22/18
https://lkml.org/lkml/2014/11/21/55
https://lkml.org/lkml/2014/11/18/26
https://lkml.org/lkml/2014/11/19/31
https://lkml.org/lkml/2014/11/18/41
https://lkml.org/lkml/2014/10/25/48
https://lkml.org/lkml/2014/10/22/254
https://lkml.org/lkml/2014/8/27/255
https://lkml.org/lkml/2014/8/12/12
https://lkml.org/lkml/2014/8/8/992
https://lkml.org/lkml/2014/8/8/5
https://lkml.org/lkml/2014/8/5/63



Jon Medhurst (1):
  ARM: kprobes: Add test cases for stack consuming instructions

Masami Hiramatsu (1):
  kprobes: Pass the original kprobe for preparing optimized kprobe

Wang Nan (5):
  ARM: probes: move all probe code to dedicate directory
  ARM: kprobes: introduces checker
  ARM: kprobes: collects stack consumption for store instructions
  ARM: kprobes: disallow probing stack consuming instructions
  ARM: kprobes: enable OPTPROBES for ARM 32

 arch/arm/Kconfig                                   |   1 +
 arch/arm/Makefile                                  |   1 +
 arch/arm/{kernel => include/asm}/insn.h            |   0
 arch/arm/include/asm/kprobes.h                     |  30 +-
 arch/arm/{kernel => include/asm}/patch.h           |   0
 arch/arm/include/asm/probes.h                      |  13 +
 arch/arm/kernel/Makefile                           |  16 +-
 arch/arm/kernel/entry-armv.S                       |   3 +-
 arch/arm/kernel/ftrace.c                           |   3 +-
 arch/arm/kernel/jump_label.c                       |   5 +-
 arch/arm/kernel/patch.c                            |   3 +-
 arch/arm/probes/Makefile                           |   7 +
 .../{kernel/probes-arm.c => probes/decode-arm.c}   |  12 +-
 .../{kernel/probes-arm.h => probes/decode-arm.h}   |   7 +-
 .../probes-thumb.c => probes/decode-thumb.c}       |  16 +-
 .../probes-thumb.h => probes/decode-thumb.h}       |  10 +-
 arch/arm/{kernel/probes.c => probes/decode.c}      |  74 ++++-
 arch/arm/{kernel/probes.h => probes/decode.h}      |  13 +-
 arch/arm/probes/kprobes/Makefile                   |  12 +
 .../kprobes-arm.c => probes/kprobes/actions-arm.c} |   9 +-
 .../kprobes/actions-common.c}                      |   4 +-
 .../kprobes/actions-thumb.c}                       |  10 +-
 arch/arm/probes/kprobes/checkers-arm.c             |  99 +++++++
 arch/arm/probes/kprobes/checkers-common.c          | 101 +++++++
 arch/arm/probes/kprobes/checkers-thumb.c           | 110 +++++++
 arch/arm/probes/kprobes/checkers.h                 |  54 ++++
 .../{kernel/kprobes.c => probes/kprobes/core.c}    |  23 +-
 .../{kernel/kprobes.h => probes/kprobes/core.h}    |  10 +-
 arch/arm/probes/kprobes/opt-arm.c                  | 322 +++++++++++++++++++++
 .../kprobes/test-arm.c}                            |  31 +-
 .../kprobes-test.c => probes/kprobes/test-core.c}  |   8 +-
 .../kprobes-test.h => probes/kprobes/test-core.h}  |   2 +-
 .../kprobes/test-thumb.c}                          |  16 +-
 arch/arm/probes/uprobes/Makefile                   |   2 +
 .../uprobes-arm.c => probes/uprobes/actions-arm.c} |   6 +-
 .../{kernel/uprobes.c => probes/uprobes/core.c}    |   8 +-
 .../{kernel/uprobes.h => probes/uprobes/core.h}    |   0
 arch/x86/kernel/kprobes/opt.c                      |   3 +-
 include/linux/kprobes.h                            |   3 +-
 kernel/kprobes.c                                   |   4 +-
 samples/kprobes/kprobe_example.c                   |   2 +-
 41 files changed, 961 insertions(+), 92 deletions(-)
 rename arch/arm/{kernel => include/asm}/insn.h (100%)
 rename arch/arm/{kernel => include/asm}/patch.h (100%)
 create mode 100644 arch/arm/probes/Makefile
 rename arch/arm/{kernel/probes-arm.c => probes/decode-arm.c} (99%)
 rename arch/arm/{kernel/probes-arm.h => probes/decode-arm.h} (93%)
 rename arch/arm/{kernel/probes-thumb.c => probes/decode-thumb.c} (98%)
 rename arch/arm/{kernel/probes-thumb.h => probes/decode-thumb.h} (90%)
 rename arch/arm/{kernel/probes.c => probes/decode.c} (85%)
 rename arch/arm/{kernel/probes.h => probes/decode.h} (97%)
 create mode 100644 arch/arm/probes/kprobes/Makefile
 rename arch/arm/{kernel/kprobes-arm.c => probes/kprobes/actions-arm.c} (98%)
 rename arch/arm/{kernel/kprobes-common.c => probes/kprobes/actions-common.c} (98%)
 rename arch/arm/{kernel/kprobes-thumb.c => probes/kprobes/actions-thumb.c} (98%)
 create mode 100644 arch/arm/probes/kprobes/checkers-arm.c
 create mode 100644 arch/arm/probes/kprobes/checkers-common.c
 create mode 100644 arch/arm/probes/kprobes/checkers-thumb.c
 create mode 100644 arch/arm/probes/kprobes/checkers.h
 rename arch/arm/{kernel/kprobes.c => probes/kprobes/core.c} (96%)
 rename arch/arm/{kernel/kprobes.h => probes/kprobes/core.h} (83%)
 create mode 100644 arch/arm/probes/kprobes/opt-arm.c
 rename arch/arm/{kernel/kprobes-test-arm.c => probes/kprobes/test-arm.c} (97%)
 rename arch/arm/{kernel/kprobes-test.c => probes/kprobes/test-core.c} (99%)
 rename arch/arm/{kernel/kprobes-test.h => probes/kprobes/test-core.h} (99%)
 rename arch/arm/{kernel/kprobes-test-thumb.c => probes/kprobes/test-thumb.c} (98%)
 create mode 100644 arch/arm/probes/uprobes/Makefile
 rename arch/arm/{kernel/uprobes-arm.c => probes/uprobes/actions-arm.c} (98%)
 rename arch/arm/{kernel/uprobes.c => probes/uprobes/core.c} (97%)
 rename arch/arm/{kernel/uprobes.h => probes/uprobes/core.h} (100%)

-- 
1.8.4

