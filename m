Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964948Ab3FSSm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:42:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965016Ab3FSSmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:42:50 -0400
Date: Wed, 19 Jun 2013 14:42:18 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130619184218.GB26752@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20130619164540.GB22483@redhat.com>
 <20130619175356.GA23673@redhat.com>
 <20130619181302.GE5146@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619181302.GE5146@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 11:13:02AM -0700, Paul E. McKenney wrote:

 > > On a whim, I reverted 971394f389992f8462c4e5ae0e3b49a10a9534a3
 > > (As I started seeing these just after that rcu merge).
 > > 
 > > It's only been 30 minutes, but it seems stable again. Normally I would
 > > hit these within 5 minutes.
 > > 
 > > I think this may be the same root cause for http://www.spinics.net/lists/kernel/msg1551503.html too.
 > 
 > In both cases, I am guessing that you built with CONFIG_PROVE_RCU_DELAY=y.

Yes.

 > Even then, this is very strange.  I am at a loss as to why udelay(200)
 > would result in a hang.

It may not be a real 'hang' per se, but might just be that that process isn't
scheduled within the time needed to appease the lockup detector ?
(20 seconds is a long time, but that box is under constant load when it's 
 running the fuzz tests, so.. ?)

 > Or does your system turn udelay() into something other than a pure spin?

I see no reason why it would. Am I missing something ?


I also don't know if it's related, but it would be real nice if someone
would push along that fix for rcu_preempt hogging the cpu when idle that's
been in timers/urgent for over a month.

	Dave

