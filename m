Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab3LPWp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 17:45:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab3LPWpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 17:45:24 -0500
Date: Mon, 16 Dec 2013 23:45:20 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Eric Dumazet <edumazet@google.com>, Shawn Bohrer <sbohrer@rgmadvisors.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] udp: ipv4: fix potential deadlock on sk_dst_lock
In-Reply-To: <1387233731.19078.254.camel@edumazet-glaptop2.roam.corp.google.com>
Message-ID: <alpine.LNX.2.00.1312162343520.12882@pobox.suse.cz>
References: <alpine.LNX.2.00.1312162336220.12882@pobox.suse.cz> <1387233731.19078.254.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Dec 2013, Eric Dumazet wrote:

> > Commit 975022310 ("udp: ipv4: must add synchronization in 
> > udp_sk_rx_dst_set()) caused sk_dst_lock to be obtained in udp4 receive 
> > path, which is happening in softirq context.
> > 
> > inet_bind() is taking sk_dst_lock (through sk_dst_reset()) without turning 
> > IRQs off, which results in the lockdep splat below.
> > 
> > Fix that by disabling IRQs while taking the lock in sk_dst_reset().
> 
> Thanks but I posted this fix instead :
> 
>  http://patchwork.ozlabs.org/patch/301382/

Right, I missed the incarnation in sk_dst_set(), so my patch is apparently 
incomplete anyway.

But using xchg also fixes the issue.

Thanks,

-- 
Jiri Kosina
SUSE Labs
