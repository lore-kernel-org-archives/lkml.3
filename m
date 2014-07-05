Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbaGEUtX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 16:49:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156AbaGEUtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 16:49:22 -0400
Date: Sat, 5 Jul 2014 22:49:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
cc: Jiri Slaby <jslaby@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, Pavel Machek <pavel@ucw.cz>,
        jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>
Subject: Re: kGraft to -next [was: 00/21 kGraft]
In-Reply-To: <20140705203606.GC3069@mtj.dyndns.org>
Message-ID: <alpine.LNX.2.00.1407052240020.1655@pobox.suse.cz>
References: <1403694329-3064-1-git-send-email-jslaby@suse.cz> <53B3F556.7050002@suse.cz> <20140702123002.GA20071@mtj.dyndns.org> <20140702134721.00163886@alan.etchedpixels.co.uk> <alpine.LNX.2.00.1407021459330.1655@pobox.suse.cz> <20140702133053.GB20071@mtj.dyndns.org>
 <alpine.LNX.2.00.1407052148410.1655@pobox.suse.cz> <20140705203606.GC3069@mtj.dyndns.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jul 2014, Tejun Heo wrote:

> > What we need is to have a defined point in execution where we can draw a 
> > line between "old" and "new" universes. For processess that are crossing 
> > the userspace/kernelspace boundary, the obvious choice, that covers most 
> > of the use-cases, has been made. There are still scenarios where this 
> > aproach can't be just-blindly-applied(TM) for various reasons (changing 
> > lock order might cause deadlocks, there are cases where state is lingering 
> 
> Sure, if something breaks work due to semantic differences, there
> isn't anything we can do.
[ ... ]
> > The same holds for the kernel threads -- until all (or most of) the 
> > kthreads are converted to workqueues, the obivous choice, that should 
> > cover most of the use-cases, has been made.
> 
> But, this is different.  

Quite frankly, I have to say that I don't personally see *that* big 
difference. In both cases we are making assumptions about semantics, and 
are trying to get "as close as possible" to the point in time where the 
set of assumptions can be made as minimal as possible.

With userspace thread, this is kernel/userspace boundary. With kthread, 
this is starting of new iteration of the main loop / try_to_freeze().

We were not able to come up with anything better. Alan, you were 
stating "I don't see why it can't use the kernel freeze functionality?". 
What exactly was your suggestion, if not this, please?

> This is the mechanism itself being flaky and buggy.  This can make 
> things fail not because the patch itself is semantically wrong but 
> because the mechanism stopped the kernel at the wrong place.  

Well, to be precise, we are not "stopping" the kernel at all.

> If kthread can't be safely supported now, that's fine but then make it 
> clear that functions which may be executed by kthreads aren't supported.

So one of the aproaches implied by this would be first merging a light 
version of kGraft which doesn't support kthreads, and working towards a 
solution for kthreads as well (which might be tangential to kGraft; if 
most of the kthreads get converted to workqueues, it's a win-win 
situation anyway); would such kGraft-light get your Ack then? :)

Thanks,

-- 
Jiri Kosina
SUSE Labs
