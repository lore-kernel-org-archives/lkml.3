Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbaFZQPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:15:13 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:49686 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753575AbaFZQPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:15:11 -0400
X-Yandex-Uniq: 7793d61b-4d4a-46c4-b4f9-2afb0afe51a6
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, dsahern@gmail.com, stfomichev@yandex-team.ru,
        jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/5] perf trace pagefaults
Date: Thu, 26 Jun 2014 20:14:23 +0400
Message-Id: <1403799268-1367-1-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for pagefaults tracing to 'perf trace' command.

v3:
  - added trace format documentation and example
  - added mode detailed trace when --verbose specified

v2:
  - added more info to the changelogs
  - reworked options (-f -> -F, --pgfaults -> --pf=[all|min|maj])
  - separated tracepoint_handler changes into additional patch
  - separated record/replay into additional patch
  - other fixes pointed out by Arnaldo Carvalho de Melo

Stanislav Fomichev (5):
  perf trace: add perf_event parameter to tracepoint_handler
  perf trace: add support for pagefault tracing
  perf trace: add pagefaults record and replay support
  perf trace: add pagefault statistics
  perf trace: add possibility to switch off syscall events

 tools/perf/Documentation/perf-trace.txt |  44 ++++++
 tools/perf/builtin-trace.c              | 248 +++++++++++++++++++++++++++-----
 2 files changed, 254 insertions(+), 38 deletions(-)

-- 
1.9.1

