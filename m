Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab3BFXfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 18:35:12 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:6799 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab3BFXfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 18:35:08 -0500
Message-ID: <1360193660.32217.39.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 0/2] fix kernel crash with macvtap on top of LRO
From: Ben Hutchings <bhutchings@solarflare.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: <netdev@vger.kernel.org>, Eilon Greenstein <eilong@broadcom.com>,
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
        <linux-kernel@vger.kernel.org>, <e1000-devel@lists.sourceforge.net>,
        <eric.dumazet@gmail.com>
In-Reply-To: <cover.1360191528.git.mst@redhat.com>
References: <cover.1360191528.git.mst@redhat.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 6 Feb 2013 23:34:20 +0000
MIME-Version: 1.0
X-Mailer: Evolution 3.4.4-1 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19616.005
X-TM-AS-Result: No--16.369900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 01:02 +0200, Michael S. Tsirkin wrote:
> At the moment, macvtap crashes are observed if macvtap is attached
> to an interface with LRO enabled.
> The crash in question is BUG() in macvtap_skb_to_vnet_hdr.
> This happens because several drivers set gso_size but not gso_type
> in incoming skbs.
> The following patches fix this for
> Additionally, cbf1de72324a8105ddcc3d9ce9acbc613faea17e is required
> to fix this for broadcom - would it make sense to cherry-pick
> this patch into 3.8?
> 
> I tested that the patch fixes the crash for ixgbe but
> don't have qlogic hardware to fix.  I also only tested TCP.
> 
> Feedback wellcome.

If we want to allow forwarding from LRO then net/ipv4/inet_lro.c also
needs to set gso_type.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

