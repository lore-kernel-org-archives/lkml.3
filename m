Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041Ab3BGRFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:05:43 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:29617 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758292Ab3BGRFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:05:41 -0500
Message-ID: <1360256716.3605.12.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCHv2-net-3.8 0/3] fix kernel crash with macvtap on top of
 LRO
From: Ben Hutchings <bhutchings@solarflare.com>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
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
        Jacob Keller <jacob.e.keller@intel.com>,
        <linux-kernel@vger.kernel.org>, <e1000-devel@lists.sourceforge.net>,
        <eric.dumazet@gmail.com>
Date: Thu, 7 Feb 2013 17:05:16 +0000
In-Reply-To: <cover.1360236441.git.mst@redhat.com>
References: <cover.1360236441.git.mst@redhat.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19620.001
X-TM-AS-Result: No--22.947800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 15:12 +0200, Michael S. Tsirkin wrote:
> At the moment, macvtap crashes are observed if macvtap is attached
> to an interface with LRO enabled.
> The crash in question is BUG() in macvtap_skb_to_vnet_hdr.
> This happens because several drivers set gso_size but not gso_type
> in incoming skbs.
> This didn't use to be the case: with intel cards on 3.2 and older
> kernels, with qlogic - on 3.4 and older kernels, so it's a regression if
> not a recent one.
> The following patches fix this for qlogic, broadcom and intel drivers.
> 
> I tested that the patch fixes the crash for ixgbe but
> don't have qlogic/broadcom hardware to test.
> I also only tested TCPv4.
> 
> Please review, and consider for 3.8.
> 
> Changes from v1:
> 	- added missing htons as suggested by Eric
> 	- backported the relevant bits from
> 	  cbf1de72324a8105ddcc3d9ce9acbc613faea17e for bnx2x

I still don't think macvtap should behave inconsistently with forwarding
and the bridge device.  We need a consensus as to whether transformation
by LRO is allowable before making changes one way or the other.  If
we're going to allow it then inet_lro also needs this fix.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

