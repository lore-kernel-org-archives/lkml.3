Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaBLGkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 01:40:35 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:61980 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaBLGkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 01:40:33 -0500
MIME-Version: 1.0
In-Reply-To: <52FAF1A0.8040605@cn.fujitsu.com>
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
	<0261f094b836f1acbcdf52e7166487c0c77323c8.1392103744.git.yangds.fnst@cn.fujitsu.com>
	<CAGXu5j+wSEnWAwgUBM47C8TXiEzmJt-J6sGHNEewwXqb5FgGEA@mail.gmail.com>
	<52FAF1A0.8040605@cn.fujitsu.com>
Date: Tue, 11 Feb 2014 22:40:32 -0800
X-Google-Sender-Auth: 1Q5EPsuq4LuPlpFVC-5K6vnOkGs
Message-ID: <CAGXu5jKqEF7KPk0MipmcSB_5=Ka3RfehKS7gceFjUaOyMQSeng@mail.gmail.com>
Subject: Re: [PATCH 7/9] sys: Replace hardcoding of -20 and 19 with MIN_NICE
 and MAX_NICE.
From: Kees Cook <keescook@chromium.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Robin Holt <holt@sgi.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 7:59 PM, Dongsheng Yang
<yangds.fnst@cn.fujitsu.com> wrote:
> Hi Kees,
>
>
>  On 02/12/2014 02:27 AM, Kees Cook wrote:
>>
>> On Mon, Feb 10, 2014 at 11:34 PM, Dongsheng Yang
>> <yangds.fnst@cn.fujitsu.com> wrote:
>>>
>>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>>> cc: Andrew Morton <akpm@linux-foundation.org>
>>> cc: Oleg Nesterov <oleg@redhat.com>
>>> cc: Robin Holt <holt@sgi.com>
>>> cc: Al Viro <viro@zeniv.linux.org.uk>
>>> cc: Kees Cook <keescook@chromium.org>
>>> cc: "Eric W. Biederman" <ebiederm@xmission.com>
>>> cc: Stephen Rothwell <sfr@canb.auug.org.au>
>>> cc: Peter Zijlstra <peterz@infradead.org>
>>> cc: Ingo Molnar <mingo@kernel.org>
>>> ---
>>>   kernel/sys.c | 8 ++++----
>>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/kernel/sys.c b/kernel/sys.c
>>> index c0a58be..adaeab6 100644
>>> --- a/kernel/sys.c
>>> +++ b/kernel/sys.c
>>> @@ -174,10 +174,10 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who,
>>> int, niceval)
>>>
>>>          /* normalize: avoid signed division (rounding problems) */
>>>          error = -ESRCH;
>>> -       if (niceval < -20)
>>> -               niceval = -20;
>>> -       if (niceval > 19)
>>> -               niceval = 19;
>>> +       if (niceval < MIN_NICE)
>>> +               niceval = MIN_NICE;
>>> +       if (niceval > MAX_NICE)
>>> +               niceval = MAX_NICE;
>>
>> Good catch! I'm all for using names instead of numeric values,
>> however, I wonder if it'd be more readable to use "clamp" instead?
>>
>> niceval = clamp(niceval, MIN_NICE, MAX_NICE);
>
>
> Good suggestion! This patch here is just to replace the numeric values with
> a name defined in prio.h. So I will send another patch to make it more
> readable
> with clamp after the patch set here applied. Is this plan ok to you?

Sounds good to me. Thanks!

-Kees

>
> Thanx.
>
>>
>> -Kees
>>
>>>          rcu_read_lock();
>>>          read_lock(&tasklist_lock);
>>> --
>>> 1.8.2.1
>>>
>>
>>
>



-- 
Kees Cook
Chrome OS Security
