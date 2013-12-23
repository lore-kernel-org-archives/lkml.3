Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab3LWGR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 01:17:27 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:57286 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3LWGR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 01:17:26 -0500
X-AuditID: 9c93017d-b7c2eae000004ec2-8c-52b7d574c87e
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt \(Red Hat\)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip 1/3] [CLEANUP] perf-probe: Expand given path to absolute path
References: <20131220100255.7169.19384.stgit@kbuild-fedora.novalocal>
	<20131220100257.7169.60537.stgit@kbuild-fedora.novalocal>
Date: Mon, 23 Dec 2013 15:17:24 +0900
In-Reply-To: <20131220100257.7169.60537.stgit@kbuild-fedora.novalocal> (Masami
	Hiramatsu's message of "Fri, 20 Dec 2013 10:02:57 +0000")
Message-ID: <871u14drbf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Fri, 20 Dec 2013 10:02:57 +0000, Masami Hiramatsu wrote:
> Expand given path to absolute path in option parser,
> except for a module name. Instead of expanding it later,
> this get the absolute path in early stage.
>
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  tools/perf/builtin-probe.c    |    9 +++++++++
>  tools/perf/util/probe-event.c |   11 ++---------
>  2 files changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index 6ea9e85..b40d064 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -180,6 +180,15 @@ static int opt_set_target(const struct option *opt, const char *str,
>  		else
>  			return ret;
>  
> +		/* Expand given path to absolute path, except for modulename */
> +		if (params.uprobes || strchr(str, '/')) {
> +			str = realpath(str, NULL);
> +			if (!str) {
> +				pr_warning("Failed to find the path of %s.\n",
> +					   str);

It won't print the path since the str already was overwritten to NULL.


> +				return ret;
> +			}
> +		}
>  		params.target = str;

It now points either a dynamically allocated string or not..

Thanks,
Namhyung


>  		ret = 0;
>  	}
