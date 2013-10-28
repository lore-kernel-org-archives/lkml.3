Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab3J1KzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:55:24 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:44567 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab3J1KzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:55:22 -0400
Date: Mon, 28 Oct 2013 11:55:19 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu, tglx@linutronix.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, arjan@linux.intel.com,
        linux@roeck-us.net, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH 1/2] x86: unify copy_from_user() size checking
Message-ID: <20131028105519.GA7798@gmail.com>
References: <5265056D02000078000FC4F3@nat28.tlf.novell.com>
 <20131026103109.GC14949@gmail.com>
 <526E1EFA02000078000FD1E7@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526E1EFA02000078000FD1E7@nat28.tlf.novell.com>
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
> Afaict yes, but I certainly didn't test with all possible gcc 
> versions. So minimally everyone involved in getting that change in 
> would be good to be in agreement.

Mind submitting a patch? I can keep it pending until v3.14, that 
should give time for compiler dependencies to be caught. Even if it 
breaks anything it shouldn't be too hard to revert again ;-)

Thanks,

	Ingo
