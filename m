Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbaKTGoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 01:44:38 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48946 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaKTGoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 01:44:37 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tools: Fix segfault due to invalid kernel dso access
References: <1416285028-30572-1-git-send-email-namhyung@kernel.org>
Date: Thu, 20 Nov 2014 15:44:36 +0900
In-Reply-To: <1416285028-30572-1-git-send-email-namhyung@kernel.org> (Namhyung
	Kim's message of "Tue, 18 Nov 2014 13:30:28 +0900")
Message-ID: <87wq6qnzfv.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

Could you please consider applying this?

Thanks,
Namhyung


On Tue, 18 Nov 2014 13:30:28 +0900, Namhyung Kim wrote:
> Jiri reported that the commit 96d78059d6d9 ("perf tools: Make vmlinux
> short name more like kallsyms short name") segfaults on perf script.
>
> When processing kernel mmap event, it should access the 'kernel'
> variable as sometimes it cannot find a matching dso from build-id
> table so 'dso' might be invalid.
>
> Reported-by: Jiri Olsa <jolsa@redhat.com>
> Tested-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/machine.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 52e94902afb1..85033d80fd6a 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1106,8 +1106,8 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
>  		if (__machine__create_kernel_maps(machine, kernel) < 0)
>  			goto out_problem;
>  
> -		if (strstr(dso->long_name, "vmlinux"))
> -			dso__set_short_name(dso, "[kernel.vmlinux]", false);
> +		if (strstr(kernel->long_name, "vmlinux"))
> +			dso__set_short_name(kernel, "[kernel.vmlinux]", false);
>  
>  		machine__set_kernel_mmap_len(machine, event);
