Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaFJPFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:05:14 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:49668 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbaFJPFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:05:06 -0400
X-Yandex-Uniq: bab4ba8f-3c61-4892-8c8a-e9112e55a493
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: acme@kernel.org, namhyung@kernel.org, artagnon@gmail.com, jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] perf timechart io mode
Date: Tue, 10 Jun 2014 19:04:51 +0400
Message-Id: <1402412694-5996-1-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds IO mode: instead of process time we record io syscalls
and then draw timechart of writes/reads/tx/rx/polls.

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

 tools/perf/Documentation/perf-timechart.txt |  34 +-
 tools/perf/builtin-timechart.c              | 654 +++++++++++++++++++++++++++-
 tools/perf/util/svghelper.c                 |  98 ++++-
 tools/perf/util/svghelper.h                 |   6 +-
 4 files changed, 767 insertions(+), 25 deletions(-)

-- 
1.8.3.2

