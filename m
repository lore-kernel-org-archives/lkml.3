Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab3K1RnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 12:43:19 -0500
Received: from smtp.citrix.com ([66.165.176.89]:41235 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab3K1RnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 12:43:16 -0500
X-IronPort-AV: E=Sophos;i="4.93,792,1378857600"; 
   d="scan'208";a="79034051"
Message-ID: <1385660592.20209.27.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH net-next RFC 0/5] xen-netback: TX grant mapping instead
 of copy
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Date: Thu, 28 Nov 2013 17:43:12 +0000
In-Reply-To: <52977F5C.7090703@citrix.com>
References: <1383094220-14775-1-git-send-email-zoltan.kiss@citrix.com>
		 <1383303035.672.29.camel@kazak.uk.xensource.com>
		 <5273FA37.6020903@citrix.com>
	 <1383821563.26213.168.camel@kazak.uk.xensource.com>
	 <52977F5C.7090703@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-28 at 17:37 +0000, Zoltan Kiss wrote:
> On 07/11/13 10:52, Ian Campbell wrote:
> > On Fri, 2013-11-01 at 19:00 +0000, Zoltan Kiss wrote:
> >> On 01/11/13 10:50, Ian Campbell wrote:
> >>> Does this always avoid copying when bridging/openvswitching/forwarding
> >>> (e.g. masquerading etc)? For both domU->domU and domU->physical NIC?
> >> I've tested the domU->domU, domU->physical with bridge and openvswitch
> >> usecase, and now I've created a new stat counter to see how often copy
> >> happens (the callback's second parameter tells you whether the skb was
> >> freed or copied). It doesn't do copy in all of these scenarios.
> >> What do you mean by forwarding? The scenario when you use bridge and
> >> iptables mangling with the packet, not just filtering?
> >
> > I mean using L3 routing rather L2 bridging. Which might involve
> > NAT/MASQUERADE or might just be normal IP routing.
> I still couldn't find time to try out this scenario, but I think in this 
> case packet goes through deliver_skb, which means it will get copied. So 
> performance would be a bit worse due to the extra map/unmap. And I'm 
> afraid we can't help that too much due to this:
> https://lkml.org/lkml/2012/7/20/363
> However I think using Dom0 as a router/firewall is already a suboptimal 
> solution, so maybe a small performance regression is acceptable?

Routing/firewalling domUs is as valid as bridging. There is nothing in
the slightest bit suboptimal about it.

If this use case regresses with this approach then I'm afraid that
either needs to be addressed or a different approach considered.

> Anyway, I will try this out, and see if it really copies everything, and 
> get some numbers as well.

Thanks.

> >>> How does it deal with broadcast traffic?
> Now I had time to check it: broadcast packets get copied only once, when 
> cloning happens. It will swap out the frags with local ones, so any 
> subsequent cloning will have a local SKB.

That's good.

Ian.

