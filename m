Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab3LYRho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 12:37:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50296 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3LYRhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 12:37:42 -0500
Message-ID: <1387993057.5346.17.camel@marge.simpson.net>
Subject: Re: [PATCH] rcu: Eliminate softirq processing from rcutree
From: Mike Galbraith <bitbucket@online.de>
To: paulmck@linux.vnet.ibm.com
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 25 Dec 2013 18:37:37 +0100
In-Reply-To: <20131225075544.GE19211@linux.vnet.ibm.com>
References: <20131221193900.GA8427@linutronix.de>
	 <1387681647.5412.25.camel@marge.simpson.net>
	 <1387702631.5412.101.camel@marge.simpson.net>
	 <1387773533.5369.16.camel@marge.simpson.net>
	 <20131224193636.GD19211@linux.vnet.ibm.com>
	 <1387940854.5373.8.camel@marge.simpson.net>
	 <20131225075544.GE19211@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:9dK9/6KXd0MsEysZvWUcI/aGPZof2Ods11T8PKnWuqg
 OTUl4Dh6W3gs8fndZoqck7I4o3uuHt6httWvWeotrG4AWmvWX5
 c9iW1zjz1v5827lIU6WI0TqBgpmAiw/Ew9nsKXJ5lQhcigYNUN
 ekum5DU29NMMwkCIW2or5avdC6BZWjaKVhYioyHPdIImKtCqaj
 FOEOPmKQL+ULDtUHoZ87chYW2kkkILJBBTNchEfucSfWSerpiK
 VTS4SBM56sjAMuKVlpdEtbKIikyKUNsvJEGE+0whSzIsB+ZA26
 xRyLXC1Emns3KmIly47qJ7hX4d/m/3tNF4oCcgGP0XMSSc+Plj
 dEwyJZpAnbBaf/6aLVR0Mm/gpGJIKB4HhkCeSa5Czuv1HcSkcu
 IDa9PLGiiMPgw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-24 at 23:55 -0800, Paul E. McKenney wrote: 
> On Wed, Dec 25, 2013 at 04:07:34AM +0100, Mike Galbraith wrote:

> > > So which code do you think deserves the big lump of coal?  ;-)
> > 
> > Sebastian's NO_HZ_FULL locking fixes.  Locking is hard, and rt sure
> > doesn't make it any easier, so lets give him a cookie or three to nibble
> > on while he ponders that trylock stuff again instead :)
> 
> Fair enough.  Does Sebastian prefer milk and cookies or the other
> tradition of beer and a cigar?  ;-)

Having sufficiently recovered from turkey overdose to be able to slither
upstairs (bump bump bump) to check on the box, commenting..

# timers-do-not-raise-softirq-unconditionally.patch
# rtmutex-use-a-trylock-for-waiter-lock-in-trylock.patch

..those two out does seem to have stabilized the thing.

Merry Christmasss,

-Mike

