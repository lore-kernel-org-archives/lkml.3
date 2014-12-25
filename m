Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaLYWJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 17:09:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbaLYWJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 17:09:33 -0500
Date: Thu, 25 Dec 2014 23:09:05 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 05/37] perf tools: Create separate mmap for dummy
 tracking event
Message-ID: <20141225220905.GC8719@krava>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-6-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419405333-27952-6-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 04:15:01PM +0900, Namhyung Kim wrote:

SNIP

>  
>  union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx);
> -
>  void perf_evlist__mmap_consume(struct perf_evlist *evlist, int idx);
> +struct perf_mmap *perf_evlist__mmap_desc(struct perf_evlist *evlist, int idx);
>  
>  int perf_evlist__open(struct perf_evlist *evlist);
>  void perf_evlist__close(struct perf_evlist *evlist);
> @@ -211,6 +214,12 @@ bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str);
>  void perf_evlist__to_front(struct perf_evlist *evlist,
>  			   struct perf_evsel *move_evsel);
>  
> +/* convert from/to negative idx for track mmaps */
> +static inline int track_mmap_idx(int idx)
> +{
> +	return -idx - 1;
> +}

hum, whats the logic with negative numbers in here?
you still access track_mmap array with this index no?

thanks,
jirka
