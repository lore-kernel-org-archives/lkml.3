Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab3LFVRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:17:08 -0500
Received: from smtprelay0178.hostedemail.com ([216.40.44.178]:36098 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758386Ab3LFVRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:17:06 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3868:3870:3871:3872:3873:3874:4321:5007:7576:7652:7903:9389:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: frogs32_5acb4b6eb2841
X-Filterd-Recvd-Size: 1981
Message-ID: <1386364621.31845.32.camel@joe-AO722>
Subject: Re: [PATCH -next] batadv: Slight optimization of batadv_compare_eth
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: mareklindner@neomailbox.ch, sw@simonwunderlich.de, antonio@meshcoding.com,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 06 Dec 2013 13:17:01 -0800
In-Reply-To: <20131206.153944.1382127535160341376.davem@davemloft.net>
References: <1386317890.31845.26.camel@joe-AO722>
	 <20131206.153944.1382127535160341376.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-06 at 15:39 -0500, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Fri, 06 Dec 2013 00:18:10 -0800
> 
> > @@ -266,7 +266,11 @@ static inline void batadv_dbg(int type __always_unused,
> >   */
> >  static inline int batadv_compare_eth(const void *data1, const void *data2)
> >  {
> > -	return (memcmp(data1, data2, ETH_ALEN) == 0 ? 1 : 0);
> > +#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
> > +	return ether_addr_equal(data1, data2);
> > +#else
> > +	return memcmp(data1, data2, ETH_ALEN) == 0;
> > +#endif
> >  }
> 
> Let's not crap up implementations with these ifdefs.
> 
> What's the specific situation here?  Is it that 'data1' and/or
> 'data2' my not be u16 aligned?

Yes.

> If so, make a function for that in linux/etherdevice.h and invoke it
> in such places.  You can name it something like
> "ether_addr_equal_unaligned()" or similar.

I'll resubmit if/after you apply the
ether_addr_equal/compare_ether_addr removal.

cheers, Joe


