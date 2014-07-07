Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaGGXFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:05:03 -0400
Received: from one.firstfloor.org ([193.170.194.197]:33048 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaGGXFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:05:01 -0400
Date: Tue, 8 Jul 2014 01:04:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: fallout of 16K stacks
Message-ID: <20140707230459.GF18735@two.firstfloor.org>
References: <20140707223001.GD18735@two.firstfloor.org>
 <53BB240C.30400@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BB240C.30400@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 03:49:48PM -0700, H. Peter Anvin wrote:
> On 07/07/2014 03:30 PM, Andi Kleen wrote:
> > 
> > Since the 16K stack change I noticed a number of problems with
> > my usual stress tests. They have a tendency to bomb out
> > because something cannot fork.
> 
> As in ENOMEM or does something worse happen?

EAGAIN, then the workload stops. For an overnight stress
test that's pretty catastrophic. It may have killed some stuff
with the OOM killer too.

> > - AIM7 on a dual socket socket system now cannot reliably run 
> >> 1000 parallel jobs.
> 
> ... with how much RAM?

This system has 32G

> > - LTP stress + memhog stress in parallel to something else
> > usually doesn't survive the night.
> > 
> > Do we need to strengthen the memory allocator to try
> > harder for 16K?
> 
> Can we even?  The probability of success goes down exponentially in the
> order requested.  Movable pages can help, of course, but still, there is
> a very real cost to this :(

I hope so. In the worst case just try longer.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
