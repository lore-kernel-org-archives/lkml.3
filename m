Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaA0GYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 01:24:14 -0500
Received: from relais.videotron.ca ([24.201.245.36]:51663 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaA0GYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 01:24:12 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jan 2014 01:24:12 EST
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 0/9] setting the table for integration of cpuidle with the
 scheduler
Date: Mon, 27 Jan 2014 01:08:15 -0500
Message-id: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As everyone should know by now, we want to integrate the cpuidle
governor with the scheduler for a more efficient idling of CPUs.
In order to help the transition, this small patch series moves the
existing interaction with cpuidle from architecture code to generic
core code.  No functional change should have occurred yet.

The ARM, PPC, SH and X86 architectures are concerned.  Small cleanups
to ARM and ARM64 are also included. I don't know yet the best path for
those patches to get into mainline, but it is probably best if they
stay together. So ACKs from architecture maintainers would be greatly
appreciated.


 arch/arm/kernel/process.c                       | 21 +++---------
 arch/arm/kernel/setup.c                         |  7 ++++
 arch/arm64/kernel/process.c                     |  5 ---
 arch/arm64/kernel/setup.c                       |  7 ++++
 arch/powerpc/platforms/pseries/processor_idle.c |  5 +++
 arch/powerpc/platforms/pseries/setup.c          | 34 ++++++++-----------
 arch/sh/kernel/idle.c                           |  4 +--
 arch/x86/kernel/process.c                       |  5 +--
 include/linux/cpu.h                             |  1 -
 kernel/Makefile                                 |  1 -
 kernel/cpu/Makefile                             |  1 -
 kernel/sched/Makefile                           |  2 +-
 kernel/{cpu => sched}/idle.c                    |  6 ++--
 13 files changed, 44 insertions(+), 55 deletions(-)


Nicolas

