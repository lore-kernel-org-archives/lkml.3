Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaATLqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:46:46 -0500
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:38937 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbaATLqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:46:37 -0500
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jan 2014 06:46:37 EST
X-Yandex-Uniq: 75a4ac6f-d268-4e4b-8eba-99f808969fc3
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, stfomichev@yandex-team.ru,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] perf fixes
Date: Mon, 20 Jan 2014 15:39:37 +0400
Message-Id: <1390217980-22424-1-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains couple of unrelated changes. I already sent two of them
(perf util, perf tools) to the lkml but didn't get any response.
Thus resending them along with new perf timechart fix.

- perf timechart: fix wrong SVG height
  removes unused empty space from generated SVG when called with -p 0 option

- perf util: free cpu_map in perf_session__cpu_bitmap
  frees temporary cpu_map

- perf tools: bring back old behavior when NO_DEMAGLE doesn't link with libbfd
  this is a patch I'd like to get feedback on. The motivation behind it is to
  have a possibility to link without libbfd (because on 3.10 lts NO_DEMANGLE=1
  does not link with libbfd and I'd like to preserve this behavior).

Stanislav Fomichev (3):
  perf timechart: fix wrong SVG height
  perf util: free cpu_map in perf_session__cpu_bitmap
  perf tools: bring back old behavior when NO_DEMAGLE doesn't link with
    libbfd

 tools/perf/builtin-timechart.c | 3 +++
 tools/perf/config/Makefile     | 8 +++-----
 tools/perf/util/session.c      | 2 ++
 3 files changed, 8 insertions(+), 5 deletions(-)

-- 
1.8.3.2

