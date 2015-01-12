Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbbALX6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:58:04 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:41499 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbbALX5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:57:24 -0500
MIME-Version: 1.0
In-Reply-To: <54B45D04.2030309@linux.intel.com>
References: <cover.1421103159.git.luto@amacapital.net> <6cb492e6037780a61b973cc9e40050d43452ed63.1421103159.git.luto@amacapital.net>
 <54B45D04.2030309@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 12 Jan 2015 15:57:01 -0800
Message-ID: <CALCETrVNnn3onV3N0b2UPxYL0kM_sY6NXE5O8RABkc+prnyRYg@mail.gmail.com>
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

On Mon, Jan 12, 2015 at 3:47 PM, Dave Hansen
<dave.hansen@linux.intel.com> wrote:
> Couple of typos...
>
> On 01/12/2015 03:04 PM, Andy Lutomirski wrote:
>> +     /*
>> +      * We only _really_ need to decode bndcl/bndcn/bndcu
>> +      * Error out on anything else.  Check this before decoding the
>> +      * instruction to reduce our exposure to intentionally bad code
>> +      * to some extent.  Note that this shortcut cat incorrectly return
>
> "...can incorrectly return"

Will fix.

>
>> +      * -EINVAL instead of -EFAULT under some circumstances.  This
>> +      * discrepency has no effect.
>> +      */
>
>         ^^ discrepancy
>

Will fix.

>
>> +     if (nr_copied < 2)
>> +             goto bad_opcode;
>> +     if (buf[0] != 0x0f)
>> +             goto bad_opcode;
>> +     if (buf[1] != 0x1a && buf[1] != 0x1b)
>> +             goto bad_opcode;
> ...
>> -     /*
>> -      * We only _really_ need to decode bndcl/bndcn/bndcu
>> -      * Error out on anything else.
>> -      */
>> -     if (insn->opcode.bytes[0] != 0x0f)
>> -             goto bad_opcode;
>> -     if ((insn->opcode.bytes[1] != 0x1a) &&
>> -         (insn->opcode.bytes[1] != 0x1b))
>> -             goto bad_opcode;
>
> Otherwise, this looks OK to me.  Have you tested this at all?  I know
> you don't have any MPX hardware, but you can still hack something in to
> point the instruction decoder at an MPX binary.

I haven't tested this at all.  ISTM it's more likely that any test
hack I write for this will mask any problem than that it will be a
real test.

That being said, it should be okay, given that the condition was
already there later in the function.

--Andy
