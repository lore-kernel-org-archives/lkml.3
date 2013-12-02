Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3LBOiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:38:12 -0500
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:41239 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935Ab3LBOiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:38:04 -0500
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, stfomichev@yandex-team.ru,
        namhyung@kernel.org, artagnon@gmail.com, jolsa@redhat.com
Subject: [PATCH 0/5] perf timechart improvements part 2
Date: Mon,  2 Dec 2013 18:37:32 +0400
Message-Id: <1385995056-20158-1-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series has the following features:
- adds backtrace info to the CPU overview chart
- adds pid info to the figures on CPU overview chart
- we now read number of CPUs from the perf.data header (this makes CPU overview
  more accurate since it shows idle cores)
- adds '-t' option to sort CPUs (on the CPU overview chart) topologically (draw
  adjacent SMT threads next to each other)
- adds '-e' option to highlight long events on the CPU overview chart

Stanislav Fomichev (5):
  perf timechart: add backtrace support to CPU info
  perf timechart: print pid along the name
  perf timechart: get number of CPUs from perf header
  perf timechart: add support for topology
  perf timechart: add emphasize option

 tools/perf/Documentation/perf-timechart.txt |   7 ++
 tools/perf/builtin-timechart.c              |  79 ++++++++++++--
 tools/perf/util/svghelper.c                 | 159 ++++++++++++++++++++++++++--
 tools/perf/util/svghelper.h                 |   6 +-
 4 files changed, 235 insertions(+), 16 deletions(-)

-- 
1.8.3.2

