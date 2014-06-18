Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbaFRPCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:02:55 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:44906 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbaFRPAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:00:54 -0400
X-Yandex-Uniq: e11e4595-6a91-4faf-b23b-ef3b97325e3b
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, dsahern@gmail.com, stfomichev@yandex-team.ru,
        jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/5] perf trace pagefaults
Date: Wed, 18 Jun 2014 18:59:20 +0400
Message-Id: <1403103565-6388-1-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for pagefaults tracing to 'perf trace' command.
It seems this feature was planned by Namhyung Kim (http://events.linuxfoundation.org/images/stories/pdf/klf2012_n_kim.pdf page 17/28)
but I couldn't find any prior patches/discussion and started from scratch.

First three patches add the feature and options to enable faults and disable
syscalls.
Two last patches add events caching (like it's done in the perf kvm), so that
we don't get fault events prior to mmap/comm events (makes sense only
for live mode).

This is just a proof-of-concept, and I'd like to get some comments about
where and what I got wrong and what additional useful information I can
expose in the trace.

Stanislav Fomichev (5):
  perf trace: add support for pagefault tracing
  perf trace: add pagefault statistics
  perf trace: add possibility to switch off syscall events
  perf kvm: move perf_kvm__mmap_read into session utils
  perf trace: add events cache

 tools/perf/Documentation/perf-trace.txt |  19 ++
 tools/perf/builtin-kvm.c                |  88 +-------
 tools/perf/builtin-trace.c              | 351 ++++++++++++++++++++++----------
 tools/perf/util/session.c               |  85 ++++++++
 tools/perf/util/session.h               |   5 +
 5 files changed, 353 insertions(+), 195 deletions(-)

-- 
1.8.3.2

