Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaIMKj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 06:39:28 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:14095 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbaIMKjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 06:39:21 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: linux-kernel@vger.kernel.org
Cc: Yann Droneaud <ydroneaud@opteya.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        William Cohen <wcohen@redhat.com>
Subject: [PATCH 0/2] perf tool: improve error handling in perf_flag_probe()
Date: Sat, 13 Sep 2014 10:46:22 +0200
Message-Id: <cover.1410595700.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following the EBUSY errors reported by Jiri Olsa [1], I've tryed to
improve a bit the way perf_flag_probe() handle errors.

In case EBUSY is returned by perf_event_open(), testing the function
again without PERF_FLAG_FD_CLOEXEC is meaningless: EBUSY is not
related to close-on-exec flag, so there's nothing to confirm.

For other errors, not yet handled by perf_flag_probe(), it's
pointless to report a second error message for the same error code:
the second check should not print an error if the error is the same
as the one return for the first check.

[1] http://lkml.kernel.org/r/1406908014-8312-1-git-send-email-jolsa@kernel.org

Yann Droneaud (2):
  perf tools: shortcut PERF_FLAG_FD_CLOEXEC probing in case of EBUSY
    error
  perf tools: report PERF_FLAG_FD_CLOEXEC probing error once

 tools/perf/util/cloexec.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: William Cohen <wcohen@redhat.com>
-- 
1.9.3

