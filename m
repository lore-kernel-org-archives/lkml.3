Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaKZCko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 21:40:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbaKZCkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 21:40:42 -0500
Date: Tue, 25 Nov 2014 21:40:32 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141126024032.GA13246@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>
References: <20141114213124.GB3344@redhat.com>
 <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
 <20141115213405.GA31971@redhat.com>
 <20141116014006.GA5016@redhat.com>
 <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
 <20141126002501.GA11752@redhat.com>
 <CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 05:48:15PM -0800, Linus Torvalds wrote:

 > You have also marked 3.18-rc1 bad *twice*, along with the network
 > merge, and the tty merge. That's just odd. But it doesn't make the
 > bisect wrong, it just means that you fat-fingered thing and marked the
 > same thing bad a couple of times.
 > 
 > Nothing to worry about, unless it's a sign of early Parkinsons...

Intentional on my part, without realizing the first one was recorded.
First time, it printed the usual bisect text, but then complained my
tree was dirty (which it was). I unapplied the stuff I had, and did
the bisect command a 2nd time..

 > > Does that trace ring a bell of something else I could try on top of
 > > each bisection point ?
 > 
 > Hmm.
 > 
 > Smells somewhat like the "pipe/page fault oddness" bug you reported.
 > 
 > That one caused endless page faults on fault_in_pages_writeable()
 > because of a page table entry that the VM thought was present, but the
 > CPU thought was missing.
 > 
 > That caused the whole "pte_protnone()" thing, and trying to get rid of
 > the PTE_NUMA bit, but those patches have *not* been merged. And you
 > were ever able to reproduce it., so we left it as pending.

ah, yeah, now it comes back to me.

 > But if you actually really think that the bisect log you posted is
 > real and true and actually is the bug you're chasing, I have bad news
 > for you: do a "gitk --bisect", and you'll see that all the remaining
 > commits are just to staging drivers.
 > 
 > So that would either imply you have some staging driver (unlikely), or
 > more likely that 3.17 really already has the problem, it's just that
 > it needs some particular code alignment or phase of the moon or
 > something to trigger.

Maybe I'll try 3.17 + perf fix for an even longer runtime.
Like over thanksgiving or something.

If some of the bisection points so far had been 'good', I would
go back and re-check, but every step of the way I've been able
to reproduce it.

	Dave

