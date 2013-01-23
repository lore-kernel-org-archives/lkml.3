Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab3AWNxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 08:53:11 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:46893 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab3AWNxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:53:09 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUW7XrOGguoPO00wxPLUr2Xc8fP=jQZwekpnmWKRewwX2g@mail.gmail.com>
References: <1358946905-13320-1-git-send-email-sedat.dilek@gmail.com>
	<CAHdPZaNYFBXMhvH7Jyy5Zy4MnB3iKfL9UW9xf3jy5MNBu8aPnw@mail.gmail.com>
	<CA+icZUW7XrOGguoPO00wxPLUr2Xc8fP=jQZwekpnmWKRewwX2g@mail.gmail.com>
Date: Wed, 23 Jan 2013 14:46:14 +0100
Message-ID: <CAFTL4hzcuxoy2deQpXDBRQZZBZ4VjT=EnO3ZZv6x-jGMTr_eaA@mail.gmail.com>
Subject: Re: [PATCH 3.8-rc4-nohz3] kvm: Add missing EXPORT_SYMBOL when CONFIG_KVM=m
From: Frederic Weisbecker <fweisbec@gmail.com>
To: sedat.dilek@gmail.com
Cc: "devendra.aaru" <devendra.aaru@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/23 Sedat Dilek <sedat.dilek@gmail.com>:
> On Wed, Jan 23, 2013 at 2:17 PM, devendra.aaru <devendra.aaru@gmail.com> wrote:
>> On Wed, Jan 23, 2013 at 8:15 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> With CONFIG_KVM=m my build with 3.8-rc4-nohz3 breaks like this:
>>>
>>> ERROR: "guest_enter" [arch/x86/kvm/kvm.ko] undefined!
>>> ERROR: "guest_exit" [arch/x86/kvm/kvm.ko] undefined!
>>>
>>> Fix this by adding the missing EXPORT_SYMBOL for guest_enter() and
>>> guest_exit() in kernel/context_tracking.c as suggested by Frederic.
>>>
>>> This issue was introduced with commit 8eebafe9be58 ("kvm: Prepare to
>>> add generic guest entry/exit callbacks").
>>>
>>> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>>> ---
>>>  kernel/context_tracking.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
>>> index bbb2c2c..950f30a 100644
>>> --- a/kernel/context_tracking.c
>>> +++ b/kernel/context_tracking.c
>>> @@ -111,14 +111,16 @@ void guest_enter(void)
>>>         else
>>>                 __guest_enter();
>>>  }
>>> +EXPORT_SYMBOL(guest_enter);
>>>
>>>  void guest_exit(void)
>>> -{
>>> +{i
>>
>> compilation fails with that?
>>
>
> Hmmm, yes, but why, clueless, CONFIG_KVM=y as a workaround!

I believe he pointed out the "{i" to you. Typing mistake?
