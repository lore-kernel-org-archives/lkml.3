Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaHMITT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:19:19 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:52931 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaHMITO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:19:14 -0400
Date: Wed, 13 Aug 2014 10:19:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf ui/tui: Fix a small callchain display bug
Message-ID: <20140813081909.GA6399@gmail.com>
References: <1407909761-10822-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407909761-10822-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> The currently when perf TUI report shows callchain, the first level
> chains have bogus '+' sign even though only the last one has children.
> 
> Since they are on a single line of the chain, toggling intermediate
> entries has no effect.  Fix it to show '+' sign at the last entry
> only.  Note that non-first level callchain entries don't have this
> problem.
> 
> Before:
> 
>   Children      Self  Command  Shared Object      Symbols
> ---------------------------------------------------------------------------
> -   40.70%     0.00%  swapper  [kernel.kallsyms]  [k] cpuidle_wrap_enter
>    + cpuidle_wrap_enter
>    + cpuidle_enter_tk
>    + cpuidle_idle_call
>    + cpu_idle
> 
> After:
> 
>   Children      Self  Command  Shared Object      Symbols
> ---------------------------------------------------------------------------
> -   40.70%     0.00%  swapper  [kernel.kallsyms]  [k] cpuidle_wrap_enter
>      cpuidle_wrap_enter
>      cpuidle_enter_tk
>      cpuidle_idle_call
>    + cpu_idle
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Nice fix!

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
