Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbaE3OJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:09:55 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:61442 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933058AbaE3OJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:09:54 -0400
Message-ID: <5388912F.7010609@kernel.dk>
Date: Fri, 30 May 2014 08:09:51 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
References: <20140509120733.GA27918@kernel.org> <20140509150018.GA26215@infradead.org> <20140510040023.GA13788@kernel.org>
In-Reply-To: <20140510040023.GA13788@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-09 22:00, Shaohua Li wrote:
> On Fri, May 09, 2014 at 08:00:18AM -0700, Christoph Hellwig wrote:
>> On Fri, May 09, 2014 at 08:07:33PM +0800, Shaohua Li wrote:
>>>
>>> flush request is special, which borrows tag from other request. Need a special
>>> handling to get it from tag.
>>
>> Thanks, we probably need this one.  But I think you can simply test
>> REQ_FLUSH_SEQ the passed in request instead of the flush_rq_tag_valid
>> flag/
>
> fair enough. updated one.
>
>
> Subject: blk-mq: blk_mq_tag_to_rq should handle flush request
>
> flush request is special, which borrows tag from other request. Need a special
> handling to get it from tag.

I have applied this one, but it irks me a little bit since we have to 
touch q->flush_rq->stuff from a potential hot path. I haven't thought 
much about this yet, but it would be a lot better if we could fold in 
the flush tag somehow.

-- 
Jens Axboe

