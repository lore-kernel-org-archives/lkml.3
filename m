Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165Ab3BOFOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 00:14:05 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:7833 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab3BOFOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 00:14:03 -0500
Message-ID: <511DC3EF.60904@parallels.com>
Date: Fri, 15 Feb 2013 09:13:19 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] posix timers: Allocate timer id per process
References: <511D0E50.7090505@parallels.com> <511D0E77.2090907@parallels.com> <CA+1xoqdk5PArnjSnu=7gUq_4got09a0PxBd4Yy=inezPTGsdAA@mail.gmail.com>
In-Reply-To: <CA+1xoqdk5PArnjSnu=7gUq_4got09a0PxBd4Yy=inezPTGsdAA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 12:13 AM, Sasha Levin wrote:
> On Thu, Feb 14, 2013 at 11:19 AM, Pavel Emelyanov <xemul@parallels.com> wrote:
>> From: Stanislav Kinsbursky <skinsbursky@parallels.com>
>>
>> Patch replaces global idr with global hash table for posix timers and
>> makes timer ids unique not globally, but per process. Next free timer id is
>> type of integer and stored on signal struct (posix_timer_id). If free timer
>> id reaches negative value on timer creation, it will be dropped to zero and
>> -EAGAIN will be returned to user.
>>
>> Hash table has 512 slots.
>> Key is constructed as follows:
>> key = hash_32(hash_32(current->signal) ^ posix_timer_id));
>>
>> Note: with this patch, id, returned to user, is not the minimal free
>> amymore. It means, that id, returned to user space in loop, listed below, will
>> be increasing on each iteration till INT_MAX and then dropped to zero:
>>
>> while(1) {
>>         id = timer_create(...);
>>         timer_delete(id);
>> }
>>
>> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
>> Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
> 
> Hi Pavel,
> 
> Why not use linux/hashtable.h?

Simply because this patch was just picked from the previous discussions
as is :) I will tune it to use hashtable.h in the next iteration.

> 
> Thanks,
> Sasha
> .
> 


