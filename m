Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab3IISyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:54:19 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:34595 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3IISyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:54:18 -0400
Date: Mon, 9 Sep 2013 15:54:10 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 1/2] perf tools: fix id pos in perf_evlist__open()
Message-ID: <20130909185410.GA28428@ghostprotocols.net>
References: <1378496412-2424-1-git-send-email-adrian.hunter@intel.com>
 <1378496412-2424-2-git-send-email-adrian.hunter@intel.com>
 <522B361A.6030209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522B361A.6030209@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Sep 07, 2013 at 08:20:10AM -0600, David Ahern escreveu:
> On 9/6/13 1:40 PM, Adrian Hunter wrote:
> >Ensure the id_pos is correct when perf_evlist__open()
> >is used.
> 
> The commit log should reference 7556257 and breakage of 'kvm stat
> live'; helps identify patches when backporting.
> 
> Other than that this patch fixes the problem.

Thanks, I'm ammending the commit message log.
 
> Tested-by and Acked-by David Ahern <dsahern@gmail.com>
> 
> >
> >Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> >---
> >  tools/perf/util/evlist.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> >diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> >index b8727ae..005c0eb 100644
> >--- a/tools/perf/util/evlist.c
> >+++ b/tools/perf/util/evlist.c
> >@@ -64,6 +64,16 @@ void perf_evlist__set_id_pos(struct perf_evlist *evlist)
> >  	evlist->is_pos = first->is_pos;
> >  }
> >
> >+static void perf_evlist__update_id_pos(struct perf_evlist *evlist)
> >+{
> >+	struct perf_evsel *evsel;
> >+
> >+	list_for_each_entry(evsel, &evlist->entries, node)
> >+		perf_evsel__calc_id_pos(evsel);
> >+
> >+	perf_evlist__set_id_pos(evlist);
> >+}
> >+
> >  static void perf_evlist__purge(struct perf_evlist *evlist)
> >  {
> >  	struct perf_evsel *pos, *n;
> >@@ -915,6 +925,8 @@ int perf_evlist__open(struct perf_evlist *evlist)
> >  	struct perf_evsel *evsel;
> >  	int err;
> >
> >+	perf_evlist__update_id_pos(evlist);
> >+
> >  	list_for_each_entry(evsel, &evlist->entries, node) {
> >  		err = perf_evsel__open(evsel, evlist->cpus, evlist->threads);
> >  		if (err < 0)
> >
