Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaCDUAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:00:15 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:40034 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbaCDUAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:00:12 -0500
Date: Tue, 4 Mar 2014 21:00:10 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@web.de>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Jan Stancek <jstancek@redhat.com>,
        Florian Westphal <fwestpha@redhat.com>
Subject: Re: [PATCH] bridge: multicast: add sanity check for query source addresses
Message-ID: <20140304200010.GA26307@order.stressinduktion.org>
Mail-Followup-To: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@web.de>,
	netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, Jan Stancek <jstancek@redhat.com>,
	Florian Westphal <fwestpha@redhat.com>
References: <1393901855-18231-1-git-send-email-linus.luessing@web.de> <20140304090614.GA3952@order.stressinduktion.org> <20140304104032.GB5090@Linus-Debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140304104032.GB5090@Linus-Debian>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 11:43:55AM +0100, Linus Lüssing wrote:
> On Tue, Mar 04, 2014 at 10:06:14AM +0100, Hannes Frederic Sowa wrote:
> > > diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> > > index ef66365..fb0e36f 100644
> > > --- a/net/bridge/br_multicast.c
> > > +++ b/net/bridge/br_multicast.c
> > > @@ -1235,6 +1235,12 @@ static int br_ip6_multicast_query(struct net_bridge *br,
> > >  	    (port && port->state == BR_STATE_DISABLED))
> > >  		goto out;
> > >  
> > > +	/* RFC2710+RFC3810 (MLDv1+MLDv2) require link-local source addresses */
> > > +	if (!(ipv6_addr_type(&ip6h->saddr) & IPV6_ADDR_LINKLOCAL)) {
> > > +		err = -EINVAL;
> > > +		goto out;
> > > +	}
> > > +
> > 
> > Shouldn't we allow empty source address, here?
> > 
> > Routers are supposed to drop them but bridges care. Linux uses ::
> > as source address as long as no valid LL addresses are available,
> > e.g. at boot-up (RFC3810 5.2.13.).
> 
> RFC3810, 5.2.13. refers to MLD reports, not queries, so that
> shouldn't be relevant, section 5.1.14 should apply. Also the
> bridge code only issues queries with a valid link-local source
> address (see br_ip6_multicast_alloc_query() in
> net/bridge/br_multicast.c). Where does Linux use :: for queries?

Sorry, I confused queries with reports.
Your patch looks good, same check as in igmp6_event_query.

Reviewed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

Bye,

  Hannes

