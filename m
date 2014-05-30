Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871AbaE3QQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:16:55 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:62872 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbaE3QQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:16:54 -0400
Date: Fri, 30 May 2014 12:16:50 -0400
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: paolo <paolo.valente@unimore.it>, Jens Axboe <axboe@kernel.dk>,
        Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC RESEND 00/14] New version of the BFQ I/O Scheduler
Message-ID: <20140530161650.GH24871@htj.dyndns.org>
References: <1401194558-5283-1-git-send-email-paolo.valente@unimore.it>
 <20140530153228.GE16605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530153228.GE16605@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Fri, May 30, 2014 at 11:32:28AM -0400, Vivek Goyal wrote:
> I don't think most of the people care about strong fairness guarantee.
> As an algorithm round robin is not bad for ensuring fairness. CFQ had
> started with that but then it stopped focussing on fairness and rather
> focussed on trying to address various real issues.

Oh, I widely disagree.  Have you looked at the test results in the
paper?  Unless the results are completely bogus, which it probably
isn't, this is awesome.  This is a *lot* more clearly characterized
algorithm which shows significantly better behavior especially in use
cases where scheduling matters.  I mean, it even reaches higher
throughput while achieving lower latency.  Why wouldn't we want it?

> And CFQ's problems don't arise from not having a good fairness algorithm.
> So I don't think this should be the reason for taking a new scheduler.

In comparison, cfq's fairness behavior is a lot worse but even
ignoring thing, one of the major problems of cfq is that the behavior
is hardly characterized.  It's really difficult to anticipate what
it'd do and understand why, which makes it very difficult to maintain
and improve.  Even just for the latter point, it'd be worthwhile to
adopt bfq.

> I think instead of numbers, what would help is a short description
> that what's the fundamental problem with CFQ which BFQ does not
> have and how did you solve that issue.

The papers are pretty clear and not too long.  Have you read them?

> One issue you seemed to mention is that write is a problem. CFQ 
> suppresses buffered writes very actively in an attempt to improve
> read latencies. How did you make it even better with BFQ.
> 
> Last time I had looked at BFQ, it looked pretty similar to CFQ except
> that core round robin algorithm had been replaced by a more fair
> algo and more things done like less preemption etc.
> 
> But personally I don't think using a more accurate fairness algorithm
> is the problem to begin with most of the time.
> 
> So I fail to understand that why do we need BFQ.

I violently disagree.  This is awesome.

Thanks.

-- 
tejun
