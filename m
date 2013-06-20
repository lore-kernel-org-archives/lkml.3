Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965575Ab3FTQ34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:29:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965397Ab3FTQ3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:29:54 -0400
Date: Thu, 20 Jun 2013 12:27:02 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130620162702.GA24695@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20130619164540.GB22483@redhat.com>
 <20130619175356.GA23673@redhat.com>
 <20130619181302.GE5146@linux.vnet.ibm.com>
 <20130620001212.GB12151@redhat.com>
 <20130620161652.GA4462@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620161652.GA4462@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 09:16:52AM -0700, Paul E. McKenney wrote:
 > On Wed, Jun 19, 2013 at 08:12:12PM -0400, Dave Jones wrote:
 > > On Wed, Jun 19, 2013 at 11:13:02AM -0700, Paul E. McKenney wrote:
 > >  > On Wed, Jun 19, 2013 at 01:53:56PM -0400, Dave Jones wrote:
 > >  > > On Wed, Jun 19, 2013 at 12:45:40PM -0400, Dave Jones wrote:
 > >  > >  > I've been hitting this a lot the last few days.
 > >  > >  > This is the same machine that I was also seeing lockups during sync()
 > >  > > 
 > >  > > On a whim, I reverted 971394f389992f8462c4e5ae0e3b49a10a9534a3
 > >  > > (As I started seeing these just after that rcu merge).
 > >  > > 
 > >  > > It's only been 30 minutes, but it seems stable again. Normally I would
 > >  > > hit these within 5 minutes.
 > >  > > 
 > >  > > I think this may be the same root cause for http://www.spinics.net/lists/kernel/msg1551503.html too.
 > >  > > 
 > >  > > Paul ?
 > >  > 
 > >  > ???
 > >  > 
 > >  > In both cases, I am guessing that you built with CONFIG_PROVE_RCU_DELAY=y.
 > >  > Even then, this is very strange.  I am at a loss as to why udelay(200)
 > >  > would result in a hang.  Or does your system turn udelay() into something
 > >  > other than a pure spin?
 > > 
 > > Dammit. Paul, you're off the hook (for now).
 > > It just took longer to hit.
 > 
 > Well, this commit could significantly increase CPU overhead, which might
 > make the bug more likely to occur.  (Hey, I can rationalize -anything-!!!)

bisecting it now. Hopefully by end of day I'll have it figured out.

	Dave

