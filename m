Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab3ARQ1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 11:27:36 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:63362 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3ARQ1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 11:27:34 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v3 0/2] perf stat: add interval counter printing
Date: Fri, 18 Jan 2013 17:26:47 +0100
Message-Id: <1358526409-9382-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patchset extends perf stat with the -I option.

The -I option enables interval printing. It expects
an interval duration in milliseconds. Minimum is
100ms. Once, activated perf stat prints events deltas
since last printout. All modes are supported.

$ perf stat -I 1000 -e cycles noploop 10
noploop for 10 seconds
1.000086918         2385155642 cycles                    #    0.000 GHz
2.000267937         2392279774 cycles                    #    0.000 GHz
3.000385400         2390971450 cycles                    #    0.000 GHz
4.000504408         2390996752 cycles                    #    0.000 GHz
5.000626878         2390853097 cycles                    #    0.000 GHz

The output format makes it easy to feed into a plotting program
such as gnuplot when the -I option is used in combination with the -x
option:

$ perf stat -x, -I 1000 -e cycles noploop 10
noploop for 10 seconds
1.000084113,2378775498,cycles
2.000245798,2391056897,cycles
3.000354445,2392089414,cycles
4.000459115,2390936603,cycles
5.000565341,2392108173,cycles

The first patch adds the code to keep previous counts. The second
is the actual extension of perf stat.

In v2, we changed the option from -T to -I based on feedback
from Andi Kleen (who is using -T in an upcoming patch).

In v3, added compute_deltas() to evsel.c to factorize
deltas computation based on Jiri's comments.

Signed-off-by: Stephane Eranian <eranian@google.com>

Stephane Eranian (2):
  perf tools: add evsel prev_raw_count field
  perf stat: add interval printing

 tools/perf/Documentation/perf-stat.txt |    4 +
 tools/perf/builtin-stat.c              |  157 ++++++++++++++++++++++++++++----
 tools/perf/util/evsel.c                |   26 ++++++
 tools/perf/util/evsel.h                |    1 +
 4 files changed, 172 insertions(+), 16 deletions(-)

-- 
1.7.9.5

