Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936012Ab3DKRb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:31:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36889 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935644Ab3DKRbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:31:24 -0400
Date: Thu, 11 Apr 2013 13:31:19 -0400 (EDT)
Message-Id: <20130411.133119.913809939413807690.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: w@1wt.eu, andrew@lunn.ch, jason@lakedaemon.net, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, florian@openwrt.org, smoch@web.de,
        paulus@samba.org, buytenh@wantstofly.org, dale@farnsworth.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: mv643xx_eth: Add GRO support
From: David Miller <davem@davemloft.net>
In-Reply-To: <CABJ1b_TRxm97DKJLP_h0VwMJvcYmSpjoJvtg1KvBNGah=VzqMQ@mail.gmail.com>
References: <CABJ1b_TQDabT1J7ffo5cb1Th=71bcSduifMJaDpfVRiiHvtWDw@mail.gmail.com>
	<20130411150326.GA19978@1wt.eu>
	<CABJ1b_TRxm97DKJLP_h0VwMJvcYmSpjoJvtg1KvBNGah=VzqMQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 11 Apr 2013 10:31:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Thu, 11 Apr 2013 17:27:03 +0200

> On Thu, Apr 11, 2013 at 5:03 PM, Willy Tarreau <w@1wt.eu> wrote:
>> On Thu, Apr 11, 2013 at 04:47:49PM +0200, Sebastian Hesselbarth wrote:
>>> I tried todays net-next on top of 3.9-rc6 without any gro patch, with
>>> the initial
>>> patch (Soeren) and your proposed patch (Willy). The results show that
>>> both patches
>>> allow a significant increase in throughput compared to
>>> netif_receive_skb (!gro, !lro)
>>> alone. Having gro with lro disabled gives some 2% more throughput
>>> compared to lro only.
>>
>> Indeed this is consistent with my memories, since Eric improved the
>> GRO path, it became faster than LRO on this chip.
> 
> I don't have a strong opinion on whether Soeren's or your proposal should
> be submitted. But I insist on having one of them in, as GRO significantly
> improves the common use case, is enabled by default, and not as
> constrained as LRO.

I think, as per other drivers, LRO should be eliminated completely from
all drivers, including this one, and GRO used exclusively instead.
