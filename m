Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbaHRCTF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 22:19:05 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:35128 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaHRCTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 22:19:03 -0400
Date: Sun, 17 Aug 2014 22:18:59 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Jason Cooper <jason@lakedaemon.net>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] irqchip: gic: Allow gic_arch_extn hooks to call into
 scheduler
In-Reply-To: <20140818015430.GN12769@titan.lakedaemon.net>
Message-ID: <alpine.LFD.2.11.1408172208490.29347@knanqh.ubzr>
References: <1407938238-21413-1-git-send-email-sboyd@codeaurora.org> <20140817173236.GG12769@titan.lakedaemon.net> <20140817185522.GX30401@n2100.arm.linux.org.uk> <20140817190434.GJ12769@titan.lakedaemon.net> <alpine.LFD.2.11.1408172000460.29347@knanqh.ubzr>
 <20140818012512.GL12769@titan.lakedaemon.net> <alpine.LFD.2.11.1408172131550.29347@knanqh.ubzr> <20140818015430.GN12769@titan.lakedaemon.net>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2014, Jason Cooper wrote:

> On Sun, Aug 17, 2014 at 09:35:11PM -0400, Nicolas Pitre wrote:
> > On Sun, 17 Aug 2014, Jason Cooper wrote:
> > 
> > > On Sun, Aug 17, 2014 at 08:04:45PM -0400, Nicolas Pitre wrote:
> > > > On Sun, 17 Aug 2014, Jason Cooper wrote:
> > > > > On Sun, Aug 17, 2014 at 07:55:23PM +0100, Russell King - ARM Linux wrote:
> > > > > > On Sun, Aug 17, 2014 at 01:32:36PM -0400, Jason Cooper wrote:
> > > > > > > Applied to irqchip/urgent with Nico's Ack.
> > > > > > 
> > > > > > Interesting, so I'm discussing this patch, and it gets applied anyway...
> > > > > > yes, that's great.
> > > > > 
> > > > > Quoting Nico:
> > > > > 
> > > > > "Of course it would be good to clarify things wrt Russell's remark
> > > > > independently from this patch."
> > > > > 
> > > > > I took 'independently' to mean "This patch is ok, *and* we need to
> > > > > address Russell's concerns in a follow-up patch."
> > > > > 
> > > > > Nico's Reviewed-by with that comment was sent August 13th.  The most
> > > > > recent activity on this thread was also August 13th.  After four days, I
> > > > > reasoned there were no objections to his comment.
> > > > 
> > > > Well... I mentioned this patch is a nice cleanup independently of the 
> > > > reason why it was created in the first place.
> > > 
> > > Ah, fair enough.
> > > 
> > > > Maybe that shouldn't be sorted as "urgent" in that case, especially
> > > > when the code having problem with the current state of things is
> > > > living out of mainline.
> > > 
> > > hmmm, yes.  I've been grappling with the semantics of '/urgent' vice
> > > '/fixes'.  With mvebu, /fixes is the branch for all changes needing to go
> > > into the current -rcX cycle.  For irqchip, Thomas suggested /urgent for
> > > the equivalent branch.  To me, they serve the same purpose.
> > > Unfortunately, I occasionally hear "Well, it's not _urgent_ ...".  I
> > > suppose I'll put up with it for one more cycle and then change it to
> > > /fixes. :)
> > > 
> > > wrt this patch, I need to drop it anyway.  I was a bit rusty (it's been
> > > a few weeks) and forgot to add the Cc -stable and Fixes: tags.  I do
> > > agree, though, it's certainly not urgent.
> > 
> > Given the raised issue has to do with out-of-tree code, there is no need 
> > to CC stable in that case anyway.
> 
> I could go either way here.  On the one hand, a fix is a fix is a fix.
> On the other, if it can't be triggered in mainline, we shouldn't accept
> it at all.

For mainline, it should be accepted as a cleanup and minor optimization 
since no mainline code is currently affected by the absence of this 
patch.

If there is a real bug being fixed by this patch, and whether the best 
way to fix it is by relying on this patch, is still up for debate.

> Stephen, is the out of tree code that triggered this bound for mainline?

Maybe "mainline", but certainly not "stable".


Nicolas
