Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab3ANOCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 09:02:51 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:62348 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab3ANOCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 09:02:49 -0500
Date: Mon, 14 Jan 2013 15:02:45 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, jolsa@redhat.com, acme@redhat.com, mingo@elte.hu,
        namhyung.kim@lge.com
Subject: [PATCH] perf tools: mark branch_info maps as referenced
Message-ID: <20130114140245.GA4692@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As noticed by Jiri, the hist_entry->branch_info.to/from maps
need to be marked as referenced to avoid problems later on.
So we do this when the hist_entry is allocated.

Signed-off-by: Stephane Eranian <eranian@google.com>
--

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index cb17e2a..ab35b82 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -242,6 +242,14 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 
 		if (he->ms.map)
 			he->ms.map->referenced = true;
+
+		if (he->branch_info) {
+			if (he->branch_info->from.map)
+				he->branch_info->from.map->referenced = true;
+			if (he->branch_info->to.map)
+				he->branch_info->to.map->referenced = true;
+		}
+
 		if (symbol_conf.use_callchain)
 			callchain_init(he->callchain);
 
