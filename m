Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbaAFFKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 00:10:46 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:41312 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaAFFKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 00:10:45 -0500
Date: Mon, 6 Jan 2014 06:10:43 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li RongQing <roy.qing.li@gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20140106051043.GA3307@order.stressinduktion.org>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Li RongQing <roy.qing.li@gmail.com>
References: <20140106155413.914ed0922423400deaf87926@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140106155413.914ed0922423400deaf87926@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 03:54:13PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from net/core/dev.c:134:0:
> include/linux/if_macvlan.h: In function 'macvlan_count_rx':
> include/linux/if_macvlan.h:68:3: error: invalid use of undefined type 'struct vlan_pcpu_stats'
>    pcpu_stats = this_cpu_ptr(vlan->pcpu_stats);
>    ^
> 
> And lots more.
> 
> Caused by commit cdf3e274cf1b ("macvlan: unify macvlan_pcpu_stats and
> vlan_pcpu_stats");
> 
> I have reverted that commit for today.

This is fixed by:
https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/?id=1e85c9b66d86a776e78c332d5d32ae370ab84d3f

Greetings,

  Hannes

