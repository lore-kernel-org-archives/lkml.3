Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaIISy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:54:58 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47332 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaIISyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:54:55 -0400
Message-ID: <540F4D07.4080103@kernel.dk>
Date: Tue, 09 Sep 2014 12:55:03 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@canonical.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/8] block: introduce blk_flush_queue to drive flush machinery
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com> <1410267949-21904-6-git-send-email-ming.lei@canonical.com> <20140909184331.GE16750@infradead.org>
In-Reply-To: <20140909184331.GE16750@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 12:43 PM, Christoph Hellwig wrote:
> On Tue, Sep 09, 2014 at 09:05:46PM +0800, Ming Lei wrote:
>> This patch introduces 'struct blk_flush_queue' and puts all
>> flush machinery related stuff into this strcuture, so that
> 
> s/stuff/fields/
> s/strcuture/structure/
> 
> Looks good, but a few more nitpicks below.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
>> +int blk_init_flush(struct request_queue *q)
>> +{
>> +	int ret;
>> +	struct blk_flush_queue *fq = kzalloc(sizeof(*fq), GFP_KERNEL);
>>  
>> +	if (!fq)
>>  		return -ENOMEM;
>>  
>> +	q->fq = fq;
> 
> I think it would be cleaner to return the flush data structure and
> assign it in the caller.

I was going to suggest renaming because of this as well. If we do this:

	q->fq = blk_init_flush(q);

then it's immediately clear what it does, whereas blk_init_flush(q)
means very little on its own. I'd change the naming to
blk_alloc_flush_queue() and blk_free_flush_queue().

-- 
Jens Axboe

