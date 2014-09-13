Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaIMCsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 22:48:16 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:58946 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaIMCsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 22:48:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140911191830.GA31511@roeck-us.net>
References: <1410396496-13845-1-git-send-email-roy.qing.li@gmail.com>
	<20140911191830.GA31511@roeck-us.net>
Date: Sat, 13 Sep 2014 10:48:14 +0800
Message-ID: <CAJFZqHwsjuw5As6duphrgbzxtwmE2ZqbraNEme88M3hi1WBiRQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] signal: replace !likely with unlikely!
From: Li RongQing <roy.qing.li@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, fabf@skynet.be,
        jkosina@suse.cz, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        richard@nod.at, oleg@redhat.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did not test, how to test it?

On Fri, Sep 12, 2014 at 3:18 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Thu, Sep 11, 2014 at 08:48:16AM +0800, roy.qing.li@gmail.com wrote:
>> From: Li RongQing <roy.qing.li@gmail.com>
>>
>> !likely() is hard to be understood, and I do not know if compiler can
>> optimise this condition, but unlikely(!()) is clear
>>
>> Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
>> ---
>>  kernel/signal.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/signal.c b/kernel/signal.c
>> index 8f0876f..6156cfa 100644
>> --- a/kernel/signal.c
>> +++ b/kernel/signal.c
>> @@ -1571,7 +1571,7 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
>>       BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
>>
>>       ret = -1;
>> -     if (!likely(lock_task_sighand(t, &flags)))
>> +     if (unlikely(!lock_task_sighand(t, &flags)))
>
> I wonder if you tested this code. Seems to be unlikely (punt not intended).
>
> Guenter
>
>>               goto ret;
>>
>>       ret = 1; /* the signal is ignored */
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
