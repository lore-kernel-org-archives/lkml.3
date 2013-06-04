Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab3FDJWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:22:21 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44362 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3FDJWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:22:19 -0400
X-AuditID: 9c93017d-b7c30ae0000063eb-d6-51adb1c916e3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCHSET 0/6] perf report: Add support for callchains on GTK browser (v2)
Date: Tue,  4 Jun 2013 18:22:11 +0900
Message-Id: <1370337737-30812-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset implements callchain support in GTK report browser as
Pekka requested.  Please take a look and give me comments.

v2 changes)
 * fix a bug on percent calculation of children nodes
 * show topmost symbol only when multiple paths exist for a node
 * add alternating background colors (Ingo)
 * put callchain info into existing overhead and symbol column (Arnaldo)

You can get it from 'perf/callchain-gtk-v2' branch on my tree at

 git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, thanks!
Namhyung

Namhyung Kim (6):
  perf gtk/hists: Use GtkTreeStore instead of GtkListStore
  perf gtk/hists: Add support for callchains
  perf gtk/hists: Display callchain overhead also
  perf gtk/hists: Make column headers resizable
  perf gtk/hists: Add a double-click handler for callchains
  perf gtk/hists: Set rules hint for the hist browser

 tools/perf/ui/gtk/hists.c | 117 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 112 insertions(+), 5 deletions(-)

-- 
1.7.11.7

