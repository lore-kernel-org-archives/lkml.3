Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbaCLGQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 02:16:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47033 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbaCLGQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 02:16:09 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CALCETrVyR4GmLZ-yzPCL8xGZOZkRtPkQUcqQ=nzcRqG_Yp60wg@mail.gmail.com>
References: <cover.1394575968.git.luto@amacapital.net> <531FEA69.7050107@zytor.com> <CALCETrVyR4GmLZ-yzPCL8xGZOZkRtPkQUcqQ=nzcRqG_Yp60wg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v2 0/2] x86: Relocate the compat vdso per process
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 11 Mar 2014 23:14:54 -0700
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>
Message-ID: <7a13aeea-2190-4922-81cf-2072fe6c2fbe@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is one sensible address: end of address space perhaps minus some small offset.  Unlikely to be used by anything specific.

On March 11, 2014 11:09:11 PM PDT, Andy Lutomirski <luto@amacapital.net> wrote:
>On Mar 11, 2014 10:02 PM, "H. Peter Anvin" <hpa@zytor.com> wrote:
>>
>> On 03/11/2014 03:15 PM, Andy Lutomirski wrote:
>>>
>>> The meat of this patch series is in patch 1.  Patch 2 is split out
>for
>>> improved bisectability.
>>>
>>> Changes from v1: Split into two patches and fixed a comment.
>>>
>>> Andy Lutomirski (2):
>>>    x86: Dynamically relocate the compat vdso
>>>    x86_32: Remove user bit from identity map PDE
>>>
>>>   Documentation/kernel-parameters.txt  |  18 +++-
>>>   arch/x86/Kconfig                     |  24 +++--
>>>   arch/x86/include/asm/elf.h           |   4 -
>>>   arch/x86/include/asm/fixmap.h        |   8 --
>>>   arch/x86/include/asm/pgtable_types.h |   7 +-
>>>   arch/x86/include/asm/vdso.h          |   5 +-
>>>   arch/x86/vdso/vdso-layout.lds.S      |   2 +-
>>>   arch/x86/vdso/vdso32-setup.c         | 173
>++++++++++++++++-------------------
>>>   arch/x86/vdso/vdso32/vdso32.lds.S    |   2 -
>>>   9 files changed, 111 insertions(+), 132 deletions(-)
>>>
>>
>> Why per process?  *If* we have compat vdso turned on, can't we just
>put it in one place system-wide?
>
>My machine has ASLR turned on, and the vma really does end up
>somewhere different each time.  I suspect that most (?) ASLR users
>would happily accept the 4k hit to keep ASLR working fully.
>
>Another downside of trying to have a common address for all processes:
>someone needs to figure out what that address is.  What happens if an
>ELF binary (or interpreter) wants to load something at the chosen
>address?
>
>--Andy

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
