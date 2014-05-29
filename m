Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaE2Wpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 18:45:45 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:57373 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbaE2Wpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 18:45:43 -0400
MIME-Version: 1.0
In-Reply-To: <5385B46B.9030807@imgtec.com>
References: <1400796102-12832-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<5385B46B.9030807@imgtec.com>
Date: Fri, 30 May 2014 00:45:42 +0200
Message-ID: <CAFo99gb3sPVmHSJQFAppfNmrRm4OBsn4QwpoWz2_wYKnkaoMRw@mail.gmail.com>
Subject: Re: [PATCH] arch: metag: mm: hugetlbpage.c: Cleaning up inconsistent
 NULL checks
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: James Hogan <james.hogan@imgtec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-metag@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul <Paul.Burton@imgtec.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

First, I do not think we'll adapt the code as a static code checking to work!
This must be resolved by other means.

But yes, it is control where that gets cppcheck to react. And it is
then also an unnecessary control. So then I guess it's ok to remove
it.
I resend a patch, with it removed.


Best regards
Rickard Strandqvist


2014-05-28 12:03 GMT+02:00 James Hogan <james.hogan@imgtec.com>:
> Hi Rickard,
>
> On 22/05/14 23:01, Rickard Strandqvist wrote:
>> Cleaning up inconsistent NULL checks.
>> There is otherwise a risk of a possible null pointer dereference.
>>
>> Was largely found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  arch/metag/mm/hugetlbpage.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/metag/mm/hugetlbpage.c b/arch/metag/mm/hugetlbpage.c
>> index 0424315..3f8d5cd 100644
>> --- a/arch/metag/mm/hugetlbpage.c
>> +++ b/arch/metag/mm/hugetlbpage.c
>> @@ -188,7 +188,8 @@ new_search:
>>                       }
>>               }
>>               after_huge = 0;
>> -             addr = ALIGN_HUGEPT(vma->vm_end);
>> +             if (vma)
>> +                     addr = ALIGN_HUGEPT(vma->vm_end);
>>       }
>>  }
>>  #endif
>>
>
> I don't think this is a correct fix.
>
> If !vma && !after_huge the first if block in the loop will match and the
> function will return 0.
> If !vma && after_huge the 3rd if block in the loop will match and the
> function will return addr.
>
> So removing the vma condition on the final if block in the loop would
> probably make sense instead. Does that satisfy cppcheck?
>
> Cheers
> James
