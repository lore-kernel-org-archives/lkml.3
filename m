Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422749Ab3BGWbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:31:55 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:8671 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3BGWbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:31:53 -0500
Message-ID: <1360276295.3605.44.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH 0/2] fix kernel crash with macvtap on top of LRO
From: Ben Hutchings <bhutchings@solarflare.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: David Miller <davem@davemloft.net>, <eric.dumazet@gmail.com>,
        <netdev@vger.kernel.org>, <eilong@broadcom.com>,
        <jeffrey.t.kirsher@intel.com>, <jesse.brandeburg@intel.com>,
        <bruce.w.allan@intel.com>, <carolyn.wyborny@intel.com>,
        <donald.c.skidmore@intel.com>, <gregory.v.rose@intel.com>,
        <peter.p.waskiewicz.jr@intel.com>, <alexander.h.duyck@intel.com>,
        <john.ronciak@intel.com>, <tushar.n.dave@intel.com>,
        <jitendra.kalsaria@qlogic.com>, <sony.chacko@qlogic.com>,
        <linux-driver@qlogic.com>, <john.r.fastabend@intel.com>,
        <jacob.e.keller@intel.com>, <linux-kernel@vger.kernel.org>,
        <e1000-devel@lists.sourceforge.net>
Date: Thu, 7 Feb 2013 22:31:35 +0000
In-Reply-To: <20130207213315.GB5064@redhat.com>
References: <1360193660.32217.39.camel@deadeye.wl.decadent.org.uk>
	 <1360207111.28557.47.camel@edumazet-glaptop>
	 <1360254046.3605.8.camel@bwh-desktop.uk.solarflarecom.com>
	 <20130207.131420.1211188723341167971.davem@davemloft.net>
	 <20130207213315.GB5064@redhat.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19620.001
X-TM-AS-Result: No--27.066200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 23:33 +0200, Michael S. Tsirkin wrote:
> On Thu, Feb 07, 2013 at 01:14:20PM -0500, David Miller wrote:
> > From: Ben Hutchings <bhutchings@solarflare.com>
> > Date: Thu, 7 Feb 2013 16:20:46 +0000
> > 
> > > If the consensus is still that we must preserve packets exactly (aside
> > > from the usual modifications by IP routers) then LRO should be disabled
> > > on all devices for which forwarding is enabled.
> > 
> > I believe this is still undoubtedly the consensus.
> 
> But we don't need to preserve the packets when passing them to macvtap
> (which discards all this info smashing the packet into a single buffer anyway),
> correct?

macvtap_skb_to_vnet_hdr() certainly seems to be trying to preserve all
the packet information.

> If true LRO with macvtap might be useful and so the patchset is probably
> still the right thing to do to fix the macvtap crash. Makes sense?

If macvtap+virtio_net is expected to re-segment then this is fine.  But
I don't see why it should be different from other uses of macvlan.

> We might want to add code to forward LRO status from macvlan
> (not macvtap) back to the lowerdev, so that setting up forwarding
> from macvlan disables LRO on the lowerdev, but that seems like another
> issue.

I think it's the same issue!

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

