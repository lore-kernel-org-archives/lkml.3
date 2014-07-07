Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaGGSXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:23:23 -0400
Received: from mail.kernel.org ([198.145.19.201]:48048 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbaGGSXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:23:21 -0400
Date: Mon, 7 Jul 2014 15:23:16 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCHES 0/7] Add support for showing headers in the hist
 browser.
Message-ID: <20140707182316.GA7252@kernel.org>
References: <1404423780-24026-1-git-send-email-acme@kernel.org>
 <20140703214811.GC11267@kernel.org>
 <878uo94ia9.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878uo94ia9.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jul 04, 2014 at 05:53:02PM +0900, Namhyung Kim escreveu:
> you ;-) ).  But I also think it needs to fix column/header alignment
> first, hmm...

This one liner should do the trick, i.e. left justify it.

- Arnaldo

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 1ec57dd82284..14e5a039bc45 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1215,7 +1215,7 @@ static int __sort__hpp_header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 	hse = container_of(fmt, struct hpp_sort_entry, hpp);
 	len = hists__col_len(&evsel->hists, hse->se->se_width_idx);
 
-	return scnprintf(hpp->buf, hpp->size, "%*s", len, hse->se->se_header);
+	return scnprintf(hpp->buf, hpp->size, "%-*s", len, hse->se->se_header);
 }
 
 static int __sort__hpp_width(struct perf_hpp_fmt *fmt,
