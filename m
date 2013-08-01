Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab3HAB6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 21:58:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab3HAB6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 21:58:24 -0400
Message-ID: <51F9C0B8.9000707@redhat.com>
Date: Wed, 31 Jul 2013 21:58:16 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Paul Turner <pjt@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, Peter Anvin <hpa@zytor.com>, dzickus@redhat.com,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched,x86: optimize switch_mm for multi-threaded workloads
References: <20130731174335.006a58f9@annuminas.surriel.com> <CA+55aFx3ZHZrgP3yQwb=ttYUeH1zFVQtUA5dFW1h8FPhjfKgUA@mail.gmail.com> <51F98CAB.80100@redhat.com> <CA+55aFwj+6P4y8MgGTGbiK_EtfY7LJ_bL_7k9zFYLx4S8F0rJQ@mail.gmail.com> <51F99218.4060104@redhat.com> <CA+55aFxKSEHSkdsCkTvjwwo4MnEpN0TwJrek2jd1QJCyUTb-=Q@mail.gmail.com> <51F999DE.7080200@redhat.com> <CAPM31R+BiTiLbNrD+33q31z8Ww7dpm7t1vcLak-hZ-z5L2PY-g@mail.gmail.com> <CA+55aFwTNQFFJbeP4bYuMBREq=n6GU2vV71ftr_7OnE6SK5OSw@mail.gmail.com>
In-Reply-To: <CA+55aFwTNQFFJbeP4bYuMBREq=n6GU2vV71ftr_7OnE6SK5OSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 08:41 PM, Linus Torvalds wrote:
> On Wed, Jul 31, 2013 at 4:14 PM, Paul Turner <pjt@google.com> wrote:
>> We attached the following explanatory comment to our version of the patch:
>>
>> /*
>> * In the common case (two user threads sharing mm
>> * switching) the bit will be set; avoid doing a write
>> * (via atomic test & set) unless we have to.  This is
>> * safe, because no other CPU ever writes to our bit
>> * in the mask, and interrupts are off (so we can't
>> * take a TLB IPI here.)  If we don't do this, then
>> * switching threads will pingpong the cpumask
>> * cacheline.
>> */
>
> So as mentioned, the "interrupts will be off" is actually dubious.
> It's true for the context switch case, but not for the activate_mm().
>
> However, as Rik points out, activate_mm() is different in that we
> shouldn't have any preexisting MMU state anyway. And besides, that
> should never trigger the "prev == next" case.
>
> But it does look a bit messy, and even your comment is a bit
> misleading (it might make somebody think that all of switch_mm() is
> protected from interrupts)
> .
> Anyway, I'm perfectly ok with the patch itself, but I just wanted to
> make sure people had thought about these things.

Would you like me to document the things we found in the comment,
and resend a patch, or is the patch good as-is?

-- 
All rights reversed
