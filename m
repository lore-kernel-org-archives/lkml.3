Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3J2JyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:54:13 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:50468 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab3J2JyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:54:12 -0400
Date: Tue, 29 Oct 2013 10:54:08 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu, tglx@linutronix.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, arjan@linux.intel.com,
        linux@roeck-us.net, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH 1/2] x86: unify copy_from_user() size checking
Message-ID: <20131029095408.GB25306@gmail.com>
References: <5265056D02000078000FC4F3@nat28.tlf.novell.com>
 <20131026103109.GC14949@gmail.com>
 <526F914A02000078000FD806@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526F914A02000078000FD806@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> >>> On 26.10.13 at 12:31, Ingo Molnar <mingo@kernel.org> wrote:
> > * Jan Beulich <JBeulich@suse.com> wrote:
> >> I'd like to point out though that with __compiletime_object_size()
> >> being restricted to gcc before 4.6, the whole construct is going to
> >> become more and more pointless going forward. I would question
> >> however that commit 2fb0815c9ee6b9ac50e15dd8360ec76d9fa46a2 ("gcc4:
> >> disable __compiletime_object_size for GCC 4.6+") was really necessary,
> >> and instead this should have been dealt with as is done here from the
> >> beginning.
> > 
> > Can we now revert 2fb0815c9ee6?
> 
> Actually I'm afraid parisc would first need to follow the changes 
> done on x86 here, or else they'd run into (compile time) issues 
> (s390 and tile only emit warnings, i.e. would at worst suffer 
> cosmetically unless subtrees putting -Werror in place are 
> affected).

Given how trivial __compiletime_object_size() is, we could replicate 
a (differently named) copy of that in x86 uaccess.h?

This is something that would be pretty platform dependent anyway.

Thanks,

	Ingo
