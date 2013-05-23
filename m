Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133Ab3EWPMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:12:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab3EWPMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:12:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFww-UYfLA4cN6MSkeXzmAnAruShddAPegCpn+5yd1HGmQ@mail.gmail.com>
References: <CA+55aFww-UYfLA4cN6MSkeXzmAnAruShddAPegCpn+5yd1HGmQ@mail.gmail.com> <6402.1369320636@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Ingo Molnar <mingo@kernel.org>, milosz@adfin.com,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Is spin_is_locked() safe to use with BUG_ON()/WARN_ON()?
Date: Thu, 23 May 2013 16:12:35 +0100
Message-ID: <6788.1369321955@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> We do *not* want to add some crazy "spin_is_nt_locked". We just want
> to get rid of these idiotic debug tests.

Generally, I think you are right, though there are also some checks in
deallocation routines that check that a spinlock is not currently held before
releasing the memory holding it - should those be allowed to stay?  I'd be
tempted to wrap the whole check in something, perhaps an "spin_lock_uninit()"
and move the check to a header file.  Would this be useful for lockdep or
anything like that?

David
