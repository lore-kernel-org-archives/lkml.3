Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161008Ab3LFLqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 06:46:45 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63526 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660Ab3LFLqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 06:46:44 -0500
MIME-Version: 1.0
In-Reply-To: <52A191D3.5050507@cn.fujitsu.com>
References: <1386319310-28016-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1386319310-28016-3-git-send-email-iamjoonsoo.kim@lge.com>
	<52A191D3.5050507@cn.fujitsu.com>
Date: Fri, 6 Dec 2013 20:46:43 +0900
Message-ID: <CAAmzW4MXZyBA-RrVhL2QcFQfddBRoyROhO6xTYgQ0wJsMO6PmQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] mm/migrate: remove putback_lru_pages, fix comment on putback_movable_pages
From: Joonsoo Kim <js1304@gmail.com>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/6 Zhang Yanfei <zhangyanfei@cn.fujitsu.com>:
> Hello
>
> On 12/06/2013 04:41 PM, Joonsoo Kim wrote:
>> Some part of putback_lru_pages() and putback_movable_pages() is
>> duplicated, so it could confuse us what we should use.
>> We can remove putback_lru_pages() since it is not really needed now.
>> This makes us undestand and maintain the code more easily.
>>
>> And comment on putback_movable_pages() is stale now, so fix it.
>>
>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>
>> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
>> index f5096b5..7782b74 100644
>> --- a/include/linux/migrate.h
>> +++ b/include/linux/migrate.h
>> @@ -35,7 +35,6 @@ enum migrate_reason {
>>
>>  #ifdef CONFIG_MIGRATION
>>
>> -extern void putback_lru_pages(struct list_head *l);
>>  extern void putback_movable_pages(struct list_head *l);
>>  extern int migrate_page(struct address_space *,
>>                       struct page *, struct page *, enum migrate_mode);
>> @@ -59,7 +58,6 @@ extern int migrate_page_move_mapping(struct address_space *mapping,
>>  #else
>>
>>  static inline void putback_lru_pages(struct list_head *l) {}
>
> If you want to remove the function, this should be removed, right?

Hello, Zhang.

Oop... It's my mistake. I will send v2.
Thanks for finding this.

Thanks.
