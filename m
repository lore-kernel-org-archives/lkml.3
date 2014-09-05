Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbaIEBOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 21:14:45 -0400
Received: from imap.thunk.org ([74.207.234.97]:38982 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358AbaIEBOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 21:14:43 -0400
Date: Thu, 4 Sep 2014 21:14:19 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Gioh Kim <gioh.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org,
        adilger.kernel@dilger.ca, minchan@kernel.org, js1304@gmail.com,
        gunho.lee@lge.com, iamjoonsoo.kim@lge.com
Subject: Re: [PATCHv4 0/3] new APIs to allocate buffer-cache with user
 specific flag
Message-ID: <20140905011419.GE4364@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Gioh Kim <gioh.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
	paulmck@linux.vnet.ibm.com, peterz@infradead.org,
	adilger.kernel@dilger.ca, minchan@kernel.org, js1304@gmail.com,
	gunho.lee@lge.com, iamjoonsoo.kim@lge.com
References: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
 <20140904151612.7bf5b813069ff78973e01571@linux-foundation.org>
 <540905B1.1050200@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540905B1.1050200@lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 09:37:05AM +0900, Gioh Kim wrote:
> >But what were the problems which were observed in standard kernels and
> >what effect did this patchset have upon them?  Some quantitative
> >measurements will really help here.
> 
> The problem is that I cannot allocate entire CMA memory.
> >
> Actually the problem is not found without Joonsoo's patch:
> https://lkml.org/lkml/2014/5/28/64.  Without it CMA memory is free
> and every CMA-memory allocation is successed.
> 
> If the Joonsoo's patch is applied, the CMA memory is allocated
> generally when system boots-up.

As I said earlier, I'm happy to carry this patch in the ext4 tree,
because as it turns out I could use this facility for another purpose
(to cause a few buffer cache allocations to happen with __GFP_NOFAIL).

I do have one question; I note that Joonsoo's patch dates back to May,
and yet this has not hit the mainline kernel, and I haven't seen any
discussions about this patch after May.  Has there been some pushback
from the mm maintainers about Joonsoo's approach with respect to this
patch?   What is the current status of that patch set?

Thanks,

					- Ted
