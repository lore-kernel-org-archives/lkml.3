Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbaJ2VDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:03:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:58937 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259AbaJ2VDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:03:48 -0400
Date: Wed, 29 Oct 2014 22:03:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com
Subject: Re: e1000_netpoll(): disable_irq() triggers might_sleep() on
 linux-next
In-Reply-To: <20141029205131.GI10501@worktop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.11.1410292201530.5308@nanos>
References: <20141029155620.GA4886@kria> <20141029180734.GQ12706@worktop.programming.kicks-ass.net> <alpine.DEB.2.11.1410291918060.5308@nanos> <20141029193603.GS12706@worktop.programming.kicks-ass.net> <alpine.DEB.2.11.1410292046270.5308@nanos>
 <20141029195054.GH10501@worktop.programming.kicks-ass.net> <alpine.DEB.2.11.1410292053430.5308@nanos> <alpine.DEB.2.11.1410292119350.5308@nanos> <20141029205131.GI10501@worktop.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Peter Zijlstra wrote:

> On Wed, Oct 29, 2014 at 09:23:42PM +0100, Thomas Gleixner wrote:
> > But at least it allows to mitigate the impact by making it conditional
> > at a central point.
> > 
> > static inline void netpoll_lock(struct net_device *nd)
> > {
> > 	if (netpoll_active(nd))
> > 		spin_lock(&nd->netpoll_lock);
> > }
> 
> branch fail vs lock might be a toss on most machines, but if we're
> hitting cold cachelines we loose big.

Well, if the net_device is not cache hot on irq entry you have lost
already. The extra branch/lock is not going to add much to that.
 
Thanks,

	tglx
