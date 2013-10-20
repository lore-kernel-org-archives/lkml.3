Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab3JTUnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 16:43:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab3JTUnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 16:43:50 -0400
Date: Sun, 20 Oct 2013 22:43:35 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 14/19] perf evlist: Add a debug print if event buffer
 mmap fails
Message-ID: <20131020204335.GC12044@krava>
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
 <1382099356-4918-15-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382099356-4918-15-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 03:29:11PM +0300, Adrian Hunter wrote:
> Add a debug print if mmap of the perf event
> ring buffer fails.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/evlist.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 07ba0a4..52e434a 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -600,6 +600,7 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist,
>  	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, prot,
>  				      MAP_SHARED, fd, 0);
>  	if (evlist->mmap[idx].base == MAP_FAILED) {
> +		pr_debug2("failed to mmap perf event ring buffer\n");

while at it, we could display errno

jirka
