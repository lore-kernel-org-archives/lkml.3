Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbbANUZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 15:25:16 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:33612 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbbANUZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 15:25:14 -0500
MIME-Version: 1.0
In-Reply-To: <54B6C6D1.3010804@linux.intel.com>
References: <cover.1421103159.git.luto@amacapital.net> <6cb492e6037780a61b973cc9e40050d43452ed63.1421103159.git.luto@amacapital.net>
 <54B45D04.2030309@linux.intel.com> <CALCETrVNnn3onV3N0b2UPxYL0kM_sY6NXE5O8RABkc+prnyRYg@mail.gmail.com>
 <54B6C6D1.3010804@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 14 Jan 2015 12:24:52 -0800
Message-ID: <CALCETrXxtrvYegFDQ4-YeBrVkYYcsUKA5dG1hASoUM=Sc-aDvQ@mail.gmail.com>
Subject: Re: [PATCH 3.19 v2 2/3] x86, mpx: Short-circuit the instruction
 decoder for unexpected opcodes
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 11:43 AM, Dave Hansen
<dave.hansen@linux.intel.com> wrote:
> On 01/12/2015 03:57 PM, Andy Lutomirski wrote:
>>>> >> -     /*
>>>> >> -      * We only _really_ need to decode bndcl/bndcn/bndcu
>>>> >> -      * Error out on anything else.
>>>> >> -      */
>>>> >> -     if (insn->opcode.bytes[0] != 0x0f)
>>>> >> -             goto bad_opcode;
>>>> >> -     if ((insn->opcode.bytes[1] != 0x1a) &&
>>>> >> -         (insn->opcode.bytes[1] != 0x1b))
>>>> >> -             goto bad_opcode;
>>> >
>>> > Otherwise, this looks OK to me.  Have you tested this at all?  I know
>>> > you don't have any MPX hardware, but you can still hack something in to
>>> > point the instruction decoder at an MPX binary.
>> I haven't tested this at all.  ISTM it's more likely that any test
>> hack I write for this will mask any problem than that it will be a
>> real test.
>
> This is completely and totally broken when there is an instruction
> prefix.  Instruction prefixes which occur before the opcodes in the
> buffer, so buf[0] is not necessarily insn->opcode.bytes[0].
>
> This was immediately obvious when I actually ran this code for the first
> time, even on hardware without MPX.

My apologies -- I misunderstood what insn->opcode.bytes did, and I
assumed that the original code intentionally did the same thing.

Please drop this patch.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
