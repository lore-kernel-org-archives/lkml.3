Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab3AWNdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 08:33:15 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:62633 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3AWNdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:33:13 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAHdPZaNYFBXMhvH7Jyy5Zy4MnB3iKfL9UW9xf3jy5MNBu8aPnw@mail.gmail.com>
References: <1358946905-13320-1-git-send-email-sedat.dilek@gmail.com>
	<CAHdPZaNYFBXMhvH7Jyy5Zy4MnB3iKfL9UW9xf3jy5MNBu8aPnw@mail.gmail.com>
Date: Wed, 23 Jan 2013 14:33:13 +0100
Message-ID: <CA+icZUW7XrOGguoPO00wxPLUr2Xc8fP=jQZwekpnmWKRewwX2g@mail.gmail.com>
Subject: Re: [PATCH 3.8-rc4-nohz3] kvm: Add missing EXPORT_SYMBOL when CONFIG_KVM=m
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 2:17 PM, devendra.aaru <devendra.aaru@gmail.com> wrote:
> On Wed, Jan 23, 2013 at 8:15 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> With CONFIG_KVM=m my build with 3.8-rc4-nohz3 breaks like this:
>>
>> ERROR: "guest_enter" [arch/x86/kvm/kvm.ko] undefined!
>> ERROR: "guest_exit" [arch/x86/kvm/kvm.ko] undefined!
>>
>> Fix this by adding the missing EXPORT_SYMBOL for guest_enter() and
>> guest_exit() in kernel/context_tracking.c as suggested by Frederic.
>>
>> This issue was introduced with commit 8eebafe9be58 ("kvm: Prepare to
>> add generic guest entry/exit callbacks").
>>
>> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>> ---
>>  kernel/context_tracking.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
>> index bbb2c2c..950f30a 100644
>> --- a/kernel/context_tracking.c
>> +++ b/kernel/context_tracking.c
>> @@ -111,14 +111,16 @@ void guest_enter(void)
>>         else
>>                 __guest_enter();
>>  }
>> +EXPORT_SYMBOL(guest_enter);
>>
>>  void guest_exit(void)
>> -{
>> +{i
>
> compilation fails with that?
>

Hmmm, yes, but why, clueless, CONFIG_KVM=y as a workaround!

- Sedat -

>
>>         if (vtime_accounting_enabled())
>>                 vtime_guest_exit(current);
>>         else
>>                 __guest_exit();
>>  }
>> +EXPORT_SYMBOL(guest_exit);
>>  #endif
>>
>>
>> --
>> 1.8.1.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
