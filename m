Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaBZB3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:29:38 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:53017 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaBZB3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:29:36 -0500
Date: Wed, 26 Feb 2014 02:29:34 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: David Miller <davem@davemloft.net>
Cc: dcbw@redhat.com, mcgrof@do-not-panic.com, zoltan.kiss@citrix.com,
        netdev@vger.kernel.org, xen-devel@lists.xenproject.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net
Subject: Re: [RFC v2 2/4] net: enables interface option to skip IP
Message-ID: <20140226012934.GA24855@order.stressinduktion.org>
Mail-Followup-To: David Miller <davem@davemloft.net>, dcbw@redhat.com,
	mcgrof@do-not-panic.com, zoltan.kiss@citrix.com,
	netdev@vger.kernel.org, xen-devel@lists.xenproject.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
	kaber@trash.net
References: <1393266120.8041.19.camel@dcbw.local> <20140224.180426.411052665068255886.davem@davemloft.net> <1393362420.3032.8.camel@dcbw.local> <20140225.161817.1623503840238501415.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140225.161817.1623503840238501415.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 04:18:17PM -0500, David Miller wrote:
> From: Dan Williams <dcbw@redhat.com>
> Date: Tue, 25 Feb 2014 15:07:00 -0600
> 
> > Also, disable_ipv4 signals *intent*, which is distinct from current
> > state.
> > 
> > Does an interface without an IPv4 address mean that the user wished it
> > not to have one?
> > 
> > Or does it mean that DHCP hasn't started yet (but is supposed to), or
> > failed, or something hasn't gotten around to assigning an address yet?
> > 
> > disable_ipv4 lets you distinguish between these two cases, the same way
> > disable_ipv6 does.
> 
> Intent only matters on the kernel side if the kernel automatically
> assigns addresses to interfaces which have been brought up like ipv6
> does.
> 
> Since it does not do this for ipv4, this can be handled entirely in
> userspace.
> 
> It is not a valid argument to say that a rogue dhcp might run on
> the machine and configure an ipv4 address.  That's the admin's
> responsibility, and still a user side problem.  A "rogue" program
> could just as equally turn the theoretical disable_ipv4 off too.

Week end model strikes again. :)

Currently one would need to set arp_filter and arp_ignore and have no
ip address on the interface to isolate it from the ipv4 network.

IFF_NOARP is of no use here as it also disables neighbour discovery.

I am not sure we completley tear down igmp processing on that interface
if no ip address is available. Maybe there are some special cases with
forwarding, too.

Such a "silent" mode could come handy for intrusion detection systems
where one would ensure that no ip processing takes place but could also
be realized with nftables/netfilter/arpfilter, I think.

Bye,

  Hannes

