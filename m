Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbaEFOeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 10:34:50 -0400
Received: from mail1.windriver.com ([147.11.146.13]:64965 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaEFOet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 10:34:49 -0400
Message-ID: <5368F323.7070407@windriver.com>
Date: Tue, 6 May 2014 10:35:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>,
        Richard Weinberger <richard.weinberger@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] Deprecate BUG/BUG_ON in favour of BUG_AND_HALT/BUG_AND_HALT_ON
References: <1398870207-52889-1-git-send-email-paul.gortmaker@windriver.com> <CAFLxGvzhd6jwGsu9eOBtXu92JcH1PnZsR9EB_h5LihYRNS-hyQ@mail.gmail.com> <20140506073500.GA26303@gmail.com>
In-Reply-To: <20140506073500.GA26303@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-05-06 03:35 AM, Ingo Molnar wrote:
> 
> * Richard Weinberger <richard.weinberger@gmail.com> wrote:
> 
>> On Wed, Apr 30, 2014 at 5:03 PM, Paul Gortmaker
>> <paul.gortmaker@windriver.com> wrote:
>>> A long standing problem for us has been the misuse of BUG/BUG_ON.
>>> The typical misuse is someone only thinking of what represents
>>> a bug in their local code, and especially for people relatively
>>> new to Linux, starting out in device drivers, the appeal of using
>>> BUG w/o knowing what it really does is too great.
>>>

[...]

>>>
>>> +# Dont use BUG/BUG_ON; use WARN/WARN_ON or BUG_AND_HALT/BUG_AND_HALT_ON
>>> +               if ($rawline =~ /^\+.*BUG\(/ || $rawline =~ /^\+.*BUG_ON\(/) {
>>> +                       my $herevet = "$here\n" . cat_vet($rawline) . "\n";
>>> +                       WARN("BUG/BUG_ON",
>>> +                            "Use of BUG/BUG_ON is deprecated. Use WARN/WARN_ON or BUG_AND_HALT/BUG_AND_HALT_ON\n" . $herevet);
>>> +               }
>>> +
>>>  # Check for FSF mailing addresses.
>>>                 if ($rawline =~ /\bwrite to the Free/i ||
>>>                     $rawline =~ /\b59\s+Temple\s+Pl/i ||
>>> --
>>
>> I like the idea but not the name.
>> What about DIE() and DIE_ON()?
> 
> CRASH_ON() might be a suggestive name as well, as from the user's 
> point of view we are crashing her system.

I'd considered HALT_AND_CATCH_FIRE_ON(...) but it was too much typing
and the PC police already forced us to remove that from the lpr driver
decades ago.  So CRASH_ON works for me.  If nobody dislikes the idea,
and we are only bikeshedding over the names, then that is a good thing.

I'll let the idea stew for another day or two and send a renamed v2.

Thanks,
Paul.
--

> 
> Thanks,
> 
> 	Ingo
> 
