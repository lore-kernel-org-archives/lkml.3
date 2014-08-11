Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaHKAqG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 20:46:06 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:40635 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaHKAqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 20:46:04 -0400
Date: Mon, 11 Aug 2014 02:46:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct
 pt_regs"
Message-ID: <20140811004559.GA2656@lerouge>
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
 <1406904498-21647-4-git-send-email-dvlasenk@redhat.com>
 <20140801231929.GB26491@localhost.localdomain>
 <CAK1hOcNXdBwd4KZi1V2dLMtRdusvNLPZwTKwYvnpvz3PRnsM+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK1hOcNXdBwd4KZi1V2dLMtRdusvNLPZwTKwYvnpvz3PRnsM+Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 05:03:42AM +0200, Denys Vlasenko wrote:
> On Sat, Aug 2, 2014 at 1:19 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >>       CFI_ESCAPE      0x0f /* DW_CFA_def_cfa_expression */, 6, \
> >>                       0x77 /* DW_OP_breg7 */, 0, \
> >>                       0x06 /* DW_OP_deref */, \
> >> -                     0x08 /* DW_OP_const1u */, SS+8-RBP, \
> >> +                     0x08 /* DW_OP_const1u */, SS+8, \
> >>                       0x22 /* DW_OP_plus */
> >>       /* We entered an interrupt context - irqs are off: */
> >>       TRACE_IRQS_OFF
> >> -
> >>       call \func
> >>       .endm
> >>
> >> @@ -749,10 +719,9 @@ ret_from_intr:
> >>
> >>       /* Restore saved previous stack */
> >>       popq %rsi
> >
> > And then you pop to rsi. Ok that indeed works but perhaps we should keep it symetrical
> > just for clarity? Any reason why we can't reuse rdi here?
> 
> I changed this entire area in v2: basically, I will not change the logic,
> but will add comments explaining what are we doing here, and why.
> (Some minor code changes will be done, not affecting the logic).
> 
> While we are at it, what this  CFI_ESCAPE thing does here?
> As usual, it has no comment :/

I don't know, only Jan Beulich understands those CFI black magic.
BTW he doesn't appears to be Cc, we should add him. 

> 
> -- 
> vda
