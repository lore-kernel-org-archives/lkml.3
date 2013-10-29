Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab3J2KND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:13:03 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:48786 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3J2KNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:13:01 -0400
Date: Tue, 29 Oct 2013 11:12:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu, tglx@linutronix.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, arjan@linux.intel.com,
        linux@roeck-us.net, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH 1/2] x86: unify copy_from_user() size checking
Message-ID: <20131029101257.GA25953@gmail.com>
References: <5265056D02000078000FC4F3@nat28.tlf.novell.com>
 <20131026103109.GC14949@gmail.com>
 <526F914A02000078000FD806@nat28.tlf.novell.com>
 <20131029095408.GB25306@gmail.com>
 <526F971F02000078000FD841@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526F971F02000078000FD841@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> >>> On 29.10.13 at 10:54, Ingo Molnar <mingo@kernel.org> wrote:
> 
> > * Jan Beulich <JBeulich@suse.com> wrote:
> > 
> >> >>> On 26.10.13 at 12:31, Ingo Molnar <mingo@kernel.org> wrote:
> >> > * Jan Beulich <JBeulich@suse.com> wrote:
> >> >> I'd like to point out though that with __compiletime_object_size()
> >> >> being restricted to gcc before 4.6, the whole construct is going to
> >> >> become more and more pointless going forward. I would question
> >> >> however that commit 2fb0815c9ee6b9ac50e15dd8360ec76d9fa46a2 ("gcc4:
> >> >> disable __compiletime_object_size for GCC 4.6+") was really necessary,
> >> >> and instead this should have been dealt with as is done here from the
> >> >> beginning.
> >> > 
> >> > Can we now revert 2fb0815c9ee6?
> >> 
> >> Actually I'm afraid parisc would first need to follow the changes 
> >> done on x86 here, or else they'd run into (compile time) issues 
> >> (s390 and tile only emit warnings, i.e. would at worst suffer 
> >> cosmetically unless subtrees putting -Werror in place are 
> >> affected).
> > 
> > Given how trivial __compiletime_object_size() is, we could replicate 
> > a (differently named) copy of that in x86 uaccess.h?
> 
> I would never have dared to suggest something like that...
> 
> But if you're fine with that, I can certainly do so. I'd then even 
> wonder whether we shouldn't re-use the same name,
> #undef-ing the one we got from compiler*.h - after all the
> goal would be for compiler-gcc4.h to change in exactly that way.

Yeah, I think that would work.

> > This is something that would be pretty platform dependent 
> > anyway.
> 
> Why do you think so? That's entirely a compiler construct.

Yeah, what I mean is that the progress of kernel support here is 
done on a per platform manner anyway, the 'generic' piece in 
compiler.h and compiler-gcc4.h is tiny and more of a hindrance than 
a useful generalization/sharing of code...

Thanks,

	Ingo
