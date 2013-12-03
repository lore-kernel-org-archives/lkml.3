Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3LCQKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:10:10 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:53479 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab3LCQKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:10:05 -0500
From: Jean Pihet <jean.pihet@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo <acme@ghostprotocols.net>, Will Deacon <will.deacon@arm.com>
Cc: patches@linaro.org, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH v2 0/2] perf: config: add per-feature check flags
Date: Tue,  3 Dec 2013 17:09:44 +0100
Message-Id: <1386086986-30805-1-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CFLAGS and LDFLAGS for each feature to be checked during the
build. This allows to pass particular flags and parameters to the
feature checks compilation.

Use the per-feature check flags for the unwinding feature in order
to correctly compile the libunwind and libunwind-debug-frame feature
checks.

This change set simplifies the flags passing mechanism between the
Makefiles in config/Makefile and config/feature-checks; this
could be farther optimized by moving the compilation flags to the
per-feature check flags for all features to be checked.

Tested on x86_64, ARMv7 and ARMv8 with and without LIBUNWIND_DIR=
set in 'make -C tools/perf'


Jean Pihet (2):
  perf: add per-feature check flags
  perf: unwinding: use the per-feature check flags

 tools/perf/config/Makefile                | 48 +++++++++++++++++--------------
 tools/perf/config/feature-checks/Makefile |  6 ++--
 2 files changed, 29 insertions(+), 25 deletions(-)

-- 
1.7.11.7

