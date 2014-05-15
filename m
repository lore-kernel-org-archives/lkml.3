Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaEONsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:48:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbaEONsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:48:17 -0400
Date: Thu, 15 May 2014 15:47:52 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 15/20] perf diff: Add missing setup_output_field()
Message-ID: <20140515134751.GH25858@krava.brq.redhat.com>
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
 <1399876133-17963-16-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399876133-17963-16-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 03:28:48PM +0900, Namhyung Kim wrote:
> The perf diff command itself doesn't make use of the --fields option,
> it still needs to call the function since the output only work with
> that way.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-diff.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index f3b10dcf6838..670d191bec31 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -1155,6 +1155,9 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
>  	if (setup_sorting() < 0)
>  		usage_with_options(diff_usage, options);
>  
> +	if (setup_output_field() < 0)
> +		usage_with_options(diff_usage, options);
> +

looks like this breaks perf diff even worse than it is now ;-)

[jolsa@krava perf]$ ./perf diff 
# Event 'cycles'
#
# Baseline    Delta
# ........  .......
#
    28.03%         
            +18.93%
    31.06%         
            +36.86%
    35.06%         
     0.38%         
     0.03%   +0.03%
             +1.11%
     5.44%         
            +43.05%


anyway, as I said it was already broken, I plan to check/fix this soon..

jirka
