Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab3KUOwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:52:37 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:53745 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab3KUOwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:52:34 -0500
From: Jean Pihet <jean.pihet@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Arnaldo <acme@ghostprotocols.net>
Cc: patches@linaro.org, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 0/2] perf: config: add per-feature check flags
Date: Thu, 21 Nov 2013 15:52:17 +0100
Message-Id: <1385045539-24537-1-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CFLAGS and LDFLAGS for each feature to be checked. This allows
to pass flags and parameters to the feature checks compilation.

Use the per-feature check flags for the unwinding feature in order
to correctly compile the libunwind and libunwind-debug-frame feature
checks.

This change set simplifies the flags passing mechanism between the
Makefiles in config/Makefile and config/feature-checks; this
could be farther optimized by moving the compilation flags to the
per-feature check flags for all features to be checked.

Tested on ARMv7 and ARMv8 with 'make DEBUG=1 LIBUNWIND_DIR=/usr/local
-C tools/perf'


Jean Pihet (2):
  perf: add per-feature check flags
  perf: unwinding: use the per-feature check flags

 tools/perf/config/Makefile                | 38 +++++++++++++++++--------------
 tools/perf/config/feature-checks/Makefile |  6 ++---
 2 files changed, 24 insertions(+), 20 deletions(-)

-- 
1.7.11.7

