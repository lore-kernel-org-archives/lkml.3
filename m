Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaHKN0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:26:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbaHKN0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:26:31 -0400
Message-ID: <53E8C476.8000800@redhat.com>
Date: Mon, 11 Aug 2014 15:26:14 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Denys Vlasenko <vda.linux@googlemail.com>
CC: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct
 pt_regs"
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com> <1406904498-21647-4-git-send-email-dvlasenk@redhat.com> <20140801231929.GB26491@localhost.localdomain> <CAK1hOcNXdBwd4KZi1V2dLMtRdusvNLPZwTKwYvnpvz3PRnsM+Q@mail.gmail.com> <20140811004559.GA2656@lerouge> <53E89DA3020000780002B00B@mail.emea.novell.com>
In-Reply-To: <53E89DA3020000780002B00B@mail.emea.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 10:40 AM, Jan Beulich wrote:
>>>>>       CFI_ESCAPE      0x0f /* DW_CFA_def_cfa_expression */, 6, \
>>>>>                       0x77 /* DW_OP_breg7 */, 0, \
>>>>>                       0x06 /* DW_OP_deref */, \
>>>>> -                     0x08 /* DW_OP_const1u */, SS+8-RBP, \
>>>>> +                     0x08 /* DW_OP_const1u */, SS+8, \
>>>>>                       0x22 /* DW_OP_plus */
>>>>>       /* We entered an interrupt context - irqs are off: */
>>>>>       TRACE_IRQS_OFF
...
...
>>> While we are at it, what this  CFI_ESCAPE thing does here?
>>> As usual, it has no comment :/
> 
> Each of its lines has a comment; with other CFI annotations not
> each having comments, I don't see what else is needed here.

The existing comments explain what every byte means.
They are useful if CFI-literate reader wants to check correctness
of the encoding of this annotation.

There is no overall comment what this CFI annotation
*achieves*. In human language, what do we say
to DWARF decoder here?

