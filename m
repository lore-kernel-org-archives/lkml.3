Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965100Ab3DKRwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:52:17 -0400
Received: from 1wt.eu ([62.212.114.60]:32873 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964931Ab3DKRwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:52:16 -0400
Date: Thu, 11 Apr 2013 19:51:47 +0200
From: Willy Tarreau <w@1wt.eu>
To: David Miller <davem@davemloft.net>
Cc: sebastian.hesselbarth@gmail.com, andrew@lunn.ch, jason@lakedaemon.net,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        florian@openwrt.org, smoch@web.de, paulus@samba.org,
        buytenh@wantstofly.org, dale@farnsworth.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: mv643xx_eth: Add GRO support
Message-ID: <20130411175147.GN1910@1wt.eu>
References: <CABJ1b_TQDabT1J7ffo5cb1Th=71bcSduifMJaDpfVRiiHvtWDw@mail.gmail.com> <20130411150326.GA19978@1wt.eu> <CABJ1b_TRxm97DKJLP_h0VwMJvcYmSpjoJvtg1KvBNGah=VzqMQ@mail.gmail.com> <20130411.133119.913809939413807690.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411.133119.913809939413807690.davem@davemloft.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 01:31:19PM -0400, David Miller wrote:
> From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Date: Thu, 11 Apr 2013 17:27:03 +0200
> 
> > On Thu, Apr 11, 2013 at 5:03 PM, Willy Tarreau <w@1wt.eu> wrote:
> >> On Thu, Apr 11, 2013 at 04:47:49PM +0200, Sebastian Hesselbarth wrote:
> >>> I tried todays net-next on top of 3.9-rc6 without any gro patch, with
> >>> the initial
> >>> patch (Soeren) and your proposed patch (Willy). The results show that
> >>> both patches
> >>> allow a significant increase in throughput compared to
> >>> netif_receive_skb (!gro, !lro)
> >>> alone. Having gro with lro disabled gives some 2% more throughput
> >>> compared to lro only.
> >>
> >> Indeed this is consistent with my memories, since Eric improved the
> >> GRO path, it became faster than LRO on this chip.
> > 
> > I don't have a strong opinion on whether Soeren's or your proposal should
> > be submitted. But I insist on having one of them in, as GRO significantly
> > improves the common use case, is enabled by default, and not as
> > constrained as LRO.
> 
> I think, as per other drivers, LRO should be eliminated completely from
> all drivers, including this one, and GRO used exclusively instead.

Eric provided me with one such experimental patch in the past for this
driver. It worked for me but we never tried to clean it up to propose
it for inclusion.

If anyone is interested, I might still have it in experimental shape.

Willy

