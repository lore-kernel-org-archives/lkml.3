Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab3FYRAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:00:07 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:43554 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab3FYRAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:00:05 -0400
Message-ID: <51C9CC90.20906@gmail.com>
Date: Tue, 25 Jun 2013 11:00:00 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/5] perf tools: Remove callchain_cursor_reset call
References: <1372161253-22081-1-git-send-email-jolsa@redhat.com> <1372161253-22081-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1372161253-22081-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/13 5:54 AM, Jiri Olsa wrote:
> Removing callchain_cursor_reset call as it is called
> in subsequent machine__resolve_callchain_sample
> function.
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>   tools/perf/util/machine.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index b2ecad6..93527af 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1242,8 +1242,6 @@ int machine__resolve_callchain(struct machine *machine,
>   {
>   	int ret;
>
> -	callchain_cursor_reset(&callchain_cursor);
> -
>   	ret = machine__resolve_callchain_sample(machine, thread,
>   						sample->callchain, parent);
>   	if (ret)
>

I noticed this duplication as well.

Acked-by: David Ahern <dsahern@gmail.com>
