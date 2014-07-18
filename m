Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739AbaGRFUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 01:20:35 -0400
Received: from relais.videotron.ca ([24.201.245.36]:62580 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760193AbaGRFUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 01:20:34 -0400
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 0/4] basic IPI tracing
Date: Fri, 18 Jul 2014 01:18:51 -0400
Message-id: <1405660735-13408-1-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the energy aware scheduler work is concerned by test and
measurement tools such as idlestat[1].  This relies on the ability to
trace wake-up events, mainly IRQs and IPIs.

While IRQs are already well instrumented with tracepoints, IPIs are rather
lacking on that front, and completely invisible on ARM.

This series defines generic IPI tracepoints and adds them to ARM and
ARM64. An attempt at adding them to X86 is also included for comments.

[1] https://wiki.linaro.org/WorkingGroups/PowerManagement/Resources/Tools/Idlestat

diffstat:

 arch/arm/kernel/smp.c      | 72 ++++++++++++++++++++------------
 arch/arm64/kernel/smp.c    | 67 +++++++++++++++++++-----------
 arch/x86/kernel/smp.c      | 16 ++++++++
 include/trace/events/ipi.h | 89 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 192 insertions(+), 52 deletions(-)
