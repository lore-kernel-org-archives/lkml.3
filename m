Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370Ab3E1IHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:07:14 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:54490 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933290Ab3E1IHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:07:09 -0400
Date: Tue, 28 May 2013 10:07:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ryan Mallon <rmallon@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, milosz@adfin.com,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Is spin_is_locked() safe to use with BUG_ON()/WARN_ON()?
Message-ID: <20130528080705.GB29371@gmail.com>
References: <CA+55aFww-UYfLA4cN6MSkeXzmAnAruShddAPegCpn+5yd1HGmQ@mail.gmail.com>
 <6402.1369320636@warthog.procyon.org.uk>
 <6788.1369321955@warthog.procyon.org.uk>
 <519EC282.1010800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519EC282.1010800@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ryan Mallon <rmallon@gmail.com> wrote:

> On 24/05/13 01:12, David Howells wrote:
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> >> We do *not* want to add some crazy "spin_is_nt_locked". We just want
> >> to get rid of these idiotic debug tests.
> > 
> > Generally, I think you are right, though there are also some checks in
> > deallocation routines that check that a spinlock is not currently held before
> > releasing the memory holding it - should those be allowed to stay?  I'd be
> > tempted to wrap the whole check in something, perhaps an "spin_lock_uninit()"
> > and move the check to a header file.  Would this be useful for lockdep or
> > anything like that?
> 
> lockdep has lockdep_assert_held(), which might be what you want. Though 
> it looks like it possibly also has the false positive issues on SMP?

There should be no false positive race in the case that matters: if you 
are expecting to always hold the lock at that point, and want to make sure 
(if lock debugging is enabled), that it's truly held.

Thanks,

	Ingo
