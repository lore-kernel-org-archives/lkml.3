Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbbAIS0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 13:26:07 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:49139 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbbAIS0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 13:26:05 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <87r3v350io.fsf@tassilo.jf.intel.com>
References: <54AE5BE8.1050701@gmail.com> <87r3v350io.fsf@tassilo.jf.intel.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 9 Jan 2015 19:25:43 +0100
Message-ID: <CAKgNAki3Fh8N=jyPHxxFpicjyJ=0kA75SJ65QjYzPmWnvy4nsw@mail.gmail.com>
Subject: Re: [PATCH] x86, mpx: Ensure unused arguments of prctl() MPX requests
 are 0
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 January 2015 at 18:25, Andi Kleen <andi@firstfloor.org> wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>
>> From: Michael Kerrisk <mtk.manpages@gmail.com>
>>
>> commit fe8c7f5cbf91124987106faa3bdf0c8b955c4cf7 added two new prctl()
>> operations, PR_MPX_ENABLE_MANAGEMENT and PR_MPX_DISABLE_MANAGEMENT.
>> However, no checks were included to ensure that unused arguments
>> are zero, as is done in many existing prctl()s and as should be
>> done for all new prctl()s. This patch adds the required checks.
>
> This will break the existing gcc run time, which doesn't zero these
> arguments.

I'm a little lost here. Weren't these flags new in the
as-yet-unreleased 3.19? How does gcc run-time depends on them already?

Thanks,

Michael


>> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
>> ---
>>  kernel/sys.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/kernel/sys.c b/kernel/sys.c
>> index a8c9f5a..ea9c881 100644
>> --- a/kernel/sys.c
>> +++ b/kernel/sys.c
>> @@ -2210,9 +2210,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>>               up_write(&me->mm->mmap_sem);
>>               break;
>>       case PR_MPX_ENABLE_MANAGEMENT:
>> +             if (arg2 || arg3 || arg4 || arg5)
>> +                     return -EINVAL;
>>               error = MPX_ENABLE_MANAGEMENT(me);
>>               break;
>>       case PR_MPX_DISABLE_MANAGEMENT:
>> +             if (arg2 || arg3 || arg4 || arg5)
>> +                     return -EINVAL;
>>               error = MPX_DISABLE_MANAGEMENT(me);
>>               break;
>>       default:
>> --
>> 1.9.3
>
> --
> ak@linux.intel.com -- Speaking for myself only



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
