Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab3BGQVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:21:15 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:57650 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3BGQVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:21:13 -0500
Message-ID: <1360254046.3605.8.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH 0/2] fix kernel crash with macvtap on top of LRO
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, <netdev@vger.kernel.org>,
        Eilon Greenstein <eilong@broadcom.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>, <linux-driver@qlogic.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacob Keller <jacob.e.keller@intel.com>,
        <linux-kernel@vger.kernel.org>, <e1000-devel@lists.sourceforge.net>
Date: Thu, 7 Feb 2013 16:20:46 +0000
In-Reply-To: <1360207111.28557.47.camel@edumazet-glaptop>
References: <cover.1360191528.git.mst@redhat.com>
	 <1360193660.32217.39.camel@deadeye.wl.decadent.org.uk>
	 <1360207111.28557.47.camel@edumazet-glaptop>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19620.001
X-TM-AS-Result: No--21.372100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-06 at 19:18 -0800, Eric Dumazet wrote:
> On Wed, 2013-02-06 at 23:34 +0000, Ben Hutchings wrote:
> 
> > If we want to allow forwarding from LRO then net/ipv4/inet_lro.c also
> > needs to set gso_type.
> 
> Then, what is dev_disable_lro() purpose ?

The purpose was to disable LRO when forwarding because they weren't
compatible.

If the consensus now is that the modifications made by LRO+TSO are
acceptable in a bridge/router, then we should get rid of
dev_disable_lro() and set both gso_size & gso_type on all LRO receive
paths.

If the consensus is still that we must preserve packets exactly (aside
from the usual modifications by IP routers) then LRO should be disabled
on all devices for which forwarding is enabled.  (Also, we really ought
to keep a count of the number of forwarders and use that in
netdev_fix_features(), rather than doing a one-time disable.)

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

