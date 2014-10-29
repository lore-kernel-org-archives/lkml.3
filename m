Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbaJ2Uvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 16:51:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59123 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977AbaJ2Uvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 16:51:35 -0400
Date: Wed, 29 Oct 2014 21:51:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com
Subject: Re: e1000_netpoll(): disable_irq() triggers might_sleep() on
 linux-next
Message-ID: <20141029205131.GI10501@worktop.programming.kicks-ass.net>
References: <20141029155620.GA4886@kria>
 <20141029180734.GQ12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.11.1410291918060.5308@nanos>
 <20141029193603.GS12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.11.1410292046270.5308@nanos>
 <20141029195054.GH10501@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.11.1410292053430.5308@nanos>
 <alpine.DEB.2.11.1410292119350.5308@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410292119350.5308@nanos>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 09:23:42PM +0100, Thomas Gleixner wrote:
> But at least it allows to mitigate the impact by making it conditional
> at a central point.
> 
> static inline void netpoll_lock(struct net_device *nd)
> {
> 	if (netpoll_active(nd))
> 		spin_lock(&nd->netpoll_lock);
> }

branch fail vs lock might be a toss on most machines, but if we're
hitting cold cachelines we loose big.

> and let the core code make sure that activation/deactivation of
> netpoll on a particular interface is serialized against the interrupt
> and netpoll calls.
> 
> Not sure if it's worth the trouble, but at least it allows to deal
> with it in the core instead of dealing with it on a per driver base.

Does multi-queue have one netdev per queue or does that need moar
logicz?
