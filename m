Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3IMUXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 16:23:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45247 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab3IMUX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 16:23:28 -0400
Date: Fri, 13 Sep 2013 21:23:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-ID: <20130913202326.GV13318@ZenIV.linux.org.uk>
References: <20130910223624.GC13318@ZenIV.linux.org.uk>
 <20130910154116.cc4afe048213a779040ea3cc@linux-foundation.org>
 <20130910224823.GE13318@ZenIV.linux.org.uk>
 <20130910225934.GF13318@ZenIV.linux.org.uk>
 <CA+55aFwXXsk47WrAqF6yuVXOQHuNpxT7x-=MmLsNBptyzjH1zQ@mail.gmail.com>
 <CA+55aFxz2r3voP=W0oCns5MzMqBaeYxMLxp5AxRxjY23K3nvuA@mail.gmail.com>
 <CA+55aFxnq2hjx1Aw7+iFuGnZp4sRK3HYK0Kfipz1gEYubOdnYQ@mail.gmail.com>
 <CA+55aFyaRsk-KkjppTnqDxy8+y5z9Yvi3TpMZwgGJ7ad7kwM4g@mail.gmail.com>
 <20130913200000.GT13318@ZenIV.linux.org.uk>
 <20130913201803.GU13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913201803.GU13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 09:18:03PM +0100, Al Viro wrote:
> On Fri, Sep 13, 2013 at 09:00:00PM +0100, Al Viro wrote:
> > >  - d_lru_shrink_move: move from the "global" lru list to a private shrinker list
> > >  - d_shrink_add/del: fairly obvious.
> > > 
> > > And then "denty_lru_add/del" that actually take the current state into
> > > account and do the right thing. Those we had before, I'm just
> > > explaining the difference from the low-level operations that have
> > > fixed "from this state to that" semantics
> > 
> > Looks sane; FWIW, the variant I'm playing with uses two independent
> > flags for "shrinker" and "per-sb", but AFAICS that doesn't yield better
> > code.
> 
> Actually, it does yield slightly better code...  Look - if you take your
> patch and replace LRU_LIST | SHRINK_LIST combination with bare SHRINK_LIST
> (which can't occur right now).  Then all transitions turn into flipping
				       ^^^
> a single bit,

Obviously not *and* lru->shrink is common ;-/  Anyway, any benefit from
microoptimizing that will drown in noise, so... nevermind that idea.
