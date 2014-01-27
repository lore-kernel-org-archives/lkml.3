Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbaA0WdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:33:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44421 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbaA0WdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:33:19 -0500
Date: Mon, 27 Jan 2014 22:32:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
Message-ID: <20140127223257.GE10323@ZenIV.linux.org.uk>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
 <20140127002255.GA10323@ZenIV.linux.org.uk>
 <CA+55aFzCtJ5gfw__3A=zkjJdv9Ag2CAmtHG5MnrRnCZYqz7EQA@mail.gmail.com>
 <20140127074208.GB10323@ZenIV.linux.org.uk>
 <52E6D866.604@amacapital.net>
 <CA+55aFzWRjNC4kPeVad3isOOW+vZhnzX0Gk5_8QzD16GZEw5Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzWRjNC4kPeVad3isOOW+vZhnzX0Gk5_8QzD16GZEw5Kg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 02:17:23PM -0800, Linus Torvalds wrote:
> On Mon, Jan 27, 2014 at 2:06 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > It's not just ip and sp -- cs matters here, too, I think.
> 
> For signal *delivery*, CS will always be __USER_CS, and %rcx can be
> crap, so sysret should be fine. We could easily check that %rip is
> valid in the whole slow-path instead of saying "return 1 if we did
> do_signal()".

do_signal() is also a place where arbitrary changes to regs might've
been done by tracer, so regs->cs might need to be checked in the same
place where we validate regs->rip ;-/
