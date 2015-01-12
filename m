Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbbALT0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:26:05 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:36659 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096AbbALT0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:26:01 -0500
MIME-Version: 1.0
In-Reply-To: <20150112192314.GF3904@pd.tnic>
References: <1421017655-25561-1-git-send-email-dvlasenk@redhat.com> <20150112192314.GF3904@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 12 Jan 2015 11:25:39 -0800
Message-ID: <CALCETrXzEPKPFKBeKF3UMduNe1ViQTC6vULEySo_0XTJcK7Qkw@mail.gmail.com>
Subject: Re: [PATCH] x86: introduce push/pop macros which generate
 CFI_REL_OFFSET and CFI_RESTORE
To: Borislav Petkov <bp@alien8.de>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 11:23 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Jan 12, 2015 at 12:07:35AM +0100, Denys Vlasenko wrote:
>> Sequences
>>         pushl_cfi %reg
>>         CFI_REL_OFFSET reg, 0
>> and
>>         popl_cfi %reg
>>         CFI_RESTORE reg
>> happen quite often. This patch adds macros which generate them.
>>
>> No assembly changes (verified with objdump -dr vmlinux.o).
>
> ...
>
>> diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
>> index f6f1598..de1cdaf 100644
>> --- a/arch/x86/include/asm/dwarf2.h
>> +++ b/arch/x86/include/asm/dwarf2.h
>> @@ -86,11 +86,23 @@
>>       CFI_ADJUST_CFA_OFFSET 8
>>       .endm
>>
>> +     .macro pushq_cfi_reg reg
>> +     pushq %\reg
>> +     CFI_ADJUST_CFA_OFFSET 8
>> +     CFI_REL_OFFSET \reg, 0
>> +     .endm
>
> What's wrong with adding the CFI_REL_OFFSET to the pushl/popl_cfi macro
> and not add two new _reg macros?
>
> I.e., have the _cfi macros add all the CFI annotations needed.
>

I think that some users don't want the CFI_REL_OFFSET.  Also, there's
that pesky % sign.

--Andy

> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --



-- 
Andy Lutomirski
AMA Capital Management, LLC
