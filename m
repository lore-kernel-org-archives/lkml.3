Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaCFUrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:47:31 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:39953 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaCFUra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:47:30 -0500
Date: Thu, 6 Mar 2014 15:47:26 -0500
From: Tejun Heo <tj@kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCH 1/5][RFC][CFT] percpu fixes, part 1
Message-ID: <20140306204726.GE14033@htj.dyndns.org>
References: <20140305034751.GW18016@ZenIV.linux.org.uk>
 <20140305034919.GA26528@ZenIV.linux.org.uk>
 <20140306192026.GA14033@htj.dyndns.org>
 <20140306203030.GA18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140306203030.GA18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Al.

On Thu, Mar 06, 2014 at 08:30:30PM +0000, Al Viro wrote:
> > Also, I think it'd be better to split addition of first_free hint to a
> > separate patch.
> 
> OK, but I'm not sure how much does it simplify things, actually.

Not much, but it should at least help bisection if something goes
wrong, I think.

> > A comment explaining why ignoring the free bit during bin search is
> > okay would be nice?
> 
> Huh?  We are not ignoring it - we are searching for exact value, including
> the lower bit being set.  It might be worth adding a comment next to
> "freeme |= 1;" before the loop, but that's it.  These two BUG_ON() fold

Oh yeah, nothing too much.  I was just thinking about noting that
looking for the exact match is enough as we're looking for the
matching busy slot and the bit itself can't change ordering between
entries.

> > > +	if (unlikely(align < 2))
> > > +		align = 2;
> > 
> > Please add a comment explaining why the above min alignment is
> > necessary.
> 
> Umm...  Will "we want the lowest bit of offset available for free/in_use
> indicator" do?

Yeap.

Thanks!

-- 
tejun
