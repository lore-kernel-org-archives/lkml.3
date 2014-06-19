Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbaFSMXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:23:46 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:55144 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932717AbaFSMXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:23:43 -0400
X-Yandex-Uniq: 826b74e1-ebbf-489a-ac74-396b058dfdef
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, stfomichev@yandex-team.ru, namhyung@kernel.org,
        artagnon@gmail.com, jolsa@redhat.com, rusty@rustcorp.com.au,
        bp@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] perf timechart io mode
Date: Thu, 19 Jun 2014 16:23:00 +0400
Message-Id: <1403180583-12309-1-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds IO mode: instead of process time we record io syscalls
and then draw timechart of writes/reads/tx/rx/polls.

v3:
  - fixed segfault when skipping invalid tracepoints
  - added ms/us units support for --io-xyz time options
  - fixed missing boxes on Firefox

v2:
  - separated start_time fix into distinct commit
  - separated --io-xyz options into distinct commit
  - fixed 'error' shadowing
  - initialized variables in declaration when possible
  - removed assert usage
  - fprintf -> pr_err
  - removed wrongly placed __maybe_unused

Stanislav Fomichev (3):
  perf timechart: implement IO mode
  perf timechart: conditionally update start_time on fork
  perf timechart: add more options to IO mode

 tools/perf/Documentation/perf-timechart.txt |  38 +-
 tools/perf/builtin-timechart.c              | 686 +++++++++++++++++++++++++++-
 tools/perf/util/svghelper.c                 |  98 +++-
 tools/perf/util/svghelper.h                 |   6 +-
 4 files changed, 803 insertions(+), 25 deletions(-)

-- 
1.8.3.2

