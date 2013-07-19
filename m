Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816Ab3GSRfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:35:08 -0400
Received: from one.firstfloor.org ([193.170.194.197]:59741 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab3GSRfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:35:06 -0400
Date: Fri, 19 Jul 2013 19:35:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hitoshi Mitake <mitake.hitoshi@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        h.mitake@gmail.com, kirill.shutemov@linux.intel.com
Subject: Re: [PATCH] perf, tools, bench: Fix memcpy benchmark for large
 sizes v2
Message-ID: <20130719173505.GJ6123@two.firstfloor.org>
References: <1374187398-14234-1-git-send-email-andi@firstfloor.org>
 <87ip064k60.wl%mitake.hitoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ip064k60.wl%mitake.hitoshi@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
> > index 93c83e3..0887b46 100644
> > --- a/tools/perf/bench/mem-memcpy.c
> > +++ b/tools/perf/bench/mem-memcpy.c
> > @@ -115,8 +115,10 @@ static void alloc_mem(void **dst, void **src, size_t length)
> >  		die("memory allocation failed - maybe length is too large?\n");
> >  
> >  	*src = zalloc(length);
> > -	if (!src)
> > +	if (!*src)
> 
> In the latest mem-memcpy.c, this if (!src) is already fixed as if
> (!*src). This modification makes applying fail.

I can undo it, and repost, but the patch would still conflict.

Just whoever applies it has to resolve the trivial conflcit.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
