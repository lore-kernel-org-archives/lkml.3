Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaKYQ62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:58:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbaKYQ60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:58:26 -0500
Date: Tue, 25 Nov 2014 17:57:52 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 02/22] perf evlist: Add initial support for mmapping
 an Instruction Trace buffer
Message-ID: <20141125165752.GB563@krava.brq.redhat.com>
References: <1416489808-4489-1-git-send-email-adrian.hunter@intel.com>
 <1416489808-4489-3-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416489808-4489-3-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 03:23:08PM +0200, Adrian Hunter wrote:

SNIP

> +			bool per_cpu __maybe_unused)
> +{
> +}
> +
>  static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
>  {
>  	if (evlist->mmap[idx].base != NULL) {
> @@ -731,6 +759,7 @@ static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
>  		evlist->mmap[idx].base = NULL;
>  		evlist->mmap[idx].refcnt = 0;
>  	}
> +	itrace_mmap__munmap(&evlist->mmap[idx].itrace_mmap);
>  }
>  
>  void perf_evlist__munmap(struct perf_evlist *evlist)
> @@ -758,6 +787,7 @@ static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
>  struct mmap_params {
>  	int prot;
>  	int mask;
> +	struct itrace_mmap_params itrace_mp;
>  };
>  
>  static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
> @@ -788,6 +818,10 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
>  		return -1;
>  	}
>  
> +	if (itrace_mmap__mmap(&evlist->mmap[idx].itrace_mmap,
> +			      &mp->itrace_mp, evlist->mmap[idx].base, fd))
> +		return -1;
> +

so the itrace mmap is mmaped with right after event mmap for event fd..?
is there any latest version of kernel changes, so I could check with
kernel's perf_mmap? hum.. or you just use the same mmap?

thanks,
jirka
