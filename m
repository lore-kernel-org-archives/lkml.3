Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaA2RpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 12:45:23 -0500
Received: from relais.videotron.ca ([24.201.245.36]:21485 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaA2RpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 12:45:20 -0500
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH v2 0/6] setting the table for integration of cpuidle with the
 scheduler
Date: Wed, 29 Jan 2014 12:45:07 -0500
Message-id: <1391017513-12995-1-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As everyone should know by now, we want to integrate the cpuidle
governor with the scheduler for a more efficient idling of CPUs.
In order to help the transition, this small patch series moves the
existing interaction with cpuidle from architecture code to generic
core code.  The ARM, PPC, SH and X86 architectures are concerned.
No functional change should have occurred yet.

@peterz: Are you willing to pick up those patches?

Change from v1:

- dropped removal of arch_cpu_idle_prepare()


 arch/arm/kernel/process.c                       | 16 +++------
 arch/powerpc/platforms/pseries/processor_idle.c |  5 +++
 arch/powerpc/platforms/pseries/setup.c          | 34 ++++++++-----------
 arch/sh/kernel/idle.c                           |  4 +--
 arch/x86/kernel/process.c                       |  5 +--
 kernel/Makefile                                 |  1 -
 kernel/cpu/Makefile                             |  1 -
 kernel/sched/Makefile                           |  2 +-
 kernel/{cpu => sched}/idle.c                    |  4 ++-
 9 files changed, 30 insertions(+), 42 deletions(-)


Nicolas





