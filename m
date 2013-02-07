Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030267Ab3BGV3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:29:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759405Ab3BGV3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:29:23 -0500
Date: Thu, 7 Feb 2013 23:33:15 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: bhutchings@solarflare.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        eilong@broadcom.com, jeffrey.t.kirsher@intel.com,
        jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
        carolyn.wyborny@intel.com, donald.c.skidmore@intel.com,
        gregory.v.rose@intel.com, peter.p.waskiewicz.jr@intel.com,
        alexander.h.duyck@intel.com, john.ronciak@intel.com,
        tushar.n.dave@intel.com, jitendra.kalsaria@qlogic.com,
        sony.chacko@qlogic.com, linux-driver@qlogic.com,
        john.r.fastabend@intel.com, jacob.e.keller@intel.com,
        linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/2] fix kernel crash with macvtap on top of LRO
Message-ID: <20130207213315.GB5064@redhat.com>
References: <1360193660.32217.39.camel@deadeye.wl.decadent.org.uk>
 <1360207111.28557.47.camel@edumazet-glaptop>
 <1360254046.3605.8.camel@bwh-desktop.uk.solarflarecom.com>
 <20130207.131420.1211188723341167971.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130207.131420.1211188723341167971.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 01:14:20PM -0500, David Miller wrote:
> From: Ben Hutchings <bhutchings@solarflare.com>
> Date: Thu, 7 Feb 2013 16:20:46 +0000
> 
> > If the consensus is still that we must preserve packets exactly (aside
> > from the usual modifications by IP routers) then LRO should be disabled
> > on all devices for which forwarding is enabled.
> 
> I believe this is still undoubtedly the consensus.

But we don't need to preserve the packets when passing them to macvtap
(which discards all this info smashing the packet into a single buffer anyway),
correct?
If true LRO with macvtap might be useful and so the patchset is probably
still the right thing to do to fix the macvtap crash. Makes sense?

We might want to add code to forward LRO status from macvlan
(not macvtap) back to the lowerdev, so that setting up forwarding
from macvlan disables LRO on the lowerdev, but that seems like another
issue.

-- 
MST
