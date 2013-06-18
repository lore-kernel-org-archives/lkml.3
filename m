Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab3FRHLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 03:11:23 -0400
Received: from ozlabs.org ([203.10.76.45]:50564 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab3FRHLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 03:11:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, David Miller <davem@davemloft.net>,
        eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] fix kernel crash with macvtap on top of LRO
In-Reply-To: <1371486020.2086.27.camel@bwh-desktop.uk.level5networks.com>
References: <1360193660.32217.39.camel@deadeye.wl.decadent.org.uk> <1360207111.28557.47.camel@edumazet-glaptop> <1360254046.3605.8.camel@bwh-desktop.uk.solarflarecom.com> <20130207.131420.1211188723341167971.davem@davemloft.net> <20130610070710.GA673@redhat.com> <1371048996.1894.15.camel@bwh-desktop.uk.level5networks.com> <20130612190033.GB3462@redhat.com> <87wqptplhw.fsf@rustcorp.com.au> <1371486020.2086.27.camel@bwh-desktop.uk.level5networks.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 18 Jun 2013 14:42:47 +0930
Message-ID: <87r4g0ngs0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <bhutchings@solarflare.com> writes:
> On Mon, 2013-06-17 at 11:05 +0930, Rusty Russell wrote:
>> I thought LRO was deprecated and GRO was the new hotness, but I haven't
>> been following.  Do we still care about LRO?
>
> The old software LRO implementation, inet_lro, is deprecated in favour
> of GRO and is now only used by one or two drivers.  Hardware/firmware
> implementations of LRO are still in use and not deprecated, but we try
> to disable them on devices for which forwarding is enabled because of
> this information loss.

Right, thanks for the clarification.

Hardware implementations of LRO which can't meet GRO rules are only
semi-useful, and that should be fed back to vendors.  Hard.

> The problem I was talking about is this: you can put macvlan on top of a
> device that has LRO enabled, and then if the macvtap/macvlan device is
> used for forwarding the output packets might not look the same as those
> originally received.  So LRO should be disabled on the underlying device
> whenever forwarding is enabled on the macvtap/macvlan device; however we
> can't necessarily tell when that happens as the forwarding might be done
> inside a VM.  Maybe this is just too obscure a use case to worry much
> about getting it right automatically.

The VM needs to tell us it's OK with such mangling, otherwise we
shouldn't do it (at least by default).  The same way we'd be annoyed if
a card rev started doing LRO without the driver explicitly enabling it.

Cheers,
Rusty.
