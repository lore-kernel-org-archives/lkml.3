Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbaDKRTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:19:42 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49825 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbaDKRTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 13:19:39 -0400
Message-ID: <53482425.3090608@gmail.com>
Date: Fri, 11 Apr 2014 10:19:33 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Richard Yao <ryao@gentoo.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf machine: Search for modules in %s/lib/modules/%s
References: <1397148779-9169-1-git-send-email-ryao@gentoo.org>
In-Reply-To: <1397148779-9169-1-git-send-email-ryao@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/14, 9:52 AM, Richard Yao wrote:
> Modules installed outside of the kernel's build system should go into
> "%s/lib/modules/%s/extra", but at present, perf will only look at them
> when they are in "%s/lib/modules/%s/kernel". Lets encourage good
> citizenship by relaxing this requirement to "%s/lib/modules/%s". This
> way open source modules that are out-of-tree have no incentive to start
> populating a directory reserved for in-kernle modules and I can stop hex
> editing my system's perf binary when profiling OSS out-of-tree modules.
>
> Signed-off-by: Richard Yao <ryao@gentoo.org>
> ---
>   tools/perf/util/machine.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index a53cd0b..116842e 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -786,7 +786,7 @@ static int machine__set_modules_path(struct machine *machine)
>   	if (!version)
>   		return -1;
>
> -	snprintf(modules_path, sizeof(modules_path), "%s/lib/modules/%s/kernel",
> +	snprintf(modules_path, sizeof(modules_path), "%s/lib/modules/%s",
>   		 machine->root_dir, version);
>   	free(version);
>
>

Acked-by: David Ahern <dsahern@gmail.com>
