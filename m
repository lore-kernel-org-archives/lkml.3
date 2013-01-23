Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab3AWPR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:17:29 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:52523 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab3AWPR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:17:28 -0500
MIME-Version: 1.0
In-Reply-To: <1358953487.21576.120.camel@gandalf.local.home>
References: <1358946905-13320-1-git-send-email-sedat.dilek@gmail.com>
	<CAHdPZaNYFBXMhvH7Jyy5Zy4MnB3iKfL9UW9xf3jy5MNBu8aPnw@mail.gmail.com>
	<CA+icZUW7XrOGguoPO00wxPLUr2Xc8fP=jQZwekpnmWKRewwX2g@mail.gmail.com>
	<CAFTL4hzcuxoy2deQpXDBRQZZBZ4VjT=EnO3ZZv6x-jGMTr_eaA@mail.gmail.com>
	<1358949189.21576.114.camel@gandalf.local.home>
	<CAFTL4hzSvnE-b=TEvKcT3Jpwh4ZLPsMotCC7etpUeDDFNYOQBQ@mail.gmail.com>
	<1358953487.21576.120.camel@gandalf.local.home>
Date: Wed, 23 Jan 2013 16:17:27 +0100
Message-ID: <CAFTL4hxcS-_LL8RLGaSKnb4K=MeNxzaL3GDC2JmjBDF_o4v2rg@mail.gmail.com>
Subject: Re: [PATCH 3.8-rc4-nohz3] kvm: Add missing EXPORT_SYMBOL when CONFIG_KVM=m
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: sedat.dilek@gmail.com, "devendra.aaru" <devendra.aaru@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/23 Steven Rostedt <rostedt@goodmis.org>:
> On Wed, 2013-01-23 at 15:02 +0100, Frederic Weisbecker wrote:
>
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
>
> I don't like #ifdefs in .c files. They belong in headers. Could you
> convert this to be:
>
> include/linux/context_tracking.h:
>
> #ifdef CONFIG_KVM
>  #define add_vi_i_typo()
> #else
>  #define add_vi_i_typo()        i
> #endif
>
> and then in context_tracking.c:
>
> void guest_exit(void)
> {
>         add_vi_typo();
>
> [...]

Much cleaner indeed! And this way it's more generally available for
further users.

Will do the change, thanks!
