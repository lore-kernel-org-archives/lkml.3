Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaE1OZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:25:55 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:43505 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753306AbaE1OZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:25:54 -0400
Date: Wed, 28 May 2014 10:25:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Javi Merino <javi.merino@arm.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH v2 1/7] tracing: Add __bitmask() macro to trace
 events to cpumasks and other bitmasks
Message-ID: <20140528102551.1b4e3da6@gandalf.local.home>
In-Reply-To: <20140521082641.GA3025@e102654-lin.cambridge.arm.com>
References: <1400595057-8585-1-git-send-email-javi.merino@arm.com>
	<1400595057-8585-2-git-send-email-javi.merino@arm.com>
	<1400638043.9759.5.camel@pippen.local.home>
	<20140521082641.GA3025@e102654-lin.cambridge.arm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014 09:26:41 +0100
Javi Merino <javi.merino@arm.com> wrote:

> Hi Steve,
> 
> On Wed, May 21, 2014 at 03:07:23AM +0100, Steven Rostedt wrote:
> > Hmm, I didn't think about cross tree dependencies. I already pushed this
> > patch to my for-next branch which is already in linux-next, and I do not
> > rebase this branch unless there's a really good need to.
> > 
> > I guess I needed to make a separate branch that you could have pulled
> > separately. I'm not sure how we want to proceed, unless you wait till
> > Linus pulls my branch before you add this to your tree.
> > 
> > Maybe it would be OK to cherry pick it? I'm not sure Linus would want
> > that.
> > 
> > Maybe I can make a separate branch that only has this patch and merge it
> > into my tree, where git will handle the duplicate. But then we have a
> > strange history.
> > 
> > How urgent is your change? Can it wait till my stuff makes it into
> > Linus's tree in the 3.16 merge window?
> 
> Sorry for the confusion.  I was expecting you to merge this patch via
> your tree.  I said that in the cover letter for the series, but I
> should've repeated it in this patch.  I included it in the series for
> completeness and I'll remove it once it reaches mainline.
> 

At LinuxCon Japan I talked with Linus about how to handle this.

If you look in my for-next branch on my git repo that's here:

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git

You can cherry pick my commit:

https://git.kernel.org/cgit/linux/kernel/git/rostedt/linux-trace.git/commit/?h=for-next&id=4449bf927b61bdb4389393c6fea6837214d1ace7

commit 4449bf927b61bdb4389393c6fea6837214d1ace7

Since I don't have anything else built on top of it, and it is rather
independent (I just tried cherry-picking it to Linus's tree and it
comes in with no conflicts), he said it's fine if you just cherry pick
the commit into your tree and base the rest of your patches on top of
it.

Just state that you did so in the pull commit to Linus.

Now, I would use git to do this. Don't make a patch for it. Whoever you
send patches to should cherry pick my change and then apply the rest of
your patches.

Thanks,

-- Steve
