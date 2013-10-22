Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3JVLDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 07:03:35 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:39506 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753092Ab3JVLD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 07:03:28 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] perf timechart improvements
Date: Tue, 22 Oct 2013 14:56:46 +0400
Message-Id: <1382439412-23713-1-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.1.2
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

Stanislav Fomichev (6):
  perf timechart: always try to print at least 15 tasks
  perf timechart: use proc_num to implement --power-only
  perf timechart: add support for displaying only tasks related data
  perf timechart: group figures and add title with details
  perf timechart: add support for -P and -T in timechart recording
  perf timechart: add backtrace support

 tools/perf/builtin-timechart.c | 289 ++++++++++++++++++++++++++++++++---------
 tools/perf/util/svghelper.c    |  77 ++++++++++-
 tools/perf/util/svghelper.h    |  11 +-
 3 files changed, 305 insertions(+), 72 deletions(-)

-- 
1.8.1.2

