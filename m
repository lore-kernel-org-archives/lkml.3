Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab3JIO4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:56:31 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42919 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab3JIO4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:56:30 -0400
Date: Wed, 9 Oct 2013 16:56:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Thoughts on this RCU idle entry/exit patch?
Message-ID: <20131009145614.GA20828@localhost.localdomain>
References: <20131007153955.GA30925@linux.vnet.ibm.com>
 <20131008203427.GE8392@localhost.localdomain>
 <20131008211218.GV5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008211218.GV5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 02:12:18PM -0700, Paul E. McKenney wrote:
> On Tue, Oct 08, 2013 at 10:34:28PM +0200, Frederic Weisbecker wrote:
> > So I wonder, do we want to continue to allow this nesting? I remember that DYNTICK_TASK_NEST_*
> > stuff is there to protects against non finishing interrupts on some archs (I also remember that
> > this, or at least a practical scenario for this, was hard to really define though :o)
> > But then wouldn't it involve other kind of scenario like this?
> > 
> >        rcu_irq_enter()
> >            rcu_eqs_enter()
> >            rcu_eqs_exit()
> >            ...
> > 
> > Anyway, that's just random thougths on further simplifications, in any case, this
> > patch looks good.
> 
> Yep, if no task-level nesting is ever required, things could be a bit
> simpler.  I would be a bit slow about making such a change, though.
> After all, the need to deal with Hotel California interrupts means that
> handling nesting isn't that big of a deal comparatively.  ;-)

Right, well ideally it would be even best to fix the corner case(s) if there aren't
that many of them. I mean calling rcu_irq_exit() from the end of those half interrupts
I guess. It would make it much simpler than this complicated nesting handled on the core code.
But I agree there is a bit of unknown out there, so yeah lets be prudent :)
 
> May I add your Reviewed-by?

Sure, thanks!
