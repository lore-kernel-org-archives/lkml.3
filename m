Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3EXNp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 09:45:28 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:36327 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3EXNpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 09:45:25 -0400
Date: Thu, 23 May 2013 11:17:40 +0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 01/14] perf diff: Use internal rb tree for
 hists__precompute
Message-ID: <20130523091740.GA3064@ghostprotocols.net>
References: <1355404152-16523-1-git-send-email-jolsa@redhat.com>
 <1355404152-16523-2-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355404152-16523-2-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 13, 2012 at 02:08:59PM +0100, Jiri Olsa escreveu:

> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c

>  	while (next != NULL) {
> -		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
> -		struct hist_entry *pair = hist_entry__next_pair(he);
> +		struct hist_entry *he, *pair;
>  
> -		next = rb_next(&he->rb_node);
> +		he   = rb_entry(next, struct hist_entry, rb_node_in);
> +		pair = hist_entry__next_pair(he);
> +
> +		next = rb_next(&he->rb_node_in);


To ease review please try to make the patch as minimal as possible, i.e.
the above could be done as:

-		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
+		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node_in);
 		struct hist_entry *pair = hist_entry__next_pair(he);

-		next = rb_next(&he->rb_node);
+		next = rb_next(&he->rb_node_in);

See how we can more quickly see what happened? I.e. just replacing
'rb_node' with 'rb_node_in' :-)

- Arnaldo
