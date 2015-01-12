Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbbALULx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:11:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59951 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbbALULv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:11:51 -0500
Date: Mon, 12 Jan 2015 21:11:45 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] x86: introduce push/pop macros which generate
 CFI_REL_OFFSET and CFI_RESTORE
Message-ID: <20150112201145.GH3904@pd.tnic>
References: <1421017655-25561-1-git-send-email-dvlasenk@redhat.com>
 <20150112192314.GF3904@pd.tnic>
 <CALCETrXzEPKPFKBeKF3UMduNe1ViQTC6vULEySo_0XTJcK7Qkw@mail.gmail.com>
 <20150112193704.GG3904@pd.tnic>
 <CALCETrUVXGnqqtgw1eZRK5g0B+5vwGuvSV6dwnm5witA-fJWLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrUVXGnqqtgw1eZRK5g0B+5vwGuvSV6dwnm5witA-fJWLQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 11:46:53AM -0800, Andy Lutomirski wrote:
> Dumb example:
> 
>     pushq_cfi $__KERNEL_DS /* ss */
> 
> This doesn't save anything that the unwinder would care about.

And? The unwinder or whatever looks at that info simply ignores stuff it
is not interested in, no?

> Better example:
> 
>     pushq_cfi \child_rip /* rip */
>     CFI_REL_OFFSET    rip,0
> 
> Doing this with a macro would need a fancier macro.

I'd ask first whether we really need this at all.

> Then there's crap like:
> 
>     pushq_cfi %rdi
>     SCHEDULE_USER
>     popq_cfi %rdi

I guess we can add a gas regname argument optional and if it is set, use
it and if not, use the reg itself... Or something like that in the best
effort type of approach.

> I would need to look a lot more carefully to figure out whether this
> would need CFI_REL_OFFSET.
> 
> If we actually had a DWARF unwinder in the kernel, maybe we could have
> real test cases :-/

I don't think that's ever going to happen.

I'd say we do the CFI annotation on a best effort basis but not
sacrifice readability in the process. If it can't be annotated, well,
tough luck.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
