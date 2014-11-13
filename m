Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238AbaKMNz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:55:58 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:51007 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933029AbaKMNz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:55:57 -0500
MIME-Version: 1.0
In-Reply-To: <20141113025337.GA9068@medulla.variantweb.net>
References: <1415532143-4409-1-git-send-email-opensource.ganesh@gmail.com>
	<20141113025337.GA9068@medulla.variantweb.net>
Date: Thu, 13 Nov 2014 21:55:56 +0800
Message-ID: <CADAEsF83UsvEm02zjVtjUt7-kMkKq69xZ8bAAGtHRjAYmXw_SA@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: unregister zswap_cpu_notifier_block in cleanup procedure
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
To: Seth Jennings <sjennings@variantweb.net>
Cc: Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-13 10:53 GMT+08:00 Seth Jennings <sjennings@variantweb.net>:
> On Sun, Nov 09, 2014 at 07:22:23PM +0800, Mahendran Ganesh wrote:
>> In zswap_cpu_init(), the code does not unregister *zswap_cpu_notifier_block*
>> during the cleanup procedure.
>
> This is not needed.  If we are in the cleanup code, we never got to the
> __register_cpu_notifier() call.

Yes, you are right. Thanks for you review.

>
> Thanks,
> Seth
>
>>
>> This patch fix this issue.
>>
>> Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
>> ---
>>  mm/zswap.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index ea064c1..51a2c45 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -404,6 +404,7 @@ static int zswap_cpu_init(void)
>>  cleanup:
>>       for_each_online_cpu(cpu)
>>               __zswap_cpu_notifier(CPU_UP_CANCELED, cpu);
>> +     __unregister_cpu_notifier(&zswap_cpu_notifier_block);
>>       cpu_notifier_register_done();
>>       return -ENOMEM;
>>  }
>> --
>> 1.7.9.5
>>
