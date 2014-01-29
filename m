Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbaA2Gn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 01:43:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:5328 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbaA2Gnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 01:43:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,740,1384329600"; 
   d="scan'208";a="466399215"
Date: Wed, 29 Jan 2014 14:43:50 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Hansen <dave@sr71.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        penberg@kernel.org, mpm@selenic.com, pshelar@nicira.com
Subject: Re: [PATCH] mm: slub: fix page->_count corruption (again)
Message-ID: <20140129064350.GA20252@localhost>
References: <20140128231722.E7387E6B@viggo.jf.intel.com>
 <20140128152956.d5659f56ae279856731a1ac5@linux-foundation.org>
 <52E842CF.7090102@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E842CF.7090102@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 03:52:47PM -0800, Dave Hansen wrote:
> On 01/28/2014 03:29 PM, Andrew Morton wrote:
> > On Tue, 28 Jan 2014 15:17:22 -0800 Dave Hansen <dave@sr71.net> wrote:
> > This code is borderline insane.
> 
> No argument here.
> 
> > Yes, struct page is special and it's worth spending time and doing
> > weird things to optimise it.  But sheesh.
> > 
> > An alternative is to make that cmpxchg quietly go away.  Is it more
> > trouble than it is worth?
> 
> It has measurable performance benefits, and the benefits go up as the
> cost of en/disabling interrupts goes up (like if it takes you a hypercall).
> 
> Fengguang, could you run a set of tests for the top patch in this branch
> to see if we'd be giving much up by axing the code?
> 
> 	https://github.com/hansendc/linux/tree/slub-nocmpxchg-for-Fengguang-20140128

Sure, I've queued tests for the branch. Will report back after 1-2
days.

Thanks,
Fengguang

> I was talking with one of the distros about turning it off as well.
> They mentioned that they saw a few performance regressions when it was
> turned off.  I'll share details when I get them.
