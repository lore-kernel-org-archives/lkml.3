Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaFDTyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:54:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:58563 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751255AbaFDTym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:54:42 -0400
Date: Wed, 4 Jun 2014 15:54:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [patch v2 2/5] rtmutex: Cleanup deadlock detector debug logic
Message-ID: <20140604155440.7b137ee0@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.10.1406041515470.3319@nanos>
References: <20140531155229.493650009@linutronix.de>
	<20140531155739.265673091@linutronix.de>
	<20140531160043.1d4bfb07@gandalf.local.home>
	<alpine.DEB.2.10.1406041515470.3319@nanos>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014 15:17:35 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:


> > > +static int rt_mutex_cond_detect_deadlock(struct rt_mutex_waiter *waiter,
> > > +					 enum rtmutex_chainwalk detect)
> > > +{
> > > +	return debug_rt_mutex_detect_deadlock(waiter, detect);
> > > +}
> > > +
> > > +/*
> > 
> > I'm curious to why you created this wrapper function that adds no
> > value? Why not call debug_rt_mutex_detect_deadlock() directly?
> 
> debug_rt_mutex_detect_deadlock() smells like a magic debug feature,
> while rt_mutex_cond_detect_deadlock() clearly says; It's
> conditional.

Which brings up the next obvious question. Um, why not just rename
debug_rt_mutex_detect_deadlock() to rt_mutex_cond_detect_deadlock()?

-- Steve

