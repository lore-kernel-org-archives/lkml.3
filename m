Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3FIWiA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 18:38:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:40587 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab3FIWh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 18:37:59 -0400
Message-ID: <1370817463.14883.36.camel@pasglop>
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@au1.ibm.com>
Date: Mon, 10 Jun 2013 08:37:43 +1000
In-Reply-To: <CA+55aFz_E+x=Mr9Z6_09wzh1mXFr3a2VigPX77LzrsyLUFeb+Q@mail.gmail.com>
References: <1370764616.14883.28.camel@pasglop>
	 <CA+55aFz_E+x=Mr9Z6_09wzh1mXFr3a2VigPX77LzrsyLUFeb+Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-09 at 14:33 -0700, Linus Torvalds wrote:
> On Sun, Jun 9, 2013 at 12:56 AM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> >
> > Here are a few more powerpc changes for 3.10. I've merged your
> > tree in at some point (which I generally avoid) in order to get
> > the compat network fixes as soon as possible.
> >
> > Mostly regressions, and stuff I judged could/should still go in at
> > this stage.
> 
> Not pulled, because your hamster smells of eldeberries.
> 
> This is not just bugfixes. In fact, as far as I can tell, this
> *introduces* bugs, with that "get_user()" in the exception path that
> can apparently happen with irqs disabled and will thus potentially
> result in new warnings that just make things unreadable.

Ah right, brown paper bag for Anton and I :(

I shouldn't have put that one in, it was a last minute bad decision
after spending time tracking another stupid sigill in userspace (this
time FSL CPUs not implementing some optional instructions that Fedora
compiler seems configured to generate nowadays).

> I'm f*cking tired of people having problems understanding "we're past
> rc5". If it's not something you would call stable material, you
> shouldn't send it to me.

I've taken out that commit and the rename of the PMU interrupt (which
while trivial probably wasn't important enough). Everything else is
regressions/stable material.

That does mean I rebased, but normally nobody bases on that merge branch
so it should be fine.

I'll send a new pull request.

Cheers,
Ben.

>               Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


