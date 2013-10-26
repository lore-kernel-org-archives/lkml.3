Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab3JZJqE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 05:46:04 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:50860 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3JZJqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 05:46:02 -0400
MIME-Version: 1.0
In-Reply-To: <20131025102032.GE6612@gmail.com>
References: <000101ced09e$fed90a10$fc8b1e30$%yang@samsung.com>
	<20131025102032.GE6612@gmail.com>
Date: Sat, 26 Oct 2013 17:46:00 +0800
Message-ID: <CAL1ERfOhhJ12zXwsGJoHWRzkd2destQnJ32nfU25SOACCnzy7Q@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/2] mm/zswap: refoctor the get/put routines
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Weijie Yang <weijie.yang@samsung.com>, akpm@linux-foundation.org,
        sjennings@variantweb.net, bob.liu@oracle.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 6:20 PM, Minchan Kim <minchan@kernel.org> wrote:
> On Thu, Oct 24, 2013 at 05:53:32PM +0800, Weijie Yang wrote:
>> The refcount routine was not fit the kernel get/put semantic exactly,
>> There were too many judgement statements on refcount and it could be minus.
>>
>> This patch does the following:
>>
>> - move refcount judgement to zswap_entry_put() to hide resource free function.
>>
>> - add a new function zswap_entry_find_get(), so that callers can use easily
>> in the following pattern:
>>
>>    zswap_entry_find_get
>>    .../* do something */
>>    zswap_entry_put
>>
>> - to eliminate compile error, move some functions declaration
>>
>> This patch is based on Minchan Kim <minchan@kernel.org> 's idea and suggestion.
>>
>> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
>> Cc: Seth Jennings <sjennings@variantweb.net>
>> Cc: Minchan Kim <minchan@kernel.org>
>> Cc: Bob Liu <bob.liu@oracle.com>
>
>
> I remember Bob had a idea to remove a look up and I think it's doable.
> Anyway, I don't mind you send it with fix or not.

Thanks for review.

Bob's idea is:
"Then how about  use if (!RB_EMPTY_NODE(&entry->rbnode))  to
 replace rbtree searching?"

I'm afraid not. Because entry could be freed in previous zswap_entry_put,
we cann't reference entry or we would touch a free-and-use issue.

> Thanks for handling this, Weijie!
>
> Acked-by: Minchan Kim <minchan@kernel.org>
>
> --
> Kind regards,
> Minchan Kim
