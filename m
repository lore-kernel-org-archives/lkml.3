Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966395Ab3DQNtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 09:49:22 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:56853 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966116Ab3DQNtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 09:49:21 -0400
Message-ID: <A54DBB19C9CE485FB926E6B9199E7452@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: KVM "Hyper-V emulation" -- this can be related "Linux on Hyper-V" ? Or "KVM emulates Hyper-V" as "Hyper-V emulates Hyper-V" ? Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Date: Wed, 17 Apr 2013 16:49:16 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.4548
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

2013/4/17 Jan Beulich
>
> >>> On 17.04.13 at 12:16, "Michael S. Tsirkin"  wrote:
> > If the hypervisor says it's Hyper-V, that's because it wants
> > guests to use Hyper-V. I don't see why is guest second-guessing
> > this a good idea.
>
> There are two reasons here: For one, when the hypervisor is not
> Hyper-V, but is providing some Hyper-V emulation, that's intended
> for Windows guests to use, not e.g. Linux ones, especially when
> such guests could use the native hypervisor interface with much
> greater benefit.
>
> And second, there reportedly are features of (newer?) Hyper-V
> that some emulation may not provide, but that are also not easily
> detectable.
>


Yes

+



> On Wed, Apr 17, 2013 at 12:10:01PM +0300, Victor Miasnikov wrote:



>>
>> Question is very simple:  Hyper-V users/sysadmins need wait patch a-la this:
>> Or  "KVM_and_or_XEN_or_other_Hypervisor_what_has_non-full-emulation_of_Hyper-V emulates Hyper-V" as "Hyper-V emulates
>> Hyper-V" ?
>>
>
> No.  You are using Hyper-V, not the KVM_and_or_XEN_or_other_Hypervisor_what_has_non-full-emulation_of_Hyper-V
> emulation of it.
> No patches dealing with this emulation should have any effect on you.


 This is _positive_ variant of possible future,
but on _practic_ very often we need prevent _negative_ variant of possible future


>> ==
>> + /*
>> +  * KVM_and_or_XEN_or_other_Hypervisor_what_has_non-full-emulation_of_Hyper-V emulates Hyper-V to support
>> enlightened Windows.
>> +  * Check to see first if we are on a KVM_and_or_XEN_or_other_Hypervisor_what_has_non-full-emulation_of_Hyper-V
>> Hypervisor.
>> +  */
>> +
>> + if (KVM_and_or_XEN_or_other_Hypervisor_what_has_non-full-emulation_of_Hyper-V_cpuid_base())
>> +  return false;

>
> If the hypervisor says it's Hyper-V, that's because it wants guests to use Hyper-V.
>


 Even if guest ( i.e. Virtual Computer) contain Linux OS ?


>> ==
>> KVM_and_or_XEN_or_other_Hypervisor_what_has_non-full-emulation_of_Hyper-V emulates Hyper-V to host enlightened
>> Windows.
>>
>> . . .
>>
>> [ hpa: the problem here is that
>> KVM_and_or_XEN_or_other_Hypervisor_what_has_non-full-emulation_of_Hyper-V doesn't emulate Hyper-V well enough,  .
>>  . ]
>
> What's emulated not well enough?
>

 In case of XEN variant non-full-emulation_of_Hyper-V , IMHO :

{{
----- Original Message ----- 
From: "Victor Miasnikov"
To: "Michael S. Tsirkin"
Sent: Wednesday, April 17, 2013 12:41 PM
Subject: IMHO, XEN emulation of Hyper-V not contain needed clocksource for Lunux guest Re: [PATCH 2/3] X86: Add a check
to catch Xen emulation of Hyper-V

Hi!

> It seems that one might want to use hyper-v emulation e.g. to test
> hyper-v code without using windows, so the functionality
> that this patch disables is not completely useless,
> so there should be a good reason for disabling it.

 As I undestand, XEN emulation of Hyper-V not contain  needed clocksource for Lunux guest ( virtual computers)

I.e. Linux VM "think" what is running on Hyper-V host call clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100)
and a-la BSOD or vice versa . . .


> I went over the original discussion in
> https://patchwork.kernel.org/patch/2064331/
> and that's still not clear to me. Is there a configuration
> that is broken without this patch but starts working with
> this patch?


 IMHO, this related to:

- clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
+ if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
+  clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);


 See

https://lkml.org/lkml/2013/2/12/623
==
            Date Tue, 12 Feb 2013 16:56:07 -0800
            From tip-bot for Olaf Hering
            Subject [tip:x86/hyperv] x86: Hyper-V: register clocksource only if its advertised

 . . .

==



Best regards, Victor Miasnikov
}}





Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/

