Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaFWKMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 06:12:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:46786 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaFWKMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:12:15 -0400
Date: Mon, 23 Jun 2014 12:12:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        tkhai@yandex.ru, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Konstantin Khorenko <khorenko@parallels.com>
Subject: Re: [PATCH 2/3] sched/rt: __disable_runtime: Enqueue just
 unthrottled rt_rq back on the stack
Message-ID: <20140623101213.GV19860@laptop.programming.kicks-ass.net>
References: <20140617130442.29933.54945.stgit@tkhai>
 <1403011456.27674.45.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403011456.27674.45.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 05:24:16PM +0400, Kirill Tkhai wrote:
> 
> Make rt_rq available for pick_next_task(). Otherwise, their tasks
> stay prisoned long time till dead cpu becomes alive again.
> 
> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> CC: Mike Galbraith <umgwanakikbuti@gmail.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@kernel.org>
> ---
>  kernel/sched/rt.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index a490831..671a8b5 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -740,6 +740,9 @@ balanced:

Depending on what you use to generate patches, can you:

QUILT_DIFF_OPTS="-F ^[[:alpha:]\$_].*[^:]\$"

or .gitconfig:

[diff "default"]
        xfuncname = "^[[:alpha:]$_].*[^:]$"

That avoids mistaking labels (like the above balanced:) for function
names.

The patch itself makes sense though.
