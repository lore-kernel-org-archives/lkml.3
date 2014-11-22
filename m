Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaKVIn2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 03:43:28 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:57141 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaKVIn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 03:43:26 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <tixy@linaro.org>, <masami.hiramatsu.pt@hitachi.com>
CC: <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <taras.kondratiuk@linaro.org>, <ben.dooks@codethink.co.uk>,
        <cl@linux.com>, <rabin@rab.in>, <davem@davemloft.net>,
        <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v4 0/4] ARM: kprobes: introduces instruction checker.
Date: Sat, 22 Nov 2014 16:40:09 +0800
Message-ID: <1416645613-38904-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020208.54704CAA.0114,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 547683265885ef7c89eca6bfc584d5c5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the 4th version of instruction checker patch. Version 10 of ARM
OPTPROBE patch series can be rebase to this series cleanly.

Previous discussion can be found from:

https://lkml.org/lkml/2014/11/21/55
https://lkml.org/lkml/2014/11/18/26
https://lkml.org/lkml/2014/10/25/48
https://lkml.org/lkml/2014/10/22/254
https://lkml.org/lkml/2014/8/27/255
https://lkml.org/lkml/2014/8/12/12
https://lkml.org/lkml/2014/8/8/992
https://lkml.org/lkml/2014/8/8/5
https://lkml.org/lkml/2014/8/5/63

Thanks to Tixy, he found some bugs in my previous checker decoding
table and fixed it. He also provided some more test cases about
probing stack consuming instructions. See patch 4/4.

Jon Medhurst (1):
  ARM: kprobes: Add test cases for stack consuming instructions

Wang Nan (3):
  ARM: kprobes: introduces checker
  ARM: kprobes: collects stack consumption for store instructions
  ARM: kprobes: disallow probing stack consuming instructions

 arch/arm/include/asm/kprobes.h           |   1 -
 arch/arm/include/asm/probes.h            |  13 ++++
 arch/arm/kernel/Makefile                 |   6 +-
 arch/arm/kernel/entry-armv.S             |   3 +-
 arch/arm/kernel/kprobes-arm.c            |   3 +
 arch/arm/kernel/kprobes-test-arm.c       |  29 ++++++--
 arch/arm/kernel/kprobes-test-thumb.c     |  12 ++++
 arch/arm/kernel/kprobes-thumb.c          |   4 ++
 arch/arm/kernel/kprobes.c                |  15 ++++-
 arch/arm/kernel/kprobes.h                |   7 +-
 arch/arm/kernel/probes-arm.c             |   5 +-
 arch/arm/kernel/probes-arm.h             |   3 +-
 arch/arm/kernel/probes-checkers-arm.c    |  99 ++++++++++++++++++++++++++++
 arch/arm/kernel/probes-checkers-common.c | 101 ++++++++++++++++++++++++++++
 arch/arm/kernel/probes-checkers-thumb.c  | 110 +++++++++++++++++++++++++++++++
 arch/arm/kernel/probes-checkers.h        |  54 +++++++++++++++
 arch/arm/kernel/probes-thumb.c           |  10 +--
 arch/arm/kernel/probes-thumb.h           |   6 +-
 arch/arm/kernel/probes.c                 |  70 ++++++++++++++++++--
 arch/arm/kernel/probes.h                 |  11 +++-
 arch/arm/kernel/uprobes.c                |   2 +-
 21 files changed, 533 insertions(+), 31 deletions(-)
 create mode 100644 arch/arm/kernel/probes-checkers-arm.c
 create mode 100644 arch/arm/kernel/probes-checkers-common.c
 create mode 100644 arch/arm/kernel/probes-checkers-thumb.c
 create mode 100644 arch/arm/kernel/probes-checkers.h

-- 
1.8.4

