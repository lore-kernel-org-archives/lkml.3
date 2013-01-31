Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3AaAWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 19:22:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3AaAWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:22:45 -0500
Date: Wed, 30 Jan 2013 16:22:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hlist: drop the node parameter from iterators
Message-Id: <20130130162243.8137c424.akpm@linux-foundation.org>
In-Reply-To: <5109B64D.9050904@oracle.com>
References: <1358998645-20452-1-git-send-email-sasha.levin@oracle.com>
	<5108728E.5020901@oracle.com>
	<20130130154725.f7b40daa.akpm@linux-foundation.org>
	<5109B64D.9050904@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2013 19:09:49 -0500
Sasha Levin <sasha.levin@oracle.com> wrote:

> I would accept a "it's not worth the effort" if you think it's not worth
> the effort.

I don't recall ever saying that to anything, really.  Yes, there are
things which make small improvements at large effort costs, but if we
rule out an improvement just because it's a lot of work, we suck.

I'm particularly relaxed when all that effort is yours and Linus's :)

> If not, should I send it over to you on -rc1?

Probably that's the way to go, but there's no point in going via my
tree on this - put it straight into mainline and we'll have any adverse
fallout fixed up pretty soon afterwards.


But... how confident can we be that the code is correct?

I guess a bit of linux-next testing wouldn't hurt, however applying the
v2 patch to current linux-next is not pretty:

1 out of 3 hunks FAILED -- saving rejects to file arch/mips/kernel/kprobes.c.rej
4 out of 4 hunks FAILED -- saving rejects to file arch/x86/kernel/kprobes.c.rej
1 out of 3 hunks FAILED -- saving rejects to file block/blk-cgroup.c.rej
1 out of 2 hunks FAILED -- saving rejects to file block/cfq-iosched.c.rej
1 out of 1 hunk FAILED -- saving rejects to file block/elevator.c.rej
1 out of 17 hunks FAILED -- saving rejects to file drivers/clk/clk.c.rej
2 out of 2 hunks FAILED -- saving rejects to file drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c.rej
2 out of 2 hunks FAILED -- saving rejects to file drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c.rej
4 out of 4 hunks FAILED -- saving rejects to file kernel/cgroup.c.rej
6 out of 7 hunks FAILED -- saving rejects to file kernel/workqueue.c.rej
2 out of 8 hunks FAILED -- saving rejects to file net/batman-adv/bat_iv_ogm.c.rej
11 out of 23 hunks FAILED -- saving rejects to file net/batman-adv/bridge_loop_avoidance.c.rej
2 out of 15 hunks FAILED -- saving rejects to file net/batman-adv/originator.c.rej
1 out of 4 hunks FAILED -- saving rejects to file net/batman-adv/routing.c.rej
2 out of 3 hunks FAILED -- saving rejects to file net/batman-adv/send.c.rej
2 out of 38 hunks FAILED -- saving rejects to file net/batman-adv/translation-table.c.rej
4 out of 16 hunks FAILED -- saving rejects to file net/batman-adv/vis.c.rej
2 out of 6 hunks FAILED -- saving rejects to file net/ipv4/inet_connection_sock.c.rej
1 out of 2 hunks FAILED -- saving rejects to file net/ipv6/inet6_connection_sock.c.rej


Hum.  Perhaps to move this thing forward you could prepare a diff
against current linux-next and I'll see how painful it is to maintain
for a month?

