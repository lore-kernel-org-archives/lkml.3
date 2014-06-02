Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbaFBO3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:29:32 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:42801 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbaFBO3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:29:30 -0400
Message-ID: <538C8A47.1050502@kernel.dk>
Date: Mon, 02 Jun 2014 08:29:27 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Paolo Valente <paolo.valente@unimore.it>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O Scheduler
References: <20140528221929.GG1419@htj.dyndns.org> <1401354343-5527-1-git-send-email-paolo.valente@unimore.it> <20140530160712.GG24871@htj.dyndns.org> <538926F6.7080409@kernel.dk> <20140531051635.GA19925@mtj.dyndns.org>
In-Reply-To: <20140531051635.GA19925@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-30 23:16, Tejun Heo wrote:
>> for turning patch #2 into a series of changes for CFQ instead. We need to
>> end up with something where we can potentially bisect our way down to
>> whatever caused any given regression. The worst possible situation is "CFQ
>> works fine for this workload, but BFQ does not" or vice versa. Or hangs, or
>> whatever it might be.
>
> It's likely that there will be some workloads out there which may be
> affected adversely, which is true for any change really but with both
> the core scheduling and heuristics properly characterized at least
> finding a reasonable trade-off should be much less of a crapshoot and
> the expected benefits seem to easily outweigh the risks as long as we
> can properly sequence the changes.

Exactly, I think we are pretty much on the same page here. As I said in 
the previous email, the biggest thing I care about is not adding a new 
IO scheduler wholesale. If Paolo can turn the "add BFQ" patch into a 
series of patches against CFQ, then I would have no issue merging it for 
testing (and inclusion, when it's stable enough).

One thing I've neglected to bring up but have been thinking about - 
we're quickly getting to the point where the old request_fn IO path will 
become a legacy thing, mostly in maintenance mode. That isn't a problem 
for morphing bfq and cfq, but it does mean that development efforts in 
this area would be a lot better spent writing an IO scheduler that fits 
into the blk-mq framework instead.

I realize this is a tall order right now, as I haven't included any sort 
of framework for that in blk-mq yet. So what I envision happening is 
that I will write a basic deadline (ish) scheduler for blk-mq, and 
hopefully others can then pitch in and we can get the ball rolling on 
that side as well.

-- 
Jens Axboe

