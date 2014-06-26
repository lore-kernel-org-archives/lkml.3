Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbaFZQLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:11:37 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:45382 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757211AbaFZQLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:11:33 -0400
X-Yandex-Uniq: 7dd882a4-4845-47d4-917a-d2040fa130a9
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, stfomichev@yandex-team.ru, namhyung@kernel.org,
        artagnon@gmail.com, jolsa@redhat.com, bp@suse.de,
        rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/4] perf timechart io mode
Date: Thu, 26 Jun 2014 20:11:07 +0400
Message-Id: <1403799071-1252-1-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds IO mode: instead of process time we record io syscalls
and then draw timechart of writes/reads/tx/rx/polls.

v5:
  - converted consistency check errors to warnings so we can tolerate
    some perf.data errors
  - added more info to 'implement IO mode' changelog

v4:
  - another attempt for fix segfault when skipping invalid tracepoints
  - added new patch to fix rendering in Firefox

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

Stanislav Fomichev (4):
  perf timechart: fix rendering in Firefox
  perf timechart: implement IO mode
  perf timechart: conditionally update start_time on fork
  perf timechart: add more options to IO mode

 tools/perf/Documentation/perf-timechart.txt |  38 +-
 tools/perf/builtin-timechart.c              | 686 +++++++++++++++++++++++++++-
 tools/perf/util/svghelper.c                 | 168 +++++--
 tools/perf/util/svghelper.h                 |   6 +-
 4 files changed, 838 insertions(+), 60 deletions(-)

-- 
1.9.1

