Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab3KTLLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 06:11:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab3KTLLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 06:11:15 -0500
Date: Wed, 20 Nov 2013 13:08:25 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christian Engelmayer <cengelma@gmx.at>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        fweisbec@gmail.com, Paul Turner <pjt@google.com>
Subject: Re: [PROBLEM] possible divide by 0 in kernel/sched/cputime.c
 scale_stime()
Message-ID: <20131120120815.GA12860@redhat.com>
References: <20131116223740.3cd579cb@spike>
 <20131118140224.GA3330@redhat.com>
 <20131118172706.GI3866@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118172706.GI3866@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 06:27:06PM +0100, Peter Zijlstra wrote:
> The below is a compile tested only attempt to deal with both these
> problems. Comments?

Just two nits as I don't understand vast of the patch.

> +	delta_exec = now - curr->exec_start;
> +	if ((s64)delta_exec < 0)
>  		return;

Check here should probably use <= and also unlikely() would be
reasonable. 

> +	schedstat_set(curr->statistics.exec_max,
> +		      max((u64)delta_exec, curr->statistics.exec_max));

(u64) cast not needed.

Stanislaw
