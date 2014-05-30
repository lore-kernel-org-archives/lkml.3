Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597AbaE3Pcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:32:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933122AbaE3Pcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:32:53 -0400
Date: Fri, 30 May 2014 11:32:28 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: paolo <paolo.valente@unimore.it>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC RESEND 00/14] New version of the BFQ I/O Scheduler
Message-ID: <20140530153228.GE16605@redhat.com>
References: <1401194558-5283-1-git-send-email-paolo.valente@unimore.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401194558-5283-1-git-send-email-paolo.valente@unimore.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 02:42:24PM +0200, paolo wrote:

[..]
> Strong fairness guarantees (already provided by BFQ-v0)
> 
> As for long-term guarantees, BFQ distributes the device throughput
> (and not just the device time) as desired to I/O-bound applications,
> with any workload and regardless of the device parameters.

I don't think most of the people care about strong fairness guarantee.
As an algorithm round robin is not bad for ensuring fairness. CFQ had
started with that but then it stopped focussing on fairness and rather
focussed on trying to address various real issues.

And CFQ's problems don't arise from not having a good fairness algorithm.
So I don't think this should be the reason for taking a new scheduler.

I think instead of numbers, what would help is a short description
that what's the fundamental problem with CFQ which BFQ does not
have and how did you solve that issue.

One issue you seemed to mention is that write is a problem. CFQ 
suppresses buffered writes very actively in an attempt to improve
read latencies. How did you make it even better with BFQ.

Last time I had looked at BFQ, it looked pretty similar to CFQ except
that core round robin algorithm had been replaced by a more fair
algo and more things done like less preemption etc.

But personally I don't think using a more accurate fairness algorithm
is the problem to begin with most of the time.

So I fail to understand that why do we need BFQ.

Thanks
Vivek
