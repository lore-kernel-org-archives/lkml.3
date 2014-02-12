Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaBLD7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 22:59:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50001 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbaBLD7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 22:59:44 -0500
X-IronPort-AV: E=Sophos;i="4.95,829,1384272000"; 
   d="scan'208";a="9510970"
Message-ID: <52FAF1A0.8040605@cn.fujitsu.com>
Date: Wed, 12 Feb 2014 11:59:28 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Robin Holt <holt@sgi.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 7/9] sys: Replace hardcoding of -20 and 19 with MIN_NICE
 and MAX_NICE.
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com> <0261f094b836f1acbcdf52e7166487c0c77323c8.1392103744.git.yangds.fnst@cn.fujitsu.com> <CAGXu5j+wSEnWAwgUBM47C8TXiEzmJt-J6sGHNEewwXqb5FgGEA@mail.gmail.com>
In-Reply-To: <CAGXu5j+wSEnWAwgUBM47C8TXiEzmJt-J6sGHNEewwXqb5FgGEA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/12 11:57:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/12 11:57:42,
	Serialize complete at 2014/02/12 11:57:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

  On 02/12/2014 02:27 AM, Kees Cook wrote:
> On Mon, Feb 10, 2014 at 11:34 PM, Dongsheng Yang
> <yangds.fnst@cn.fujitsu.com> wrote:
>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>> cc: Andrew Morton <akpm@linux-foundation.org>
>> cc: Oleg Nesterov <oleg@redhat.com>
>> cc: Robin Holt <holt@sgi.com>
>> cc: Al Viro <viro@zeniv.linux.org.uk>
>> cc: Kees Cook <keescook@chromium.org>
>> cc: "Eric W. Biederman" <ebiederm@xmission.com>
>> cc: Stephen Rothwell <sfr@canb.auug.org.au>
>> cc: Peter Zijlstra <peterz@infradead.org>
>> cc: Ingo Molnar <mingo@kernel.org>
>> ---
>>   kernel/sys.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/sys.c b/kernel/sys.c
>> index c0a58be..adaeab6 100644
>> --- a/kernel/sys.c
>> +++ b/kernel/sys.c
>> @@ -174,10 +174,10 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
>>
>>          /* normalize: avoid signed division (rounding problems) */
>>          error = -ESRCH;
>> -       if (niceval < -20)
>> -               niceval = -20;
>> -       if (niceval > 19)
>> -               niceval = 19;
>> +       if (niceval < MIN_NICE)
>> +               niceval = MIN_NICE;
>> +       if (niceval > MAX_NICE)
>> +               niceval = MAX_NICE;
> Good catch! I'm all for using names instead of numeric values,
> however, I wonder if it'd be more readable to use "clamp" instead?
>
> niceval = clamp(niceval, MIN_NICE, MAX_NICE);

Good suggestion! This patch here is just to replace the numeric values with
a name defined in prio.h. So I will send another patch to make it more 
readable
with clamp after the patch set here applied. Is this plan ok to you?

Thanx.
>
> -Kees
>
>>          rcu_read_lock();
>>          read_lock(&tasklist_lock);
>> --
>> 1.8.2.1
>>
>
>

