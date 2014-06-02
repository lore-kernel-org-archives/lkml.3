Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaFBRqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:46:25 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:45941 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaFBRqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:46:23 -0400
Message-ID: <538CB87C.7030600@kernel.dk>
Date: Mon, 02 Jun 2014 11:46:36 -0600
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
References: <20140528221929.GG1419@htj.dyndns.org> <1401354343-5527-1-git-send-email-paolo.valente@unimore.it> <20140530160712.GG24871@htj.dyndns.org> <538926F6.7080409@kernel.dk> <20140531051635.GA19925@mtj.dyndns.org> <538C8A47.1050502@kernel.dk> <20140602172454.GA8912@htj.dyndns.org> <538CB515.3090700@kernel.dk> <20140602174250.GC8912@htj.dyndns.org>
In-Reply-To: <20140602174250.GC8912@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 11:42 AM, Tejun Heo wrote:
> Hello, Jens.
> 
> On Mon, Jun 02, 2014 at 11:32:05AM -0600, Jens Axboe wrote:
>> For things like blkcg, I agree, it should be able to be common code and
>> reusable. But there's a need for scheduling beyond that, for people that
>> don't use control groups (ie most...). And it'd be hard to retrofit cfq
>> into blk-mq, without rewriting it. I don't believe we need anything this
>> fancy for blk-mq, hopefully. At least having simple deadline scheduling
>> would be Good Enough for the foreseeable future.
> 
> Heh, looks like we're miscommunicating.  I don't think anything with
> the level of complexity of cfq is realistic for high-iops devices.  It
> has already become a liability for SATA ssds after all.  My suggestion
> is that as hierarchical scheduling tends to be logical extension of
> flat scheduling, it probably would make sense to implement both
> scheduling logics in the same framework as in the cpu scheduler or (to
> a lesser extent) cfq.  So, a new blk-mq scheduler which can work in
> hierarchical mode if blkcg is in active use.

But blk-mq will potentially drive anything, so it might not be out of
the question with a more expensive scheduling variant, if it makes any
sense to do of course. At least until there's no more rotating stuff out
there :-). But it's not a priority at all to me yet. As long as we have
coexisting IO paths, it'd be trivial to select the needed one based on
the device characteristics.

> One part I was wondering about is whether we'd need to continue the
> modular multiple implementation mechanism.  For rotating disks, for
> various reasons including some historical ones, we ended up with
> multiple ioscheds and somewhat uglily layered blkcg implementations.
> Given that the expected characteristics of blk-mq devices are more
> consistent, it could be reasonable to stick with single iops and/or
> bandwidth scheme.

I hope not to do that. I just want something sane and simple (like a
deadline scheduler), nothing more.

-- 
Jens Axboe

