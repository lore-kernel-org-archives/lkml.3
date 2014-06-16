Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbaFPPMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:12:43 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57683 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaFPPMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:12:41 -0400
Message-ID: <539F0964.5070002@kernel.dk>
Date: Mon, 16 Jun 2014 09:12:36 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>, Fabian Frederick <fabf@skynet.be>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] block/bio.c: use GFP_NOFS
References: <1402779467-6398-1-git-send-email-fabf@skynet.be> <alpine.LSU.2.11.1406151720170.25654@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1406151720170.25654@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-15 18:28, Hugh Dickins wrote:
> On Sat, 14 Jun 2014, Fabian Frederick wrote:
>
>> Use GFP_NOFS instead of its definition.
>>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Fabian Frederick <fabf@skynet.be>
>> ---
>>   block/bio.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/block/bio.c b/block/bio.c
>> index 8c2e55e..ec5d172 100644
>> --- a/block/bio.c
>> +++ b/block/bio.c
>> @@ -211,7 +211,7 @@ fallback:
>>   		bvl = mempool_alloc(pool, gfp_mask);
>>   	} else {
>>   		struct biovec_slab *bvs = bvec_slabs + *idx;
>> -		gfp_t __gfp_mask = gfp_mask & ~(__GFP_WAIT | __GFP_IO);
>> +		gfp_t __gfp_mask = gfp_mask & ~GFP_NOFS;
>>
>>   		/*
>>   		 * Make this allocation restricted and don't dump info on
>> --
>> 1.8.4.5
>
> Please no.  The original was fine, this just makes it harder to read.

I agree. GFP_NOFS is useful when it's used as a whole, but for this use 
case, explicitly saying that we want to wait for mem and we allow IO is 
much clearer. The fact that this just happens to be GFP_NOFS doesn't 
really matter.

> (But I confess to hypocrisy in finding "& ~GFP_KERNEL" useful myself
> in the past somewhere.)

That's just sick, Hugh :-)

-- 
Jens Axboe

