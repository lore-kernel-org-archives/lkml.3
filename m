Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaHMFpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:45:39 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60577 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaHMFph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:45:37 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: naota@elisp.net
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf report: Set proper sort__mode for the branch option
References: <87y4v1fylq.fsf@elisp.net>
Date: Wed, 13 Aug 2014 14:45:34 +0900
In-Reply-To: <87y4v1fylq.fsf@elisp.net> (naota@elisp.net's message of "Thu, 07
	Aug 2014 00:04:49 +0900")
Message-ID: <877g2ddjsx.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naohiro,

(CC'ing Stephane)

> When you specify "--branch-stack"("-b" for short) or
> "--no-branch-stack", "branch_mode" variable is set to 1 or 0
> respectively. However, the code is just checking if the variable is -1
> or not, ignoring "branch_mode == 1" case. Thus "perf report -b" dose not
> show its result with the branch sorted mode. This patch fix the problem.
>
> Signed-off-by: Naohiro Aota <naota@elisp.net>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks for fixing this!
Namhyung


> ---
>  tools/perf/builtin-report.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 21d830b..94dcf2d 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -719,7 +719,7 @@ repeat:
>  	has_br_stack = perf_header__has_feat(&session->header,
>  					     HEADER_BRANCH_STACK);
>  
> -	if (branch_mode == -1 && has_br_stack) {
> +	if ((branch_mode == -1 && has_br_stack) || branch_mode == 1) {
>  		sort__mode = SORT_MODE__BRANCH;
>  		symbol_conf.cumulate_callchain = false;
>  	}
