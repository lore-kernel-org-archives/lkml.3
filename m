Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965019Ab3GESRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 14:17:40 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:48620 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab3GESRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 14:17:38 -0400
Date: Fri, 5 Jul 2013 14:17:28 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: azurIt <azurit@pobox.sk>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups mailinglist <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH for 3.2] memcg: do not trap chargers with full callstack
 on OOM
Message-ID: <20130705181728.GQ17812@cmpxchg.org>
References: <20130211112240.GC19922@dhcp22.suse.cz>
 <20130222092332.4001E4B6@pobox.sk>
 <20130606160446.GE24115@dhcp22.suse.cz>
 <20130606181633.BCC3E02E@pobox.sk>
 <20130607131157.GF8117@dhcp22.suse.cz>
 <20130617122134.2E072BA8@pobox.sk>
 <20130619132614.GC16457@dhcp22.suse.cz>
 <20130622220958.D10567A4@pobox.sk>
 <20130624201345.GA21822@cmpxchg.org>
 <20130628120613.6D6CAD21@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628120613.6D6CAD21@pobox.sk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi azurIt,

On Fri, Jun 28, 2013 at 12:06:13PM +0200, azurIt wrote:
> >It's not a kernel thread that does it because all kernel-context
> >handle_mm_fault() are annotated properly, which means the task must be
> >userspace and, since tasks is empty, have exited before synchronizing.
> >
> >Can you try with the following patch on top?
> 
> 
> Michal and Johannes,
> 
> i have some observations which i made: Original patch from Johannes
> was really fixing something but definitely not everything and was
> introducing new problems. I'm running unpatched kernel from time i
> send my last message and problems with freezing cgroups are occuring
> very often (several times per day) - they were, on the other hand,
> quite rare with patch from Johannes.

That's good!

> Johannes, i didn't try your last patch yet. I would like to wait
> until you or Michal look at my last message which contained detailed
> information about freezing of cgroups on kernel running your
> original patch (which was suppose to fix it for good). Even more, i
> would like to hear your opinion about that stucked processes which
> was holding web server port and which forced me to reboot production
> server at the middle of the day :( more information was in my last
> message. Thank you very much for your time.

I looked at your debug messages but could not find anything that would
hint at a deadlock.  All tasks are stuck in the refrigerator, so I
assume you use the freezer cgroup and enabled it somehow?

Sorry about your production server locking up, but from the stacks I
don't see any connection to the OOM problems you were having... :/
