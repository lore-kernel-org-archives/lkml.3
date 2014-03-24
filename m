Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaCXN4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 09:56:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbaCXN4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 09:56:20 -0400
Date: Mon, 24 Mar 2014 09:56:07 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        eparis@redhat.com, sgrubb@redhat.com, hadi@mojatatu.com,
        davem@davemloft.net
Subject: Re: [PATCH] netlink: simplify nfnetlink_bind
Message-ID: <20140324135607.GB28666@madcap2.tricolour.ca>
References: <d9a410952c6b88e5855d36f91c06d466d2ce9bed.1395418617.git.rgb@redhat.com>
 <20140324111044.GC5074@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140324111044.GC5074@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/24, Pablo Neira Ayuso wrote:
> On Fri, Mar 21, 2014 at 12:44:09PM -0400, Richard Guy Briggs wrote:
> > Remove duplicity and simplify code flow by moving the rcu_read_unlock() above
> > the condition and let the flow control exit naturally at the end of the
> > function.
> > 
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  net/netfilter/nfnetlink.c |    4 +---
> >  1 files changed, 1 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> > index 046aa13..75619f9 100644
> > --- a/net/netfilter/nfnetlink.c
> > +++ b/net/netfilter/nfnetlink.c
> > @@ -399,12 +399,10 @@ static void nfnetlink_bind(int group)
> >  
> >  	rcu_read_lock();
> >  	ss = nfnetlink_get_subsys(type);
> > +	rcu_read_unlock();
> >  	if (!ss) {
> > -		rcu_read_unlock();
> >  		request_module("nfnetlink-subsys-%d", type);
> > -		return;
> >  	}
> > -	rcu_read_unlock();
> 
> Applied with minor glitch. Removed the brackets in that if branch.

Good point!  Thanks.

> Thanks

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
