Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab3GEKUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 06:20:10 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36196 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab3GEKUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 06:20:08 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/4] Minor perf build fixes
Date: Fri,  5 Jul 2013 15:46:13 +0530
Message-Id: <1373019377-12741-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.722.g3244e19.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After Namhyung's review of the first iteration, I realized that I'd
made a few mistakes.  This iteration should be much better.

[1/4] is the same as before.

[2/4] is new, and is used in [4/4].

[3/4] introduces a util/perf-perl.h to include <perl.h> with #pragma
statements, hence eliminating duplication.  It then updates Context.xs
and trace-event-perl.c to use this new header.

Also, notice that feature-tests.mak has not been touched in this
iteration: the Perl check passes without needing the #pragma
statements (although I'm not sure why exactly).

Thanks.

Ramkumar Ramachandra (4):
  perf/Makefile: do not open-code shell-sq
  perf/Perf-Trace-Util: fix broken include in Context.xs
  perf: squelch warnings from perl.h to compile-pass
  perf/Perf-Trace-Util: regenerate Context.c

 tools/perf/Makefile                                |   2 +-
 tools/perf/config/Makefile                         |  23 ++-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  | 215 +++++++++++++++++----
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |   6 +-
 tools/perf/util/perf-perl.h                        |  10 +
 .../perf/util/scripting-engines/trace-event-perl.c |   2 +-
 6 files changed, 199 insertions(+), 59 deletions(-)
 create mode 100644 tools/perf/util/perf-perl.h

-- 
1.8.3.1.643.gebeea52.dirty

