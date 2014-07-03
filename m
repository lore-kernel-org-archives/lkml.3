Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858AbaGCWP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:15:56 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:56948 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbaGCWPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:15:55 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1407031511070.10658@chino.kir.corp.google.com>
References: <1404423935-5287-1-git-send-email-xerofoify@gmail.com>
	<alpine.DEB.2.02.1407031456430.10658@chino.kir.corp.google.com>
	<CAPDOMVh9F7p05wmzaQTpXvAGQzwjuTqJyU__=+e0CzXE152bcw@mail.gmail.com>
	<alpine.DEB.2.02.1407031511070.10658@chino.kir.corp.google.com>
Date: Thu, 3 Jul 2014 18:15:54 -0400
Message-ID: <CAPDOMVhJwEFvU1jsM5HZmXvLwSz1aj7bdF57JhKxHKmPfNGXUg@mail.gmail.com>
Subject: Re: [PATCH] microblaze: fixes includes in sigcontext.h
From: Nick Krause <xerofoify@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: monstr@monstr.eu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very well ,
I guess this bug is outside my scope.
Cheers Nick

On Thu, Jul 3, 2014 at 6:14 PM, David Rientjes <rientjes@google.com> wrote:
> On Thu, 3 Jul 2014, Nick Krause wrote:
>
>> You may be right I don't have a compiler that supports microblaze therefore I
>> would suggest removing this FIXME message.
>
> The FIXME here is obviously stating that the code needs to be fixed so
> that it can include linux/ptrace.h rather than asm/ptrace.h since we want
> to include the former rather than the latter.  It doesn't imply, in any
> way, that you can just do the conversion without some due diligence
> (compilation) to ensure it works; otherwise it would have been including
> linux/ptrace.h since the beginning.
>
> It's bad practice to mess with per-arch header files for platforms that
> you cannot compile yourself.
>
>> Cheers Nick
>>
>> On Thu, Jul 3, 2014 at 5:57 PM, David Rientjes <rientjes@google.com> wrote:
>> > On Thu, 3 Jul 2014, Nicholas Krause wrote:
>> >
>> >> diff --git a/arch/microblaze/include/uapi/asm/sigcontext.h b/arch/microblaze/include/uapi/asm/sigcontext.h
>> >> index 55873c8..1180d9b 100644
>> >> --- a/arch/microblaze/include/uapi/asm/sigcontext.h
>> >> +++ b/arch/microblaze/include/uapi/asm/sigcontext.h
>> >> @@ -9,8 +9,7 @@
>> >>  #ifndef _ASM_MICROBLAZE_SIGCONTEXT_H
>> >>  #define _ASM_MICROBLAZE_SIGCONTEXT_H
>> >>
>> >> -/* FIXME should be linux/ptrace.h */
>> >> -#include <asm/ptrace.h>
>> >> +#include <linux/ptrace.h>
>> >>
>> >>  struct sigcontext {
>> >>       struct pt_regs regs;
>> >
>> > Umm, does this even compile?  How does sigcontext.h get the definition of
>> > struct pt_regs?  Seems like it would be better to just do a forward
>> > declaration.
>>
