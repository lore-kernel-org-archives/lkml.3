Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab3AWPDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:03:32 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:48998 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab3AWPDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:03:30 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUXM+tj5hnh--3CraRsvrsKfBUrS7Udf2L1OEhBnvWqpjQ@mail.gmail.com>
References: <1358946905-13320-1-git-send-email-sedat.dilek@gmail.com>
	<CAHdPZaNYFBXMhvH7Jyy5Zy4MnB3iKfL9UW9xf3jy5MNBu8aPnw@mail.gmail.com>
	<CA+icZUW7XrOGguoPO00wxPLUr2Xc8fP=jQZwekpnmWKRewwX2g@mail.gmail.com>
	<CAFTL4hzcuxoy2deQpXDBRQZZBZ4VjT=EnO3ZZv6x-jGMTr_eaA@mail.gmail.com>
	<1358949189.21576.114.camel@gandalf.local.home>
	<CAFTL4hzSvnE-b=TEvKcT3Jpwh4ZLPsMotCC7etpUeDDFNYOQBQ@mail.gmail.com>
	<CA+icZUXM+tj5hnh--3CraRsvrsKfBUrS7Udf2L1OEhBnvWqpjQ@mail.gmail.com>
Date: Wed, 23 Jan 2013 16:03:29 +0100
Message-ID: <CAFTL4hwkRv5LjzXN2BmSxS73GqKZkJ=H92qaD+ohvdOs-pAxHg@mail.gmail.com>
Subject: Re: [PATCH 3.8-rc4-nohz3] kvm: Add missing EXPORT_SYMBOL when CONFIG_KVM=m
From: Frederic Weisbecker <fweisbec@gmail.com>
To: sedat.dilek@gmail.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "devendra.aaru" <devendra.aaru@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/23 Sedat Dilek <sedat.dilek@gmail.com>:
> On Wed, Jan 23, 2013 at 3:02 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> 2013/1/23 Steven Rostedt <rostedt@goodmis.org>:
>>> On Wed, 2013-01-23 at 14:46 +0100, Frederic Weisbecker wrote:
>>>
>>>> > Hmmm, yes, but why, clueless, CONFIG_KVM=y as a workaround!
>>>>
>>>> I believe he pointed out the "{i" to you. Typing mistake?
>>>
>>> In which case the CONFIG_KVM=y is a work around if that {i is within a
>>> #ifndef CONFIG_KVM ;-)
>>
>> No it's in #ifdef CONFIG_KVM so the right fix is:
>>
>> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
>> index bbb2c2c..a13b8a3 100644
>> --- a/kernel/context_tracking.c
>> +++ b/kernel/context_tracking.c
>> @@ -111,14 +111,19 @@ void guest_enter(void)
>>         else
>>                 __guest_enter();
>>  }
>> +EXPORT_SYMBOL_GPL(guest_enter);
>>
>>  void guest_exit(void)
>>  {
>> +#ifndef CONFIG_KVM
>> +i
>> +#endif
>>         if (vtime_accounting_enabled())
>>                 vtime_guest_exit(current);
>>         else
>>                 __guest_exit();
>>  }
>> +EXPORT_SYMBOL_GPL(guest_exit);
>>  #endif
>
> So, what's the real fix for this issue?

So CONFIG_SOMETHING doesn't work when it's a module. Hence we need to
remove the ifdef CONFIG_KVM around guest_enter(), guest_exit(),
vtime_guest_enter() and vtime_guest_exit(). Also it seems we need
<linux/export.h> in context_tracking.c
