Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935730Ab3IELM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 07:12:57 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:52285 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759475Ab3IELMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 07:12:55 -0400
Date: Thu, 5 Sep 2013 13:12:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexey Vlasov <renton@renton.name>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <bitbucket@online.de>, linux-kernel@vger.kernel.org
Subject: Re: Kernel migration eat CPUs
Message-ID: <20130905111252.GA23362@gmail.com>
References: <20130823151711.f4c1f596b4c7aa1eecccc9a6@linux-foundation.org>
 <20130825142837.GD31370@twins.programming.kicks-ass.net>
 <20130904185315.GB13294@beaver>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904185315.GB13294@beaver>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Vlasov <renton@renton.name> wrote:

> On Sun, Aug 25, 2013 at 04:28:37PM +0200, Peter Zijlstra wrote:
> 
> > and a function (or function-graph)
> > trace for when this happens?
> 
> Unfortunately I could not make trace.
> First when migration threads start to eat CPUs and when I turn on trace:
> # echo function > current_tracer
> # echo 1 > tracing_on
> then server is down at once. LA comes up to several thousands, it stops
> to receive commands. Sometimes I even have to reboot it.

Could you try the latest -tip tree at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git

In particular this fix:

   5a8e01f8fa51 sched/cputime: Do not scale when utime == 0

Could perhaps fix the phantom CPU overhead you are seeing?

Thanks,

	Ingo
