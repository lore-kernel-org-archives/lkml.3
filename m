Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934277AbaGXHwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 03:52:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:40709 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934200AbaGXHwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 03:52:00 -0400
Date: Thu, 24 Jul 2014 09:51:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140724075157.GJ3935@laptop>
References: <53C8E90F.1010306@daenzer.net>
 <53CE00EF.70108@daenzer.net>
 <53CF31AE.30403@daenzer.net>
 <CA+55aFwyURgG717kmuAXzKcHddN_63GirtwHZB4ePKH+8qVtJw@mail.gmail.com>
 <20140723064948.GK3935@laptop>
 <53CF6CC4.6090207@daenzer.net>
 <20140723082819.GR3935@laptop>
 <20140723092536.GO12054@laptop.lan>
 <53CF80EE.5050702@daenzer.net>
 <53D0B358.5010400@daenzer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53D0B358.5010400@daenzer.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 04:18:48PM +0900, Michel Dänzer wrote:
> On 23.07.2014 18:31, Michel Dänzer wrote:
> > On 23.07.2014 18:25, Peter Zijlstra wrote:
> >> On Wed, Jul 23, 2014 at 10:28:19AM +0200, Peter Zijlstra wrote:
> >>
> >>> Of course, the other thing that patch did is clear sgp->power (now
> >>> sgc->capacity). 
> >>
> >> Hmm, re-reading the thread there isn't a clear confirmation its this
> >> patch at all. Could you perhaps bisect this to either verify it is
> >> indeed that patch we're talking about:
> >>
> >> caffcdd8d27b ("sched: Do not zero sg->cpumask and sg->sgp->power in build_sched_groups()")
> >>
> >> or find which patch is causing this.
> > 
> > It can take a long time for the problem to occur, so I need to run at
> > least for one or two days to be at least somewhat sure a given kernel is
> > not affected.
> > 
> > I'll try reproducing the problem with your previous suggestions first,
> 
> Just happened again, with your robustness patch and setting
> sg->sgc->capacity = 0.

Yeah, that pretty much confirms its not that patch :/

> > but if I manage to do that, I guess there's no alternative to bisecting...
> 
> I hope the assembly output I sent earlier helps, I'm afraid bisecting
> this could be painful.

Yeah, lemme go have a look...
