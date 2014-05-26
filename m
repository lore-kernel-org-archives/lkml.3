Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaEZOT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 10:19:27 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52869 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaEZOT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 10:19:26 -0400
Message-ID: <1401113960.23186.41.camel@marge.simpson.net>
Subject: Re: balance storm
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Libo Chen <libo.chen@huawei.com>
Cc: tglx@linutronix.de, mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>,
        peterz@infradead.org
Date: Mon, 26 May 2014 16:19:20 +0200
In-Reply-To: <538330B7.5070503@huawei.com>
References: <5382AF2E.1040407@huawei.com>
	 <1401081082.5339.41.camel@marge.simpson.net> <538330B7.5070503@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-26 at 20:16 +0800, Libo Chen wrote: 
> On 2014/5/26 13:11, Mike Galbraith wrote:

> > Your synthetic test is the absolute worst case scenario.  There has to
> > be work between wakeups for select_idle_sibling() to have any chance
> > whatsoever of turning in a win.  At 0 work, it becomes 100% overhead.
> 
> not synthetic, it is a real problem in our product. under no load, waste
> much cpu time.

What happens in your product if you apply the commit I pointed out?

> >> so I think 15% cpu usage and migration event are too high, how to fixed?
> > 
> > You can't for free, low latency wakeup can be worth one hell of a lot.
> > 
> > You could do a decayed hit/miss or such to shut the thing off when the
> > price is just too high.  Restricting migrations per unit time per task
> > also helps cut the cost, but hurts tasks that could have gotten to the
> > CPU quicker, and started your next bit of work.  Anything you do there
> > is going to be a rob Peter to pay Paul thing.
> > 
> 
> I had tried to change sched_migration_cost and sched_nr_migrate in /proc,
> but no use.  any other  suggestion?
> 
> I still think this is a problem to schedular.  it is better to directly solve
> this issue instead of a workaroud

I didn't say it wasn't a problem, it is.  I said whatever you do will be
a tradeoff.

-Mike

