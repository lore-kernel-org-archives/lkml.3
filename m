Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbaISOoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:44:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49017 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766AbaISOoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:44:23 -0400
Date: Fri, 19 Sep 2014 16:44:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Nadav Amit <namit@cs.technion.ac.il>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>, kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND PATCH 1/3] x86: Adding structs to reflect cpuid fields
Message-ID: <20140919144408.GA5318@nazgul.tnic>
References: <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il>
 <1410958454-7501-2-git-send-email-namit@cs.technion.ac.il>
 <20140917132141.GD5358@nazgul.tnic>
 <CAKLkAJ5wYuDL+96RcRwxi7xD1iAK8_oug1zC_niipV-ToCUu=A@mail.gmail.com>
 <20140917140601.GE5358@nazgul.tnic>
 <541AD8F3.5010700@redhat.com>
 <20140918132635.GB27008@nazgul.tnic>
 <541ADFEB.6030801@redhat.com>
 <20140919075814.GA30491@nazgul.tnic>
 <541C324D.2080608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <541C324D.2080608@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 03:40:29PM +0200, Paolo Bonzini wrote:
> And similarly, Intel would not extend a bit from 16 to 17 bits if it
> weren't zero on all older processors.

Nothing is stopping a hw designer to say we're using 17 bits now. And
software needs to deal with that. It is that simple!

> > However, even there
> > 
> > "16 - Reserved - Do not count on the value."
> > 
> > I'm quoting Intel's CPUID doc 241618-037 from 2011 (there might be a
> > newer one though), the CPUID(1).ECX description.
> 
> Once that bit gets a meaning in newer processors, the same meaning will
> work retroactively for existing processors.  That's just how CPUID is
> used.  Nobody checks families before testing bits, Intel/AMD do not even
> suggest that.

I know that, and I bet those bits won't even get reused but we don't
know, do we?! All I'm pointing at is that even the feature bits which
are reserved cannot be relied to be of any value.

In any case, the moment hw designers decide to change any field width
for which you have an union defined, this fragile scheme breaks with you
needing to introduce ifdeffery.

And frankly, this whole waste-time discussion is only about you guys
wanting to use those bitfields so that constructing a CPUID value works
more conveniently. (Reportedly, I'm not convinced of that at all).

While the gazillion other places in the kernel simply use logical
operations to construct a value and write it into the corresponding
register. Does that mean that they have to go and define unions for
those registers too? Of course not! That would be insane.

I remember a time where we did remove exactly that type of bitfields
from the ide code because it wasn't helping, it was counter-intuitive
and needless.

Geez, can we drop this already! It is a dumb idea, it doesn't bring us
anything besides some superficial readability which you don't really
need. Nowadays you can use even goddam wikipedia to understand what the
CPUID bits mean:

https://en.wikipedia.org/wiki/CPUID

Everytime we have to access registers, we need to open the corresponding
manual (or wikipedia, alternatively :-)) and look at the bit
definitions. This will not change.

> > Do you have a guarantee that this won't happen in the future and break
> > all your fancy bitfields assumptions?
> 
> No guarantee, but were that to happen, I'd expect tar and feathers
> spectacles around Intel's engineering headquarters.

You're going over and doing some fireworks there?

:-P

-- 
Regards/Gruss,
    Boris.
--
