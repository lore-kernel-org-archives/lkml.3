Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3JJXS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 19:18:57 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:60603 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab3JJXS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 19:18:56 -0400
Date: Thu, 10 Oct 2013 19:18:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, "sangjung.woo" <sangjung.woo@samsung.com>,
        Alessandro Rubini <rubini@gnudd.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] rtc: pl030: Use devm_kzalloc() instead of kmalloc()
Message-ID: <20131010231851.GB14030@mtj.dyndns.org>
References: <1381291240-23727-1-git-send-email-sangjung.woo@samsung.com>
 <1381291649.2040.1.camel@joe-AO722>
 <5254DD64.4090205@samsung.com>
 <1381294767.2040.5.camel@joe-AO722>
 <20131010160603.1489fe054c2bdc0a0eb9460f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010160603.1489fe054c2bdc0a0eb9460f@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 10, 2013 at 04:06:03PM -0700, Andrew Morton wrote:
> On Tue, 08 Oct 2013 21:59:27 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > I was a bit surprised to find there isn't a devm_kmalloc.
> 
> Yes, the unconditional memset is silly.  Especially when the
> function has a handy gfp_t and could be passed __GFP_ZERO.
> 
> The comment says "managed kzalloc/kfree for device drivers, no kmalloc,
> always use kzalloc".  There's no explanation for this - it looks like
> some ideological thing.

Skipping resetting just is highly unlikely to make any meaningful
difference in the paths devres is supposed to be used.  These don't
and shouldn't get called from hot paths.  Wouldn't it be more
idelogical to have something just because it feels weird not to have
it even if it is not necessary?  I don't necessarily object to having
non-zeroing interface but it seems rather pointless.  Do we have an
actual cases where this makes meaningful differences?

> -	memset(dr, 0, tot_size);
> +	if (gfp & __GFP_ZERO)
> +		memset(dr, 0, tot_size);

I'd much prefer to have at least the devres_node part cleared
regardless of __GFP_ZERO and Joe already has better patches doing
this.

Thanks.

-- 
tejun
