Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155AbaI3WnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:43:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58460 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbaI3WnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:43:20 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.DEB.2.11.1410010025050.4455@nanos>
References: <cover.1412105369.git.luto@amacapital.net> <c4b7904ef2ddd3dec27400d18bcd00badb4dcedf.1412105369.git.luto@amacapital.net> <542B2305.9060805@fds-team.de> <CALCETrX86zeONHsf74yKseddXUc1BMHHAFaGKgU82HuU9+_PjQ@mail.gmail.com> <alpine.DEB.2.11.1410010025050.4455@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 1/2] x86_64,entry: Filter RFLAGS.NT on entry from userspace
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 30 Sep 2014 15:42:38 -0700
To: Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>
CC: Sebastian Lackner <sebastian@fds-team.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, stable@kernel.org
Message-ID: <FC91F0E6-EED6-4D3B-979C-9787D002C527@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicely enough we get the context switch benefit without any cost in the comon case of 64-bit apps.

On September 30, 2014 3:27:41 PM PDT, Thomas Gleixner <tglx@linutronix.de> wrote:
>On Tue, 30 Sep 2014, Andy Lutomirski wrote:
>> It would certainly be possible to clear NT and retry IRET if IRET
>> fails with NT set.  This would have no overhead for anything
>relevant.
>> That would be this alternative from my 0/2 email:
>> 
>>  - Don't filter NT on sysenter.  Instead, filter it on EFI entry
>>    and modify the IRET code to retry without NT set if NT was set.
>> 
>> Thomas hpa, etc: any thoughts?
>
>Filter it right away. That's solid and obvious. Anything else is just
>complex and prone for future brown paperbag failures.
>
>We get the context switch benefit from it, so there is some
>compensation for the extra cycles.
>
>Thanks,
>
>	tglx

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
