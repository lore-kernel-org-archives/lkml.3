Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaLEKnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:43:45 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:43631 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbaLEKnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:43:42 -0500
Date: Fri, 5 Dec 2014 11:43:31 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Smart Weblications GmbH - Florian Wiessner 
	<f.wiessner@smart-weblications.de>
CC: <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: 3.12.33 - BUG xfrm_selector_match+0x25/0x2f6
Message-ID: <20141205104330.GH6390@secunet.com>
References: <547F2462.6040405@smart-weblications.de>
 <20141204075627.GE6390@secunet.com>
 <54808D8B.3080804@smart-weblications.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <54808D8B.3080804@smart-weblications.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.182.7.102]
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 05:36:27PM +0100, Smart Weblications GmbH - Florian Wiessner wrote:
> Hi,
> 
> Am 04.12.2014 08:56, schrieb Steffen Klassert:
> > 
> > I really wonder why the xfrm_sk_policy_lookup codepath is taken here.
> > It looks like this is the processing of an inbound ipv4 packet that
> > is going to be rerouted to the output path by ipvs, so this packet
> > should not have socket context at all.
> > 
> > xfrm_sk_policy_lookup is called just if the packet has socket context
> > and the socket has an IPsec output policy configured. Do you use IPsec
> > socket policies?
> > 
> 
> Yes it is insane i do not know why this happens and i wonder as well - i do not
> have IPsec configured. I tried yesterday with only
> 
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=m
> 
> and all other XFRM modules disabled, same problem.
> 
> I now compiled kernel without xfrm to check if the problem is somewhere else.
> 
> I have seen that on this box (debian squeeze) the racoon tool inserts xfrm
> polcies like so:
> 
> ip xfrm policy show
> src ::/0 dst ::/0
>         dir 4 priority 0 ptype main
> src ::/0 dst ::/0
>         dir 3 priority 0 ptype main
> src ::/0 dst ::/0
>         dir 4 priority 0 ptype main
> src ::/0 dst ::/0
>         dir 3 priority 0 ptype main
> src ::/0 dst ::/0
> ...

Well, these are socket policies. The ike deamon uses them
for SA negotiation.

> 
> I tried without racoon running and with ipsec userspace tools disabled, but the
> problem still exists without ipsec userspace tools.

Does this mean that it still happens if you have no IPsec policies
in the system?

> 
> Interesting is maybe, that the longer the node is running and interfaces are
> added to a bridge, the more policies sum up. Here is an overview of other nodes,
> but without ipvs running:

Would be interesting to see them.

