Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab3AWPZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:25:58 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:41629 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab3AWPZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:25:57 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUVPDx=SkGFvYpACjoFE4NWchCJGs3ZnOVshs-a0dBYA3A@mail.gmail.com>
References: <1358946905-13320-1-git-send-email-sedat.dilek@gmail.com>
	<CAHdPZaNYFBXMhvH7Jyy5Zy4MnB3iKfL9UW9xf3jy5MNBu8aPnw@mail.gmail.com>
	<CA+icZUW7XrOGguoPO00wxPLUr2Xc8fP=jQZwekpnmWKRewwX2g@mail.gmail.com>
	<CAFTL4hzcuxoy2deQpXDBRQZZBZ4VjT=EnO3ZZv6x-jGMTr_eaA@mail.gmail.com>
	<1358949189.21576.114.camel@gandalf.local.home>
	<CAFTL4hzSvnE-b=TEvKcT3Jpwh4ZLPsMotCC7etpUeDDFNYOQBQ@mail.gmail.com>
	<CA+icZUXM+tj5hnh--3CraRsvrsKfBUrS7Udf2L1OEhBnvWqpjQ@mail.gmail.com>
	<CAFTL4hwkRv5LjzXN2BmSxS73GqKZkJ=H92qaD+ohvdOs-pAxHg@mail.gmail.com>
	<CA+icZUVPDx=SkGFvYpACjoFE4NWchCJGs3ZnOVshs-a0dBYA3A@mail.gmail.com>
Date: Wed, 23 Jan 2013 16:25:55 +0100
Message-ID: <CA+icZUW9g=GRQWkpHz=AmAvr3AdRxe7-PrJiDC=Vsu0R0bwRTg@mail.gmail.com>
Subject: Re: [PATCH 3.8-rc4-nohz3] kvm: Add missing EXPORT_SYMBOL when CONFIG_KVM=m
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "devendra.aaru" <devendra.aaru@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 4:20 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Wed, Jan 23, 2013 at 4:03 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> 2013/1/23 Sedat Dilek <sedat.dilek@gmail.com>:
>>> On Wed, Jan 23, 2013 at 3:02 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>>> 2013/1/23 Steven Rostedt <rostedt@goodmis.org>:
>>>>> On Wed, 2013-01-23 at 14:46 +0100, Frederic Weisbecker wrote:
>>>>>
>>>>>> > Hmmm, yes, but why, clueless, CONFIG_KVM=y as a workaround!
>>>>>>
>>>>>> I believe he pointed out the "{i" to you. Typing mistake?
>>>>>
>>>>> In which case the CONFIG_KVM=y is a work around if that {i is within a
>>>>> #ifndef CONFIG_KVM ;-)
>>>>
>>>> No it's in #ifdef CONFIG_KVM so the right fix is:
>>>>
>>>> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
>>>> index bbb2c2c..a13b8a3 100644
>>>> --- a/kernel/context_tracking.c
>>>> +++ b/kernel/context_tracking.c
>>>> @@ -111,14 +111,19 @@ void guest_enter(void)
>>>>         else
>>>>                 __guest_enter();
>>>>  }
>>>> +EXPORT_SYMBOL_GPL(guest_enter);
>>>>
>>>>  void guest_exit(void)
>>>>  {
>>>> +#ifndef CONFIG_KVM
>>>> +i
>>>> +#endif
>>>>         if (vtime_accounting_enabled())
>>>>                 vtime_guest_exit(current);
>>>>         else
>>>>                 __guest_exit();
>>>>  }
>>>> +EXPORT_SYMBOL_GPL(guest_exit);
>>>>  #endif
>>>
>>> So, what's the real fix for this issue?
>>
>> So CONFIG_SOMETHING doesn't work when it's a module. Hence we need to
>> remove the ifdef CONFIG_KVM around guest_enter(), guest_exit(),
>> vtime_guest_enter() and vtime_guest_exit(). Also it seems we need
>> <linux/export.h> in context_tracking.c
>
> You mean sth. like this?
>

Isn't vtime.h missing in kvm_host.h as an include?

- Sedat -

> - Sedat -
