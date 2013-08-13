Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab3HMVH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:07:26 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:58959 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758487Ab3HMVHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:07:25 -0400
Date: Tue, 13 Aug 2013 17:07:19 -0400
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/2] mm: make lru_add_drain_all() selective
Message-ID: <20130813210719.GB28996@mtj.dyndns.org>
References: <5202CEAA.9040204@linux.vnet.ibm.com>
 <201308072335.r77NZZwl022494@farm-0012.internal.tilera.com>
 <20130812140520.c6a2255d2176a690fadf9ba7@linux-foundation.org>
 <52099187.80301@tilera.com>
 <20130813123512.3d6865d8bf4689c05d44738c@linux-foundation.org>
 <20130813201958.GA28996@mtj.dyndns.org>
 <20130813133135.3b580af557d1457e4ee8331a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813133135.3b580af557d1457e4ee8331a@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 13, 2013 at 01:31:35PM -0700, Andrew Morton wrote:
> > the logical thing to do
> > would be pre-allocating per-cpu buffers instead of depending on
> > dynamic allocation.  Do the invocations need to be stackable?
> 
> schedule_on_each_cpu() calls should if course happen concurrently, and
> there's the question of whether we wish to permit async
> schedule_on_each_cpu().  Leaving the calling CPU twiddling thumbs until
> everyone has finished is pretty sad if the caller doesn't want that.

Oh, I meant the caller-side, not schedule_on_each_cpu().  So, if this
particular caller is performance sensitive for some reason, it makes
sense to pre-allocate resources on the caller side if the caller
doesn't need to be reentrant or called concurrently.

> I don't recall seeing such abuse.  It's a very common and powerful
> tool, and not implementing it because some dummy may abuse it weakens
> the API for all non-dummies.  That allocation is simply unneeded.

More powerful and flexible doesn't always equal better and I think
being simple and less prone to abuses are important characteristics
that APIs should have.  It feels a bit silly to me to push the API
that way when doing so doesn't even solve the allocation problem.  It
doesn't really buy us much while making the interface more complex.

Thanks.

-- 
tejun
