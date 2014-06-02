Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaFBRbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:31:53 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:42078 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaFBRbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:31:51 -0400
Message-ID: <538CB515.3090700@kernel.dk>
Date: Mon, 02 Jun 2014 11:32:05 -0600
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
References: <20140528221929.GG1419@htj.dyndns.org> <1401354343-5527-1-git-send-email-paolo.valente@unimore.it> <20140530160712.GG24871@htj.dyndns.org> <538926F6.7080409@kernel.dk> <20140531051635.GA19925@mtj.dyndns.org> <538C8A47.1050502@kernel.dk> <20140602172454.GA8912@htj.dyndns.org>
In-Reply-To: <20140602172454.GA8912@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 11:24 AM, Tejun Heo wrote:
> Hello, Jens.
> 
> On Mon, Jun 02, 2014 at 08:29:27AM -0600, Jens Axboe wrote:
>> One thing I've neglected to bring up but have been thinking about - we're
>> quickly getting to the point where the old request_fn IO path will become a
>> legacy thing, mostly in maintenance mode. That isn't a problem for morphing
>> bfq and cfq, but it does mean that development efforts in this area would be
>> a lot better spent writing an IO scheduler that fits into the blk-mq
>> framework instead.
> 
> What I'm planning right now is improving blkcg so that it can do both
> proportional and hard limits with high cpu scalability, most likely
> using percpu charge caches.  It probably would be best to roll all
> those into one piece of logic.  I don't think, well at least hope,
> that we'd need multiple modular scheduler / blkcg implementations for
> blk-mq and both can be served by built-in scheduling logic.
> Regardless of device speed, we'd need some form of fairness
> enforcement after all.

For things like blkcg, I agree, it should be able to be common code and
reusable. But there's a need for scheduling beyond that, for people that
don't use control groups (ie most...). And it'd be hard to retrofit cfq
into blk-mq, without rewriting it. I don't believe we need anything this
fancy for blk-mq, hopefully. At least having simple deadline scheduling
would be Good Enough for the foreseeable future.

-- 
Jens Axboe

