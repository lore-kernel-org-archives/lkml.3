Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaIDErj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 00:47:39 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:60666 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaIDErh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 00:47:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140903154219.GA30011@mtj.dyndns.org>
References: <1408050926-9525-1-git-send-email-xiyou.wangcong@gmail.com>
	<20140816122028.GC9305@htj.dyndns.org>
	<CAM_iQpVaWR-jZN3RByZgGsytRnv0NBxbXh_Y1WSdJqhasuygaQ@mail.gmail.com>
	<20140903154219.GA30011@mtj.dyndns.org>
Date: Wed, 3 Sep 2014 21:47:37 -0700
Message-ID: <CAM_iQpUCN8d_d9U+wE05zxM_LWiDwqV_9pNXgquZQybQJdY+XA@mail.gmail.com>
Subject: Re: [Patch v3 1/2] freezer: check OOM kill while being frozen
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2014 at 8:42 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Cong.
>
> On Tue, Sep 02, 2014 at 03:52:40PM -0700, Cong Wang wrote:
>> diff --git a/kernel/freezer.c b/kernel/freezer.c
>> index 33cbcb0..b06a059 100644
>> --- a/kernel/freezer.c
>> +++ b/kernel/freezer.c
>> @@ -56,7 +56,8 @@ static bool should_thaw_current(bool check_kthr_stop)
>>  {
>>         if (!freezing(current) ||
>>             (check_kthr_stop && kthread_should_stop()) ||
>> -           test_thread_flag(TIF_MEMDIE))
>> +           /* It might not be safe to check TIF_MEMDIE for pm freeze */
>> +           (cgroup_freezing(current) && test_thread_flag(TIF_MEMDIE)))
>>                 return true;
>>         else
>>                 return false;
>>
>> Are you happy now, Tejun? :)
>
> Yes, this should be a lot safer.  The function still looks weird to me
> tho.

Cool.

>
>         if (cond)
>                 return true;
>         else
>                 return false;
>
> is equivalent to
>
>         return cond;
>
> If you're worried that the conditional is too complex and harms
> readability you can do
>
>         /* explain cond0 */
>         if (cond0)
>                 return true;
>
>         /* explain cond1 */
>         if (cond1)
>                 return true;
>
>         return false;
>

Sure, definitely much more readable. I will update this patch.

Thanks!
