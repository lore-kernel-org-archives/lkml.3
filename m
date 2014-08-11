Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbaHKORl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:17:41 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:48027 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbaHKORk convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Mon, 11 Aug 2014 10:17:40 -0400
Message-Id: <53E8EC9F020000780002B383@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Mon, 11 Aug 2014 15:17:35 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Denys Vlasenko" <vda.linux@googlemail.com>,
        "Denys Vlasenko" <dvlasenk@redhat.com>
Cc: "Andy Lutomirski" <luto@amacapital.net>,
        "Kees Cook" <keescook@chromium.org>, "Will Drewry" <wad@chromium.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>, "X86 ML" <x86@kernel.org>,
        "Alexei Starovoitov" <ast@plumgrid.com>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete
 "struct pt_regs"
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
 <1406904498-21647-4-git-send-email-dvlasenk@redhat.com>
 <20140801231929.GB26491@localhost.localdomain>
 <CAK1hOcNXdBwd4KZi1V2dLMtRdusvNLPZwTKwYvnpvz3PRnsM+Q@mail.gmail.com>
 <20140811004559.GA2656@lerouge>
 <53E89DA3020000780002B00B@mail.emea.novell.com>
 <53E8C476.8000800@redhat.com>
In-Reply-To: <53E8C476.8000800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11.08.14 at 15:26, <dvlasenk@redhat.com> wrote:
> On 08/11/2014 10:40 AM, Jan Beulich wrote:
>>>>>>       CFI_ESCAPE      0x0f /* DW_CFA_def_cfa_expression */, 6, \
>>>>>>                       0x77 /* DW_OP_breg7 */, 0, \
>>>>>>                       0x06 /* DW_OP_deref */, \
>>>>>> -                     0x08 /* DW_OP_const1u */, SS+8-RBP, \
>>>>>> +                     0x08 /* DW_OP_const1u */, SS+8, \
>>>>>>                       0x22 /* DW_OP_plus */
>>>>>>       /* We entered an interrupt context - irqs are off: */
>>>>>>       TRACE_IRQS_OFF
> ...
> ...
>>>> While we are at it, what this  CFI_ESCAPE thing does here?
>>>> As usual, it has no comment :/
>> 
>> Each of its lines has a comment; with other CFI annotations not
>> each having comments, I don't see what else is needed here.
> 
> The existing comments explain what every byte means.
> They are useful if CFI-literate reader wants to check correctness
> of the encoding of this annotation.
> 
> There is no overall comment what this CFI annotation
> *achieves*. In human language, what do we say
> to DWARF decoder here?

Short answer: DW_CFA_def_cfa_expression.

Longer response: Just like I said before, what you're asking for is
identical to ask for each other CFI annotation to get a comment
associated to tell you what it's doing, which I don't think you
really mean to ask for. (Our main problem here is that we can't
specify expressions with the .cfi_* gas directives, and hence have
to resort to .cfi_escape.)

Jan

