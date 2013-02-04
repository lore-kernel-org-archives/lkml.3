Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3BDCGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 21:06:49 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:41806 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab3BDCGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 21:06:46 -0500
MIME-Version: 1.0
In-Reply-To: <1359941916.26950.12.camel@kjgkr>
References: <1359816711-16252-1-git-send-email-linkinjeon@gmail.com>
	<1359941916.26950.12.camel@kjgkr>
Date: Mon, 4 Feb 2013 11:06:45 +0900
Message-ID: <CAKYAXd8FV=oSxjRx4y6uzuPnwz2g87ojc3aLeUv3qsKkqO1GbQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] f2fs: optimize get node page readahead part
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/4, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> Hi,
>
> 2013-02-02 (토), 23:51 +0900, Namjae Jeon:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> We can remove the call to find_get_page to get a page from the cache
>> and check for up-to-date, instead we can make use of grab_cache_page
>> part itself to fetch the page from the cache.
>> So, removing the call and moving the PageUptodate at proper place, also
>> taken care of moving the lock_page condition in the page_hit part.
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
>> ---
>>  fs/f2fs/node.c |   10 ++++------
>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
>> index 33fa6d5..723185b 100644
>> --- a/fs/f2fs/node.c
>> +++ b/fs/f2fs/node.c
>> @@ -920,15 +920,12 @@ struct page *get_node_page_ra(struct page *parent,
>> int start)
>>  	if (!nid)
>>  		return ERR_PTR(-ENOENT);
>>
>> -	page = find_get_page(mapping, nid);
>> -	if (page && PageUptodate(page))
>> -		goto page_hit;
>> -	f2fs_put_page(page, 0);
>> -
>
> The reason why we use this is to avoid the lock overhead.
> This is a readahead flow, and we don't need to care about real
> existence. Let's get and check the status of the page without any locks.
> Thanks,
Yes, Agreed. I will chceck more about this.
Thanks a lot!
>
> --
> Jaegeuk Kim
> Samsung
>
