Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaHKJHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 05:07:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55742 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaHKJHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 05:07:38 -0400
MIME-Version: 1.0
In-Reply-To: <53E89DA3020000780002B00B@mail.emea.novell.com>
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
 <1406904498-21647-4-git-send-email-dvlasenk@redhat.com> <20140801231929.GB26491@localhost.localdomain>
 <CAK1hOcNXdBwd4KZi1V2dLMtRdusvNLPZwTKwYvnpvz3PRnsM+Q@mail.gmail.com>
 <20140811004559.GA2656@lerouge> <53E89DA3020000780002B00B@mail.emea.novell.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 11 Aug 2014 18:07:16 +0900
Message-ID: <CALCETrXmSOmy55r4Ww2tc4MwtywwsWED_oP+dwBS1gTBja2yuA@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct pt_regs"
To: Jan Beulich <JBeulich@suse.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        X86 ML <x86@kernel.org>, Alexei Starovoitov <ast@plumgrid.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 5:40 PM, Jan Beulich <JBeulich@suse.com> wrote:
>>>> On 11.08.14 at 02:46, <fweisbec@gmail.com> wrote:
>> On Mon, Aug 04, 2014 at 05:03:42AM +0200, Denys Vlasenko wrote:
>>> On Sat, Aug 2, 2014 at 1:19 AM, Frederic Weisbecker <fweisbec@gmail.com>
>> wrote:
>>> >>       CFI_ESCAPE      0x0f /* DW_CFA_def_cfa_expression */, 6, \
>>> >>                       0x77 /* DW_OP_breg7 */, 0, \
>>> >>                       0x06 /* DW_OP_deref */, \
>>> >> -                     0x08 /* DW_OP_const1u */, SS+8-RBP, \
>>> >> +                     0x08 /* DW_OP_const1u */, SS+8, \
>>> >>                       0x22 /* DW_OP_plus */
>>> >>       /* We entered an interrupt context - irqs are off: */
>>> >>       TRACE_IRQS_OFF
>>> >> -
>>> >>       call \func
>>> >>       .endm
>>> >>
>>> >> @@ -749,10 +719,9 @@ ret_from_intr:
>>> >>
>>> >>       /* Restore saved previous stack */
>>> >>       popq %rsi
>>> >
>>> > And then you pop to rsi. Ok that indeed works but perhaps we should keep it symetrical
>>> > just for clarity? Any reason why we can't reuse rdi here?
>>>
>>> I changed this entire area in v2: basically, I will not change the logic,
>>> but will add comments explaining what are we doing here, and why.
>>> (Some minor code changes will be done, not affecting the logic).
>>>
>>> While we are at it, what this  CFI_ESCAPE thing does here?
>>> As usual, it has no comment :/
>
> Each of its lines has a comment; with other CFI annotations not
> each having comments, I don't see what else is needed here.
>
>> I don't know, only Jan Beulich understands those CFI black magic.
>
> That would be very said if true.
>
> In any case: This needs to be a CFI_ESCAPE because there's no
> other way I know of to emit the DW_CFA_def_cfa_expression.
> And the change to it looks correct to me.
>

How does one test the entry CFI annotations?  The best that I know of
is to single-step through using gdb attached to qemu and see whether
backtraces seem to work.

--Andy
