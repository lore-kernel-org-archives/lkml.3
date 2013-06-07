Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab3FGPuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:50:05 -0400
Received: from 1wt.eu ([62.212.114.60]:36173 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab3FGPuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:50:02 -0400
Date: Fri, 7 Jun 2013 17:49:50 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 157/184] inet: add RCU protection to inet->opt
Message-ID: <20130607154950.GI19006@1wt.eu>
References: <20130604172136.807153289@1wt.eu> <1370585517.4021.94.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370585517.4021.94.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 07:11:57AM +0100, Ben Hutchings wrote:
> On Tue, 2013-06-04 at 19:24 +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Eric Dumazet <eric.dumazet@gmail.com>
> > 
> > commit f6d8bd051c391c1c0458a30b2a7abcd939329259 upstream.
> > 
> > We lack proper synchronization to manipulate inet->opt ip_options
> > 
> > Problem is ip_make_skb() calls ip_setup_cork() and
> > ip_setup_cork() possibly makes a copy of ipc->opt (struct ip_options),
> > without any protection against another thread manipulating inet->opt.
> > 
> > Another thread can change inet->opt pointer and free old one under us.
> > 
> > Use RCU to protect inet->opt (changed to inet->inet_opt).
> > 
> > Instead of handling atomic refcounts, just copy ip_options when
> > necessary, to avoid cache line dirtying.
> > 
> > We cant insert an rcu_head in struct ip_options since its included in
> > skb->cb[], so this patch is large because I had to introduce a new
> > ip_options_rcu structure.
> > 
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > [dannf/bwh: backported to Debian's 2.6.32]
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

added, thank you.

willy

