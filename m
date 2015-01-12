Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbbALLSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:18:01 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55239 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbbALLSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:18:00 -0500
Message-ID: <54B3AD60.5000503@hitachi.com>
Date: Mon, 12 Jan 2015 20:17:52 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 4/4] perf probe: Propagate error code when write(2)
 failed
References: <1420886028-15135-1-git-send-email-namhyung@kernel.org> <1420886028-15135-4-git-send-email-namhyung@kernel.org>
In-Reply-To: <1420886028-15135-4-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/10 19:33), Namhyung Kim wrote:
> When it failed to write probe commands to the probe_event file in
> debugfs, it needs to propagate the error code properly.  Current code
> blindly uses the return value of the write(2) so it always uses
> -1 (-EPERM) and it might confuse users.
> 

Good catch! :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/probe-event.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 6fe5aa357efc..ddc295885af0 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -2052,9 +2052,11 @@ static int write_probe_trace_event(int fd, struct probe_trace_event *tev)
>  	pr_debug("Writing event: %s\n", buf);
>  	if (!probe_event_dry_run) {
>  		ret = write(fd, buf, strlen(buf));
> -		if (ret <= 0)
> +		if (ret <= 0) {
> +			ret = -errno;
>  			pr_warning("Failed to write event: %s\n",
>  				   strerror_r(errno, sbuf, sizeof(sbuf)));
> +		}
>  	}
>  	free(buf);
>  	return ret;
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


