Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3BUV5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:57:36 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:58384 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3BUV5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:57:35 -0500
MIME-Version: 1.0
In-Reply-To: <20130221134227.33679567.akpm@linux-foundation.org>
References: <3556388.kjl7k6r8W6@vostro.rjw.lan>
	<1361465501-19744-1-git-send-email-msb@chromium.org>
	<20130221134227.33679567.akpm@linux-foundation.org>
Date: Thu, 21 Feb 2013 13:57:35 -0800
X-Google-Sender-Auth: 6k10eLnWS3ZQpesc5kENpz30n94
Message-ID: <CACBanvrvhBhD_kHcBx_dC6-coROc99_94=DozEkOkLuqGukYeQ@mail.gmail.com>
Subject: Re: [PATCH v6] lockdep: check that no locks held at freeze time
From: Mandeep Singh Baines <msb@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 1:42 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 21 Feb 2013 08:51:41 -0800
> Mandeep Singh Baines <msb@chromium.org> wrote:
>
>> We shouldn't try_to_freeze if locks are held. Holding a lock
>> can cause a deadlock if the lock is later acquired in the
>> suspend or hibernate path (e.g. by dpm). Holding a lock can
>> also cause a deadlock in the case of cgroup_freezer if a
>> lock is held inside a frozen cgroup that is later acquired by
>> a process outside that group.
>>
>> ...
>>
>> --- a/include/linux/freezer.h
>> +++ b/include/linux/freezer.h
>>
>> ...
>>
>> @@ -43,6 +44,8 @@ extern void thaw_kernel_threads(void);
>>
>>  static inline bool try_to_freeze(void)
>>  {
>> +     if (!(current->flags & PF_NOFREEZE))
>> +             debug_check_no_locks_held();
>>       might_sleep();
>>       if (likely(!freezing(current)))
>>               return false;
>>
>> ...
>>
>
> It still needs
> http://ozlabs.org/~akpm/mmots/broken-out/lockdep-check-that-no-locks-held-at-freeze-time-fix.patch

D'oh. I tricked myself into thinking its part of freezer so no export
needed but its inlined so can be pulled in anywhere.

Thanks for the fix:

Acked-by: Mandeep Singh Baines <msb@chromium.org>

Or should I roll in the fix and re-send with your Sign-off.

Regards,
Mandeep
