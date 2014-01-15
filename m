Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbaAOKoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:44:23 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58714 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbaAOKoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:44:20 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/3] Fix perf tool issues in tip/perf/core
Date: Wed, 15 Jan 2014 10:44:05 +0000
Message-Id: <1389782648-4417-1-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.8.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Arnaldo, Jiri,

While trying to fix perf tool cross-builds I noticed that in tip/perf/core
there are new build issues over v3.13-rc8: a build failure on x86_64, and a new
set of warnings on arm.

The following patches fix cross-building (at least for arm) and fix the new
build issues on both arm and x86_64.

Cheers,
Mark.

Mark Rutland (3):
  perf: tools: Fix aliasing violation in zfree uses
  tools lib traceevent: fix pointer-integer size mismatch
  perf: tools: fix cross building

 tools/lib/traceevent/plugin_cfg80211.c    | 2 +-
 tools/lib/traceevent/plugin_scsi.c        | 2 +-
 tools/perf/Makefile.perf                  | 1 +
 tools/perf/config/Makefile                | 6 +++---
 tools/perf/config/feature-checks/Makefile | 9 +++++----
 tools/perf/util/srcline.c                 | 4 ++--
 tools/perf/util/strlist.c                 | 2 +-
 7 files changed, 14 insertions(+), 12 deletions(-)

-- 
1.8.1.1

