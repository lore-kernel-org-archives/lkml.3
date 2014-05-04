Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaEDAcG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 20:32:06 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:59725 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbaEDAcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 20:32:04 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVVRN3gEhhtg=r3eZK-zH0qV3qFXuiLD8guCEAiOBP__A@mail.gmail.com>
References: <6cfe29821979c42cd812878e05577f69f99fafaf.1399074748.git.luto@amacapital.net>
 <53646A7E.8010400@zytor.com> <20140503072428.54f89688@gandalf.local.home>
 <53656B7A.8050606@zytor.com> <CALCETrVVRN3gEhhtg=r3eZK-zH0qV3qFXuiLD8guCEAiOBP__A@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 3 May 2014 17:31:41 -0700
Message-ID: <CALCETrXZyJx_5nMvW273gLJX+PROZpY3L5Wy_cwj=mK=6fSCJQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Return to kernel without IRET
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 3, 2014 at 4:51 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Sat, May 3, 2014 at 3:19 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 05/03/2014 04:24 AM, Steven Rostedt wrote:
>>> On Fri, 02 May 2014 21:03:10 -0700
>>> "H. Peter Anvin" <hpa@zytor.com> wrote:
>>>
>>>>
>>>> I'd really like to see a workload which would genuinely benefit before
>>>> adding more complexity.  Now... if we can determine that it doesn't harm
>>>> anything and would solve the NMI nesting problem cleaner than the
>>>> current solution, that would justify things, too...
>>>>
>>>
>>> As I stated before. It doesn't solve the NMI nesting problem. It only
>>> handles page faults. We would have to implement this for breakpoint
>>> return paths too. Is that a plan as well?
>>>
>>
>> I would assume we would do it for *ALL* the IRETs.  There are only three
>> IRETs in the kernel last I checked...
>
> I think we should carefully avoid doing it for returns from NMI, though :)
>
> If you want a realistic benchmark that will speed up, packet
> forwarding might be a good place to look.

Hmm.  I think my patch will blow up with EFI mixed mode if any EFI
functions are called with interrupts enabled.  It may also blow up
with when suspending or doing other BIOS things like that.  It should
probably check the actual value of CS as opposed to just the CPL.

I'm not sure what's happening with the alternate GDT in the EFI stuff.

--Andy
