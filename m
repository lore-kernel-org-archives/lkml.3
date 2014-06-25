Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaFYEsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 00:48:01 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:47925 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaFYEsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 00:48:00 -0400
MIME-Version: 1.0
In-Reply-To: <53AA3B6B.1040103@kernel.dk>
References: <1403621588-25109-1-git-send-email-tom.leiming@gmail.com>
	<CACVXFVMWDBEhRhKQ1V2O9sWbAdQNb_RM0Nz_BA7Cn7P_OrvndQ@mail.gmail.com>
	<53AA3B6B.1040103@kernel.dk>
Date: Wed, 25 Jun 2014 12:47:59 +0800
Message-ID: <CACVXFVMfN1mGAv5KjF6oQZxz-OSD6_5rqwconbhqB+o+On2iHw@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: run hw queue asynchronously in blk_mq_start_hw_queues
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 11:00 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-06-24 20:42, Ming Lei wrote:
>>
>> On Tue, Jun 24, 2014 at 10:53 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>>>
>>>  From API view, it isn't good to run all hw queues synchronously
>>> in one context, since it isn't correct for multi hw queue case.
>>>
>>> So this patch adds 'async' parameter to blk_mq_start_hw_queue(),
>>> and make blk_mq_start_hw_queues() to run hw queues asynchronously
>>> at default.
>>
>>
>> BTW, without the change, it is easy to trigger the WARN_ON() in
>> __blk_mq_run_hw_queue().
>
>
> Why not just have it call blk_mq_run_hw_queue()? Pass in async == false, but
> let the cpumask logic sort out if we need to force an async run.

That looks better, thanks.


Thanks,
-- 
Ming Lei
