Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab3BPAEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 19:04:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33163 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab3BPAEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 19:04:38 -0500
Date: Sat, 16 Feb 2013 00:04:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Shentino <shentino@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SIGKILL vs. SIGSEGV on late execve() failures
Message-ID: <20130216000435.GY4503@ZenIV.linux.org.uk>
References: <20130214053656.GS4503@ZenIV.linux.org.uk>
 <CA+55aFz1JjGSCdqXpVz3oH-PWFDE3Qdxt3EVxqC2i=nfLqf0Jw@mail.gmail.com>
 <20130215215946.GX4503@ZenIV.linux.org.uk>
 <CAGDaZ_pMLScoO811es3AZxzAnSiS5ixku-DeuEi4FwX8mNv3cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGDaZ_pMLScoO811es3AZxzAnSiS5ixku-DeuEi4FwX8mNv3cQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 03:12:30PM -0800, Shentino wrote:
> > +                               send_sig(SIGSEGV, current, 0);
> 
> This might be a stupid miscue on my part, but shouldn't it be
> force_sig instead of send_sig?
> 
> I've got this crazy hunch that having SEGV masked might muck something up.

How would you manage to have it masked at that point?  setup_new_exec()
is inevitable after success of flush_old_exec() and it will do
flush_signal_handlers() for us.

And yes, flush_old_exec() and setup_new_exec() ought to be merged; the
problem with that is the stuff done between those two - setting personality,
plus playing with thread flags if needed.  Unfortunately, there are non-obvious
differences between architectures, so that would have to be hashed out on
linux-arch.  Doesn't affect the point above, though...
