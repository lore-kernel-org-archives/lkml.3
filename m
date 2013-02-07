Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab3BGJCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 04:02:25 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45999 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab3BGJCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 04:02:22 -0500
X-AuditID: 9c930179-b7c24ae00000119c-4a-51136d97345e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 0/7] perf annotate: Add support for GTK+ annotation browser (v2)
Date: Thu,  7 Feb 2013 18:02:07 +0900
Message-Id: <1360227734-375-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds support to GTK+ annotation browser.  For now only
the most frequently sampled symbol per evsel will be shown.  IOW it
shows the hottest symbol per event by default and you can change it by
giving the --symbol option or an argument.

The patch 4 and 5 are somewhat independent so that they can be merged
separately.

You can also get it from my perf/annotate-gtk-v2 branch on

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments are welcome, thanks,
Namhyung

v2 changes:
 * patch 1 and 2 in the previous patchset are merged already
 * squash the last (add --gtk option) patch into the patch 1 (Arnaldo)
 * make --gtk option does not fallback to stdio for a piped stdout (Borislav)

Namhyung Kim (7):
  perf ui/gtk: Implement basic GTK2 annotation browser
  perf gtk/annotate: Support multiple event annotation
  perf gtk/annotate: Show source lines with gray color
  perf buildid-cache: Add --update option
  perf annotate: Fix warning message on a missing vmlinux
  perf gtk/annotate: Fail early if it can't annotate
  perf annotate: Make it to be able to skip unannotatable symbols

 tools/perf/Documentation/perf-annotate.txt      |   4 +-
 tools/perf/Documentation/perf-buildid-cache.txt |   4 +
 tools/perf/Makefile                             |   1 +
 tools/perf/builtin-annotate.c                   |  27 ++-
 tools/perf/builtin-buildid-cache.c              |  50 +++++-
 tools/perf/ui/gtk/annotate.c                    | 229 ++++++++++++++++++++++++
 tools/perf/ui/gtk/gtk.h                         |   1 +
 tools/perf/ui/setup.c                           |   2 +-
 tools/perf/util/annotate.c                      |   2 +-
 tools/perf/util/annotate.h                      |  24 +++
 10 files changed, 338 insertions(+), 6 deletions(-)
 create mode 100644 tools/perf/ui/gtk/annotate.c

-- 
1.7.11.7

