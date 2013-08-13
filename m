Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab3HMWrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 18:47:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab3HMWrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 18:47:41 -0400
Date: Tue, 13 Aug 2013 15:47:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/2] mm: make lru_add_drain_all() selective
Message-Id: <20130813154740.5daa053df87dd0358bbbab35@linux-foundation.org>
In-Reply-To: <20130813223304.GF28996@mtj.dyndns.org>
References: <201308072335.r77NZZwl022494@farm-0012.internal.tilera.com>
	<20130812140520.c6a2255d2176a690fadf9ba7@linux-foundation.org>
	<52099187.80301@tilera.com>
	<20130813123512.3d6865d8bf4689c05d44738c@linux-foundation.org>
	<20130813201958.GA28996@mtj.dyndns.org>
	<20130813133135.3b580af557d1457e4ee8331a@linux-foundation.org>
	<20130813210719.GB28996@mtj.dyndns.org>
	<20130813141621.3f1c3415901d4236942ee736@linux-foundation.org>
	<20130813220700.GC28996@mtj.dyndns.org>
	<20130813151805.b1177b60cba5b127b2aa6aee@linux-foundation.org>
	<20130813223304.GF28996@mtj.dyndns.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013 18:33:04 -0400 Tejun Heo <tj@kernel.org> wrote:

> Hello, Andrew.
> 
> On Tue, Aug 13, 2013 at 03:18:05PM -0700, Andrew Morton wrote:
> > I don't buy it.  The callback simply determines whether "we need to
> > schuedule work on this cpu".  It's utterly simple.  Nobody will have
> > trouble understanding or using such a thing.
> 
> Well, I don't buy that either.  Callback based interface has its
> issues.

No it hasn't.  It's a common and simple technique which we all understand.

>  The difference we're talking about here is pretty minute but
> then again the improvement brought on by the callback is pretty minute
> too.

It's a relatively small improvement in the lru_add_drain_all() case. 
Other callsites can gain improvements as well.

> > It removes one memory allocation and initialisation per call.  It
> > removes an entire for_each_online_cpu() loop.
> 
> But that doesn't solve the original problem at all and while it
> removes the loop, it also adds a separate function.

It results in superior runtime code.  At this and potentially other
callsites.

> > I really don't understand what's going on here.  You're advocating for
> > a weaker kernel interface and for inferior kernel runtime behaviour. 
> > Forcing callers to communicate their needs via a large,
> > dynamically-allocated temporary rather than directly.  And what do we
> > get in return for all this?  Some stuff about callbacks which frankly
> > has me scratching my head.
> 
> Well, it is a fairly heavy path and you're pushing for an optimization
> which won't make any noticeable difference at all.  And, yes, I do
> think we need to stick to simpler APIs whereever possible.  Sure the
> difference is minute here but the addition of test callback doesn't
> buy us anything either, so what's the point?

It does buy us things, as I've repeatedly described.  You keep on
saying things which demonstrably aren't so.  I think I'll give up now.


