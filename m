Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab3GFICi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 04:02:38 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:38203 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab3GFICf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 04:02:35 -0400
Date: Sat, 6 Jul 2013 10:02:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: scheduling while atomic & hang.
Message-ID: <20130706080225.GA439@somewhere>
References: <20130704015525.GA8486@redhat.com>
 <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
 <51D5BA25.9060207@zytor.com>
 <20130705065113.GA6588@gmail.com>
 <CA+55aFx57XS4wYeEmukk8hMGxD4sVu0pz_BYppEeOdScJObXxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx57XS4wYeEmukk8hMGxD4sVu0pz_BYppEeOdScJObXxw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 12:27:51PM -0700, Linus Torvalds wrote:
> On Thu, Jul 4, 2013 at 11:51 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > It would be nice to have a full-kernel-stack backtrace printout as an
> > option, which prints entries 'above' the current RSP.
> 
> One problem with that is that it is likely to be mostly overwritten by
> the debug code that is about to print this all out - and any non-debug
> code may well be really old, just with a sufficiently deep stack trace
> to show up. Not to mention missing any irq-stack changes etc anyway.
> 
> So it can easily be *very* misleading - I'm not sure how useful it
> would be as an idea.
> 
>                 Linus

So if the unwider doesn't run with the same stak than the target,
it migh work. This can work with BUG for example But I believe that WARN
doesn't do a trap in x86.
