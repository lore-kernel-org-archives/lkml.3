Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab3AaA4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 19:56:03 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35247 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3AaAz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:55:59 -0500
Message-ID: <5109C115.5080507@oracle.com>
Date: Wed, 30 Jan 2013 19:55:49 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: torvalds@linux-foundation.org,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hlist: drop the node parameter from iterators
References: <1358998645-20452-1-git-send-email-sasha.levin@oracle.com> <5108728E.5020901@oracle.com> <20130130154725.f7b40daa.akpm@linux-foundation.org> <5109B64D.9050904@oracle.com> <20130130162243.8137c424.akpm@linux-foundation.org>
In-Reply-To: <20130130162243.8137c424.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 07:22 PM, Andrew Morton wrote:
> On Wed, 30 Jan 2013 19:09:49 -0500
> Sasha Levin <sasha.levin@oracle.com> wrote:
>> If not, should I send it over to you on -rc1?
> 
> Probably that's the way to go, but there's no point in going via my
> tree on this - put it straight into mainline and we'll have any adverse
> fallout fixed up pretty soon afterwards.

Linus rejected this plan because this way it won't have any testing up
until the point it lands into mainline.

The idea was to put it in your tree so it would be able to live there and
in -next until the next merge window opens.

> But... how confident can we be that the code is correct?
> 
> I guess a bit of linux-next testing wouldn't hurt, however applying the
> v2 patch to current linux-next is not pretty:
> 
> 1 out of 3 hunks FAILED -- saving rejects to file arch/mips/kernel/kprobes.c.rej
> 4 out of 4 hunks FAILED -- saving rejects to file arch/x86/kernel/kprobes.c.rej
> 1 out of 3 hunks FAILED -- saving rejects to file block/blk-cgroup.c.rej
> 1 out of 2 hunks FAILED -- saving rejects to file block/cfq-iosched.c.rej
> 1 out of 1 hunk FAILED -- saving rejects to file block/elevator.c.rej
> 1 out of 17 hunks FAILED -- saving rejects to file drivers/clk/clk.c.rej
> 2 out of 2 hunks FAILED -- saving rejects to file drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c.rej
> 2 out of 2 hunks FAILED -- saving rejects to file drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c.rej
> 4 out of 4 hunks FAILED -- saving rejects to file kernel/cgroup.c.rej
> 6 out of 7 hunks FAILED -- saving rejects to file kernel/workqueue.c.rej
> 2 out of 8 hunks FAILED -- saving rejects to file net/batman-adv/bat_iv_ogm.c.rej
> 11 out of 23 hunks FAILED -- saving rejects to file net/batman-adv/bridge_loop_avoidance.c.rej
> 2 out of 15 hunks FAILED -- saving rejects to file net/batman-adv/originator.c.rej
> 1 out of 4 hunks FAILED -- saving rejects to file net/batman-adv/routing.c.rej
> 2 out of 3 hunks FAILED -- saving rejects to file net/batman-adv/send.c.rej
> 2 out of 38 hunks FAILED -- saving rejects to file net/batman-adv/translation-table.c.rej
> 4 out of 16 hunks FAILED -- saving rejects to file net/batman-adv/vis.c.rej
> 2 out of 6 hunks FAILED -- saving rejects to file net/ipv4/inet_connection_sock.c.rej
> 1 out of 2 hunks FAILED -- saving rejects to file net/ipv6/inet6_connection_sock.c.rej
> 
> 
> Hum.  Perhaps to move this thing forward you could prepare a diff
> against current linux-next and I'll see how painful it is to maintain
> for a month?

This patch is like beer, keep it open for a week and it'll become flat taste like crap.

I've tried applying it on top of today's -next with git's 3-way merge, which produced
only 2 conflicts - both were pretty trivial. I'm reviewing a bunch of greps while an
allyesconfig is running in the background, I'll resend the patch when both of these
look good.


Thanks,
Sasha

