Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab3DYG4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 02:56:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53023 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab3DYG4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 02:56:47 -0400
X-IronPort-AV: E=Sophos;i="4.87,548,1363104000"; 
   d="scan'208";a="7136079"
Message-ID: <5178D330.9030505@cn.fujitsu.com>
Date: Thu, 25 Apr 2013 14:54:40 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jens <axboe@kernel.dk>
Subject: Re: [PATCH] mm/filemap.c: fix criteria of calling iov_shorten() in
 generic_file_direct_write()
References: <51764857.5010808@cn.fujitsu.com> <20130424122100.GA21962@quack.suse.cz>
In-Reply-To: <20130424122100.GA21962@quack.suse.cz>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/25 14:54:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/25 14:54:55,
	Serialize complete at 2013/04/25 14:54:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2013 08:21 PM, Jan Kara wrote:

> On Tue 23-04-13 16:37:43, Gu Zheng wrote:
>> From 35947e6535d92c54cf523470cc8811e8b5fee3e5 Mon Sep 17 00:00:00 2001
>> From: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> Date: Tue, 23 Apr 2013 16:09:04 +0800
>> Subject: [PATCH] mm/filemap.c: fix criteria of calling iov_shorten() in generic_file_direct_write()
>>
>> generic_file_direct_write() compares 'count'(the max count we actually can write)
>> with 'ocount'(the count we request to write) to see if there is need to call
>> iov_shorten() to reduce number of segments and the iovec's length. If the
>> 'count' is equal or greater than 'ocount', there is no need to call iov_shorten()
>> indeed. So the judgement should be changed:
>> 'if (count != ocount)' --> 'if (count < ocount)'
>   Thanks for the patch but it shouldn't be really possible that count >
> ocount, should it? So your patch doesn't really fix anything. Or am I
> missing something?

Hi Jan,
   You are right, 'count' should not be greater than 'ocount' actually.
Please ignore this patch.

Thanks,
Gu

> 
> 								Honza
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  mm/filemap.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index e1979fd..c566b9c 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -2183,7 +2183,7 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
>>  	size_t		write_len;
>>  	pgoff_t		end;
>>  
>> -	if (count != ocount)
>> +	if (count < ocount)
>>  		*nr_segs = iov_shorten((struct iovec *)iov, *nr_segs, count);
>>  
>>  	write_len = iov_length(iov, *nr_segs);
>> -- 
>> 1.7.7
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/


