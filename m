Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaBYVSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 16:18:24 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:57872 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaBYVSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 16:18:22 -0500
Date: Tue, 25 Feb 2014 16:18:17 -0500 (EST)
Message-Id: <20140225.161817.1623503840238501415.davem@davemloft.net>
To: dcbw@redhat.com
Cc: mcgrof@do-not-panic.com, zoltan.kiss@citrix.com, netdev@vger.kernel.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [RFC v2 2/4] net: enables interface option to skip IP
From: David Miller <davem@davemloft.net>
In-Reply-To: <1393362420.3032.8.camel@dcbw.local>
References: <1393266120.8041.19.camel@dcbw.local>
	<20140224.180426.411052665068255886.davem@davemloft.net>
	<1393362420.3032.8.camel@dcbw.local>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Feb 2014 13:18:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dcbw@redhat.com>
Date: Tue, 25 Feb 2014 15:07:00 -0600

> Also, disable_ipv4 signals *intent*, which is distinct from current
> state.
> 
> Does an interface without an IPv4 address mean that the user wished it
> not to have one?
> 
> Or does it mean that DHCP hasn't started yet (but is supposed to), or
> failed, or something hasn't gotten around to assigning an address yet?
> 
> disable_ipv4 lets you distinguish between these two cases, the same way
> disable_ipv6 does.

Intent only matters on the kernel side if the kernel automatically
assigns addresses to interfaces which have been brought up like ipv6
does.

Since it does not do this for ipv4, this can be handled entirely in
userspace.

It is not a valid argument to say that a rogue dhcp might run on
the machine and configure an ipv4 address.  That's the admin's
responsibility, and still a user side problem.  A "rogue" program
could just as equally turn the theoretical disable_ipv4 off too.

