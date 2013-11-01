Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3KAQ2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:28:16 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:44049 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753647Ab3KAQ2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:28:13 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] perf timechart improvements
Date: Fri,  1 Nov 2013 20:25:44 +0400
Message-Id: <1383323151-19810-1-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds more features to the perf timechart command:
* -n option that adds possibility to limit number of tasks on SVG
* -T option that adds possibility to show only tasks related info
* -T and -P options now work with `perf timechart record` command to keep
  perf.data small
* -g option that adds possibility to record and add callchain to the SVG so
  it's now possible to understand why some task went to sleep or what code
  path woke it up
* add titles to the SVG blocks so it's possible to see how long task is
  running/sleeping/blocked

v2:
* fix errors pointed out by Namhyung Kim <namhyung@kernel.org>

Stanislav Fomichev (7):
  perf timechart: always try to print at least 15 tasks
  perf timechart: add option to limit number of tasks
  perf timechart: use proc_num to implement --power-only
  perf timechart: add support for displaying only tasks related data
  perf timechart: group figures and add title with details
  perf timechart: add support for -P and -T in timechart recording
  perf timechart: add backtrace support

 tools/perf/Documentation/perf-timechart.txt |  25 ++-
 tools/perf/builtin-timechart.c              | 307 ++++++++++++++++++++++------
 tools/perf/util/svghelper.c                 |  77 ++++++-
 tools/perf/util/svghelper.h                 |  11 +-
 4 files changed, 348 insertions(+), 72 deletions(-)

-- 
1.8.3.2

