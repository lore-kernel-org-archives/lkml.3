Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbaISRwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 13:52:46 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54951 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbaISRwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:52:45 -0400
Message-ID: <541C6D7B.5000005@kernel.dk>
Date: Fri, 19 Sep 2014 11:52:59 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: auto-start hw queue in requeue
References: <1411136570-23439-1-git-send-email-ming.lei@canonical.com> <20140919174806.GA19983@lst.de>
In-Reply-To: <20140919174806.GA19983@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 11:48 AM, Christoph Hellwig wrote:
> On Fri, Sep 19, 2014 at 10:22:50PM +0800, Ming Lei wrote:
>> Requests often need to be retried because of timeout, hardware
>> busy or sort of reasons via blk_mq_requeue_request(), but at
>> that time dispatch queue may have been stopped.
>>
>> This patch starts the dispatch queue automatically in requeue's
>> work handler, and fixes scsi-mq's timeout issue, which can be
>> triggered if there are two or more requests timedout.
> 
> Sounds like blk_mq_requeue_work should simply call void
> blk_mq_start_hw_queues where it calls blk_mq_run_queues currently.

I agree. I think Ming wanted to avoid an unnecessary bitflip if
possible, but the fix is more convoluted than I would like.


-- 
Jens Axboe

