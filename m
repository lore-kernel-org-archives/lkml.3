Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaF0O6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:58:08 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63721 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaF0O6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:58:06 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, Sneha Priya <sneha.cse@hotmail.com>,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 0/3] ARM: perf: allow tracing with kernel tracepoints events
Date: Fri, 27 Jun 2014 16:57:44 +0200
Message-Id: <1403881067-22690-1-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Robustify the user backtrace code, as done on other architectures.
- Provide the symbols resolution when triggering from tracepoints.

Tested with perf record and tracepoints triggering (-e <tracepoint>), with
unwinding using fp (--call-graph fp) and dwarf info (--call-graph dwarf).


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

