Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab3EESaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 14:30:30 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44666 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751842Ab3EESa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 14:30:29 -0400
Date: Sun, 5 May 2013 20:30:21 +0200
From: Florian Westphal <fw@strlen.de>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH] net: frag, fix race conditions in LRU list maintenance
Message-ID: <20130505183021.GB19796@breakpoint.cc>
References: <20130505145622.9351.86587.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130505145622.9351.86587.stgit@zurg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:
> This patch fixes race between inet_frag_lru_move() and inet_frag_lru_add()
> which was introduced in commit 3ef0eb0db4bf92c6d2510fe5c4dc51852746f206
> ("net: frag, move LRU list maintenance outside of rwlock")
> 
> One cpu already added new fragment queue into hash but not into LRU.
> Other cpu found it in hash and tries to move it to the end of LRU.
> This leads to NULL pointer dereference inside of list_move_tail().
>
> Another possible race condition is between inet_frag_lru_move() and
> inet_frag_lru_del(): move can happens after deletion.

True, thanks for fixing this problem.

> This patch initializes LRU list head before adding fragment into hash and
> inet_frag_lru_move() doesn't touches it if it's empty.

Acked-by: Florian Westphal <fw@strlen.de>
