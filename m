Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaDVStT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:49:19 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:32940 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbaDVStR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:49:17 -0400
Date: Tue, 22 Apr 2014 20:49:10 +0200
From: Alexander Aring <alex.aring@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        backports@vger.kernel.org
Subject: Re: [PATCH 1/3] 6lowpan: add helper to get 6lowpan namespace
Message-ID: <20140422184908.GA16477@omega>
References: <1397784176-15809-1-git-send-email-mcgrof@do-not-panic.com>
 <1397784176-15809-2-git-send-email-mcgrof@do-not-panic.com>
 <1398159886.4211.1.camel@jlt4.sipsolutions.net>
 <20140422095300.GA9241@omega>
 <20140422175818.GN27882@wotan.suse.de>
 <1398192315.4211.25.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1398192315.4211.25.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 08:45:15PM +0200, Johannes Berg wrote:
> On Tue, 2014-04-22 at 19:58 +0200, Luis R. Rodriguez wrote:
> 
> > > > > +#if IS_ENABLED(CONFIG_IEEE802154_6LOWPAN)
> > > > > [...]
> > > > > +#else
> > > > > +static inline struct netns_ieee802154_lowpan *
> > > > > +net_ieee802154_lowpan(struct net *net)
> > > > > +{
> > > > > +	return NULL;
> > > > > +}
> > > > > +#endif
> > > > 
> > > > Why would that be needed? If nobody compiles 802.15.4 then it seems
> > > > nothing should reference it?
> > > > 
> > > Indeed I think this is unnecessary, also.
> > 
> > I wanted to be sure, and I was not. Right now 6lowpan does not depend
> > on CONFIG_NET_NS, is this intentional? I think its fine without it
> > but I was not sure.
> 
> I fail to see how !CONFIG_LOWPAN is related CONFIG_NET_NS?
> 

mhh, IEEE802154_6LOWPAN depends on IPV6 and I think IPV6 is related to
CONFIG_NET_NS.

- Alex
