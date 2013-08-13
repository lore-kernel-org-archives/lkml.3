Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401Ab3HMWdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 18:33:13 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:48268 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429Ab3HMWdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 18:33:09 -0400
Date: Tue, 13 Aug 2013 18:33:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/2] mm: make lru_add_drain_all() selective
Message-ID: <20130813223304.GF28996@mtj.dyndns.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813151805.b1177b60cba5b127b2aa6aee@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Tue, Aug 13, 2013 at 03:18:05PM -0700, Andrew Morton wrote:
> I don't buy it.  The callback simply determines whether "we need to
> schuedule work on this cpu".  It's utterly simple.  Nobody will have
> trouble understanding or using such a thing.

Well, I don't buy that either.  Callback based interface has its
issues.  The difference we're talking about here is pretty minute but
then again the improvement brought on by the callback is pretty minute
too.

> It removes one memory allocation and initialisation per call.  It
> removes an entire for_each_online_cpu() loop.

But that doesn't solve the original problem at all and while it
removes the loop, it also adds a separate function.

> I really don't understand what's going on here.  You're advocating for
> a weaker kernel interface and for inferior kernel runtime behaviour. 
> Forcing callers to communicate their needs via a large,
> dynamically-allocated temporary rather than directly.  And what do we
> get in return for all this?  Some stuff about callbacks which frankly
> has me scratching my head.

Well, it is a fairly heavy path and you're pushing for an optimization
which won't make any noticeable difference at all.  And, yes, I do
think we need to stick to simpler APIs whereever possible.  Sure the
difference is minute here but the addition of test callback doesn't
buy us anything either, so what's the point?  The allocation doesn't
even exist for vast majority of configurations.  If kmalloc from that
site is problematic, the right thing to do is pre-allocating resources
on the caller side, isn't it?

Thanks.

-- 
tejun
