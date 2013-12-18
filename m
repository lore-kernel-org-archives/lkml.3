Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab3LRPjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:39:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679Ab3LRPjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:39:17 -0500
Date: Wed, 18 Dec 2013 16:38:49 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/18] perf sort: Compare addresses if no symbol info
Message-ID: <20131218153849.GF4146@krava.brq.redhat.com>
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
 <1387344086-12744-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387344086-12744-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 02:21:09PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> If a hist entry doesn't have symbol information, compare it with its
> address.  Currently it only compares its level or whether it's NULL.
> This can lead to an undesired result like an overhead exceeds 100%
> especially when callchain accumulation is enabled by later patch.
> 
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/sort.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 8b0bb1f4494a..68a4fd2f505e 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -161,6 +161,11 @@ struct sort_entry sort_dso = {
>  
>  /* --sort symbol */
>  
> +static int64_t _sort__addr_cmp(u64 left_ip, u64 right_ip)
> +{
> +	return (int64_t)(right_ip - left_ip);
> +}
> +

what's the reason for the leading '_' in the name?

otherwise:

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka
