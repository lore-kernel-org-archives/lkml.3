Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaGGNpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:45:33 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:59051 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaGGNpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:45:31 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>, steve.capper@linaro.org,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 0/3] ARM: perf: allow tracing with kernel tracepoints events
Date: Mon,  7 Jul 2014 15:45:07 +0200
Message-Id: <1404740710-14691-1-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Robustify the user backtrace code, as done on other architectures.
- Provide the symbols resolution when triggering from tracepoints.

Big thanks to Steve Capper for the help in debugging and rephrasing the
commits descriptions.

Stress tested with perf record and tracepoints triggering (-e <tracepoint>),
with unwinding using fp (--call-graph fp) and dwarf info (--call-graph dwarf).


Jean Pihet (3):
  ARM: perf: Check that current->mm is alive before getting user
    callchain
  ARM: perf: disable the pagefault handler when reading from user space
  ARM: perf: allow tracing with kernel tracepoints events

 arch/arm/include/asm/perf_event.h | 19 +++++++++++++++++++
 arch/arm/kernel/perf_event.c      | 13 +++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

-- 
1.8.1.2

