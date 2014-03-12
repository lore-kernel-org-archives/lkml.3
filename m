Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaCLGJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 02:09:33 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:55427 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaCLGJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 02:09:32 -0400
MIME-Version: 1.0
In-Reply-To: <531FEA69.7050107@zytor.com>
References: <cover.1394575968.git.luto@amacapital.net> <531FEA69.7050107@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 11 Mar 2014 23:09:11 -0700
Message-ID: <CALCETrVyR4GmLZ-yzPCL8xGZOZkRtPkQUcqQ=nzcRqG_Yp60wg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] x86: Relocate the compat vdso per process
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 11, 2014 10:02 PM, "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> On 03/11/2014 03:15 PM, Andy Lutomirski wrote:
>>
>> The meat of this patch series is in patch 1.  Patch 2 is split out for
>> improved bisectability.
>>
>> Changes from v1: Split into two patches and fixed a comment.
>>
>> Andy Lutomirski (2):
>>    x86: Dynamically relocate the compat vdso
>>    x86_32: Remove user bit from identity map PDE
>>
>>   Documentation/kernel-parameters.txt  |  18 +++-
>>   arch/x86/Kconfig                     |  24 +++--
>>   arch/x86/include/asm/elf.h           |   4 -
>>   arch/x86/include/asm/fixmap.h        |   8 --
>>   arch/x86/include/asm/pgtable_types.h |   7 +-
>>   arch/x86/include/asm/vdso.h          |   5 +-
>>   arch/x86/vdso/vdso-layout.lds.S      |   2 +-
>>   arch/x86/vdso/vdso32-setup.c         | 173 ++++++++++++++++-------------------
>>   arch/x86/vdso/vdso32/vdso32.lds.S    |   2 -
>>   9 files changed, 111 insertions(+), 132 deletions(-)
>>
>
> Why per process?  *If* we have compat vdso turned on, can't we just put it in one place system-wide?

My machine has ASLR turned on, and the vma really does end up
somewhere different each time.  I suspect that most (?) ASLR users
would happily accept the 4k hit to keep ASLR working fully.

Another downside of trying to have a common address for all processes:
someone needs to figure out what that address is.  What happens if an
ELF binary (or interpreter) wants to load something at the chosen
address?

--Andy
