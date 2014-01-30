Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaA3X3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 18:29:12 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:48008 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaA3X3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 18:29:10 -0500
Date: Fri, 31 Jan 2014 00:29:09 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Sohny Thomas <sthomas@linux.vnet.ibm.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org,
        davem@davemloft.net, kumuda <kumuda@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipv6: default route for link local address is not added while assigning a address
Message-ID: <20140130232909.GH25336@order.stressinduktion.org>
Mail-Followup-To: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Sohny Thomas <sthomas@linux.vnet.ibm.com>,
	netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
	yoshfuji@linux-ipv6.org, davem@davemloft.net,
	kumuda <kumuda@linux.vnet.ibm.com>
References: <52E8A2AA.3090507@linux.vnet.ibm.com> <52E8DA37.7010208@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52E8DA37.7010208@6wind.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for replying so late...

On Wed, Jan 29, 2014 at 11:38:47AM +0100, Nicolas Dichtel wrote:
> Le 29/01/2014 07:41, Sohny Thomas a écrit :
> >Resending this on netdev mailing list:
> >Default route for link local address is configured automatically if
> >NETWORKING_IPV6=yes is in ifcfg-eth*.
> >When the route table for the interface is flushed and a new address is 
> >added to
> >the same device with out removing linklocal addr, default route for link 
> >local
> >address has to added by default.
> >
> >I have found the issue to be caused by this checkin
> >
> >http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/net/ipv6?id=62b54dd91567686a1cb118f76a72d5f4764a86dd
> >
> >
> >According to this change :
> >He removes adding a link local route if any other address is added , 
> >applicable
> >across all interfaces though there's mentioned only lo interface
> >So below patch fixes for other devices
> >
> >Signed-off-by: Sohny THomas <sohthoma@linux.vnet.ibm.com>
> Your email client has corrupted the patch, it cannot be applied.
> Please read Documentation/email-clients.txt
> 
> About the patch, I still think that the flush is too agressive. Link local
> routes are marked as 'proto kernel', removing them without the link local
> address is wrong.

Actually I am not so sure, there is no defined semantic of flush. I would
be ok with all three solutions: leave it as is, always add link-local
address (it does not matter if we don't have a link-local address on
that interface, as a global scoped one is just fine enough) or make flush not
remove the link-local address (but this seems a bit too special cased for me).

Greetings,

  Hannes
