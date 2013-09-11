Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab3IKAjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 20:39:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab3IKAjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 20:39:16 -0400
Date: Wed, 11 Sep 2013 10:39:05 +1000
From: Dave Chinner <dchinner@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@openvz.org>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-ID: <20130911003905.GD2445@devil.localdomain>
References: <20130910152753.662599171456233c5f91edb4@linux-foundation.org>
 <20130910222924.GB13318@ZenIV.linux.org.uk>
 <20130910153520.14e49cd32feb16d45eb8abac@linux-foundation.org>
 <20130910223624.GC13318@ZenIV.linux.org.uk>
 <20130910154116.cc4afe048213a779040ea3cc@linux-foundation.org>
 <20130910224823.GE13318@ZenIV.linux.org.uk>
 <20130910225934.GF13318@ZenIV.linux.org.uk>
 <CA+55aFwXXsk47WrAqF6yuVXOQHuNpxT7x-=MmLsNBptyzjH1zQ@mail.gmail.com>
 <20130910235349.GG13318@ZenIV.linux.org.uk>
 <CA+55aFwMdZAVJLakx=xxY2QXaRdOxaPGMttU=P=2tH6+RNJeog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwMdZAVJLakx=xxY2QXaRdOxaPGMttU=P=2tH6+RNJeog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 05:01:23PM -0700, Linus Torvalds wrote:
> On Tue, Sep 10, 2013 at 4:53 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > list_lru_add() can fail if it's already on the list; leaving the counter
> > alone should've been conditional on that, setting the flag - no.  Said
> > that, it probably should be WARN_ON(!...); this_cpu_inc(); ... |= ...;
> 
> That WARN_ON_(!..) might indeed be better (maybe just WARN_ON_ONCE())..
> 
> That DCACHE_LRU_LIST bit needs to be coherent with "the dentry->d_lru
> entry is on _some_ list" (whether it's the dentry one or the shrinker
> one), so if that list_lru_add() ever fails, that would be a sign of
> badness.
> 
> And that whole function is very performance-critical, to the point
> where we not only don't want to call down to list_lry_add(), we don't
> even want to touch the d_lru list entry itself to even _look_ if it's
> empty or not, because that will take a cache miss. Which was obviously
> the whole reason for that DCACHE_LRU_LIST bit existing...

Guys, I'm about to be out of the office for 4-5 days, so this is
real bad timing for me. When I get back I'll put some effort into
validating that everything still works properly and performs as
expected.

Cheers,

Dave.
-- 
Dave Chinner
dchinner@redhat.com
