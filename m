Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaCQWGC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:06:02 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:49715 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbaCQWF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:05:59 -0400
Date: Mon, 17 Mar 2014 18:05:54 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@kernel.org>,
        Stewart Smith <stewart@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20140317220554.GG17373@mtj.dyndns.org>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
 <20140312015021.GC10106@kroah.com>
 <20140317101611.d043a90e1cb72dcfb8bc767a@canb.auug.org.au>
 <20140317183333.GE10565@kroah.com>
 <1395088410.15098.175.camel@pasglop>
 <20140317215619.GA25228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317215619.GA25228@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Mar 17, 2014 at 02:56:19PM -0700, Greg KH wrote:
> > Now regarding the practicals of sorting out our trees, Stephen suggested
> > that rather than doing anything on my side (heh, I like that !), you
> > should revert the last patch of the series, the one removing the old
> > API, in your tree.
> > 
> > It can then be re-applied later around rc1.
> 
> I'll look to see if we can do that, let me dig it up out of my tree...

I think this is being blown out of proportion.  It was a rarely used
API and converting to the new one is mostly trivial which can be
easily done as a merge fix, which is what it is.  Seriously, following
protocols is beneficial upto certain point but we don't want DMV level
beaurocracy in handling patches and there's something wrong when the
first questions for merge conflict in devel branches which comes up
are not "what's this change and what would it take to resolve it?" but
those of strict adherences to protocol.

Can we please take a step back and look at what we're doing?  This was
a change of API which was used very obscure and haven't seen new users
for years.  It is well within the scope of normal (and efficient)
patch routing to route it directly without separate staging release.
It sure developed a conflict but there's nothing wrong to that.  We
don't even want to try to eliminate all the conflicts.  That'd be a
lot of extra effort for no actual gain and simply a stupid trade-off.

This is a merge conflict well with in the scope of what we can expect
to happen with distributed development and this whole thing works as
well as it does only because we can make *sensible* trade offs not
only in code itself but also in how we resolve conflicts among
different branches.

Thanks.

-- 
tejun
