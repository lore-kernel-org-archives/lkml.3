Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287Ab3LKT01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:26:27 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:62642 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3LKT0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:26:25 -0500
Message-ID: <52A8BC5D.2030603@gmail.com>
Date: Wed, 11 Dec 2013 12:26:21 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 07/71] perf tools: Record whether a dso is 64-bit
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-8-git-send-email-alexander.shishkin@linux.intel.com>
In-Reply-To: <1386765443-26966-8-git-send-email-alexander.shishkin@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13, 5:36 AM, Alexander Shishkin wrote:
> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
> index a0c7c59..80817ec 100644
> --- a/tools/perf/util/dso.c
> +++ b/tools/perf/util/dso.c
> @@ -446,6 +446,7 @@ struct dso *dso__new(const char *name)
>   		dso->cache = RB_ROOT;
>   		dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
>   		dso->data_type   = DSO_BINARY_TYPE__NOT_FOUND;
> +		dso->is_64_bit = (sizeof(void *) == 8);

Isnt' that going to record the bitness of perf when it is compiled?

>   		dso->loaded = 0;
>   		dso->rel = 0;
>   		dso->sorted_by_name = 0;
> diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
> index 384f2d9..62680e1 100644
> --- a/tools/perf/util/dso.h
> +++ b/tools/perf/util/dso.h
> @@ -91,6 +91,7 @@ struct dso {
>   	u8		 annotate_warned:1;
>   	u8		 sname_alloc:1;
>   	u8		 lname_alloc:1;
> +	u8		 is_64_bit:1;

The is_64_bit name seems a bit hardcoded. We need something similar for 
perf-trace to set the audit machine type for resolving syscalls. How 
about having this field set a machine type rather than a "64-bit" flag?

David
