Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbaCLRdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:33:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53770 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243AbaCLRdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:33:10 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CALCETrWAz=gVWpsCTcy=Y=Bh7PL9iPwGgUbUsBkMbsiyh3hyYQ@mail.gmail.com>
References: <cover.1394575968.git.luto@amacapital.net> <531FEA69.7050107@zytor.com> <CALCETrVyR4GmLZ-yzPCL8xGZOZkRtPkQUcqQ=nzcRqG_Yp60wg@mail.gmail.com> <7a13aeea-2190-4922-81cf-2072fe6c2fbe@email.android.com> <CALCETrWAz=gVWpsCTcy=Y=Bh7PL9iPwGgUbUsBkMbsiyh3hyYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v2 0/2] x86: Relocate the compat vdso per process
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 12 Mar 2014 10:32:06 -0700
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>
Message-ID: <02bf3aa9-b698-45d9-a6c7-fdebbe87210b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In taking about 1 here.  

On March 12, 2014 9:20:50 AM PDT, Andy Lutomirski <luto@amacapital.net> wrote:
>On Tue, Mar 11, 2014 at 11:14 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> There is one sensible address: end of address space perhaps minus
>some small offset.  Unlikely to be used by anything specific.
>
>Meh.  The compat vdso logic will end up being either:
>
>1) Try to map at the preferred address.  If it fails, don't map it.
>Force ASLR off for the vdso
>
>2) Try to map at the preferred address.  If it fails, map somewhere
>else and relocate.
>
>3) Try to map at the preferred address unless ASLR is on.  If it fails
>or ASLR is on, map somewhere else and relocate.
>
>since the whole point is to simplify this stuff, I don't really like
>any of these choices.  That's a lot of code to save 4k per process,
>and when it breaks (which I suspect it will the next time anyone
>touches the address space layout) so one will notice that 4k gets
>wasted again.
>
>>
>> On March 11, 2014 11:09:11 PM PDT, Andy Lutomirski
><luto@amacapital.net> wrote:
>>>On Mar 11, 2014 10:02 PM, "H. Peter Anvin" <hpa@zytor.com> wrote:
>>>>
>>>> On 03/11/2014 03:15 PM, Andy Lutomirski wrote:
>>>>>
>>>>> The meat of this patch series is in patch 1.  Patch 2 is split out
>>>for
>>>>> improved bisectability.
>>>>>
>>>>> Changes from v1: Split into two patches and fixed a comment.
>>>>>
>>>>> Andy Lutomirski (2):
>>>>>    x86: Dynamically relocate the compat vdso
>>>>>    x86_32: Remove user bit from identity map PDE
>>>>>
>>>>>   Documentation/kernel-parameters.txt  |  18 +++-
>>>>>   arch/x86/Kconfig                     |  24 +++--
>>>>>   arch/x86/include/asm/elf.h           |   4 -
>>>>>   arch/x86/include/asm/fixmap.h        |   8 --
>>>>>   arch/x86/include/asm/pgtable_types.h |   7 +-
>>>>>   arch/x86/include/asm/vdso.h          |   5 +-
>>>>>   arch/x86/vdso/vdso-layout.lds.S      |   2 +-
>>>>>   arch/x86/vdso/vdso32-setup.c         | 173
>>>++++++++++++++++-------------------
>>>>>   arch/x86/vdso/vdso32/vdso32.lds.S    |   2 -
>>>>>   9 files changed, 111 insertions(+), 132 deletions(-)
>>>>>
>>>>
>>>> Why per process?  *If* we have compat vdso turned on, can't we just
>>>put it in one place system-wide?
>>>
>>>My machine has ASLR turned on, and the vma really does end up
>>>somewhere different each time.  I suspect that most (?) ASLR users
>>>would happily accept the 4k hit to keep ASLR working fully.
>>>
>>>Another downside of trying to have a common address for all
>processes:
>>>someone needs to figure out what that address is.  What happens if an
>>>ELF binary (or interpreter) wants to load something at the chosen
>>>address?
>>>
>>>--Andy
>>
>> --
>> Sent from my mobile phone.  Please pardon brevity and lack of
>formatting.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
